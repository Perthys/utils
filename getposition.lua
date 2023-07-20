-- kinda useless but parse position from most objects
local PositionMap = nil;

PositionMap = {
    ["CFrame"] = function(Arg)
        return Arg.Position
    end;
    ["Vector3"] = function(Arg)
        return Arg
    end;
    ["Instance"] = function(Arg)
        for Index, Value in pairs(PositionMap.__InstanceMap) do -- I could do table.find but that doesn't account for inherited class type
            if Arg:IsA(Index) then
                return Value(Arg);
            end
        end
    end;
    __InstanceMap = {
        ["PVInstance"] = function(Arg)
            return Arg:GetPivot().Position;
        end;
        ["Player"] = function(Arg) 
            local Character = Arg.Character or Arg.CharacterAdded:Wait(); -- I think yielding for this is acceptable purely due to, players forced to have a character
            
            if Character then
                return Character:GetPivot().Position;
            end
        end;
        ["Humanoid"] = function(Arg)
            local Character = Arg.Parent;
            
            if Character then
                return Character:GetPivot().Position;
            end
        end
    };
}

local function ConvertToPosition(Arg1)
    return PositionMap[typeof(Arg1)](Arg1);
end

return ConvertToPosition
