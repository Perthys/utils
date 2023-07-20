local function Syntax(Handler)
  local ArgAmount = debug.info(Handler, "a")

  local Functions = {};
  local Arguments = {}

  for Count = 1, ArgAmount  do
    table.insert(Functions, function(Arg)
        table.insert(Arguments, Arg)
        return Functions[Count + 1] or Count == ArgAmount and Handler(unpack(Arguments));
    end)
  end
  
  return Functions[1]
end

return Syntax

--[[
local Syntax = loadstring(game:HttpGet('https://raw.githubusercontent.com/Perthys/CustomLuaSyntax/main/main.lua'))()
local Class = Syntax(function(Name, Data)
    print(Name, Data[1])

    return Name, Data[1]
end)

Class "Balls" {
  "Test"
}
]]
