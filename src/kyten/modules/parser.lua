--[[FIND AND REPLACE PARSER MADE BY ME (HEALING)
Discord: Healing#1109]]

local parser = {}
-- Imports
require("src/kyten/modules/parseWorker")

-- Globals
Keywords = {"putln","format","for","end","if","else","elseif","while","public","static","||", "&&", "import","func","return"}
ints = {'1','2','3','4','5','6','7','8','9','0'}
variables = {static = {}, global = {}, static_immutables = {}, global_immutables = {}}

-- Code
function import(filename)
  importing = true
  if filename == "Textstyle" then
    filename = "src/kyten/modules/"..filename
  end
  if filename == "parse" then
    require("src/kyten/modules/parser")
    require("src/kyten/modules/parseWorker")
  elseif string.find(filename,"<lua>") ~= nil then
    filename = string.gsub(filename, "<lua>", "")
    if io.open(filename..".lua") == nil then
      print("Kyten: <import error>\n\t[ky]: '"..filename..".lua' No such file or directory found\ntraceback:\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
      os.exit()
    end
    require(filename)
  else
    if io.open(filename..".ky") == nil then
      print("Kyten: <import error>\n\t[ky]: '"..filename..".ky' No such file or directory found\ntraceback:\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
      os.exit()
    end
    parse(filename)
    parseConnect(split_string)
    openwrite = io.open(filename.."_.lua","w")
    openwrite:write(tostring(rtble[1]).."\nreturn "..filename:gsub("/",""))
    openwrite:close()
    require(filename.."_")
    os.remove(filename.."_.lua")
  end
  importing = false
end


function search(table, value)
  local num = 0
  for _,i in pairs(table) do
    num = num + 1
    if (value == i) then
      return true
    elseif (value ~= i and num == #table) then
      return false
    end
  end
end

function os.run(args)
  return os.execute(args)
end

function io.error(words)
  print("Kyten:")
  print("traceback:\n\t[ky]: '"..words.."' in command 'error'")
  print("\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
  os.exit()
end

function io.getln(string)
  string = string or nil
  if string == "*l" or string == "*a" or string == "*number" then 
    return io.read(string)
  elseif string~=nil then
    io.write(string)
    return io.read()
  else
    return io.read()
  end
end

function math.genrand(num1, num2)
  math.randomseed(os.time())
  return math.random(num1, num2)
end

function parse(f)
  split_string = {}
  tokenTable = {}
  syntaxTable = {}
  splitSyntaxTable = {}
  filetypeLua = false
  local l = {}
  local iph = 'format "sh.io"'
  local n = 0
  local v = 0
  local value
  local n_chars = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','_'}
  local o_chars = {'+','-','*','/','^','%'}
  local whitespace = {" ","\n","\t"}
  local special = {'"',":",";","(",")","{","}",".",",","#","="}
  fileName = f
  if io.open(f..".ky") == nil then
    print("Kyten: '"..f..".ky' No such file or directory found")
    print("\027[31mexit status 1\027[0m")
    os.exit()
  else
    file = io.open(f..".ky")
  end
  lines = file:lines()
  for line in lines do
    syntaxTable[#syntaxTable+1] = line
    l[#l+1] = line
  end
  file:close()
  if l[1] == nil then
    print("Kyten: <format> error\ntracback\n\t[ky]: '"..fileName..".ky' missing format type\n\t[file]: "..fileName..".ky \n\t[line]: 1")
    os.exit()
  end
  if l[1] == nil and not importing and fileName == "index" or string.find(l[1],'format "sh.io"') == nil and not importing and fileName == "index" then
    print("Kyten: index.ky: missing format type 'sh.io'")
    os.exit()
  end
  if string.find(l[1],'@format "sh.io"') ~= nil and #l[1] > #"@format " and fileName == "index" then
    table.remove(l,1)
  elseif string.find(l[1],'@format "lib.module"') == nil and fileName ~= "index" and string.find(l[1],'@format "core.file"') == nil then
    print("Kyten: "..fileName..".ky: missing format or improper format type")
    os.exit()
  else
    for _,i in pairs(l) do
      if string.find(i,'@format "lib.module"') then
        l[_] = "local "..fileName:gsub("/","").." = {}\n"
      elseif string.find(i,'<Syntax> = "Lua"') and not string.find(i,"-#") and not string.find(i,"###") then
        l[_] = '-- <Syntax> = "Lua"\n'
        fileTypeLua = true
      elseif string.find(i,'@format "core.file"') then
        l[_] = "-# Core file\n"
      end
    end
  end
  for _,i in pairs(syntaxTable) do
    v = v +1
    for s = 1, syntaxTable[v]:len() do
      local str = syntaxTable[v]:sub(s,s)
      splitSyntaxTable[#splitSyntaxTable+1] = str
    end
  end
  for _,i in pairs(l) do
    n = n +1
    for s = 1, l[n]:len() do
      local str = l[n]:sub(s,s)
      split_string[#split_string+1] = str
    end
  end
  for _,i in pairs(split_string) do
    value = nil
    local t = 0
    for _,s in pairs(special) do
      if i == s then
        if i == ";" then
          value = "End of Line"
        elseif i == ":" then
          value = "Function/Method Character"
        elseif i == "(" then
          value = "Function Opener"
        elseif i == ")" then
          value = "Function Closer"
        elseif i == "{" then
          value = "Open Brace"
        elseif i == "}" then
          value = "Close Brace"
        else
          value = "special"
        end
      end
    end
    for _,w in pairs(whitespace) do
      if i == w then
        value = "whitespace"
      end
    end
    for _,n in pairs(ints) do
      t = t + 1
      if i == n and i[t-1] ~= '"' then
        value = "integer"
      end
    end
    for _,c in pairs(n_chars) do
      if i == c or i == c:upper() then
        value = "character"
      end
    end
    for _,o in pairs(o_chars) do
      if i == o then
        value = "operator"
      end
    end
    tokenTable[#tokenTable+1] = tostring(value)
  end
  return split_string, tokenTable, fileName, splitSyntaxTable
end

function parseConnect(tble)
-- Variables, Tables, And Bools
  variables.static = {}  
  variables.static_immutables = {}
  local alpha = 0
  local currentPosition = 0
  lineNumber = 0
  local string = ""
  local fs = false
  rtble = {}
  local ifs = false
  local multiLineComment = false
  local tv = false
  local inString = false
  local ws = false
  local ip_p = false
  local comment = false
  local ittv = false
  local pmultiLineComment = false
  local ptv = false
  local pv = false
  varTable = {}
  local importPhrase = {}
  local phraseTable = {}
  local phraseTableLocation = {}
  variableTable = {}
              --[[Actual Code Chuck Now (aka the Syntax)]]--
  if not fileTypeLua then
    for l,v in pairs(tble) do
      currentPosition = currentPosition + 1
      if split_string[currentPosition] == "#" and split_string[currentPosition+1] == "#" and split_string[currentPosition+2] == "#" and not multiLineComment and not inString then
        tble[currentPosition] = "-"
        tble[currentPosition+1] = "-"
        tble[currentPosition+2] = "[["
        multiLineComment = true
      elseif split_string[currentPosition] == "#" and split_string[currentPosition+1] == "#" and split_string[currentPosition+2] == "#" and multiLineComment and not inString then
        tble[currentPosition] = "]"
        tble[currentPosition+1] = "]"
        tble[currentPosition+2] = "\n"
        multiLineComment = false
      elseif split_string[currentPosition] == "-" and split_string[currentPosition+1] == "#" and not inString then
        tble[currentPosition] = "--"
        tble[currentPosition+1] = ""
        comment = true
      elseif split_string[currentPosition] == "-" and split_string[currentPosition+1] == "-" and not inString then
        if tokenTable[currentPosition+2] == "whitespace" then
          error(fileName..".ky: Invalid syntax near ".."'"..split_string[currentPosition+3].."'",9)
        elseif tokenTable[currentPosition+2] ~= "whitespace" then
          error(fileName..".ky: Invalid syntax near ".."'"..split_string[currentPosition+2].."'",9)
        end
      end
      if split_string[currentPosition] == "i" and split_string[currentPosition + 1] == "f" and not inString and not comment and not multiLineComment then
        ifs = true
        ittv = true
      elseif split_string[currentPosition] == "e" and split_string[currentPosition+1] == "l" and split_string[currentPosition+2] == "s" and split_string[currentPosition+3] == "e" and not comment and not multiLineComment then
        ittv = true
      elseif split_string[currentPosition] == "e" and split_string[currentPosition+1] == "l" and split_string[currentPosition+2] == "s" and split_string[currentPosition+3] == "e" and split_string[currentPosition+4] == "i" and split_string[currentPosition+5] == "f" and not inString and not comment and not multiLineComment then
        ifs = true
        ittv= true
      elseif split_string[currentPosition] == "w" and split_string[currentPosition+1] == "h" and split_string[currentPosition+2] == "i" and split_string[currentPosition+3] == "l" and split_string[currentPosition+4] == "e" and not inString then
        ws = true
        ittv = true
      elseif split_string[currentPosition] == "f" and split_string[currentPosition+1] == "o" and split_string[currentPosition+2] == "r" and not inString and not comment and not multiLineComment then
        ws = true
        fs = true
        ittv = true
      end
      if split_string[currentPosition] == "p" and split_string[currentPosition+1] == "a" and split_string[currentPosition+2] == "i" and split_string[currentPosition+3] == "r" and split_string[currentPosition+4] == "s" and not inString or split_string[currentPosition] == "i" and split_string[currentPosition+1] == "p" and split_string[currentPosition+2] == "a" and split_string[currentPosition+3] == "i" and split_string[currentPosition+4] == "r" and split_string[currentPosition+5] == "s" and not inString then
        ip_p = true
      elseif split_string[currentPosition] == "@" and split_string[currentPosition+1] == "s" and split_string[currentPosition+2] == "e" and split_string[currentPosition+3] == "l" and split_string[currentPosition+4] == "e" and split_string[currentPosition+5] == "c" and split_string[currentPosition+6] == "t" and not inString then
        tble[currentPosition] = "select"
        tble[currentPosition+1] = ""
        tble[currentPosition+2] = ""
        tble[currentPosition+3] = ""
        tble[currentPosition+4] = ""
        tble[currentPosition+5] = ""
        tble[currentPosition+6] = ""
        ip_p = true
      end
      if tokenTable[currentPosition] == "Function Closer" and ip_p then
        ip_p = false
      end
      if tokenTable[currentPosition] == "Function Opener" and fs and not ip_p then
        tble[currentPosition] = ""
      elseif tokenTable[currentPosition] == "Function Closer" and fs and not ip_p then
        tble[currentPosition] = ""
        fs = false
      end
      if tokenTable[currentPosition] == "Open Brace" and tokenTable[currentPosition - 1] == "whitespace" and not comment and not multiLineComment or tokenTable[currentPosition] == "Open Brace" and tokenTable[currentPosition - 1] == "special" and not comment and not multiLineComment then
        tv = true
      end
      if tokenTable[currentPosition] == "End of Line" and not inString or tokenTable[currentPosition] == "Open Brace" and not tv and not inString then
        tble[currentPosition] = "\n"
        comment = false
        tv = false
        ptv = true
      end
      if tokenTable[currentPosition] == "Open Brace" and not tv and not comment and not multiLineComment and not inString or tokenTable[currentPosition] == "Close Brace" and not tv and tokenTable[currentPosition+1] ~= "Close Brace" and not comment and not multiLineComment and not inString then
        tble[currentPosition] = " "
      elseif tokenTable[currentPosition] == "Open Brace" and not tv and not comment and not multiLineComment and not inString and ittv then
        ittv = false
      elseif tokenTable[currentPosition] == "Close Brace" and not tv and not comment and not multiLineComment and not inString and ittv then
        ittv = false
      elseif tv and tokenTable[currentPosition] == "Close Brace" and tokenTable[currentPosition+1] ~= "Close Brace" then
        tble[currentPosition] = "}"
      end
      if tokenTable[currentPosition] == "Function/Method Character" and split_string[currentPosition+1] == "s" and split_string[currentPosition+2] == "e" and split_string[currentPosition+3] == "t" and not ifs and not comment and not multiLineComment then
        tble[currentPosition] = ""
        tble[currentPosition+1] = "."
        tble[currentPosition+2] = "_"
        tble[currentPosition+3] = ""
      end
      if tokenTable[currentPosition] == "Function/Method Character" and tokenTable[currentPosition - 1] == "Function Closer" and tokenTable[currentPosition - 1] ~= "character" and not comment and not multiLineComment then
        tble[currentPosition] = "\n"
        tv = false
      end
      if tokenTable[currentPosition] == "Function/Method Character" and ifs and not inString and split_string[currentPosition -1] ~= ")" then
        tble[currentPosition] = ":"
      elseif tokenTable[currentPosition] == "Function/Method Character" and ifs then
        tble[currentPosition] = " then\n"
        ifs = false
      elseif tokenTable[currentPosition] == "Function/Method Character" and ws then
        tble[currentPosition] = " do\n"
        ws = false
      elseif split_string[currentPosition] == "!" and ifs and split_string[currentPosition+1] == "=" or split_string[currentPosition] == "!" and ws and split_string[currentPosition+1] == "=" then
        tble[currentPosition] = "~"
      elseif split_string[currentPosition] == "~" and ifs then
        error(fileName..".ky: unexpected symbol near '"..split_string[currentPosition+1].."'",9)
      end
      if split_string[currentPosition] == '"' and not inString or split_string[currentPosition] == "'" and not inString then
        inString = true
      elseif split_string[currentPosition] == '"' and inString or split_string[currentPosition] == "'" and inString then
        inString = false
      end
      if split_string[currentPosition] == "|" and split_string[currentPosition+1] == "|" and not inString and not comment and not multiLineComment then
        tble[currentPosition] = "o"
        tble[currentPosition+1] = "r"
      elseif split_string[currentPosition] == "&" and split_string[currentPosition+1] == "&" and not inString and not comment and not multiLineComment then
        tble[currentPosition] = "and"
        tble[currentPosition+1] = ""
      elseif split_string[currentPosition] == "!" and not inString and not comment and not multiLineComment and ifs or split_string[currentPosition] == "!" and not inString and not comment and not multiLineComment and ws or split_string[currentPosition] == "!" and not inString and not comment and not multiLineComment and fs then
        tble[currentPosition] = "not "
      end
      if split_string[currentPosition] == "p" and split_string[currentPosition+1] == "u" and split_string[currentPosition+2] == "t" and split_string[currentPosition+3] == "l" and split_string[currentPosition+4] == "n" and tokenTable[currentPosition] ~= "Function Opener" and not inString and not tv and not pv then
        tble[currentPosition] = "p"
        tble[currentPosition+1] = "r"
        tble[currentPosition+2] = "i"
        tble[currentPosition+3] = "n"
        tble[currentPosition+4] = "t("
        pv = true
      elseif split_string[currentPosition] == "p" and split_string[currentPosition+1] == "u" and split_string[currentPosition+2] == "t" and split_string[currentPosition+3] == "l" and split_string[currentPosition+4] == "n" and tokenTable[currentPosition] == "Function Opener" and not inString and not tv then
        tble[currentPosition] = "p"
        tble[currentPosition+1] = "r"
        tble[currentPosition+2] = "i"
        tble[currentPosition+3] = "n"
        tble[currentPosition+4] = "t"
      elseif split_string[currentPosition] == "i" and split_string[currentPosition+1] == "m" and split_string[currentPosition+2] == "p" and split_string[currentPosition+3] == "o" and split_string[currentPosition+4] == "r" and split_string[currentPosition+5] == "t" and tokenTable[currentPosition+6] == "Function Opener" and not inString then
        local number = 5
        local start = -1
        local allowed_time = 1000
        if tble[currentPosition] ~= ";" then
          repeat
            number = number+1
            local store = tble[currentPosition+number]
            if store ~= ";" and store ~= '"' and store ~= "'" and store ~= " " then
              importPhrase[#importPhrase+1] = store
            end
            if start == allowed_time then
              print("Kyten: <syntax> error\ntraceback\n\t[ky]: ';' expected near '"..table.concat(importPhrase).."'\n\t[file]: "..fileName..".ky")
              os.exit()
            end
            start = start+1
          until
            tble[currentPosition+number] == ";"
        end
        immutableAdd(table.concat(importPhrase))
      elseif split_string[currentPosition] == "i" and split_string[currentPosition+1] == "m" and split_string[currentPosition+2] == "p" and split_string[currentPosition+3] == "o" and split_string[currentPosition+4] == "r" and split_string[currentPosition+5] == "t" and tokenTable[currentPosition+6] == "whitespace" and not inString then
        local number = 5
        local start = -1
        local allowed_time = 1000
        tble[currentPosition+5] = "t".."("
        if tble[currentPosition] ~= ";" then
          repeat
            number = number+1
            local store = tble[currentPosition+number]
            if store ~= ";" and store ~= '"' and store ~= "'" and store ~= " " then
              importPhrase[#importPhrase+1] = store
            end
            if start == allowed_time then
              print("Kyten: <syntax> error\ntraceback\n\t[ky]: ';' expected near '"..table.concat(importPhrase).."'\n\t[file]: "..fileName..".ky")
              os.exit()
            end
            start = start+1
          until
            tble[currentPosition+number] == ";"
        end
        immutableAdd(table.concat(importPhrase))
        pv = true
      elseif pv and split_string[currentPosition] == "/" and not inString then
        conj = true
        tble[currentPosition] = ".."
      elseif pv and tokenTable[currentPosition] == "End of Line" and not inString then
        tble[currentPosition] = ")"..split_string[currentPosition]
        pv = false
      end
      if split_string[currentPosition] == "f" and split_string[currentPosition+1] == "u" and split_string[currentPosition+2] == "n" and split_string[currentPosition+3] == "c" and not inString or split_string[currentPosition] == "f" and split_string[currentPosition+1] == "u" and split_string[currentPosition+2] == "n" and split_string[currentPosition+3] == "c" and tokenTable[currentPosition+4] == "Function Opener" and not inString then
        tble[currentPosition] = "fun"
        tble[currentPosition+1] = "ct"
        tble[currentPosition+2] = "io"
        tble[currentPosition+3] = "n"
        ittv = true
      end
      if split_string[currentPosition] == "?" and split_string[currentPosition+1] == "s" and split_string[currentPosition+2] == "t" and split_string[currentPosition+3] == "a" and split_string[currentPosition+4] == "t" and split_string[currentPosition+5] == "i" and split_string[currentPosition+6] == "c" and not inString then
        tble[currentPosition] = "l"
        tble[currentPosition+1] = ""
        tble[currentPosition+2] = "oc" 
        tble[currentPosition+3] = "" 
        tble[currentPosition+4] = "a"
        tble[currentPosition+5] = "l"
        tble[currentPosition+6] = ""
      end
      if split_string[currentPosition] == ":" and split_string[currentPosition+1] == ":" and split_string[currentPosition+2] == "<" and split_string[currentPosition+3] == "@" and split_string[currentPosition+4] == "S" and split_string[currentPosition+5] == "t" and split_string[currentPosition+6] == "r" and split_string[currentPosition+7] == "i" and split_string[currentPosition+8] == "n" and split_string[currentPosition+9] == "g" and split_string[currentPosition+10] == ">" and not inString then
        tble[currentPosition] = ""
        tble[currentPosition+1] = ""
        tble[currentPosition+2] = ""
        tble[currentPosition+3] = ""
        tble[currentPosition+4] = ""
        tble[currentPosition+5] = ""
        tble[currentPosition+6] = ""
        tble[currentPosition+7] = ""
        tble[currentPosition+8] = ""
        tble[currentPosition+9] = ""
        tble[currentPosition+10] = ""
      elseif split_string[currentPosition] == ":" and split_string[currentPosition+1] == ":" and split_string[currentPosition+2] == "<" and split_string[currentPosition+3] == "@" and split_string[currentPosition+4] == "I" and split_string[currentPosition+5] == "n" and split_string[currentPosition+6] == "t" and split_string[currentPosition+7] == "e" and split_string[currentPosition+8] == "g" and split_string[currentPosition+9] == "e" and split_string[currentPosition+10] == "r" and split_string[currentPosition+11] == ">" and not inString then
        tble[currentPosition] = ""
        tble[currentPosition+1] = ""
        tble[currentPosition+2] = ""
        tble[currentPosition+3] = ""
        tble[currentPosition+4] = ""
        tble[currentPosition+5] = ""
        tble[currentPosition+6] = ""
        tble[currentPosition+7] = ""
        tble[currentPosition+8] = ""
        tble[currentPosition+9] = ""
        tble[currentPosition+10] = ""
        tble[currentPosition+11] = ""
      elseif split_string[currentPosition] == ":" and split_string[currentPosition+1] == ":" and split_string[currentPosition+2] == "<" and split_string[currentPosition+3] == "@" and split_string[currentPosition+4] == "F" and split_string[currentPosition+5] == "l" and split_string[currentPosition+6] == "o" and split_string[currentPosition+7] == "a" and split_string[currentPosition+8] == "t" and split_string[currentPosition+9] == ">" and not inString then
        tble[currentPosition] = ""
        tble[currentPosition+1] = ""
        tble[currentPosition+2] = ""
        tble[currentPosition+3] = ""
        tble[currentPosition+4] = ""
        tble[currentPosition+5] = ""
        tble[currentPosition+6] = ""
        tble[currentPosition+7] = ""
        tble[currentPosition+8] = ""
        tble[currentPosition+9] = ""
      elseif split_string[currentPosition] == ":" and split_string[currentPosition+1] == ":" and split_string[currentPosition+2] == "<" and split_string[currentPosition+3] == "@" and split_string[currentPosition+4] == "C" and split_string[currentPosition+5] == "h" and split_string[currentPosition+6] == "a" and split_string[currentPosition+7] == "r" and split_string[currentPosition+8] == ">" and not inString then
        tble[currentPosition] = ""
        tble[currentPosition+1] = ""
        tble[currentPosition+2] = ""
        tble[currentPosition+3] = ""
        tble[currentPosition+4] = ""
        tble[currentPosition+5] = ""
        tble[currentPosition+6] = ""
        tble[currentPosition+7] = ""
        tble[currentPosition+8] = ""
      elseif split_string[currentPosition] == ":" and split_string[currentPosition+1] == ":" and split_string[currentPosition+2] == "<" and split_string[currentPosition+3] == "@" and split_string[currentPosition+4] == "A" and split_string[currentPosition+5] == "r" and split_string[currentPosition+6] == "r" and split_string[currentPosition+7] == "a" and split_string[currentPosition+8] == "y" and split_string[currentPosition+9] == ">" and not inString then
        tble[currentPosition] = ""
        tble[currentPosition+1] = ""
        tble[currentPosition+2] = ""
        tble[currentPosition+3] = ""
        tble[currentPosition+4] = ""
        tble[currentPosition+5] = ""
        tble[currentPosition+6] = ""
        tble[currentPosition+7] = ""
        tble[currentPosition+8] = ""
        tble[currentPosition+9] = ""
      end
      if split_string[currentPosition] == "e" and split_string[currentPosition+1] == "r" and split_string[currentPosition+2] == "r" and split_string[currentPosition+3] == "o" and split_string[currentPosition+4] == "r" and tokenTable[currentPosition+5] == "whitespace" and not comment and not multiLineComment and not inString then
        tble[currentPosition+4] = "r("
        pv = true
      end
      if split_string[currentPosition] == "s" and split_string[currentPosition+1] == "e" and split_string[currentPosition+2] == "t" and tokenTable[currentPosition - 1] == "whitespace" and not inString and not comment and not multiLineComment then
        tble[currentPosition] = ""
        tble[currentPosition+1] = ""
        tble[currentPosition+2] = ""
        if tokenTable[currentPosition+3] == "whitespace" then
          tble[currentPosition+3] = ""
        end
      end
      string = tostring(string..tble[currentPosition])
    end
    --[[Logic Stuff]]--
    for _,i in pairs(syntaxTable) do
      lineNumber = lineNumber + 1
      i:KytenFindVariable(_)
      local ignore = false
      local scope
      alpha = alpha + (#syntaxTable[_])
      local vl = splitSyntaxTable[alpha]
      for p,m in pairs(Keywords) do
        if string.find(i, m) ~= nil and #i == #m or string.find(i, m) ~= nil and #i == #m+1 then
          print("Kyten: <syntax> error\ntraceback:\n\t[ky]: unexpected keyword '"..m.."'\n\t[file]: "..fileName..".ky\n\t[line]: ".._)
          os.exit()
        end
      end
      if vl == "{" and not ptv and string.find(syntaxTable[_], "=") ~= nil and string.find(syntaxTable[_],":{") == nil then
        ptv = true
        ignore = true
      elseif vl == ";" and ptv or vl == "}" and string.find(syntaxTable[_], ";") ~= nil and ptv then
        ptv  = false
      end
      if string.find(i, "###") and not pmultiLineComment then
        pmultiLineComment = true
      elseif vl == "#" and pmultiLineComment then
        pmultiLineComment = false
      end
      if vl ~= nil and vl ~= ";" and vl ~= "{" and vl ~= "#" and not pmultiLineComment and not ptv or vl == "," and not ptv then
        print("Kyten: <eol> error")
        print("traceback:\n\t[ky]: ';' expected")
        print("\t[file]: "..fileName..".ky\n\t[line]: ".._)
        os.exit()
      elseif vl ~= "," and ptv and string.find(syntaxTable[_+1],"}") == nil and #syntaxTable[_] > 0 and #syntaxTable[_+1] > 0 and ptv and string.find(syntaxTable[_],"{") == nil and not ignore then
        print("Kyten: <eol> error")
        print("traceback:\n\t[ky]: ',' expected")
        print("\t[file]: "..fileName..".ky\n\t[line]: ".._)
        os.exit()
      end
    end
    local errorLineNumber = 0
    alpha = 0
    for _,h in pairs(syntaxTable) do
      local Assigned_Keywords = {Keywords[3], Keywords[5], Keywords[6], Keywords[8], Keywords[14]}
      local found_kw = false
      local found_var = false
      for k,v in pairs(Assigned_Keywords) do
        if string.find(h,v) then
          found_kw = true
          if v == Keywords[5] and string.find(h, Keywords[6]) == nil or v == Keywords[8] or v == Keywords[14] then
            errorLineNumber = _
            phraseTable[tostring(errorLineNumber)] = v
            phraseTableLocation[#phraseTableLocation+1] = errorLineNumber
            break
          end
        elseif string.find(h,Keywords[3]) and not string.find(h,Keywords[2]) and not string.find(h,"'") and not string.find(h, '"') then
          found_kw = true
          errorLineNumber = _
          phraseTable[tostring(errorLineNumber)] = Keywords[3]
          phraseTableLocation[#phraseTableLocation+1] = errorLineNumber
          break
        end
        alpha = alpha + (#h)
        local vl = splitSyntaxTable[alpha]
        local singlelncomment = false
        if string.find(h, "{") ~= nil and not ptv and string.find(h, "=") ~= nil then
          ptv = true
        elseif string.find(h, ";") ~= nil and ptv or string.find(h, "}") ~= nil and string.find(h, ";") ~= nil and ptv then
          ptv = false
        end
        if not found_kw and #h > 0 and string.find(h, "%a") ~= nil then
          for n,t in pairs(varTable) do
            if string.find(h,t) ~= nil then
              found_var = true
              break
            end
          end
        end
      end
      if string.find(h,Keywords[4].."};") ~= nil then
        phraseTable[tostring(phraseTableLocation[#phraseTableLocation])] = nil
        table.remove(phraseTableLocation,#phraseTableLocation)
      end
    end
    for _,i in pairs(phraseTable) do
      if i == Keywords[14] then
        print("Kyten: <eof> error\ntraceback:\n\t[ky]: 'end' expected to close function at line "..phraseTableLocation[#phraseTableLocation].."\n\t[file]: "..fileName..".ky\n\t[line]: "..phraseTableLocation[#phraseTableLocation])
        os.exit()
      else
        print("Kyten: <eof> error\ntraceback:\n\t[ky]: 'end' expected to close "..i.." statement at line "..phraseTableLocation[#phraseTableLocation].."\n\t[file]: "..fileName..".ky\n\t[line]: "..phraseTableLocation[#phraseTableLocation])
        os.exit()
      end
    end
  else
    for _,i in pairs(tble) do
      currentPosition = currentPosition + 1
      string = tostring(string..tble[currentPosition])
    end
  end
  for _,i in pairs(syntaxTable) do
    if string.find(i,"=") and not string.find(i,"^<Syntax>") then
      var = i:match("(.-=)")
      if not string.find(var,"'") and not string.find(var,'"') then
        var = var:gsub("?static","")
        var = var:gsub("function","")
        var = var:gsub("%=","")
        var = var:gsub("%s+","")
        var = var:gsub("%,"," ")
        for k in string.gmatch(var, "[^%s]+") do
          if not string.find(k, "%[") and not string.find(k, "%]") and not search(variableTable, k) then
            variableTable[#variableTable+1] = k
          end
        end
      end
    end
  end
  rtble[#rtble+1] = string
  return rtble
end
return parser