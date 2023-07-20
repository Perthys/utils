local HashMap = {}; HashMap.__index = HashMap;

local function RoundToNearestNumber(Number, Target)
    local Divided = math.floor(Number / Target + 0.5);
    local Rounded = Divided * Target;

    return Rounded
end

function HashMap.new(HashmapData)
    local self = setmetatable(HashmapData, HashMap);
    local Nodes = {}; self.Nodes = Nodes;

    return self;
end

function HashMap:Insert(Data)
    local Scale = self.Scale; 
    local Hashed = Data.Hashed;
    local Position = Data.Position;
    
    local X, Y, Z = Position.X, Position.Y, Position.Z;

    local X, Y, Z = RoundToNearestNumber(X, Scale), RoundToNearestNumber(Y, Scale), RoundToNearestNumber(Z, Scale);

    local XTable = self.Nodes[X]; if not XTable then XTable = {}; self.Nodes[X] = XTable end;
    local YTable = XTable[Y]; if not YTable then YTable = {}; XTable[Y] = YTable end;
    local ZTable = YTable[Z]; if not ZTable then ZTable = {}; YTable[Z] = ZTable end;

    table.insert(ZTable, Hashed);
end

function HashMap:GetNeighbors(Data)
    local Position = Data.Position;
    local Range = Data.Range;
    local Scale = self.Scale;

    local Neighbors = {};

    local DividedRange = Range / 2;
    
    local X, Y, Z = Position.X, Position.Y, Position.Z;
    local X, Y, Z = RoundToNearestNumber(X, Scale), RoundToNearestNumber(Y, Scale), RoundToNearestNumber(Z, Scale);

    for XIndex = X - Range * Scale, X + Range * Scale, Scale do
        local XTable = self.Nodes[XIndex]; if not XTable then continue end;
        
        for YIndex = Y - Range * Scale, Y + Range * Scale, Scale do
            local YTable = XTable[YIndex]; if not YTable then continue end;

            for ZIndex = Z - Range * Scale, Z + Range * Scale, Scale do

                local ZTable = YTable[ZIndex]; if not ZTable then continue end;

                for _, Hashed in ZTable do
                    table.insert(Neighbors, Hashed)
                end
            end
        end
    end
    return Neighbors;
end

--[[
local XYZNeighborMap = HashMap.new({
    Scale = 3;
})

for X_Index = 1, 10 do 
    for Y_Index = 1, 10 do 
        local Part = Instance.new("Part")
        Part.Anchored = true
        Part.Position = Vector3.new(X_Index * 4, 10, Y_Index * 4)
        XYZNeighborMap:Insert({
            Position = Part.Position,
            Hashed = Part,
        })
        Part.Parent = workspace
    end
end

local Neighbors = XYZNeighborMap:GetNeighbors({
    Position = Vector3.new(1, 2, 4),
    Range = 7
})

for Index, Neighbor in Neighbors do 
    Neighbor.Material = Enum.Material.Neon
end]]



