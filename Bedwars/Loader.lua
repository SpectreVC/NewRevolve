local NewRevolve = makefolder("NewRevolve")
local Saves = makefolder("NewRevolve/Saves")
local Config = makefolder("NewRevolve/Config")
local MainSrc_Url = "https://raw.githubusercontent.com/SpectreVC/NewRevolve/Core/Bedwars/MainSrc.lua"
local Main_Src = game:HttpGet(MainSrc_Url)
local Data_Path = "NewRevolve/Saves/Data.json"

if not isfile(Data_Path) then
writefile(Data_Path, game:GetService("HttpService"):JSONEncode(true))
end

local doc = [[
Creating a Custom Tab

local World = CreateTab({
  Tittle = "World",--\\ Tittle of the tab
  Position = UDim2.new(0.43, 0, 0.1, 0),--\\ Position Of The Tab
  IconSize = UDim2.new(0.1, 0, 0.7, 0),--\\ Icon Size (optional)
  IconPos = UDim2.new(0.87, 0, 0.2, 0), --\\Icon Position (optional)
  Icon = "rbxassetid://4830959433", --\\Icon
  IconColor = Color3.fromRGB(255, 100, 100)--\\Icon Color
})

Creating a Toggle

local ToggleVal = false
local Toggle = CreateToggle({
    Parent = World,--\\The Tab U Want The Toggle To Be
    Name = "ToggleEx",--\\ Toggle Name
    SaveToFile = "Settings.json",--\\Where u Want The Toggle To Save
    LoadFromFile = "Settings.json",--\\Where u Want The Toggle To Load From
    Callback = function(value)--\\Callback (Bool)
    if value then
    --...--
    end
    end
})




Sentry Was Here:)
]]
local documentation = writefile("NewRevolve/Config/documentation.lua", doc)


local MainSrc = writefile("NewRevolve/Config/MainSrc.lua", Main_Src)

task.wait(0.4)
loadstring(game:HttpGet("https://raw.githubusercontent.com/SpectreVC/NewRevolve/Core/Test/Loader2.lua"))()
