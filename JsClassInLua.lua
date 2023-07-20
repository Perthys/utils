local Constructors = {};

local AllMetaMethods = {
    "__index";
    "__newindex";
    "__call";
    "__concat";
    "__unm";
    "__add";
    "__sub";
    "__mul";
    "__div";
    "__mod";
    "__pow";
    "__tostring";
    "__metatable";
    "__eq";
    "__lt";
    "__le";
    "__mode";
    "__gc";
    "__len";
}

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

local constructor = Syntax(function(Handler)
    return {
        Type = "Constructor";
        Handler = Handler;
    }
end)

local class = Syntax(function(Name, Data)
    Constructors[Name] = function(...)
        local self = {};

        local Constructor;

        local UserData = newproxy(true)
        local Metatable = getmetatable(UserData)
    
        Metatable.__index = function(_, Index)
            local Value = self[Index]
            local Found = Data[Index];

            if type(Found) == "table" and Found.Get then
                return Found.Get(self);
            end

            return Value
        end

        Metatable.__newindex = function(_, Index, Value)
            local Found = Data[Index];

            if type(Found) == "table" and Found.Set then
                return Found.Set(self, Value);
            end

            self[Index] = Value
        end
    
        for Index, Value in pairs(Data) do
            if type(Value) == "table" then 
                local Type = Value.Type; 

                if Type and Type == "Constructor" then
                    Constructor = Value;
                end

                continue
            elseif table.find(AllMetaMethods, Index) then
                Metatable[Index] = Value
                continue
            else
                self[Index] = Value;
            end
        end

        Constructor = Constructor.Handler;

        if not Constructor then error "No Constructor Found" end
        Constructor(self, ...);

        return UserData;
    end
end)

local new = Syntax(function(Class)
    return function(...)
        return Constructors[Class] and Constructors[Class](...); 
    end;
end)

return function()
  return class, new, constructor;
end


--[[

class "TestClass" {
  constructor(function(...)
    self.Test = "Hello";
  end);
  Test = {
    Get = function()
        return self.Test
    end;
    Set = function(Value)
      self.Test = Value * 2;
    end;
  };
  Method = function(...)
    print("Test");
  end;
  __mul = function(self, Index)
    return 03000
  end;
  OtherTest = "Value";
}

local Test = new "TestClass" ()

print(Test * 500)
Test:Method()

Test.Test = 4

print(Test.Test)
]]
