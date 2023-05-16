local parseWorker = {}

function string.KytenFindVariable(string,lineNumber)
  local isImmutable = false
  if string.find(string,"=") and not string.find(string,"^<Syntax>") then
    local var = string:match("(.-=)")
    if not string.find(var,"'") and not string.find(var,'"') then
      var = var:gsub("function","")
      if var:find("::<@%w+>") and var:find("set") then
        isImmutable = true
        var = var:gsub("set","")
        local varType = var:match("(@%w+)")
        local afterEqS = string:gsub(".*=",""):gsub("%;",""):gsub("%s+","")
        varType = varType:gsub("%p","")
        if varType == "Integer" then
          if afterEqS:find("%'") or afterEqS:find('%"') or afterEqS:find("%.") or afterEqS:find("%a") then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Integer'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        elseif varType == "String" then
          if not afterEqS:find("%'") and not afterEqS:find('%"') then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'String'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        elseif varType == "Array" then
          if not afterEqS:find("%{.+}") and not afterEqS:find("%{}") then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Array'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        elseif varType == "Char" then
          if not afterEqS:find("%'") and not afterEqS:find('%"') then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Char'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          elseif not afterEqS:find('%"%a"') and not afterEqS:find("%'%a'")then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Char'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        elseif varType == "Float" then
          if afterEqS:find("%'") or afterEqS:find('%"') then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Float'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        else
          print("Kyten: <type> error\ntraceback:\n\t[ky]: Attempt to set assign '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' to unknown type '"..varType.."'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
        end
        var = var:gsub("::<@%w+>","")
        var = var:gsub("%=","")
        var = var:gsub("%s+","")
        if not var:find("%?static") and not keysearch(variables.global_immutables,var:gsub("%?static","")) then
          variables.global_immutables[var] = varType
        elseif var:find("%?static") and not keysearch(variables.static_immutables,var:gsub("%?static","")) then
          var = var:gsub("?static","")
          variables.static_immutables[var] = varType
        end
      elseif var:find("::<@%w+>") and not var:find("set") then
        if not var:find("?static") then
          print("Kyten: <syntax> error\ntraceback:\n\t[ky]: Missing keyword 'set' near '"..var:gsub("%=",""):gsub("%s+",""):gsub("%,"," "):gsub("::<@%w+>","").."'\n\t[file]: "..fileName.."\n\t[line]: "..lineNumber)
          os.exit()
        else
          print("Kyten: <syntax> error\ntraceback:\n\t[ky]: Missing keyword 'set' near keyword '?static'\n\t[file]: "..fileName.."\n\t[line]: "..lineNumber)
          os.exit()
        end
      end
      var = var:gsub("%=","")
      var = var:gsub("%s+","")
      var = var:gsub("%,"," ")
      for k in string.gmatch(var, "[^%s]+") do
        if not string.find(k, "%[") and not string.find(k, "%]") and not search(variables.global, k) and not isImmutable and not k:find("%?static") then
          table.insert(variables.global,k)
        elseif not string.find(k, "%[") and not string.find(k, "%]") and not search(variables.static, k) and not isImmutable then
          k = k:gsub("?static","")
          table.insert(variables.static,k)
        end
      end
    end
  end
end

function immutableAdd(fileName)
  local fileLines = {}
  if io.open(fileName..".ky") == nil then
    goto skip
  end
  local file = io.open(fileName..".ky")
  local lines = file:lines()
  for line in lines do
    fileLines[#fileLines+1] = line
  end
  file:close()
  for _,i in pairs(fileLines) do
    local isImmutable = false
    local string = i
  if string.find(string,"=") and not string.find(string,"^<Syntax>") then
    local var = string:match("(.-=)")
    if not string.find(var,"'") and not string.find(var,'"') then
      var = var:gsub("function","")
      if var:find("::<@%w+>") and var:find("set") then
        isImmutable = true
        var = var:gsub("set","")
        local varType = var:match("(@%w+)")
        local afterEqS = string:gsub(".*=",""):gsub("%;",""):gsub("%s+","")
        varType = varType:gsub("%p","")
        if varType == "Integer" then
          if afterEqS:find("%'") or afterEqS:find('%"') or afterEqS:find("%.") or afterEqS:find("%a") then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Integer'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        elseif varType == "String" then
          if not afterEqS:find("%'") and not afterEqS:find('%"') then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'String'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        elseif varType == "Array" then
          if not afterEqS:find("%{.+}") and not afterEqS:find("%{}") then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Array'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        elseif varType == "Char" then
          if not afterEqS:find("%'") and not afterEqS:find('%"') then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Char'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          elseif not afterEqS:find('%"%a"') and not afterEqS:find("%'%a'")then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Char'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        elseif varType == "Float" then
          if afterEqS:find("%'") or afterEqS:find('%"') then
            print("Kyten: <type> error\ntraceback:\n\t[ky]: Varible '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' does not match set type 'Float'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
          end
        else
          print("Kyten: <type> error\ntraceback:\n\t[ky]: Attempt to set assign '"..var:gsub("::<@%w+>",""):gsub("%=",""):gsub("%s+",""):gsub("?static","").."' to unknown type '"..varType.."'\n\t[file]: "..fileName..".ky\n\t[line]: "..lineNumber)
            os.exit()
        end
        var = var:gsub("::<@%w+>","")
        var = var:gsub("%=","")
        var = var:gsub("%s+","")
        if not var:find("%?static") and not keysearch(variables.global_immutables,var:gsub("%?static","")) then
          variables.global_immutables[var] = varType
        elseif var:find("%?static") and not keysearch(variables.static_immutables,var:gsub("%?static","")) then
          var = var:gsub("?static","")
          variables.static_immutables[var] = varType
        end
      elseif var:find("::<@%w+>") and not var:find("set") then
        if not var:find("?static") then
          print("Kyten: <syntax> error\ntraceback:\n\t[ky]: Missing keyword 'set' near '"..var:gsub("%=",""):gsub("%s+",""):gsub("%,"," "):gsub("::<@%w+>","").."'\n\t[file]: "..fileName.."\n\t[line]: "..lineNumber)
          os.exit()
        else
          print("Kyten: <syntax> error\ntraceback:\n\t[ky]: Missing keyword 'set' near keyword '?static'\n\t[file]: "..fileName.."\n\t[line]: "..lineNumber)
          os.exit()
        end
      end
      var = var:gsub("%=","")
      var = var:gsub("%s+","")
      var = var:gsub("%,"," ")
      for k in string.gmatch(var, "[^%s]+") do
        if not string.find(k, "%[") and not string.find(k, "%]") and not search(variables.global, k) and not isImmutable and not k:find("%?static") then
          table.insert(variables.global,k)
        elseif not string.find(k, "%[") and not string.find(k, "%]") and not search(variables.static, k) and not isImmutable then
          k = k:gsub("?static","")
          table.insert(variables.static,k)
        end
      end
    end
  end
  end
  ::skip::
end

return parseWorker