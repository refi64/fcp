import os, threadpool, strutils

type
  FilePath = object of RootObj
    src, dst: string
  FileList = seq[FilePath]

var
  live = 0
  copied = 0
  threadMax = 20

when declared(atomicAddFetch):
  template ainc(a: int) = discard atomicAddFetch(addr(a), 1, ATOMIC_RELAXED)
  template adec(a: int) = discard atomicAddFetch(addr(a), -1, ATOMIC_RELAXED)
else:
  template ainc(a: int) = discard addAndFetch(addr(a), 1)
  template adec(a: int) = discard addAndFetch(addr(a), -1)

proc `$$`[T](s: T, z: T): string = align($s, len($z), '0')

proc copy(file: FilePath) {.thread.} =
  copyFileWithPermissions file.src, file.dst
  ainc copied
  adec live

proc copyFiles(files: FileList) =
  var total = files.len

  # it would be cleaner if this were a closure, but Nim issue #2440 prevents that
  template report() =
    stdout.flushFile
    stdout.write "\rFiles copied: $#, files left: $#, active threads: $#" % [
      copied $$ total,
      (total-copied) $$ total,
      live $$ threadMax
    ]
    stdout.flushFile

  for file in files:
    while live+1 > threadMax:
      stdout.flushFile
    ainc live
    spawn copy(file)
    report()
  while total-copied != 0: report()
  report()
  sync()
  report()
  echo()

proc setupThreadCount(threads: string) =
  threadMax = threads.parseInt
  if threadMax <= 0:
    quit "Cannot have 0 or less threads"

proc setupFileList(src, dst: string): seq[FilePath] =
  result = @[]
  if not existsDir src:
    quit "Source either doesn't exist or isn't a directory"

  if existsFile dst:
    quit "Destination is a file"

  createDir dst

  echo "Building directory list..."

  for path in walkDirRec src:
    var
      dstfile = dst / path[src.len .. ^1]
      parent = parentDir(dstfile)
    if parent != "": createDir parent
    result.add FilePath(src: path, dst: dstfile)

proc main() =
  var
    src, dst: string
    args: seq[string] = commandLineParams()

  if args.len != 2 and args.len != 3:
    quit "usage: fcp <source> <destination> [<threadMax>=$#]" % [$threadMax]

  src = args[0]
  dst = args[1]

  if args.len == 3: setupThreadCount args[2]

  copyFiles setupFileList(src, dst)

when isMainModule: main()
