local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService")

local Maid = loadstring(game:HttpGet('https://raw.githubusercontent.com/Quenty/NevermoreEngine/main/src/maid/src/Shared/Maid.lua'))()

shared.Maid = shared.Maid or Maid.new(); local Maid = shared.Maid; Maid:DoCleaning();
shared.Active = true;

local Ignore = false

local Offset = 4;

local Camera = workspace.CurrentCamera;

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait();
local Character = LocalPlayer.Character or LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();

local CurrentPoint = Character:GetPivot();

local task = table.clone(task);

local OldDelay = task.delay;

function task.delay(Time, Function)
    local Enabled = true;
    
    OldDelay(Time, function()
        if Enabled then
            Function();
        end
    end)
    
    return {
        Cancel = function()
            Enabled = false;
        end;
        Activate = function()
            Enabled = false
            Function()
        end
    }
end
local wait = task.wait;

local function StopVelocity()
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart"); if not HumanoidRootPart then return end;
    
    HumanoidRootPart.Velocity = Vector3.zero;
end

Maid:GiveTask(LocalPlayer.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
end))

Maid:GiveTask(RunService.Stepped:Connect(function()
    if shared.Active then
        StopVelocity();
        local CameraCFrame = Camera.CFrame
        
        CurrentPoint = CFrame.new(CurrentPoint.Position, CurrentPoint.Position + CameraCFrame.LookVector)
        Character:PivotTo(CurrentPoint);
    end
end))

local CurrentTask = nil;

local KeyBindStarted = {
    [Enum.KeyCode.Q] = {
        ["FLY_UP"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.Q) do
                RunService.Stepped:Wait()
                if Ignore then continue end;
                
                CurrentPoint = CurrentPoint * CFrame.new(0, Offset, 0)
            end
        end;
    };
    [Enum.KeyCode.E] = {
        ["FLY_DOWN"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.E) do
                RunService.Stepped:Wait()
                if Ignore then continue end;
                
                CurrentPoint = CurrentPoint * CFrame.new(0, -Offset, 0)
            end
        end;
    };
    [Enum.KeyCode.W] = {
        ["FLY_FORWARD"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.W) do
                RunService.Stepped:Wait()
                if Ignore then continue end;
                
                CurrentPoint = CurrentPoint * CFrame.new(0, 0, -Offset)
            end
        end;
    };
    [Enum.KeyCode.S] = {
        ["FLY_BACK"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.S) do
                RunService.Stepped:Wait()
                if Ignore then continue end;
                
                CurrentPoint = CurrentPoint * CFrame.new(0, 0, Offset)
            end
        end;
    };
    [Enum.KeyCode.A] = {
        ["FLY_LEFT"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.A) do
                RunService.Stepped:Wait()
                if Ignore then continue end;

                CurrentPoint = CurrentPoint * CFrame.new(-Offset, 0, 0)
            end
        end;
    };
    [Enum.KeyCode.D] = {
        ["FLY_RIGHT"] = function()
            while UserInputService:IsKeyDown(Enum.KeyCode.D) do
                RunService.Stepped:Wait()
                if Ignore then continue end;
                
                CurrentPoint = CurrentPoint * CFrame.new(Offset, 0, 0)
            end
        end;
    };
    [Enum.KeyCode.Space] = {
        ["IGNORE_ON"] = function()
            Ignore = true
        end;
    };
    [Enum.KeyCode.Equals] = {
        ["TOGGLE"] = function()
            local Humanoid = Character:FindFirstChild("Humanoid") if not Humanoid then return end;
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") if not HumanoidRootPart then return end;
            
            if not shared.Active then
                CurrentPoint = Character:GetPivot();
            else
                if CurrentTask then
                    CurrentTask:Activate()
                end
            
                StopVelocity();
                
                Character:PivotTo(CFrame.new(Character:GetPivot().Position))
                
                local RunServiceSignal = RunService.Stepped:Connect(function()
                    local AssemblyAngularVelocity = HumanoidRootPart.AssemblyAngularVelocity;
                    
                    if AssemblyAngularVelocity.X > 20 
                    or AssemblyAngularVelocity.Y > 20
                    or AssemblyAngularVelocity.Z > 20  then
                         Character:PivotTo(CFrame.new(Character:GetPivot().Position))
                    end
                end)
                
                CurrentTask = task.delay(10, function()
                    RunServiceSignal:Disconnect()
                end)
                
                Maid:GiveTask(RunServiceSignal)
            end
            
            shared.Active = not shared.Active
        end;
    }
}

local KeyBindEnded = {
    [Enum.KeyCode.Space] = {
        ["IGNORE_OFF"] = function()
            Ignore = false
        end;
    };
}

Maid:GiveTask(UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
	if not GameProcessedEvent then
		if Input.UserInputType == Enum.UserInputType.Keyboard and KeyBindStarted[Input.KeyCode] then
			for _, Function in pairs(KeyBindStarted[Input.KeyCode]) do
				task.spawn(Function)
			end
		elseif KeyBindStarted[Input.UserInputType] then
			for _, Function in pairs(KeyBindStarted[Input.UserInputType]) do
                task.spawn(Function)
			end
		end
	end
end))

Maid:GiveTask(UserInputService.InputEnded:Connect(function(Input, GameProcessedEvent)
	if not GameProcessedEvent then
		if Input.UserInputType == Enum.UserInputType.Keyboard and KeyBindEnded[Input.KeyCode] then
			for _, Function in pairs(KeyBindEnded[Input.KeyCode]) do
				task.spawn(Function)
			end
		elseif KeyBindEnded[Input.UserInputType] then
			for _, Function in pairs(KeyBindEnded[Input.UserInputType]) do
                task.spawn(Function)
			end
		end
	end
end))

