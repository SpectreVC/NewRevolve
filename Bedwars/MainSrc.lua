local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NewRevolve"
screenGui.Enabled = false
screenGui.Parent = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")


function CreateTab(Entity)
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0.155, 0, 0.05, 0)
    Main.Position = Entity.Position
    Main.Name = "Revolve"
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BackgroundTransparency = 0
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
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.BackgroundTransparency = 0
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
            local Tween = TweenService:Create(Toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(106, 90, 205)})
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
            print("Saved Settings:", Entity.Name, Entity.Value)
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


local ScreenGui2 = Instance.new("ScreenGui")
ScreenGui2.Parent = game:GetService("CoreGui")

local function Tab_Toggle()
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.09, 0, 0.05, 0)
    Button.Position = UDim2.new(0.45, 0, 0, 0)
    Button.Text = "Revolve"
    Button.TextSize = 14
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.SourceSansBold 
    Button.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    Button.BorderSizePixel = 0
    Button.Parent = ScreenGui2

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0.2, 0)
    Corner.Parent = Button

    local IsVisible = false
    Button.MouseButton1Click:Connect(function()
        IsVisible = not IsVisible
        screenGui.Enabled = IsVisible
    end)
end

local TabToggle = Tab_Toggle()




local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character 
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local HeartBeat = game:GetService("RunService").Heartbeat
local Camera = workspace.CurrentCamera
local KnitClient = debug.getupvalue(require(LocalPlayer.PlayerScripts.TS.knit).setup, 6)
local CombatConstants = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]).CombatConstant
local BedwarsSwords = require(game:GetService("ReplicatedStorage").TS.games.bedwars["bedwars-swords"]).BedwarsMelees
local ClientHandlerStore = require(LocalPlayer.PlayerScripts.TS.ui.store).ClientStore
local SwordController = KnitClient.Controllers.SwordController
local RS = game:GetService("RunService")
local TWS = game:GetService("TweenService")
local Players = game.Players   
local Players = game:GetService("Players")
local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

local Remotes = {
    DeathRemote = game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.ResetCharacter  
}

local function kill_player()
    Remotes.DeathRemote:FireServer()
end  

function HitBlock(Pos1, Pos2, Pos3)
    local args = {
        [1] = {
            ["blockRef"] = {
                ["blockPosition"] = Pos1
            },
            ["hitPosition"] = Pos2,
            ["hitNormal"] = Pos3 or Vector3.new(0,0,0)
        }
    }

    game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@easy-games"):FindFirstChild("block-engine").node_modules:FindFirstChild("@rbxts").net.out._NetManaged.DamageBlock:InvokeServer(unpack(args))
end

local function has_forcefield(player)
    return player.Character and player.Character:FindFirstChildOfClass("ForceField") ~= nil
end

local function find_player()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.TeamColor ~= LocalPlayerTeam.TeamColor then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

function tpto_player()
    local closestPlayer = find_player()
    if closestPlayer then
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local targetCFrame = closestPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame
            local tweenInfo = TweenInfo.new(0.65)
            local tween = TWS:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
        end
    end
end


function find_bed()
    local nearestBed = nil
    local minDistance = math.huge

    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name:lower() == "bed" and v:FindFirstChild("Covers") and v:FindFirstChild("Covers").BrickColor ~= LocalPlayer.Team.TeamColor then
            local distance = (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < minDistance then
                nearestBed = v
                minDistance = distance
            end
        end
    end
    return nearestBed
end

function tween()
    local nearestBed = find_bed()
    if nearestBed then
        if humanoidRootPart then
            local targetCFrame = nearestBed.CFrame + Vector3.new(0, 6, 0)
            local tweenInfo = TweenInfo.new(0.65) 
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
        end
    end
 end

local function get_inventory(Player)
	if not Player then 
		return {Items = {}, Armor = {}}
	end

	local Success, Return = pcall(function() 
		return require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil.getInventory(Player)
	end)

	if not Success then 
		return {Items = {}, Armor = {}}
	end
	if Player.Character and Player.Character:FindFirstChild("InventoryFolder") then 
		local InvFolder = Player.Character:FindFirstChild("InventoryFolder").Value
		if not InvFolder then return Return end
		for i, v in next, Return do 
			for i2, v2 in next, v do 
				if typeof(v2) == 'table' and v2.itemType then
					v2.instance = InvFolder:FindFirstChild(v2.itemType)
				end
			end
			if typeof(v) == 'table' and v.itemType then
				v.instance = InvFolder:FindFirstChild(v.itemType)
			end
		end
	end
	return Return
end



function HashFunc(Vec)
	return {value = Vec}
end




function get_sword()
	local Highest, Returning = -9e9, nil
	for i, v in next, get_inventory(LocalPlayer).items do 
		local Power = table.find(BedwarsSwords, v.itemType)
		if not Power then continue end 
		if Power > Highest then 
			Returning = v
			Highest = Power
		end
	end
	return Returning
end



function is_alive(Player)
	Player = Player or LocalPlayer
	if not Player.Character then return false end
	if not Player.Character:FindFirstChild("Head") then return false end
	if not Player.Character:FindFirstChild("Humanoid") then return false end
	if Player.Character:FindFirstChild("Humanoid").Health < 0.11 then return false end
	return true
end

function RunRevolveX(entity)
entity()
end

function GetMatchState()
	return ClientHandlerStore:getState().Game.matchState
end




local OrigC0 = game:GetService("ReplicatedStorage").Assets.Viewmodel.RightHand.RightWrist.C0
local Animations = {
	["ReversedSwing"] = {
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(8), math.rad(5)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(90), math.rad(3), math.rad(13)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(-5), math.rad(8)), Time = 0.1},
		{CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), Time = 0.1}
	}
}
local CurrentAnimation = {["Value"] = "ReversedSwing"}





--[TABS]--
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
  IconPos = UDim2.new(0.87, 0, 0.2, 0),
  Icon = "rbxassetid://4830959433",
  IconColor = Color3.fromRGB(255, 100, 100)
})



--[WORLD]--

local HashToggleWorld = CreateToggle({
  Parent = World,
  Name = "",
  HashToggle = true,
  Callback = function(value)
  
  end
})



RunRevolveX(function()
    getgenv().LuckyBlock = false
    getgenv().Ore = false
    getgenv().Bed = true
    local NukerEnabled = false

    local Nuker = CreateToggle({
        Parent = World,
        Name = "Nuker",
        SaveToFile = "NewRevolve/Saves/Settings.json", 
        LoadFromFile = "NewRevolve/Saves/Settings.json", 
        Callback = function(value)
            NukerEnabled = value

            function GetBlock()
                local nearestBlock = nil
                local minDistance = math.huge

                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name:lower() == "iron_ore" then
                        local distance = (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                        if distance < minDistance then
                            nearestBlock = v
                            minDistance = distance
                        end
                    end
                end

                if minDistance <= 30 and nearestBlock then
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://11523495669"
                    sound.Parent = game.Workspace
                    sound.Volume = 0.7
                    sound:Play()
                end

                return nearestBlock
            end

            function GetBed()
                local nearestBed = nil
                local minDistance = math.huge

                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name:lower() == "bed" and v:FindFirstChild("Covers") and v:FindFirstChild("Covers").BrickColor ~= LocalPlayer.Team.TeamColor then
                        local distance = (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                        if distance < minDistance then
                            nearestBed = v
                            minDistance = distance
                        end
                    end
                end

                if minDistance <= 30 and nearestBed then
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://11523495669"
                    sound.Parent = game.Workspace
                    sound.Volume = 0.7
                    sound:Play()
                end

                return nearestBed
            end

            function GetLuckyBlock()
                local NearestLuckyBlock = nil
                local minDistance = math.huge

                for _, v in pairs(game.Workspace:GetDescendants()) do
                    if v.Name:lower() == "lucky_block" then
                        local distance = (v.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                        if distance < minDistance then
                            NearestLuckyBlock = v
                            minDistance = distance
                        end
                    end
                end

                if minDistance <= 30 and NearestLuckyBlock then
                    local sound = Instance.new("Sound")
                    sound.SoundId = "rbxassetid://11523495669"
                    sound.Parent = game.Workspace
                    sound.Volume = 0.7
                    sound:Play()
                end

                return NearestLuckyBlock
            end

            function ReturnPositions(Pos)
                local X = math.round(Pos.x / 3)
                local Y = math.round(Pos.y / 3)
                local Z = math.round(Pos.z / 3)
                return Vector3.new(X, Y, Z)
            end

            spawn(function()
                while Ore and NukerEnabled do
                    local block = GetBlock()
                    local Hash = LocalPlayer.Character.HumanoidRootPart.Position 
                    HitBlock(ReturnPositions(block.Position), ReturnPositions(Hash), ReturnPositions(block.Position))
                    task.wait()
                end
            end)

            spawn(function()
                while Bed and NukerEnabled do
                    local Hash2 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    local Bed = GetBed()
                    HitBlock(ReturnPositions(Bed.Position), ReturnPositions(Hash2))
                    task.wait()
                end
            end)

            spawn(function()
                while LuckyBlock and NukerEnabled do
                    local Hash3 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                    local LuckyBlock = GetLuckyBlock()
                    HitBlock(ReturnPositions(LuckyBlock.Position), ReturnPositions(Hash3), ReturnPositions(LuckyBlock.Position))
                    task.wait()
                end
            end)
        end
    })
end)



RunRevolveX(function()
    local AntiVoid_Part = Instance.new("Part")

    local AntiVoid = CreateToggle({
        Parent = World,
        Name = "AntiVoid",
        TextPos = UDim2.new(0.09, 0, 0.4, 0),
        SaveToFile = "NewRevolve/Saves/Settings.json",
        LoadFromFile = "NewRevolve/Saves/.json",
        Callback = function(value)
            if value and GetMatchState() ~= 0 then
                AntiVoid_Part.Size = Vector3.new(10000, 1, 10000)
                AntiVoid_Part.Position = LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 18, 0)
                AntiVoid_Part.Color = Color3.fromRGB(138, 43, 226)
                AntiVoid_Part.Anchored = true
                AntiVoid_Part.Transparency = 0.3
                AntiVoid_Part.Material = Enum.Material.Neon
                AntiVoid_Part.Velocity = Vector3.new(0, 100, 0)
                AntiVoid_Part.Parent = workspace
            else
                if AntiVoid_Part then 
                    AntiVoid_Part:Destroy()
                end
            end
        end
    })
end)



--[UTILITY]--
local HashToggleUtility = CreateToggle({
  Parent = Utility,
  Name = "",
  HashToggle = true,
  Callback = function(value)
  
  end
})


RunRevolveX(function()
    local NoFallEnabled = false

    local NoFall = CreateToggle({
        Parent = Utility,
        Name = "NoFall",
        SaveToFile = "NewRevolve/Saves/Settings.json", 
        LoadFromFile = "NewRevolve/Saves/Settings.json", 
        Callback = function(value)
            NoFallEnabled = value
            if NoFallEnabled then
                RS.Heartbeat:Connect(function()
                    game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
                    task.wait(2)
                end)
            end
        end
    })
end)





RunRevolveX(function()
    local InfJumpEnabled = false
    local InfJump = CreateToggle({
        Parent = Utility,
        Name = "InfJump",
        TextPos = UDim2.new(0.09, 0, 0.4, 0),
        SaveToFile = "NewRevolve/Saves/Settings.json", 
        LoadFromFile = "NewRevolve/Saves/Settings.json", 
        Callback = function(value)
            InfJumpEnabled = value
            game:GetService("UserInputService").JumpRequest:connect(function()
                if InfJumpEnabled then
                    game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
                end
            end)
        end
    })
end)




RunRevolveX(function()
    local sky = Instance.new("Sky")
    sky.Name = "RevolveSky"
    local SkyBoxEnabled = false

    local SkyBox = CreateToggle({
        Parent = Utility,
        Name = "Skybox",
        TextPos = UDim2.new(0.06, 0, 0.4, 0),
        SaveToFile = "NewRevolve/Saves/Settings.json", 
        LoadFromFile = "NewRevolve/Saves/Settings.json", 
        Callback = function(value)
            SkyBoxEnabled = value
            if SkyBoxEnabled then
                local Images = {
                    "rbxassetid://14993957229", 
                    "rbxassetid://14993958854",
                    "rbxassetid://14993961695"
                } 

                sky.SkyboxBk = Images[1]
                sky.SkyboxDn = Images[2]
                sky.SkyboxFt = Images[2]
                sky.SkyboxLf = Images[3]
                sky.SkyboxRt = Images[1]
                sky.SkyboxUp = Images[1]
                sky.Parent = game.Lighting
            else
                for _, v in ipairs(game.Lighting:GetDescendants()) do
                    if v.Name == "RevolveSky" then
                        v:Destroy()
                    end
                end
            end
        end
    })
end)













--[COMBAT]--
local HashToggleCombat = CreateToggle({
  Parent = Combat,
  Name = "",
  HashToggle = true,
  Callback = function(value)
  end
})


RunRevolveX(function()
    local function isNumber(Hash)
        return tonumber(Hash) ~= nil or Hash == 'inf'
    end

    local SpeedEnabled = false
    local Speed1 = 0.07

    local Speed = CreateToggle({
        Parent = Combat,
        Name = "Speed",
        TextPos = UDim2.new(0.06, 0, 0.4, 0),
        Callback = function(value)
            SpeedEnabled = value
            if SpeedEnabled and GetMatchState() ~= 0 then
                local SpeedLoop = task.spawn(function()
                    while SpeedEnabled and HeartBeat:Wait() and Character do
                        if Humanoid.MoveDirection.Magnitude > 0 then
                            if Speed1 and isNumber(Speed1) then
                                Character:TranslateBy(Humanoid.MoveDirection * tonumber(Speed1))
                            else
                                Character:TranslateBy(Humanoid.MoveDirection)
                            end
                        end
                    end
                end)
            end
        end,
        SaveToFile = "NewRevolve/Saves/Settings.json",
        LoadFromFile = "NewRevolve/Saves/Settings.json"
    })
end)



RunRevolveX(function()
    local SprintController = KnitClient.Controllers.SprintController
    local SprintEnabled = false

    local Sprint = CreateToggle({
        Parent = Combat,
        Name = "Sprint",
        TextPos = UDim2.new(0.06, 0, 0.4, 0),
        Callback = function(value)
            SprintEnabled = value
            if SprintEnabled then
                HeartBeat:Connect(function()
                    SprintController:startSprinting()
                end)
            end
        end,
        SaveToFile = "NewRevolve/Saves/Settings.json",
        LoadFromFile = "NewRevolve/Saves/Settings.json"
    })    
end)






RunRevolveX(function()
local KillauraEnabled = false
local Killaura = CreateToggle({
    Parent = Combat,
    Name = "Killaura",
    TextPos = UDim2.new(0.09, 0, 0.4, 0),
    SaveToFile = "NewRevolve/Saves/Settings.json", 
    LoadFromFile = "NewRevolve/Saves/Settings.json", 
    Callback = function(value)
    KillauraEnabled = value
    spawn(function()
    repeat
        task.wait()
        for _, enemyPlayer in pairs(game:GetService("Players"):GetPlayers()) do
            if enemyPlayer ~= LocalPlayer and enemyPlayer.Team ~= LocalPlayer.Team and is_alive(enemyPlayer) and GetMatchState() ~= 0 and is_alive(LocalPlayer) and not enemyPlayer.Character:FindFirstChildOfClass("ForceField") then
                local distance = (enemyPlayer.Character:FindFirstChild("HumanoidRootPart").Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude

                if distance < 20 then
                    local Sword = get_sword()
                    CombatConstants.RAYCAST_SWORD_CHARACTER_DISTANCE = 22

                    if Sword then
                        spawn(function()
                            if KillauraEnabled then
                                KillauraEnabled = false
                                for _, animationStep in pairs(Animations[CurrentAnimation["Value"]]) do
                                    game:GetService("TweenService"):Create(Camera.Viewmodel.RightHand.RightWrist, TweenInfo.new(animationStep.Time), {C0 = OrigC0 * animationStep.CFrame}):Play()
                                    task.wait(animationStep.Time - 0.01)
                                end
                                KillauraEnabled = true
                            end
                        end)

                        SwordController.lastAttack = game:GetService("Workspace"):GetServerTimeNow()

                        local Args = {
                            [1] = {
                                ["chargedAttack"] = {["chargeRatio"] = 0},
                                ["entityInstance"] = enemyPlayer.Character,
                                ["validate"] = {
                                    ["targetPosition"] = HashFunc(enemyPlayer.Character:FindFirstChild("HumanoidRootPart").Position),
                                    ["selfPosition"] = HashFunc(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0, -0.03, 0) + ((distance > 14) and (CFrame.lookAt(LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position, enemyPlayer.Character:FindFirstChild("HumanoidRootPart").Position).LookVector * 4) or Vector3.new(0, 0, 0))),
                                },
                                ["weapon"] = Sword.tool,
                            }
                        }

                        game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.SwordHit:FireServer(unpack(Args))
                    end
                end
            end
        end
    until not game
end)
 end
})
end)




RunRevolveX(function()
    local Range = 14
    local Speed = 7
    local Speed2 = 7
    local Follow = 3.5
    local Follow2 = 1
    local HealthAllert = 1
    local StrafeEnabled = false

    local Strafe = CreateToggle({
        Parent = Combat,
        Name = "Strafe",
        TextPos = UDim2.new(0.06, 0, 0.4, 0),
        Callback = function(value)
            StrafeEnabled = value

            game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
                if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.E then
                    StrafeEnabled = not StrafeEnabled
                end
            end)

            game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
                if StrafeEnabled and GetMatchState() ~= 0 then
                    for _, targetPlayer in pairs(game.Players:GetPlayers()) do
                        if targetPlayer ~= LocalPlayer and LocalPlayer.Team ~= targetPlayer.Team then
                            local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart"))
                            if distance then
                                distance = (LocalPlayer.Character.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
                                if distance <= Range and targetPlayer.Character:FindFirstChild("Humanoid") then
                                    local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                                    if targetHumanoid.Health > HealthAllert then
                                        local angle = tick() * Speed
                                        local offsetX = math.sin(angle) * Speed2
                                        local targetPosition = targetPlayer.Character.HumanoidRootPart.Position
                                        local newPosition = Vector3.new(targetPosition.X + offsetX, targetPosition.Y, targetPosition.Z)
                                        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(newPosition))
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            local timer = 0
            while wait(0.1) do
                if StrafeEnabled then
                    timer = timer + 0.1
                    if timer >= Follow then
                        StrafeEnabled = false
                        wait(Follow2)
                        StrafeEnabled = true
                        timer = 0
                    end
                end
            end
        end,
        SaveToFile = "NewRevolve/Saves/Settings.json",
        LoadFromFile = "NewRevolve/Saves/Settings.json"
    })
end)
