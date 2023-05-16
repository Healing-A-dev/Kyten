require "src/kyten/modules/parser"
parse("src/kyten/modules/init")
parseConnect(split_string)
f=io.open("src/kyten/modules/tmp.lua.ky","w")
f:write(tostring(rtble[1]))
f:close()
dofile("src/kyten/modules/tmp.lua.ky")
os.remove("src/kyten/modules/tmp.lua.ky")