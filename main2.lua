local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "Private Weed Hub -- Booga Booga Reborn",
    Footer = "by Crack Dealer",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main", "menu"),
    Combat = Window:AddTab("Combat", "axe"),
    Map = Window:AddTab("Map", "trees"),
    Pickup = Window:AddTab("Pickup", "backpack"),
    Farming = Window:AddTab("Farming", "sprout"),
    Extra = Window:AddTab("Extra", "plus"),
    Settings = Window:AddTab("UI Settings", "settings"),
}

-- Инициализация сервисов и переменных
local rs = game:GetService("ReplicatedStorage")
local packets = require(rs.Modules.Packets)
local Item_Ids = require(game:GetService("ReplicatedStorage").Modules.ItemIDS)
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local runs = game:GetService("RunService")
local httpservice = game:GetService("HttpService")
local Players = game:GetService("Players")
local localiservice = game:GetService("LocalizationService")
local marketservice = game:GetService("MarketplaceService")
local rbxservice = game:GetService("RbxAnalyticsService")
local placestructure
local tspmo = game:GetService("TweenService")
local itemslist = {
    "Adurite", "Berry", "Bloodfruit", "Bluefruit", "Coin", "Essence", "Hide", "Ice Cube", "Iron", "Jelly", "Leaves", "Log", "Steel", "Stone", "Wood", "Gold", "Raw Gold", "Crystal Chunk", "Raw Emerald", "Pink Diamond", "Raw Adurite", "Raw Iron", "Coal"
}

-- MAIN TAB
local MainLeftGroup = Tabs.Main:AddLeftGroupbox("Character")
local MainRightGroup = Tabs.Main:AddRightGroupbox("Interactions")

MainLeftGroup:AddToggle("wstoggle", {
    Text = "Walkspeed",
    Default = false,
    Tooltip = "Enable/disable walkspeed modification",
    Callback = function(Value)
        updws()
    end,
})

MainLeftGroup:AddSlider("wsslider", {
    Text = "Value",
    Default = 16,
    Min = 1,
    Max = 35,
    Rounding = 1,
    Suffix = " studs",
    Callback = function(Value)
        if Toggles.wstoggle.Value then
            updws()
        end
    end,
})

MainLeftGroup:AddToggle("jptoggle", {
    Text = "JumpPower",
    Default = false,
    Tooltip = "Enable/disable jumppower modification",
    Callback = function(Value)
        updws()
    end,
})

MainLeftGroup:AddSlider("jpslider", {
    Text = "Value",
    Default = 50,
    Min = 1,
    Max = 65,
    Rounding = 1,
    Suffix = " power",
    Callback = function(Value)
        if Toggles.jptoggle.Value then
            updws()
        end
    end,
})

MainLeftGroup:AddToggle("hheighttoggle", {
    Text = "HipHeight",
    Default = false,
    Tooltip = "Enable/disable hipheight modification",
    Callback = function(Value)
        updhh()
    end,
})

MainLeftGroup:AddSlider("hheightslider", {
    Text = "Value",
    Default = 2,
    Min = 0.1,
    Max = 6.5,
    Rounding = 1,
    Suffix = " studs",
    Callback = function(Value)
        if Toggles.hheighttoggle.Value then
            updhh()
        end
    end,
})

MainLeftGroup:AddToggle("msatoggle", {
    Text = "No Mountain Slip",
    Default = false,
    Tooltip = "Prevents slipping on mountains",
    Callback = function(Value)
        updmsa()
    end,
})

MainRightGroup:AddToggle("CampFires_Interact", {
    Text = "Interact Campfire",
    Default = false,
    Tooltip = "CampFires_Interact",
    Callback = function(Value)
        updmsa()
    end,
})

MainRightGroup:AddDropdown("CampFire_Fule", {
    Text = "Fuel for campfire",
    Values = {"Log", "Leaves", "Coal", "Wood"},
    Default = "Leaves",
    Multi = false,
})

MainRightGroup:AddSlider("Deploy_Time_CampFires", {
    Text = "time to deploy fuel",
    Default = 2,
    Min = 0.1,
    Max = 60,
    Rounding = 1,
    Suffix = "s",
})

MainRightGroup:AddSlider("Range_CampFire", {
    Text = "Range",
    Default = 2,
    Min = 1,
    Max = 200,
    Rounding = 1,
    Suffix = "studs",
})


MainRightGroup:AddDropdown("Tareget_count_camfires", {
    Text = "Max Targets",
    Values = {"1", "2", "3", "4", "5", "6"},
    Default = "1",
    Multi = false,
})


-- COMBAT TAB
local CombatLeftGroup = Tabs.Combat:AddLeftGroupbox("Kill Aura")
local CombatRightGroup = Tabs.Combat:AddRightGroupbox("Auto Heal")
local CombatLeftGroupVoodo = Tabs.Combat:AddLeftGroupbox("Voodo")

CombatLeftGroupVoodo:AddToggle("VoodoAimBot", {
    Text = "VoodoAimBot",
    Default = false,
})

CombatLeftGroupVoodo:AddToggle("VoodooShowTarget", {
    Text = "Show Target",
    Default = false,
})

CombatLeftGroup:AddToggle("killauratoggle", {
    Text = "Kill Aura",
    Default = false,
})




CombatLeftGroup:AddSlider("killaurarange", {
    Text = "Range",
    Default = 5,
    Min = 1,
    Max = 9,
    Rounding = 1,
    Suffix = " studs",
})

CombatLeftGroupVoodo:AddSlider("VoodooAimbotRangeDetect", {
    Text = "Voodoo Aimbot Range Detect",
    Default = 30,
    Min = 1,
    Max = 1000,
    Rounding = 1,
    Suffix = " studs",
})

CombatLeftGroup:AddDropdown("katargetcountdropdown", {
    Text = "Max Targets",
    Values = {"1", "2", "3", "4", "5", "6"},
    Default = "1",
    Multi = false,
})

CombatLeftGroup:AddSlider("kaswingcooldownslider", {
    Text = "Attack Cooldown (s)",
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Suffix = "s",
})

CombatRightGroup:AddToggle("AutoHealToggle", {
    Text = "Auto Heal",
    Default = false,
})

CombatRightGroup:AddSlider("HealPercent", {
    Text = "Heal to",
    Default = 0.1,
    Min = 1,
    Max = 100,
    Rounding = 2,
    Suffix = "%",
})

CombatRightGroup:AddSlider("HealColdown", {
    Text = "Use Cooldown",
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
})

CombatRightGroup:AddDropdown("HealFruitDropDown", {
    Text = "Select Fruit to eat",
    Values = {"Bloodfruit", "Bluefruit", "Lemon", "Coconut", "Jelly", "Banana", "Orange", "Oddberry", "Berry", "Strangefruit", "Strawberry", "Sunjfruit", "Pumpkin", "Prickly Pear", "Apple", "Barley", "Cloudberry", "Carrot"},
    Default = "Bloodfruit",
    Multi = false,
})

-- MAP TAB
local MapLeftGroup = Tabs.Map:AddLeftGroupbox("Resource Aura")
local MapRightGroup = Tabs.Map:AddRightGroupbox("Critter Aura")

MapLeftGroup:AddToggle("resourceauratoggle", {
    Text = "Resource Aura",
    Default = false,
})

MapLeftGroup:AddSlider("resourceaurarange", {
    Text = "Range",
    Default = 20,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Suffix = " studs",
})

MapLeftGroup:AddDropdown("resourcetargetdropdown", {
    Text = "Max Targets",
    Values = {"1", "2", "3", "4", "5", "6"},
    Default = "1",
    Multi = false,
})

MapLeftGroup:AddSlider("resourcecooldownslider", {
    Text = "Swing Cooldown (s)",
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Suffix = "s",
})

MapRightGroup:AddToggle("critterauratoggle", {
    Text = "Critter Aura",
    Default = false,
})

MapRightGroup:AddSlider("critterrangeslider", {
    Text = "Range",
    Default = 20,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Suffix = " studs",
})

MapRightGroup:AddDropdown("crittertargetdropdown", {
    Text = "Max Targets",
    Values = {"1", "2", "3", "4", "5", "6"},
    Default = "1",
    Multi = false,
})

MapRightGroup:AddSlider("crittercooldownslider", {
    Text = "Swing Cooldown (s)",
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Suffix = "s",
})

-- PICKUP TAB
local PickupLeftGroup = Tabs.Pickup:AddLeftGroupbox("Auto Pickup")
local PickupRightGroup = Tabs.Pickup:AddRightGroupbox("Auto Drop")

PickupLeftGroup:AddToggle("autopickuptoggle", {
    Text = "Auto Pickup",
    Default = false,
})

PickupLeftGroup:AddToggle("chestpickuptoggle", {
    Text = "Auto Pickup From Chests",
    Default = false,
})

PickupLeftGroup:AddSlider("pickuprange", {
    Text = "Pickup Range",
    Default = 20,
    Min = 1,
    Max = 35,
    Rounding = 1,
    Suffix = " studs",
})

PickupLeftGroup:AddDropdown("itemdropdown", {
    Text = "Items",
    Values = {"Berry", "Bloodfruit", "Bluefruit", "Lemon", "Strawberry", "Gold", "Raw Gold", "Crystal Chunk", "Coin", "Coins", "Coin2", "Coin Stack", "Essence", "Emerald", "Raw Emerald", "Pink Diamond", "Raw Pink Diamond", "Void Shard", "Jelly", "Magnetite", "Raw Magnetite", "Adurite", "Raw Adurite", "Ice Cube", "Stone", "Iron", "Raw Iron", "Steel", "Hide", "Leaves", "Log", "Wood", "Pie"},
    Default = {"Leaves", "Log"},
    Multi = true,
})

PickupRightGroup:AddToggle("droptoggle", {
    Text = "Auto Drop",
    Default = false,
})

PickupRightGroup:AddDropdown("dropdropdown", {
    Text = "Select Item to Drop",
    Values = {"Bloodfruit", "Jelly", "Bluefruit", "Log", "Leaves", "Wood"},
    Default = "Bloodfruit",
    Multi = false,
})

PickupRightGroup:AddToggle("droptogglemanual", {
    Text = "Auto Drop Custom",
    Default = false,
})

PickupRightGroup:AddInput("droptextbox", {
    Text = "Custom Item",
    Default = "Bloodfruit",
    Numeric = false,
    Finished = false,
    Placeholder = "Enter item name",
})

-- FARMING TAB
local FarmingLeftGroup = Tabs.Farming:AddLeftGroupbox("Auto Farming")
local FarmingRightGroup = Tabs.Farming:AddRightGroupbox("Tween & Plantbox")

FarmingLeftGroup:AddDropdown("fruitdropdown", {
    Text = "Select Fruit",
    Values = {"Bloodfruit", "Bluefruit", "Lemon", "Coconut", "Jelly", "Banana", "Orange", "Oddberry", "Berry", "Strangefruit", "Strawberry", "Sunjfruit", "Pumpkin", "Prickly Pear", "Apple", "Barley", "Cloudberry", "Carrot"},
    Default = "Bloodfruit",
    Multi = false,
})

FarmingLeftGroup:AddToggle("planttoggle", {
    Text = "Auto Plant",
    Default = false,
})

FarmingLeftGroup:AddSlider("plantrange", {
    Text = "Plant Range",
    Default = 30,
    Min = 1,
    Max = 30,
    Rounding = 1,
    Suffix = " studs",
})

FarmingLeftGroup:AddSlider("plantdelay", {
    Text = "Plant Delay (s)",
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
})

FarmingLeftGroup:AddToggle("harvesttoggle", {
    Text = "Auto Harvest",
    Default = false,
})

FarmingLeftGroup:AddSlider("harvestrange", {
    Text = "Harvest Range",
    Default = 30,
    Min = 1,
    Max = 30,
    Rounding = 1,
    Suffix = " studs",
})

FarmingRightGroup:AddLabel("Tween Stuff"):SetText("Tween Stuff")
FarmingRightGroup:AddLabel("wish this ui was more like linoria :("):SetText("wish this ui was more like linoria :(")

FarmingRightGroup:AddToggle("tweentoplantbox", {
    Text = "Tween to Plant Box",
    Default = false,
})

FarmingRightGroup:AddToggle("tweentobush", {
    Text = "Tween to Bush + Plant Box",
    Default = false,
})

FarmingRightGroup:AddSlider("tweenrange", {
    Text = "Range",
    Default = 250,
    Min = 1,
    Max = 250,
    Rounding = 1,
    Suffix = " studs",
})

FarmingRightGroup:AddLabel("Plantbox Stuff"):SetText("Plantbox Stuff")

FarmingRightGroup:AddButton({
    Text = "Place 16x16 Plantboxes (256)",
    Func = function()
        if placestructure then
            placestructure(16)
        end
    end,
    DoubleClick = false,
})

FarmingRightGroup:AddButton({
    Text = "Place 15x15 Plantboxes (225)",
    Func = function()
        if placestructure then
            placestructure(15)
        end
    end,
    DoubleClick = false,
})

FarmingRightGroup:AddButton({
    Text = "Place 10x10 Plantboxes (100)",
    Func = function()
        if placestructure then
            placestructure(10)
        end
    end,
    DoubleClick = false,
})

FarmingRightGroup:AddButton({
    Text = "Place 5x5 Plantboxes (25)",
    Func = function()
        if placestructure then
            placestructure(5)
        end
    end,
    DoubleClick = false,
})

-- EXTRA TAB
local ExtraLeftGroup = Tabs.Extra:AddLeftGroupbox("Scripts")
local ExtraRightGroup = Tabs.Extra:AddRightGroupbox("Item Orbit")

ExtraLeftGroup:AddButton({
    Text = "Infinite Yield",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/decryp1/herklesiy/refs/heads/main/hiy"))()
    end,
    DoubleClick = false,
    Tooltip = "inf yield chat",
})

ExtraRightGroup:AddLabel("orbit breaks sometimes"):SetText("orbit breaks sometimes")
ExtraRightGroup:AddLabel("i dont give a shit"):SetText("i dont give a shit")

ExtraRightGroup:AddToggle("orbittoggle", {
    Text = "Item Orbit",
    Default = false,
})

ExtraRightGroup:AddSlider("orbitrange", {
    Text = "Grab Range",
    Default = 20,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Suffix = " studs",
})

ExtraRightGroup:AddSlider("orbitradius", {
    Text = "Orbit Radius",
    Default = 10,
    Min = 0,
    Max = 30,
    Rounding = 1,
    Suffix = " studs",
})

ExtraRightGroup:AddSlider("orbitspeed", {
    Text = "Orbit Speed",
    Default = 5,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Suffix = " speed",
})

ExtraRightGroup:AddSlider("itemheight", {
    Text = "Item Height",
    Default = 3,
    Min = -3,
    Max = 10,
    Rounding = 1,
    Suffix = " studs",
})

-- Функции из вашего скрипта
local wscon, hhcon
local function updws()
    if wscon then wscon:Disconnect() end

    if Toggles.wstoggle.Value or Toggles.jptoggle.Value then
        wscon = runs.RenderStepped:Connect(function()
            if hum then
                hum.WalkSpeed = Toggles.wstoggle.Value and Options.wsslider.Value or 16
                hum.JumpPower = Toggles.jptoggle.Value and Options.jpslider.Value or 50
            end
        end)
    end
end

local function updhh()
    if hhcon then hhcon:Disconnect() end

    if Toggles.hheighttoggle.Value then
        hhcon = runs.RenderStepped:Connect(function()
            if hum then
                hum.HipHeight = Options.hheightslider.Value
            end
        end)
    end
end

local function onplradded(newChar)
    char = newChar
    root = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")

    updws()
    updhh()
end

plr.CharacterAdded:Connect(onplradded)
Toggles.wstoggle:OnChanged(updws)
Toggles.jptoggle:OnChanged(updws)
Toggles.hheighttoggle:OnChanged(updhh)

local slopecon
local function updmsa()
    if slopecon then slopecon:Disconnect() end

    if Toggles.msatoggle.Value then
        slopecon = game:GetService("RunService").RenderStepped:Connect(function()
            if hum then
                hum.MaxSlopeAngle = 90
            end
        end)
    else
        if hum then
            hum.MaxSlopeAngle = 46
        end
    end
end

Toggles.msatoggle:OnChanged(updmsa)

local function getlayout(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then
        return nil
    end
    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            return child.LayoutOrder
        end
    end
    return nil
end


local function campfire(campFireId, itemId)
    if packets.InteractStructure and packets.InteractStructure.send then
        packets.InteractStructure.send({ entityID = campFireId, itemID = itemId })
    end
end

local function swingtool(tspmogngicl)
    if packets.SwingTool and packets.SwingTool.send then
        packets.SwingTool.send(tspmogngicl)
    end
end

local function Eating(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then return end

    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
           if packets.UseBagItem and packets.UseBagItem.send then
               print(itemname,  'Selected fruit')
               packets.UseBagItem.send(child.LayoutOrder)
               print(child.LayoutOrder)
           end
       end
    end
end

local function pickup(entityid)
    if packets.Pickup and packets.Pickup.send then
        packets.Pickup.send(entityid)
    end
end

local function drop(itemname)
    local inventory = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.RightPanel.Inventory:FindFirstChild("List")
    if not inventory then return end

    for _, child in ipairs(inventory:GetChildren()) do
        if child:IsA("ImageLabel") and child.Name == itemname then
            if packets and packets.DropBagItem and packets.DropBagItem.send then
                packets.DropBagItem.send(child.LayoutOrder)
                print(child.LayoutOrder)
            end
        end
    end
end

local selecteditems = {}
Options.itemdropdown:OnChanged(function(Value)
    selecteditems = {} 
    for item, State in pairs(Value) do
        if State then
            table.insert(selecteditems, item)
        end
    end
end)

-- Kill Aura
task.spawn(function()
    while true do
        if not Toggles.killauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.killaurarange.Value) or 20
        local targetCount = tonumber(Options.katargetcountdropdown.Value) or 1
        local cooldown = tonumber(Options.kaswingcooldownslider.Value) or 0.1
        local targets = {}

        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= plr then
                local playerfolder = workspace.Players:FindFirstChild(player.Name)
                if playerfolder then
                    local rootpart = playerfolder:FindFirstChild("HumanoidRootPart")
                    local entityid = playerfolder:GetAttribute("EntityID")

                    if rootpart and entityid then
                        local dist = (rootpart.Position - root.Position).Magnitude
                        if dist <= range then
                            table.insert(targets, { eid = entityid, dist = dist })
                        end
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)


local function findNearestPlayerSimple(plr)
    local character = plr.Character
    if not character then return nil end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    
    local nearestPlayer = nil
    local shortestDistance = tonumber(Options.VoodooAimbotRangeDetect.Value) or 20
    
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= plr then
            local otherChar = otherPlayer.Character
            if otherChar then
                local otherRoot = otherChar:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    

                    local distance = (otherRoot.Position - rootPart.Position).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestPlayer = otherPlayer
                    end
                end
            end
        end
    end
    
    return nearestPlayer
end




task.spawn(function()
    local lastCharacter = nil  -- Храним последний подсвеченный персонаж
    
    while true do
        if not Toggles.VoodooShowTarget.Value then
            -- Если выключено, удаляем подсветку с последнего персонажа
            if lastCharacter then
                local oldHighlight = lastCharacter:FindFirstChild("Highlight")
                if oldHighlight then
                    oldHighlight:Destroy()
                end
                lastCharacter = nil
            end
            
            task.wait(0.1)
            continue
        end

        local target = findNearestPlayerSimple(plr)
        local char = target and target.Character or nil

        -- Удаляем подсветку с предыдущего персонажа, если цель изменилась
        if lastCharacter and lastCharacter ~= char then
            local oldHighlight = lastCharacter:FindFirstChild("Highlight")
            if oldHighlight then
                oldHighlight:Destroy()
            end
        end

        if char and not char:FindFirstChild("Highlight") then
            local high = Instance.new("Highlight")
            high.Parent = char
            high.OutlineTransparency = 0.9
            high.FillTransparency = 0.2
        end

        -- Обновляем запись о последнем подсвеченном персонаже
        lastCharacter = char
        
        task.wait(0.1)  -- Не забудьте добавить задержку, чтобы не грузить процессор
    end
end)

local oldsend; oldsend = hookfunction(packets.VoodooSpell.send, function(...)
if Toggles.VoodoAimBot.Value then
   args = ...
   
     
    print("argsoldmethod", args)
    

    return oldsend(findNearestPlayerSimple(plr).Character:FindFirstChild("HumanoidRootPart").Position)
end
end);




-- Campfire Aura

task.spawn(function()
    while true do
        if not Toggles.CampFires_Interact.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.Range_CampFire.Value) or 20
        local targetCount = tonumber(Options.Tareget_count_camfires.Value) or 1
        local cooldown = tonumber(Options.Deploy_Time_CampFires.Value) or 0.1
        local targets = {}
        local AllDeployables = {}

        for _, r in pairs(workspace.Deployables:GetChildren()) do
            table.insert(AllDeployables, r)
        end

        for _, res in pairs(AllDeployables) do
            if res:IsA("Model") and res:GetAttribute("EntityID") and res.Name == "Campfire" then
                local eid = res:GetAttribute("EntityID")
                local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            -- Получаем ID выбранного топлива
            local itemName = Options.CampFire_Fule.Value
            local itemId = Item_Ids[itemName] -- Предполагаем, что в Item_Ids есть такие ключи

            -- Для каждого выбранного campfire отправляем взаимодействие
            for _, campFireId in ipairs(selectedTargets) do
                campfire(campFireId, itemId)
            end
        end

        task.wait(cooldown)
    end
end)
               

-- Resource Aura
task.spawn(function()
    while true do
        if not Toggles.resourceauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.resourceaurarange.Value) or 20
        local targetCount = tonumber(Options.resourcetargetdropdown.Value) or 1
        local cooldown = tonumber(Options.resourcecooldownslider.Value) or 0.1
        local targets = {}
        local allresources = {}

        for _, r in pairs(workspace.Resources:GetChildren()) do
            table.insert(allresources, r)
        end
        for _, r in pairs(workspace:GetChildren()) do
            if r:IsA("Model") and r.Name == "Gold Node" then
                table.insert(allresources, r)
            end
        end

        for _, res in pairs(allresources) do
            if res:IsA("Model") and res:GetAttribute("EntityID") then
                local eid = res:GetAttribute("EntityID")
                local ppart = res.PrimaryPart or res:FindFirstChildWhichIsA("BasePart")
                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end     
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)

-- Auto Heal
task.spawn(function()
    while true do 
       if not Toggles.AutoHealToggle.Value then
           task.wait(0.1)
           continue
       end
     
     print(Options.HealPercent.Value)
     
     local humanoid = plr.Character:FindFirstChild("Humanoid")
     if humanoid and humanoid.Health > 0 and humanoid.Health <= Options.HealPercent.Value then
        Eating(Options.HealFruitDropDown.Value)
     end
 
     task.wait(Options.HealColdown.Value)
    end
 end)

-- Critter Aura
task.spawn(function()
    while true do
        if not Toggles.critterauratoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.critterrangeslider.Value) or 20
        local targetCount = tonumber(Options.crittertargetdropdown.Value) or 1
        local cooldown = tonumber(Options.crittercooldownslider.Value) or 0.1
        local targets = {}

        for _, critter in pairs(workspace.Critters:GetChildren()) do
            if critter:IsA("Model") and critter:GetAttribute("EntityID") then
                local eid = critter:GetAttribute("EntityID")
                local ppart = critter.PrimaryPart or critter:FindFirstChildWhichIsA("BasePart")

                if ppart then
                    local dist = (ppart.Position - root.Position).Magnitude
                    if dist <= range then
                        table.insert(targets, { eid = eid, dist = dist })
                    end
                end
            end
        end

        if #targets > 0 then
            table.sort(targets, function(a, b)
                return a.dist < b.dist
            end)

            local selectedTargets = {}
            for i = 1, math.min(targetCount, #targets) do
                table.insert(selectedTargets, targets[i].eid)
            end

            swingtool(selectedTargets)
        end

        task.wait(cooldown)
    end
end)

-- Auto Pickup
task.spawn(function()
    while true do
        local range = tonumber(Options.pickuprange.Value) or 35

        if Toggles.autopickuptoggle.Value then
            for _, item in ipairs(workspace.Items:GetChildren()) do
                if item:IsA("BasePart") or item:IsA("MeshPart") then
                    local selecteditem = item.Name
                    local entityid = item:GetAttribute("EntityID")

                    if entityid and table.find(selecteditems, selecteditem) then
                        local dist = (item.Position - root.Position).Magnitude
                        if dist <= range then
                            pickup(entityid)
                        end
                    end
                end
            end
        end

        if Toggles.chestpickuptoggle.Value then
            for _, chest in ipairs(workspace.Deployables:GetChildren()) do
                if chest:IsA("Model") and chest:FindFirstChild("Contents") then
                    for _, item in ipairs(chest.Contents:GetChildren()) do
                        if item:IsA("BasePart") or item:IsA("MeshPart") then
                            local selecteditem = item.Name
                            local entityid = item:GetAttribute("EntityID")

                            if entityid and table.find(selecteditems, selecteditem) then
                                local dist = (chest.PrimaryPart.Position - root.Position).Magnitude
                                if dist <= range then
                                    pickup(entityid)
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(0.01)
    end
end)

-- Auto Drop
local debounce = 0
local cd = 0
runs.Heartbeat:Connect(function()
    if Toggles.droptoggle.Value then
        if tick() - debounce >= cd then
            local selectedItem = Options.dropdropdown.Value
            drop(selectedItem)
            debounce = tick()
        end
    end
end)

runs.Heartbeat:Connect(function()
    if Toggles.droptogglemanual.Value then
        if tick() - debounce >= cd then
            local itemname = Options.droptextbox.Value
            drop(itemname)
            debounce = tick()
        end
    end
end)

-- Farming Functions
local plantedboxes = {}
local fruittoitemid = {
    Bloodfruit = 94,
    Bluefruit = 377,
    Lemon = 99,
    Coconut = 1,
    Jelly = 604,
    Banana = 606,
    Orange = 602,
    Oddberry = 32,
    Berry = 35,
    Strangefruit = 302,
    Strawberry = 282,
    Sunfruit = 128,
    Pumpkin = 80,
    ["Prickly Pear"] = 378,
    Apple = 243,
    Barley = 247,
    Cloudberry = 101,
    Carrot = 147
}

local function plant(entityid, itemID)
    if packets.InteractStructure and packets.InteractStructure.send then
        packets.InteractStructure.send({ entityID = entityid, itemID = itemID })
        plantedboxes[entityid] = true
    end
end

local function getpbs(range)
    local plantboxes = {}
    for _, deployable in ipairs(workspace.Deployables:GetChildren()) do
        if deployable:IsA("Model") and deployable.Name == "Plant Box" then
            local entityid = deployable:GetAttribute("EntityID")
            local ppart = deployable.PrimaryPart or deployable:FindFirstChildWhichIsA("BasePart")
            if entityid and ppart then
                local dist = (ppart.Position - root.Position).Magnitude
                if dist <= range then
                    table.insert(plantboxes, { entityid = entityid, deployable = deployable, dist = dist })
                end
            end
        end
    end
    return plantboxes
end

local function getbushes(range, fruitname)
    local bushes = {}
    for _, model in ipairs(workspace:GetChildren()) do
        if model:IsA("Model") and model.Name:find(fruitname) then
            local ppart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if ppart then
                local dist = (ppart.Position - root.Position).Magnitude
                if dist <= range then
                    local entityid = model:GetAttribute("EntityID")
                    if entityid then
                        table.insert(bushes, { entityid = entityid, model = model, dist = dist })
                    end
                end
            end
        end
    end
    return bushes
end

local tweening = nil
local function tween(target)
    if tweening then tweening:Cancel() end
    local distance = (root.Position - target.Position).Magnitude
    local duration = distance / 21
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = tspmo:Create(root, tweenInfo, { CFrame = target })
    tween:Play()
    
    tweening = tween
end

local function tweenplantbox(range)
    while Toggles.tweentoplantbox.Value do
        local plantboxes = getpbs(range)
        table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

        for _, box in ipairs(plantboxes) do
            if not box.deployable:FindFirstChild("Seed") then
                local target = box.deployable.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                tween(target)
                break
            end
        end

        task.wait(0.1)
    end
end

local function tweenpbs(range, fruitname)
    while Toggles.tweentobush.Value do
        local bushes = getbushes(range, fruitname)
        table.sort(bushes, function(a, b) return a.dist < b.dist end)

        if #bushes > 0 then
            for _, bush in ipairs(bushes) do
                local target = bush.model.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                tween(target)
                break
            end
        else
            local plantboxes = getpbs(range)
            table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

            for _, box in ipairs(plantboxes) do
                if not box.deployable:FindFirstChild("Seed") then
                    local target = box.deployable.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    tween(target)
                    break
                end
            end
        end

        task.wait(0.1)
    end
end



-- Auto Plant
task.spawn(function()
    while true do
        if not Toggles.planttoggle.Value then
            task.wait(0.1)
            continue
        end

        local range = tonumber(Options.plantrange.Value) or 30
        local delay = tonumber(Options.plantdelay.Value) or 0.1
        local selectedfruit = Options.fruitdropdown.Value
        local itemID = fruittoitemid[selectedfruit] or 94
        local plantboxes = getpbs(range)
        table.sort(plantboxes, function(a, b) return a.dist < b.dist end)

        for _, box in ipairs(plantboxes) do
            if not box.deployable:FindFirstChild("Seed") then
                plant(box.entityid, itemID)
            else
                plantedboxes[box.entityid] = true
            end
        end
        task.wait(delay)
    end
end)

-- Auto Harvest
task.spawn(function()
    while true do
        if not Toggles.harvesttoggle.Value then
            task.wait(0.1)
            continue
        end
        local harvestrange = tonumber(Options.harvestrange.Value) or 30
        local selectedfruit = Options.fruitdropdown.Value
        local bushes = getbushes(harvestrange, selectedfruit)
        table.sort(bushes, function(a, b) return a.dist < b.dist end)
        for _, bush in ipairs(bushes) do
            pickup(bush.entityid)
        end
        task.wait(0.1)
    end
end)

-- Tween to Plant Box
task.spawn(function()
    while true do
        if not Toggles.tweentoplantbox.Value then
            task.wait(0.1)
            continue
        end
        local range = tonumber(Options.tweenrange.Value) or 250
        tweenplantbox(range)
    end
end)

-- Tween to Bush
task.spawn(function()
    while true do
        if not Toggles.tweentobush.Value then
            task.wait(0.1)
            continue
        end
        local range = tonumber(Options.tweenrange.Value) or 20
        local selectedfruit = Options.fruitdropdown.Value
        tweenpbs(range, selectedfruit)
    end
end)

-- Place Structure
placestructure = function(gridsize)
    if not plr or not plr.Character then return end

    local torso = plr.Character:FindFirstChild("HumanoidRootPart")
    if not torso then return end

    local startpos = torso.Position - Vector3.new(0, 3, 0)
    local spacing = 6.04

    for x = 0, gridsize - 1 do
        for z = 0, gridsize - 1 do
            task.wait(0.3)
            local position = startpos + Vector3.new(x * spacing, 0, z * spacing)

            if packets.PlaceStructure and packets.PlaceStructure.send then
                packets.PlaceStructure.send{
                    ["buildingName"] = "Plant Box",
                    ["yrot"] = 45,
                    ["vec"] = position,
                    ["isMobile"] = false
                }
            end
        end
    end
end

-- Item Orbit
local orbiton, range, orbitradius, orbitspeed, itemheight = false, 20, 10, 5, 3
local attacheditems, itemangles, lastpositions = {}, {}, {}
local itemsfolder = workspace:WaitForChild("Items")

Toggles.orbittoggle:OnChanged(function(value)
    orbiton = value
    if not orbiton then
        for _, bp in pairs(attacheditems) do bp:Destroy() end
        table.clear(attacheditems)
        table.clear(itemangles)
        table.clear(lastpositions)
    else
        task.spawn(function()
            while orbiton do
                for item, bp in pairs(attacheditems) do
                    if item then
                        local currentpos = item.Position
                        local lastpos = lastpositions[item]
                        
                        if lastpos and (currentpos - lastpos).Magnitude < 0.1 then
                            if packets.ForceInteract and packets.ForceInteract.send then
                                packets.ForceInteract.send(item:GetAttribute("EntityID"))
                            end
                        end

                        lastpositions[item] = currentpos
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

Options.orbitrange:OnChanged(function(value) range = value end)
Options.orbitradius:OnChanged(function(value) orbitradius = value end)
Options.orbitspeed:OnChanged(function(value) orbitspeed = value end)
Options.itemheight:OnChanged(function(value) itemheight = value end)

runs.RenderStepped:Connect(function()
    if not orbiton then return end
    local time = tick() * orbitspeed
    for item, bp in pairs(attacheditems) do
        if item then
            local angle = itemangles[item] + time
            bp.Position = root.Position + Vector3.new(math.cos(angle) * orbitradius, itemheight, math.sin(angle) * orbitradius)
        end
    end
end)

task.spawn(function()
    while true do
        if orbiton then
            local children, index = itemsfolder:GetChildren(), 0
            local anglestep = (math.pi * 2) / math.max(#children, 1)

            for _, item in pairs(children) do
                local primary = item:IsA("BasePart") and item or item:IsA("Model") and item.PrimaryPart
                if primary and (primary.Position - root.Position).Magnitude <= range then
                    if not attacheditems[primary] then
                        local bp = Instance.new("BodyPosition")
                        bp.MaxForce, bp.D, bp.P, bp.Parent = Vector3.new(math.huge, math.huge, math.huge), 1500, 25000, primary
                        attacheditems[primary], itemangles[primary], lastpositions[primary] = bp, index * anglestep, primary.Position
                        index += 1
                    end
                end
            end
        end
        task.wait()
    end
end)

-- Настройка ThemeManager и SaveManager
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("PrivateWeedHub")
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("PrivateWeedHub")
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Уведомление о загрузке
Library:Notify("Private Weed Hub loaded successfully!", 5)

-- Выбор первой вкладки
Library:SelectTab(1)

task.spawn(function()
    while true do
        if Library.Background then
            local time = tick()
            Library.Background.BackgroundColor3 = Color3.fromHSV(
                (math.sin(time * 0.1) * 0.1 + 0.7) % 1,
                0.3,
                0.08
            )
        end
        task.wait(0.1)
    end
end)
