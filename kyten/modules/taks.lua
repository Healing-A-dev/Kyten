local Utility = {}

-- Waits 1 seconds or allotted seconds;
function wait(seconds)
  local s = os.time()
  if seconds == nil then
    repeat until os.time() > s
  else
    repeat until os.time() > s + seconds
  end
end


-- Spilts prints every value in a table, including values in a nested table;
function table.split(table, assigned_value)
  assigned_value = assigned_value or nil
  if type(table) ~= "table" then
    error("['table.split'] bad argument #1 (table expected, got "..type(table)..")",9)
  end
  local n = 0
  local tn
  if assigned_value == nil then
    for _,i in pairs(table) do
      if type(i) == "table" then
        print(tostring("\nTable: ".._))
        local tnum = 0
        for k,v in pairs(i) do
          tnum = tnum + 1
          print(i[tnum])
        end
      else
        print(i)
      end
    end
  else
    if type(assigned_value) ~= "string" then
      error("bad arugment #2 to split (string expected, got "..type(assigned_value)..")")
    end
    for _,k in pairs(table) do
      if (type(k) == "table") then
        tn = 0
        print(tostring("\nTable: ".._))
        for v,l in pairs(k) do
          tn = tn+1
          print(assigned_value..". "..tn.." "..tostring(l));
        end
      else
        n = n + 1
        print(assigned_value.." "..n..". "..k)
      end
    end
  end
end


-- Searches for 'value' in the given table. Returns true is value is found and false if not;
function table.search(table, value)
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


-- Merges two tables together. You MUST have a table set aside to merge the to tables together;
function table.merge(table1, table2, tablename)
  local tmp = {}
  local t1 = 0
  tablename = tablename or {};
  for _,i in pairs(table1) do
    tmp[#tmp+1] = i
  end
  for _,k in pairs(table2) do
    tmp[#tmp+1] = k
  end
  for _,v in pairs(tmp) do
    tablename[#tablename+1] = v
  end
  for _,i in pairs(table1) do
    t1 = t1 + 1
    table.remove(table1,t1)
  end
  t1 = 0
  for _,o in pairs(table2) do
    t1 = t1 + 1
    table.remove(table2,t1)
  end
  return tablename
end


-- Colors;
Color = {
  ["Red"] = "\027[91m",
  ["Purple"] = "\027[95m",
  ["Green"] = "\027[92m",
  ["Yellow"] = "\027[93m",
  ["Blue"] = "\027[94m",
  ["Cyan"] = "\027[96m",
  ["Grey"] = "\027[90m",
  ["Red.Strong"] = "\027[31m",
  ["Green.Strong"] = "\027[32m",
  ["Yellow.Strong"] = "\027[33m",
  ["Blue.Strong"] = "\027[34m",
  ["Cyan.Strong"] = "\027[36m",
  ["Grey.Strong"] = "\027[30m",
  ["Purple.Strong"] = "\027[35m",
}


-- Text Formats;
Style = {
  ["Bold"] = '\027[1m',
  ["Dim"] = '\027[2m',
  ["Slant"] = '\027[3m',
  ["Underline"] = '\027[4m',
  ["Inverse"] = '\027[7m',
  ["Invisible"] = '\027[8m',
  ["Crossover"] = '\027[9m',
}


-- Reset;
Reset = "\027[0m";


-- Typewriter Effect (CREDIT: ChatGPT);
function typewrite(text, delay)
  if type(text) ~= "string" then
    error("['typewrite'] bad argument #1 (string expected got "..type(text)..")",9);
  end
  for i = 1, #text do
    io.write(string.sub(text, i, i))
    io.flush()
    os.execute("sleep "..tostring(delay))
  end
end

return Utility