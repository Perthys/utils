shared.Signals = shared.Signals or {}; 
local Signals = shared.Signals;

for _, Connection in ipairs(Signals) do
    Connection:Disconnect();
end

local function AddSignal(Signal)
    return table.insert(Signals, Signal);
end

local CoreGui = game:GetService("CoreGui");
local ServerScriptService = game:GetService("ServerScriptService")

shared.ScreenGui = shared.ScreenGui or Instance.new("ScreenGui") 
local ScreenGui = shared.ScreenGui; 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
ScreenGui.Parent = CoreGui

local Toolbar = {} Toolbar.__index = Toolbar;
local Button = {}; Button.__index = Button;

function Toolbar.new(Name)
    local self = setmetatable({
        Name = Name;
    }, Toolbar)
    
    self.Buttons = {};

    local MainUI = Instance.new("Frame"); self.Object = MainUI
    MainUI["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
    MainUI["AnchorPoint"] = Vector2.new(0.5, 0.5);
    MainUI["Size"] = UDim2.new(0, 151, 0, 33);
    MainUI["Position"] = UDim2.new(0.5, 0, 0.5, 0);
    MainUI["AutomaticSize"] = Enum.AutomaticSize.Y;
    MainUI.Parent = ScreenGui;

    local Title = Instance.new("TextLabel"); self.Title = Title
    Title["TextWrapped"] = true;
    Title["RichText"] = true;
    Title["TextXAlignment"] = Enum.TextXAlignment.Left;
    Title["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
    Title["TextSize"] = 14;
    Title["TextColor3"] = Color3.fromRGB(255, 255, 255);
    Title["LayoutOrder"] = -9999999;
    Title["Size"] = UDim2.new(0.8999999761581421, 0, 0, 11);
    Title["Text"] = ("<b>%s</b>"):format(Name);
    Title["Font"] = Enum.Font.Gotham;
    Title["BackgroundTransparency"] = 1;
    Title.TextScaled = true
    Title.Parent = MainUI;

    local Corner = Instance.new("UICorner");
    Corner.Parent = MainUI;

    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
    UIListLayout["Padding"] = UDim.new(0, 5);
    UIListLayout["SortOrder"] = Enum.SortOrder.LayoutOrder;

    UIListLayout.Parent = MainUI;

    local UIPadding = Instance.new("UIPadding");
    UIPadding["PaddingTop"] = UDim.new(0, 5);
    UIPadding["PaddingBottom"] = UDim.new(0, 7);

    UIPadding.Parent = MainUI;

    return self;
end

function Toolbar:Toggle(Bool)
    local Object = self.Object;

    Object.Visible = Bool;
end

function Toolbar:Destroy()
    local Object = self.Object;

    Object:Destroy();
end

function Toolbar:SetTitle(TitleText)
    local Title = self.Title;
    Title.Text = ("<b>%s</b>"):format(TitleText);
end

function Toolbar:AddButton(Data)
    local Text = Data.Name
    local _self = setmetatable(Data, Button)
    _self.Parent = self;

    self.Buttons[Text] = _self;
    local TextButton = Instance.new("TextButton"); _self.Object = TextButton
    TextButton["TextWrapped"] = true;
    TextButton["RichText"] = true;
    TextButton["TextSize"] = 12;
    TextButton["BackgroundColor3"] = Color3.fromRGB(0, 201, 255);
    TextButton["TextColor3"] = Color3.fromRGB(255, 255, 255);
    TextButton["Size"] = UDim2.new(0.8999999761581421, 0, 0, 14);
    TextButton["Text"] = Text;
    TextButton["Font"] = Enum.Font.Gotham;
    TextButton.Parent = self.Object

    local Corner = Instance.new("UICorner");
    Corner["CornerRadius"] = UDim.new(0, 5);
    Corner.Parent = TextButton;

    if _self.OnClicked then
        local Conncetion = TextButton.MouseButton1Click:Connect(function()
            _self:OnClicked()
        end)
        AddSignal(Conncetion)
    end

    return _self
end

function Button:Destroy()
    local Object = self.Object

    return Object:Destroy();
end

function Button:SetTitle(Title)
    local Object = self.Object;

    Object.Text = Title;
end

return Toolbar;
