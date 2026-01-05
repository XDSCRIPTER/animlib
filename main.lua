local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

-- Удаляем неподдерживаемые методы SetColor и SetCursor
-- Вместо этого используем ThemeManager для настройки цветов

local Window = Library:CreateWindow({
    Title = "🍃 Private Weed Hub | Booga Booga Reborn 🍃",
    Footer = "✨ by Crack Dealer ✨",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Size = UDim2.new(0, 600, 0, 500),
    Position = UDim2.new(0.5, 0, 0.5, 0)
})

-- Добавляем анимацию появления
task.spawn(function()
    for i = 1, 10 do
        if Library.Background then
            Library.Background.Transparency = 1 - (i/10)
        end
        task.wait(0.02)
    end
end)

-- Создаем красивый заголовок
local HeaderLabel = Window:AddLabel("🌿 Premium Booga Booga Script 🌿")
if HeaderLabel.SetTextSize then
    HeaderLabel:SetTextSize(18)
end

local Tabs = {
    Main = Window:AddTab("📱 Main", "rbxassetid://10723385012"),
    Combat = Window:AddTab("⚔️ Combat", "rbxassetid://10723384758"),
    Map = Window:AddTab("🗺️ Map", "rbxassetid://10723384513"),
    Pickup = Window:AddTab("🎒 Pickup", "rbxassetid://10723384316"),
    Farming = Window:AddTab("🌱 Farming", "rbxassetid://10723384093"),
    Extra = Window:AddTab("✨ Extra", "rbxassetid://10723383877"),
    Settings = Window:AddTab("⚙️ UI Settings", "rbxassetid://10723383644"),
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
local tspmo = game:GetService("TweenService")

-- MAIN TAB
local MainLeftGroup = Tabs.Main:AddLeftGroupbox("🎭 Character")
local MainRightGroup = Tabs.Main:AddRightGroupbox("🔥 Interactions")

MainLeftGroup:AddToggle("wstoggle", {
    Text = "🚶‍♂️ Walkspeed",
    Default = false,
    Tooltip = "Enable/disable walkspeed modification",
    Callback = function(Value)
        updws()
    end,
})

MainLeftGroup:AddSlider("wsslider", {
    Text = "📏 Value",
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
    Text = "🦘 JumpPower",
    Default = false,
    Tooltip = "Enable/disable jumppower modification",
    Callback = function(Value)
        updws()
    end,
})

MainLeftGroup:AddSlider("jpslider", {
    Text = "📐 Value",
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
    Text = "📏 HipHeight",
    Default = false,
    Tooltip = "Enable/disable hipheight modification",
    Callback = function(Value)
        updhh()
    end,
})

MainLeftGroup:AddSlider("hheightslider", {
    Text = "📐 Value",
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
    Text = "⛰️ No Mountain Slip",
    Default = false,
    Tooltip = "Prevents slipping on mountains",
    Callback = function(Value)
        updmsa()
    end,
})

-- Interactions
MainRightGroup:AddToggle("CampFires_Interact", {
    Text = "🔥 Interact Campfire",
    Default = false,
    Tooltip = "Auto interact with campfires",
    Callback = function(Value)
        updmsa()
    end,
})

MainRightGroup:AddDropdown("CampFire_Fule", {
    Text = "🪵 Fuel for campfire",
    Values = {"Log", "Leaves", "Coal"},
    Default = "Leaves",
    Multi = false,
})

MainRightGroup:AddSlider("Deploy_Time_CampFires", {
    Text = "⏱️ Time to deploy fuel",
    Default = 2,
    Min = 0.1,
    Max = 60,
    Rounding = 1,
    Suffix = "s",
})

MainRightGroup:AddSlider("Range_CampFire", {
    Text = "📡 Range",
    Default = 2,
    Min = 1,
    Max = 200,
    Rounding = 1,
    Suffix = "studs",
})

MainRightGroup:AddDropdown("Tareget_count_camfires", {
    Text = "🎯 Max Targets",
    Values = {"1", "2", "3", "4", "5", "6"},
    Default = "1",
    Multi = false,
})

-- COMBAT TAB
local CombatLeftGroup = Tabs.Combat:AddLeftGroupbox("⚔️ Kill Aura")
local CombatRightGroup = Tabs.Combat:AddRightGroupbox("💖 Auto Heal")
local CombatLeftGroupVoodo = Tabs.Combat:AddLeftGroupbox("🔮 Voodoo")

CombatLeftGroupVoodo:AddToggle("VoodoAimBot", {
    Text = "🎯 Voodo AimBot",
    Default = false,
})

CombatLeftGroupVoodo:AddToggle("VoodooShowTarget", {
    Text = "👁️ Show Target",
    Default = false,
})

CombatLeftGroup:AddToggle("killauratoggle", {
    Text = "⚔️ Kill Aura",
    Default = false,
})

CombatLeftGroup:AddSlider("killaurarange", {
    Text = "📏 Range",
    Default = 5,
    Min = 1,
    Max = 9,
    Rounding = 1,
    Suffix = " studs",
})

CombatLeftGroupVoodo:AddSlider("VoodooAimbotRangeDetect", {
    Text = "🎯 Range Detect",
    Default = 30,
    Min = 1,
    Max = 1000,
    Rounding = 1,
    Suffix = " studs",
})

CombatLeftGroup:AddDropdown("katargetcountdropdown", {
    Text = "🎯 Max Targets",
    Values = {"1", "2", "3", "4", "5", "6"},
    Default = "1",
    Multi = false,
})

CombatLeftGroup:AddSlider("kaswingcooldownslider", {
    Text = "⏱️ Attack Cooldown",
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Suffix = "s",
})

CombatRightGroup:AddToggle("AutoHealToggle", {
    Text = "💖 Auto Heal",
    Default = false,
})

CombatRightGroup:AddSlider("HealPercent", {
    Text = "📊 Heal to",
    Default = 0.1,
    Min = 1,
    Max = 100,
    Rounding = 2,
    Suffix = "%",
})

CombatRightGroup:AddSlider("HealColdown", {
    Text = "⏱️ Use Cooldown",
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
})

CombatRightGroup:AddDropdown("HealFruitDropDown", {
    Text = "🍎 Select Fruit to eat",
    Values = {"Bloodfruit", "Bluefruit", "Lemon", "Coconut", "Jelly", "Banana", "Orange", "Oddberry", "Berry", "Strangefruit", "Strawberry", "Sunjfruit", "Pumpkin", "Prickly Pear", "Apple", "Barley", "Cloudberry", "Carrot"},
    Default = "Bloodfruit",
    Multi = false,
})

-- MAP TAB
local MapLeftGroup = Tabs.Map:AddLeftGroupbox("⛏️ Resource Aura")
local MapRightGroup = Tabs.Map:AddRightGroupbox("🐾 Critter Aura")

MapLeftGroup:AddToggle("resourceauratoggle", {
    Text = "⛏️ Resource Aura",
    Default = false,
})

MapLeftGroup:AddSlider("resourceaurarange", {
    Text = "📏 Range",
    Default = 20,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Suffix = " studs",
})

MapLeftGroup:AddDropdown("resourcetargetdropdown", {
    Text = "🎯 Max Targets",
    Values = {"1", "2", "3", "4", "5", "6"},
    Default = "1",
    Multi = false,
})

MapLeftGroup:AddSlider("resourcecooldownslider", {
    Text = "⏱️ Swing Cooldown",
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Suffix = "s",
})

MapRightGroup:AddToggle("critterauratoggle", {
    Text = "🐾 Critter Aura",
    Default = false,
})

MapRightGroup:AddSlider("critterrangeslider", {
    Text = "📏 Range",
    Default = 20,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Suffix = " studs",
})

MapRightGroup:AddDropdown("crittertargetdropdown", {
    Text = "🎯 Max Targets",
    Values = {"1", "2", "3", "4", "5", "6"},
    Default = "1",
    Multi = false,
})

MapRightGroup:AddSlider("crittercooldownslider", {
    Text = "⏱️ Swing Cooldown",
    Default = 0.1,
    Min = 0.01,
    Max = 1.01,
    Rounding = 2,
    Suffix = "s",
})

-- PICKUP TAB
local PickupLeftGroup = Tabs.Pickup:AddLeftGroupbox("📦 Auto Pickup")
local PickupRightGroup = Tabs.Pickup:AddRightGroupbox("🗑️ Auto Drop")

PickupLeftGroup:AddToggle("autopickuptoggle", {
    Text = "📦 Auto Pickup",
    Default = false,
})

PickupLeftGroup:AddToggle("chestpickuptoggle", {
    Text = "📦 Auto Pickup From Chests",
    Default = false,
})

PickupLeftGroup:AddSlider("pickuprange", {
    Text = "📏 Pickup Range",
    Default = 20,
    Min = 1,
    Max = 35,
    Rounding = 1,
    Suffix = " studs",
})

PickupLeftGroup:AddDropdown("itemdropdown", {
    Text = "📋 Items",
    Values = {"Berry", "Bloodfruit", "Bluefruit", "Lemon", "Strawberry", "Gold", "Raw Gold", "Crystal Chunk", "Coin", "Coins", "Coin2", "Coin Stack", "Essence", "Emerald", "Raw Emerald", "Pink Diamond", "Raw Pink Diamond", "Void Shard", "Jelly", "Magnetite", "Raw Magnetite", "Adurite", "Raw Adurite", "Ice Cube", "Stone", "Iron", "Raw Iron", "Steel", "Hide", "Leaves", "Log", "Wood", "Pie"},
    Default = {"Leaves", "Log"},
    Multi = true,
})

PickupRightGroup:AddToggle("droptoggle", {
    Text = "🗑️ Auto Drop",
    Default = false,
})

PickupRightGroup:AddDropdown("dropdropdown", {
    Text = "📦 Select Item to Drop",
    Values = {"Bloodfruit", "Jelly", "Bluefruit", "Log", "Leaves", "Wood"},
    Default = "Bloodfruit",
    Multi = false,
})

PickupRightGroup:AddToggle("droptogglemanual", {
    Text = "✏️ Auto Drop Custom",
    Default = false,
})

PickupRightGroup:AddInput("droptextbox", {
    Text = "✏️ Custom Item",
    Default = "Bloodfruit",
    Numeric = false,
    Finished = false,
    Placeholder = "Enter item name",
})

-- FARMING TAB
local FarmingLeftGroup = Tabs.Farming:AddLeftGroupbox("🌱 Auto Farming")
local FarmingRightGroup = Tabs.Farming:AddRightGroupbox("🚀 Tween & Plantbox")

FarmingLeftGroup:AddDropdown("fruitdropdown", {
    Text = "🍎 Select Fruit",
    Values = {"Bloodfruit", "Bluefruit", "Lemon", "Coconut", "Jelly", "Banana", "Orange", "Oddberry", "Berry", "Strangefruit", "Strawberry", "Sunjfruit", "Pumpkin", "Prickly Pear", "Apple", "Barley", "Cloudberry", "Carrot"},
    Default = "Bloodfruit",
    Multi = false,
})

FarmingLeftGroup:AddToggle("planttoggle", {
    Text = "🌱 Auto Plant",
    Default = false,
})

FarmingLeftGroup:AddSlider("plantrange", {
    Text = "📏 Plant Range",
    Default = 30,
    Min = 1,
    Max = 30,
    Rounding = 1,
    Suffix = " studs",
})

FarmingLeftGroup:AddSlider("plantdelay", {
    Text = "⏱️ Plant Delay",
    Default = 0.1,
    Min = 0.01,
    Max = 1,
    Rounding = 2,
    Suffix = "s",
})

FarmingLeftGroup:AddToggle("harvesttoggle", {
    Text = "🌾 Auto Harvest",
    Default = false,
})

FarmingLeftGroup:AddSlider("harvestrange", {
    Text = "📏 Harvest Range",
    Default = 30,
    Min = 1,
    Max = 30,
    Rounding = 1,
    Suffix = " studs",
})

FarmingRightGroup:AddLabel("🚀 Tween Stuff")
FarmingRightGroup:AddLabel("✨ wish this ui was more like linoria :(")

FarmingRightGroup:AddToggle("tweentoplantbox", {
    Text = "🚀 Tween to Plant Box",
    Default = false,
})

FarmingRightGroup:AddToggle("tweentobush", {
    Text = "🌿 Tween to Bush + Plant Box",
    Default = false,
})

FarmingRightGroup:AddSlider("tweenrange", {
    Text = "📏 Range",
    Default = 250,
    Min = 1,
    Max = 250,
    Rounding = 1,
    Suffix = " studs",
})

FarmingRightGroup:AddLabel("📦 Plantbox Stuff")

FarmingRightGroup:AddButton({
    Text = "🔲 Place 16x16 Plantboxes (256)",
    Func = function()
        if placestructure then
            placestructure(16)
            Library:Notify("✅ Placing 16x16 plantboxes...", 3)
        end
    end,
    DoubleClick = false,
})

FarmingRightGroup:AddButton({
    Text = "🔳 Place 15x15 Plantboxes (225)",
    Func = function()
        if placestructure then
            placestructure(15)
            Library:Notify("✅ Placing 15x15 plantboxes...", 3)
        end
    end,
    DoubleClick = false,
})

FarmingRightGroup:AddButton({
    Text = "🟦 Place 10x10 Plantboxes (100)",
    Func = function()
        if placestructure then
            placestructure(10)
            Library:Notify("✅ Placing 10x10 plantboxes...", 3)
        end
    end,
    DoubleClick = false,
})

FarmingRightGroup:AddButton({
    Text = "🟩 Place 5x5 Plantboxes (25)",
    Func = function()
        if placestructure then
            placestructure(5)
            Library:Notify("✅ Placing 5x5 plantboxes...", 3)
        end
    end,
    DoubleClick = false,
})

-- EXTRA TAB
local ExtraLeftGroup = Tabs.Extra:AddLeftGroupbox("📜 Scripts")
local ExtraRightGroup = Tabs.Extra:AddRightGroupbox("🌀 Item Orbit")

ExtraLeftGroup:AddButton({
    Text = "🎮 Infinite Yield",
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/decryp1/herklesiy/refs/heads/main/hiy"))()
        Library:Notify("🚀 Loading Infinite Yield...", 3)
    end,
    DoubleClick = false,
    Tooltip = "inf yield chat",
})

ExtraRightGroup:AddLabel("⚠️ Orbit breaks sometimes")
ExtraRightGroup:AddLabel("😎 i dont give a shit")

ExtraRightGroup:AddToggle("orbittoggle", {
    Text = "🌀 Item Orbit",
    Default = false,
})

ExtraRightGroup:AddSlider("orbitrange", {
    Text = "📏 Grab Range",
    Default = 20,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Suffix = " studs",
})

ExtraRightGroup:AddSlider("orbitradius", {
    Text = "⭕ Orbit Radius",
    Default = 10,
    Min = 0,
    Max = 30,
    Rounding = 1,
    Suffix = " studs",
})

ExtraRightGroup:AddSlider("orbitspeed", {
    Text = "⚡ Orbit Speed",
    Default = 5,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Suffix = " speed",
})

ExtraRightGroup:AddSlider("itemheight", {
    Text = "📏 Item Height",
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

-- Остальной функционал остается без изменений...

-- Настройка ThemeManager и SaveManager с красивой темой
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("PrivateWeedHub")

-- Создаем красивую тему для Obsidian
ThemeManager:AddTheme("Purple Haze", {
    SchemeColor = Color3.fromRGB(120, 80, 200),
    Background = Color3.fromRGB(15, 15, 25),
    Header = Color3.fromRGB(30, 30, 45),
    TextColor = Color3.fromRGB(220, 220, 255),
    ElementColor = Color3.fromRGB(40, 40, 60),
})

ThemeManager:AddTheme("Forest Green", {
    SchemeColor = Color3.fromRGB(80, 200, 120),
    Background = Color3.fromRGB(15, 25, 15),
    Header = Color3.fromRGB(30, 45, 30),
    TextColor = Color3.fromRGB(220, 255, 220),
    ElementColor = Color3.fromRGB(40, 60, 40),
})

ThemeManager:AddTheme("Ocean Blue", {
    SchemeColor = Color3.fromRGB(80, 120, 200),
    Background = Color3.fromRGB(15, 15, 25),
    Header = Color3.fromRGB(30, 30, 45),
    TextColor = Color3.fromRGB(220, 220, 255),
    ElementColor = Color3.fromRGB(40, 40, 60),
})

-- Применяем тему
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("PrivateWeedHub")
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Анимированное уведомление о загрузке
task.spawn(function()
    Library:Notify("✨ Private Weed Hub loaded successfully! ✨", 5)
    
    task.wait(1)
    Library:Notify("🎮 Enjoy the premium features!", 3)
end)

-- Выбор первой вкладки
Library:SelectTab(1)

-- Вставьте сюда остальной функционал (Kill Aura, Auto Heal и т.д.)
-- из вашего оригинального кода, начиная от "Функции из вашего скрипта" и до конца
