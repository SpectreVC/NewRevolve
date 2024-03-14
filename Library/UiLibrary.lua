local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

function CreateTab(Entity)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0.155, 0, 0.05, 0)
Main.Position = Entity.Position
Main.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)
Main.BackgroundTransparency = 0.2
Main.BorderSizePixel = 0
Main.Parent = screenGui

local TittleHolder = Instance.new("Frame")
TittleHolder.Size = UDim2.new(0.155, 0, 0.05, 0)
TittleHolder.Position = Main.Position 
TittleHolder.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)
TittleHolder.BackgroundTransparency = 1
TittleHolder.BorderSizePixel = 0
TittleHolder.Parent = screenGui

local Tittle = Instance.new("TextLabel")
Tittle.Size = UDim2.new(0.155, 0, 0.05, 0)
Tittle.Position = UDim2.new(0.09, 0, 0.4, 0)
Tittle.Text = Entity.Tittle
Tittle.TextColor3 = Color3.new(1,1,1)
Tittle.TextSize = 15
Tittle.Font = Enum.Font.SourceSansBold 
Tittle.BackgroundTransparency = 1
Tittle.Parent = TittleHolder

local Icon = Instance.new("ImageLabel")
Icon.Size = Entity.IconSize or UDim2.new(0.1, 0, 0.5, 0)
Icon.Position = Entity.IconPos or UDim2.new(0.87, 0, 0.31, 0)
Icon.BackgroundTransparency = 1
Icon.Image = Entity.Icon
Icon.ImageColor3 = Entity.IconColor 
Icon.Parent = TittleHolder

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Main
UIListLayout.Padding = UDim.new(0, 0)


return Main
end

function CreateToggle(Entity)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 1, 0)
    Toggle.Position = UDim2.new(0, 0, 1, 0)
    Toggle.BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.BackgroundTransparency = 0.4
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Entity.Parent
     

      
    local ToggleName = Instance.new("TextLabel")
    ToggleName.Size = UDim2.new(0.1, 0, 0.1, 0)
    ToggleName.Position = Entity.TextPos or UDim2.new(0.06, 0, 0.4, 0)
    ToggleName.BackgroundTransparency = 1
    ToggleName.Text = Entity.Name
    ToggleName.Name = "ToggleName"
    ToggleName.TextColor3 = Color3.new(1, 1, 1)
    ToggleName.TextSize = 14
    ToggleName.Font = Enum.Font.SourceSansBold
    ToggleName.Parent = Toggle
    
    local HashToggle = Entity.HashToggle or false
    
    local function Update()
        if Entity.Value and HashToggle == false then
            local Tween = TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(205, 98, 152)})
            Tween:Play()
        else
            local Tween2 = TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.new(0.06, 0.06, 0.06)})
            Tween2:Play()
        end
        if Entity.SaveToFile then
            local file = Entity.SaveToFile
            local data = {}
            if isfile(file) then
                pcall(function()
                    data = game:GetService("HttpService"):JSONDecode(readfile(file))
                end)
            end
            data[Entity.Name] = Entity.Value
            writefile(file, game:GetService("HttpService"):JSONEncode(data))
            print("Saved settings:", Entity.Name, Entity.Value)
        end
    end

    local function Callback()
        Entity.Value = not Entity.Value
        Update()
        if Entity.Callback then
            Entity.Callback(Entity.Value)
        end
    end

    Toggle.MouseButton1Click:Connect(Callback)
    
    if Entity.LoadFromFile then
        local file = Entity.LoadFromFile
        if isfile(file) then
            local data = {}
            pcall(function()
                data = game:GetService("HttpService"):JSONDecode(readfile(file))
            end)
            if data[Entity.Name] ~= nil then
                Entity.Value = data[Entity.Name]
                Update()
                if Entity.Callback then
                    Entity.Callback(Entity.Value)
                end
                print("Loaded settings:", Entity.Name, Entity.Value)
            end
        end
    end
    return Toggle
end




local Combat = CreateTab({
  Tittle = "Combat",
  Position = UDim2.new(0.03, 0, 0.1, 0),
  Icon = "rbxassetid://13350770192",
  IconColor = Color3.fromRGB(255, 100, 100)
})
local Utility = CreateTab({
  Tittle = "Utility",
  Position = UDim2.new(0.23, 0, 0.1, 0),
  IconPos = UDim2.new(0.87, 0, 0.27, 0),
  Icon = "rbxassetid://10829245398",
  IconColor = Color3.fromRGB(255, 100, 100)
})
local World = CreateTab({
  Tittle = "World",
  Position = UDim2.new(0.43, 0, 0.1, 0),
  IconSize = UDim2.new(0.1, 0, 0.7, 0),
  IconPos = UDim2.new(0.87, 0, 0.25, 0),
  Icon = "rbxassetid://4830959433",
  IconColor = Color3.fromRGB(255, 100, 100)
})




end
local HashToggle = CreateToggle({
  Parent = Combat,
  Name = "",
  HashToggle = true,
  Callback = function(value)
  end
})
 
local HashToggle = CreateToggle({
  Parent = Utility,
  Name = "",
  HashToggle = true,
  Callback = function(value)
  end
})
local HashToggle = CreateToggle({
  Parent = World,
  Name = "",
  HashToggle = true,
  Callback = function(value)
  end
})
