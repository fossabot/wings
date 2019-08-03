from strutils
import capitalizeAscii, contains, join, normalize, parseEnum, removeSuffix, split, splitWhitespace
from sequtils import foldr
import tables
import lib/header, lib/wenum, lib/wstruct
import util/wenumutil, util/wstructutil

proc newFileName(filename: string): Table[string, string] =
    const filetypes: array[5, string] = ["go", "kt", "nim", "py", "ts"]
    let temp: seq[string] = filename.split('/')
    result = initTable[string, string]()

    for filetype in filetypes:
        case filetype
        of "go", "nim", "py":
            result.add(
                filetype,
                join(
                    split(
                        temp[temp.len() - 1], '_'
                    )
                )
            )
        of "kt", "ts":
            var words = split(temp[temp.len() - 1], '_')
            for i in countup(0, words.len() - 1, 1):
                words[i] = capitalizeAscii(words[i])
            result.add(filetype, join(words))

proc fromFile*(filename: string, header: string = ""): Table[string, string] =
    var fileInfo: seq[string] = filename.split('.')

    var newFileName: Table[string, string] = initTable[string, string]()
    var fileContents: Table[string, string] = initTable[string, string]()
    var packages: Table[string, string] = initTable[string, string]()

    let file: File = open(filename)
    var line: string

    while readLine(file, line) and line.len() > 0:
        var words: seq[string] = line.splitWhitespace()
        var filepath: seq[string] = words[0].split('-')

        if words.len() < 2 or filepath.len() < 2:
            continue

        if filepath[1] != "filepath":
            break;

        packages.add(filepath[0], words[1])

    case fileInfo[fileInfo.len() - 1]
    of "struct":
        var wstruct = newWStruct()
        wstruct.parseFile(file, filename, packages)
        fileContents = wstruct.genFiles()
        newFileName = newFileName(filename.substr(0, filename.len() - 7))
    of "enum":
        var wenum = newWEnum()
        wenum.parseFile(file, filename, packages)
        fileContents = wenum.genFiles()
        newFileName = newFileName(filename.substr(0, filename.len() - 5))
    else:
        echo "Unsupported file type: " & fileInfo[fileInfo.len() - 1]
        file.close()
        return

    file.close()
    result = initTable[string, string]()
    for filetype in packages.keys:
        result.add(
            getOrDefault(packages, filetype) &
            "/" &
            newFileName[filetype] &
            filetype,
            genHeader(filetype, filename, header) &
            getOrDefault(fileContents, filetype),
        )
