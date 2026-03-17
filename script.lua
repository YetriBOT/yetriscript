local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")  -- EKLENDİ

local player = Players.LocalPlayer
local mouse = player:GetMouse()

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "Xena" then
        v:Destroy()
    end
end

-- KEY SİSTEMİ - GEÇERLİ KEYLER
local VALID_KEYS = {
    "XENA-2157-0912",
    "Yetri0"
}
local authenticated = false

_G.mousemoverel = _G.mousemoverel or function() end
_G.mouse1click = _G.mouse1click or function() end

local colors = {
    primary = Color3.fromRGB(255, 140, 0),
    bg = Color3.fromRGB(18, 18, 18),
    card = Color3.fromRGB(28, 28, 30),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(160, 160, 160),
    success = Color3.fromRGB(76, 175, 80),
    danger = Color3.fromRGB(244, 67, 54)
}

local features = {
    aimbot = {enabled = false, key = nil, wallCheck = true, smoothness = 5, mode = "camera"},
    triggerbot = {enabled = false, key = nil, wallCheck = true, delay = 0, range = 500},
    esp = {enabled = false, key = nil},
    nametags = {enabled = false, key = nil},
    fly = {enabled = false, key = nil, speed = 50},
    speed = {enabled = false, key = nil, multiplier = 32},
    jumpBoost = {enabled = false, key = nil, power = 100},
    noclip = {enabled = false, key = nil},
    multiJump = {enabled = false, key = nil},
    teleport = {enabled = false, key = nil}
}

local troll = {
    fling = {enabled = false, key = nil},
    spin = {enabled = false, key = nil, speed = 10},
    sizeChanger = {enabled = false, key = nil, size = 5},
    headless = {enabled = false, key = nil},
    freeze = {enabled = false, key = nil}
}

local clickTeleport = {
    enabled = false,
    mode = "mouse",
    key = nil
}

local buttonRefs = {}
local trollButtonRefs = {}
local nameTags = {}
local originalSizes = {}

local manualFriends = {}
local manualTeam = {enabled = false}

local guiKey = Enum.KeyCode.G

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Xena"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========== KEY GİRİŞ EKRANI ==========
local keyFrame = Instance.new("Frame")
keyFrame.Parent = screenGui
keyFrame.BackgroundColor3 = colors.bg
keyFrame.BorderColor3 = colors.primary
keyFrame.BorderSizePixel = 2
keyFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
keyFrame.Size = UDim2.new(0, 500, 0, 400)
keyFrame.Active = true
keyFrame.Draggable = true
keyFrame.ClipsDescendants = true

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 12)
keyCorner.Parent = keyFrame

local keyTitleBar = Instance.new("Frame")
keyTitleBar.Parent = keyFrame
keyTitleBar.BackgroundColor3 = colors.primary
keyTitleBar.Size = UDim2.new(1, 0, 0, 50)

local keyTitleCorner = Instance.new("UICorner")
keyTitleCorner.CornerRadius = UDim.new(0, 12)
keyTitleCorner.Parent = keyTitleBar

local keyTitle = Instance.new("TextLabel")
keyTitle.Parent = keyTitleBar
keyTitle.BackgroundTransparency = 1
keyTitle.Size = UDim2.new(1, -50, 1, 0)
keyTitle.Position = UDim2.new(0, 15, 0, 0)
keyTitle.Text = "🔐 XENA AUTHENTICATION"
keyTitle.TextColor3 = colors.bg
keyTitle.TextSize = 20
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextXAlignment = Enum.TextXAlignment.Left

local keyClose = Instance.new("TextButton")
keyClose.Parent = keyTitleBar
keyClose.BackgroundColor3 = colors.danger
keyClose.Position = UDim2.new(1, -40, 0, 10)
keyClose.Size = UDim2.new(0, 30, 0, 30)
keyClose.Text = "✕"
keyClose.TextColor3 = colors.text
keyClose.Font = Enum.Font.GothamBold
keyClose.TextSize = 18

local keyCloseCorner = Instance.new("UICorner")
keyCloseCorner.CornerRadius = UDim.new(0, 6)
keyCloseCorner.Parent = keyClose

keyClose.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local keyIcon = Instance.new("TextLabel")
keyIcon.Parent = keyFrame
keyIcon.BackgroundTransparency = 1
keyIcon.Position = UDim2.new(0.5, -40, 0, 80)
keyIcon.Size = UDim2.new(0, 80, 0, 80)
keyIcon.Text = "🔑"
keyIcon.TextColor3 = colors.primary
keyIcon.TextSize = 60
keyIcon.Font = Enum.Font.GothamBold

local keyWelcome = Instance.new("TextLabel")
keyWelcome.Parent = keyFrame
keyWelcome.BackgroundTransparency = 1
keyWelcome.Position = UDim2.new(0, 20, 0, 170)
keyWelcome.Size = UDim2.new(1, -40, 0, 30)
keyWelcome.Text = "ENTER YOUR LICENSE KEY"
keyWelcome.TextColor3 = colors.primary
keyWelcome.TextSize = 22
keyWelcome.Font = Enum.Font.GothamBold

local keyDesc = Instance.new("TextLabel")
keyDesc.Parent = keyFrame
keyDesc.BackgroundTransparency = 1
keyDesc.Position = UDim2.new(0, 20, 0, 200)
keyDesc.Size = UDim2.new(1, -40, 0, 50)
keyDesc.Text = "Don't have a key? Get one instantly by watching a short ad."
keyDesc.TextColor3 = colors.textDim
keyDesc.TextSize = 14
keyDesc.Font = Enum.Font.Gotham
keyDesc.TextWrapped = true

local keyBox = Instance.new("TextBox")
keyBox.Parent = keyFrame
keyBox.BackgroundColor3 = colors.card
keyBox.BorderColor3 = colors.primary
keyBox.Position = UDim2.new(0, 50, 0, 260)
keyBox.Size = UDim2.new(1, -100, 0, 45)
keyBox.PlaceholderText = "Enter your license key"
keyBox.PlaceholderColor3 = colors.textDim
keyBox.Text = ""
keyBox.TextColor3 = colors.text
keyBox.TextSize = 14
keyBox.Font = Enum.Font.Gotham
keyBox.ClearTextOnFocus = false

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 8)
keyBoxCorner.Parent = keyBox

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Parent = keyFrame
getKeyBtn.BackgroundColor3 = colors.primary
getKeyBtn.Position = UDim2.new(0, 50, 0, 315)
getKeyBtn.Size = UDim2.new(0.5, -25, 0, 45)
getKeyBtn.Text = "🔑 GET KEY"
getKeyBtn.TextColor3 = colors.bg
getKeyBtn.TextSize = 16
getKeyBtn.Font = Enum.Font.GothamBold

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyBtn

getKeyBtn.MouseButton1Click:Connect(function()
    setclipboard("https://link-center.net/4336278/QJzHXl7oKBpj")
    getKeyBtn.Text = "✅ LINK COPIED!"
    task.wait(2)
    getKeyBtn.Text = "🔑 GET KEY"
end)

local submitBtn = Instance.new("TextButton")
submitBtn.Parent = keyFrame
submitBtn.BackgroundColor3 = colors.success
submitBtn.Position = UDim2.new(0.5, 5, 0, 315)
submitBtn.Size = UDim2.new(0.5, -25, 0, 45)
submitBtn.Text = "▶ ACTIVATE"
submitBtn.TextColor3 = colors.text
submitBtn.TextSize = 16
submitBtn.Font = Enum.Font.GothamBold

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 8)
submitCorner.Parent = submitBtn

local keyStatus = Instance.new("TextLabel")
keyStatus.Parent = keyFrame
keyStatus.BackgroundTransparency = 1
keyStatus.Position = UDim2.new(0, 20, 0, 370)
keyStatus.Size = UDim2.new(1, -40, 0, 25)
keyStatus.Text = ""
keyStatus.TextColor3 = colors.textDim
keyStatus.TextSize = 14
keyStatus.Font = Enum.Font.Gotham

submitBtn.MouseButton1Click:Connect(function()
    local key = keyBox.Text:gsub("%s+", "")
    
    if key == "" then
        keyStatus.Text = "❌ Please enter a key!"
        keyStatus.TextColor3 = colors.danger
        return
    end
    
    submitBtn.Text = "⏳ CHECKING..."
    submitBtn.BackgroundColor3 = colors.primary
    
    local valid = false
    for _, validKey in ipairs(VALID_KEYS) do
        if key == validKey then
            valid = true
            break
        end
    end
    
    task.wait(0.5)
    
    if valid then
        keyStatus.Text = "✅ KEY ACCEPTED! Loading XENA..."
        keyStatus.TextColor3 = colors.success
        submitBtn.Text = "✅ SUCCESS"
        submitBtn.BackgroundColor3 = colors.success
        
        task.wait(1)
        
        authenticated = true
        keyFrame.Visible = false
        keyFrame:Destroy()
        
        loadMainPanel()
    else
        keyStatus.Text = "❌ INVALID KEY! Get a valid key below."
        keyStatus.TextColor3 = colors.danger
        submitBtn.Text = "▶ ACTIVATE"
        submitBtn.BackgroundColor3 = colors.success
    end
end)

function loadMainPanel()
    StarterGui:SetCore("SendNotification", {
        Title = "XENA",
        Text = "You can turn the panel on and off with the G key.",
        Duration = 3
    })

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = colors.bg
    mainFrame.BorderColor3 = colors.primary
    mainFrame.BorderSizePixel = 2
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
    mainFrame.Size = UDim2.new(0, 600, 0, 500)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.ZIndex = 10
    mainFrame.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.Parent = mainFrame
    corner.CornerRadius = UDim.new(0, 8)

    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = colors.primary
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.ZIndex = 11

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar

    local title = Instance.new("TextLabel")
    title.Parent = titleBar
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(0, 450, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Text = "XENA | Developer: Yetri"
    title.TextColor3 = colors.bg
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 12

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.BackgroundColor3 = colors.danger
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = colors.text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 12

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

    local tabFrame = Instance.new("Frame")
    tabFrame.Parent = mainFrame
    tabFrame.BackgroundColor3 = colors.card
    tabFrame.Position = UDim2.new(0, 10, 0, 50)
    tabFrame.Size = UDim2.new(1, -20, 0, 40)
    tabFrame.ZIndex = 11

    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabFrame

    local combatTab = Instance.new("TextButton")
    combatTab.Parent = tabFrame
    combatTab.BackgroundColor3 = colors.primary
    combatTab.Position = UDim2.new(0, 5, 0, 5)
    combatTab.Size = UDim2.new(0, 100, 0, 30)
    combatTab.Text = "⚔️ COMBAT"
    combatTab.TextColor3 = colors.bg
    combatTab.Font = Enum.Font.GothamBold
    combatTab.TextSize = 14
    combatTab.ZIndex = 12

    local combatCorner = Instance.new("UICorner")
    combatCorner.CornerRadius = UDim.new(0, 6)
    combatCorner.Parent = combatTab

    local movementTab = Instance.new("TextButton")
    movementTab.Parent = tabFrame
    movementTab.BackgroundColor3 = colors.card
    movementTab.Position = UDim2.new(0, 110, 0, 5)
    movementTab.Size = UDim2.new(0, 100, 0, 30)
    movementTab.Text = "🏃 MOVEMENT"
    movementTab.TextColor3 = colors.text
    movementTab.Font = Enum.Font.GothamBold
    movementTab.TextSize = 14
    movementTab.ZIndex = 12

    local movementCorner = Instance.new("UICorner")
    movementCorner.CornerRadius = UDim.new(0, 6)
    movementCorner.Parent = movementTab

    local visualTab = Instance.new("TextButton")
    visualTab.Parent = tabFrame
    visualTab.BackgroundColor3 = colors.card
    visualTab.Position = UDim2.new(0, 215, 0, 5)
    visualTab.Size = UDim2.new(0, 100, 0, 30)
    visualTab.Text = "👁️ VISUAL"
    visualTab.TextColor3 = colors.text
    visualTab.Font = Enum.Font.GothamBold
    visualTab.TextSize = 14
    visualTab.ZIndex = 12

    local visualCorner = Instance.new("UICorner")
    visualCorner.CornerRadius = UDim.new(0, 6)
    visualCorner.Parent = visualTab

    local utilityTab = Instance.new("TextButton")
    utilityTab.Parent = tabFrame
    utilityTab.BackgroundColor3 = colors.card
    utilityTab.Position = UDim2.new(0, 320, 0, 5)
    utilityTab.Size = UDim2.new(0, 100, 0, 30)
    utilityTab.Text = "🔧 UTILITY"
    utilityTab.TextColor3 = colors.text
    utilityTab.Font = Enum.Font.GothamBold
    utilityTab.TextSize = 14
    utilityTab.ZIndex = 12

    local utilityCorner = Instance.new("UICorner")
    utilityCorner.CornerRadius = UDim.new(0, 6)
    utilityCorner.Parent = utilityTab

    local trollTab = Instance.new("TextButton")
    trollTab.Parent = tabFrame
    trollTab.BackgroundColor3 = colors.card
    trollTab.Position = UDim2.new(0, 425, 0, 5)
    trollTab.Size = UDim2.new(0, 100, 0, 30)
    trollTab.Text = "🤡 TROLL"
    trollTab.TextColor3 = colors.text
    trollTab.Font = Enum.Font.GothamBold
    trollTab.TextSize = 14
    trollTab.ZIndex = 12

    local trollCorner = Instance.new("UICorner")
    trollCorner.CornerRadius = UDim.new(0, 6)
    trollCorner.Parent = trollTab

    local settingsTab = Instance.new("TextButton")
    settingsTab.Parent = tabFrame
    settingsTab.BackgroundColor3 = colors.card
    settingsTab.Position = UDim2.new(0, 530, 0, 5)
    settingsTab.Size = UDim2.new(0, 60, 0, 30)
    settingsTab.Text = "⚙️"
    settingsTab.TextColor3 = colors.text
    settingsTab.Font = Enum.Font.GothamBold
    settingsTab.TextSize = 20
    settingsTab.ZIndex = 12

    local settingsCorner = Instance.new("UICorner")
    settingsCorner.CornerRadius = UDim.new(0, 6)
    settingsCorner.Parent = settingsTab

    local contentFrame = Instance.new("Frame")
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundColor3 = colors.card
    contentFrame.Position = UDim2.new(0, 10, 0, 100)
    contentFrame.Size = UDim2.new(1, -20, 1, -110)
    contentFrame.ZIndex = 11

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = contentFrame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Parent = contentFrame
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.Size = UDim2.new(1, -10, 1, -10)
    scrollFrame.Position = UDim2.new(0, 5, 0, 5)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = colors.primary
    scrollFrame.ZIndex = 12

    local layout = Instance.new("UIListLayout")
    layout.Parent = scrollFrame
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local settingsFrame = Instance.new("Frame")
    settingsFrame.Parent = contentFrame
    settingsFrame.BackgroundColor3 = colors.card
    settingsFrame.Size = UDim2.new(1, 0, 1, 0)
    settingsFrame.Position = UDim2.new(0, 0, 0, 0)
    settingsFrame.ZIndex = 20
    settingsFrame.Visible = false

    local settingsCorner2 = Instance.new("UICorner")
    settingsCorner2.CornerRadius = UDim.new(0, 6)
    settingsCorner2.Parent = settingsFrame

    local infoFrame = Instance.new("Frame")
    infoFrame.Parent = settingsFrame
    infoFrame.BackgroundColor3 = colors.bg
    infoFrame.BorderColor3 = colors.primary
    infoFrame.Size = UDim2.new(1, -40, 0, 200)
    infoFrame.Position = UDim2.new(0, 20, 0, 20)

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoFrame

    local infoTitle = Instance.new("TextLabel")
    infoTitle.Parent = infoFrame
    infoTitle.BackgroundTransparency = 1
    infoTitle.Size = UDim2.new(1, 0, 0, 30)
    infoTitle.Position = UDim2.new(0, 0, 0, 10)
    infoTitle.Text = "XENA INFORMATION"
    infoTitle.TextColor3 = colors.primary
    infoTitle.TextSize = 18
    infoTitle.Font = Enum.Font.GothamBold

    local devLabel = Instance.new("TextLabel")
    devLabel.Parent = infoFrame
    devLabel.BackgroundTransparency = 1
    devLabel.Size = UDim2.new(1, -40, 0, 25)
    devLabel.Position = UDim2.new(0, 20, 0, 50)
    devLabel.Text = "Developer: Yetri"
    devLabel.TextColor3 = colors.text
    devLabel.TextSize = 14
    devLabel.Font = Enum.Font.Gotham
    devLabel.TextXAlignment = Enum.TextXAlignment.Left

    local discordLabel = Instance.new("TextLabel")
    discordLabel.Parent = infoFrame
    discordLabel.BackgroundTransparency = 1
    discordLabel.Size = UDim2.new(1, -40, 0, 25)
    discordLabel.Position = UDim2.new(0, 20, 0, 80)
    discordLabel.Text = "Discord: yetri"
    discordLabel.TextColor3 = colors.text
    discordLabel.TextSize = 14
    discordLabel.Font = Enum.Font.Gotham
    discordLabel.TextXAlignment = Enum.TextXAlignment.Left

	local discordLabel = Instance.new("TextLabel")
    discordLabel.Parent = infoFrame
    discordLabel.BackgroundTransparency = 1
    discordLabel.Size = UDim2.new(1, -40, 0, 25)
    discordLabel.Position = UDim2.new(0, 20, 0, 110)
    discordLabel.Text = "Tester: Lua_ui"
    discordLabel.TextColor3 = colors.text
    discordLabel.TextSize = 14
    discordLabel.Font = Enum.Font.Gotham
    discordLabel.TextXAlignment = Enum.TextXAlignment.Left

    local versionLabel = Instance.new("TextLabel")
    versionLabel.Parent = infoFrame
    versionLabel.BackgroundTransparency = 1
    versionLabel.Size = UDim2.new(1, -40, 0, 25)
    versionLabel.Position = UDim2.new(0, 20, 0, 140)
    versionLabel.Text = "Version: 3.0.0"
    versionLabel.TextColor3 = colors.text
    versionLabel.TextSize = 14
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextXAlignment = Enum.TextXAlignment.Left

    local releaseLabel = Instance.new("TextLabel")
    releaseLabel.Parent = infoFrame
    releaseLabel.BackgroundTransparency = 1
    releaseLabel.Size = UDim2.new(1, -40, 0, 25)
    releaseLabel.Position = UDim2.new(0, 20, 0, 170)
    releaseLabel.Text = "Release Date: 2024"
    releaseLabel.TextColor3 = colors.text
    releaseLabel.TextSize = 14
    releaseLabel.Font = Enum.Font.Gotham
    releaseLabel.TextXAlignment = Enum.TextXAlignment.Left

    local statusFrame = Instance.new("Frame")
    statusFrame.Parent = settingsFrame
    statusFrame.BackgroundColor3 = colors.bg
    statusFrame.BorderColor3 = colors.primary
    statusFrame.Size = UDim2.new(1, -40, 0, 150)
    statusFrame.Position = UDim2.new(0, 20, 0, 240)

    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 6)
    statusCorner.Parent = statusFrame

    local statusTitle = Instance.new("TextLabel")
    statusTitle.Parent = statusFrame
    statusTitle.BackgroundTransparency = 1
    statusTitle.Size = UDim2.new(1, 0, 0, 30)
    statusTitle.Position = UDim2.new(0, 0, 0, 10)
    statusTitle.Text = "STATUS"
    statusTitle.TextColor3 = colors.primary
    statusTitle.TextSize = 18
    statusTitle.Font = Enum.Font.GothamBold

    local panelKeyLabel = Instance.new("TextLabel")
    panelKeyLabel.Parent = statusFrame
    panelKeyLabel.BackgroundTransparency = 1
    panelKeyLabel.Size = UDim2.new(1, -40, 0, 25)
    panelKeyLabel.Position = UDim2.new(0, 20, 0, 50)
    panelKeyLabel.Text = "Panel Key: G"
    panelKeyLabel.TextColor3 = colors.text
    panelKeyLabel.TextSize = 14
    panelKeyLabel.Font = Enum.Font.Gotham
    panelKeyLabel.TextXAlignment = Enum.TextXAlignment.Left

    local friendsLabel = Instance.new("TextLabel")
    friendsLabel.Parent = statusFrame
    friendsLabel.BackgroundTransparency = 1
    friendsLabel.Size = UDim2.new(1, -40, 0, 25)
    friendsLabel.Position = UDim2.new(0, 20, 0, 80)
    friendsLabel.Text = "Friend List: " .. (manualTeam.enabled and "ON" or "OFF")
    friendsLabel.TextColor3 = manualTeam.enabled and colors.success or colors.danger
    friendsLabel.TextSize = 14
    friendsLabel.Font = Enum.Font.Gotham
    friendsLabel.TextXAlignment = Enum.TextXAlignment.Left

    local totalFeatures = Instance.new("TextLabel")
    totalFeatures.Parent = statusFrame
    totalFeatures.BackgroundTransparency = 1
    totalFeatures.Size = UDim2.new(1, -40, 0, 25)
    totalFeatures.Position = UDim2.new(0, 20, 0, 110)
    totalFeatures.Text = "Total Features: 15+"
    totalFeatures.TextColor3 = colors.text
    totalFeatures.TextSize = 14
    totalFeatures.Font = Enum.Font.Gotham
    totalFeatures.TextXAlignment = Enum.TextXAlignment.Left

    local function getKeyName(key)
        if not key then return "─" end
        return key.Name:gsub("KeyCode.", "")
    end

    local function isFriend(target)
        return manualTeam.enabled and manualFriends[target]
    end

    local function createButton(id, name, icon, category)
        local btn = Instance.new("TextButton")
        btn.Name = id .. "_" .. category
        btn.Parent = scrollFrame
        btn.BackgroundColor3 = colors.bg
        btn.BorderColor3 = colors.primary
        btn.Size = UDim2.new(1, -10, 0, 70)
        btn.Text = ""
        btn.ZIndex = 13
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        buttonRefs[id] = btn
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Parent = btn
        iconLabel.BackgroundTransparency = 1
        iconLabel.Position = UDim2.new(0, 10, 0, 10)
        iconLabel.Size = UDim2.new(0, 30, 0, 30)
        iconLabel.Text = icon
        iconLabel.TextColor3 = colors.primary
        iconLabel.TextSize = 20
        iconLabel.ZIndex = 14
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = btn
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 50, 0, 10)
        nameLabel.Size = UDim2.new(1, -200, 0, 20)
        nameLabel.Text = name
        nameLabel.TextColor3 = colors.text
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 14
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = btn
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 50, 0, 30)
        descLabel.Size = UDim2.new(1, -200, 0, 20)
        descLabel.Text = id == "aimbot" and "Smooth aimbot" or id == "triggerbot" and "Auto shoot" or id == "esp" and "Player highlight" or id == "nametags" and "Show names" or id == "fly" and "Flight mode" or id == "speed" and "Walk speed" or id == "jumpBoost" and "Jump power" or id == "noclip" and "Wall walk" or id == "multiJump" and "Infinite jump" or id == "teleport" and "Teleport menu" or ""
        descLabel.TextColor3 = colors.textDim
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 14
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Parent = btn
        keyLabel.BackgroundColor3 = colors.card
        keyLabel.BorderColor3 = colors.primary
        keyLabel.Position = UDim2.new(1, -120, 0, 15)
        keyLabel.Size = UDim2.new(0, 40, 0, 25)
        keyLabel.Text = features[id].key and getKeyName(features[id].key) or "─"
        keyLabel.TextColor3 = colors.primary
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.TextSize = 12
        keyLabel.ZIndex = 14
        
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 4)
        keyCorner.Parent = keyLabel
        
        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Parent = btn
        status.BackgroundColor3 = features[id].enabled and colors.success or colors.danger
        status.Position = UDim2.new(1, -70, 0, 15)
        status.Size = UDim2.new(0, 60, 0, 25)
        status.Text = features[id].enabled and "ON" or "OFF"
        status.TextColor3 = colors.text
        status.Font = Enum.Font.GothamBold
        status.TextSize = 12
        status.ZIndex = 14
        
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 4)
        statusCorner.Parent = status
        
        btn.MouseButton1Click:Connect(function()
            features[id].enabled = not features[id].enabled
            status.BackgroundColor3 = features[id].enabled and colors.success or colors.danger
            status.Text = features[id].enabled and "ON" or "OFF"
            if id == "teleport" then
                if features.teleport.enabled then showTeleportMenu() else if _G.tpMenu then _G.tpMenu:Destroy() _G.tpMenu = nil end end
            elseif id == "noclip" then updateNoClip()
            elseif id == "nametags" then updateNameTags() end
        end)
        
        btn.MouseButton2Click:Connect(function()
            if _G.settingsMenu then _G.settingsMenu:Destroy() _G.settingsMenu = nil end
            local menu = Instance.new("Frame")
            menu.Parent = screenGui
            menu.BackgroundColor3 = colors.bg
            menu.BorderColor3 = colors.primary
            menu.BorderSizePixel = 2
            menu.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
            menu.Size = UDim2.new(0, 280, 0, id == "aimbot" and 300 or id == "triggerbot" and 300 or 150)
            menu.ZIndex = 200
            menu.Active = true
            menu.Draggable = true
            _G.settingsMenu = menu
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local header = Instance.new("Frame")
            header.Parent = menu
            header.BackgroundColor3 = colors.primary
            header.Size = UDim2.new(1, 0, 0, 30)
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 8)
            headerCorner.Parent = header
            
            local headerTitle = Instance.new("TextLabel")
            headerTitle.Parent = header
            headerTitle.BackgroundTransparency = 1
            headerTitle.Position = UDim2.new(0, 10, 0, 0)
            headerTitle.Size = UDim2.new(1, -50, 1, 0)
            headerTitle.Text = name .. " SETTINGS"
            headerTitle.TextColor3 = colors.bg
            headerTitle.Font = Enum.Font.GothamBold
            headerTitle.TextSize = 14
            headerTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local closeHeader = Instance.new("TextButton")
            closeHeader.Parent = header
            closeHeader.BackgroundColor3 = colors.danger
            closeHeader.Position = UDim2.new(1, -30, 0, 0)
            closeHeader.Size = UDim2.new(0, 30, 0, 30)
            closeHeader.Text = "✕"
            closeHeader.TextColor3 = colors.text
            closeHeader.Font = Enum.Font.GothamBold
            closeHeader.ZIndex = 201
            closeHeader.MouseButton1Click:Connect(function() menu:Destroy() _G.settingsMenu = nil end)
            
            local closeHeaderCorner = Instance.new("UICorner")
            closeHeaderCorner.CornerRadius = UDim.new(0, 6)
            closeHeaderCorner.Parent = closeHeader
            
            local yPos = 40
            
            local keyFrame = Instance.new("Frame")
            keyFrame.Parent = menu
            keyFrame.BackgroundColor3 = colors.card
            keyFrame.BorderColor3 = colors.primary
            keyFrame.Position = UDim2.new(0, 10, 0, yPos)
            keyFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 6)
            keyCorner.Parent = keyFrame
            
            local keyTitle = Instance.new("TextLabel")
            keyTitle.Parent = keyFrame
            keyTitle.BackgroundTransparency = 1
            keyTitle.Position = UDim2.new(0, 10, 0, 5)
            keyTitle.Size = UDim2.new(1, -130, 0, 20)
            keyTitle.Text = "KEYBIND"
            keyTitle.TextColor3 = colors.primary
            keyTitle.TextSize = 14
            keyTitle.Font = Enum.Font.GothamBold
            keyTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Parent = keyFrame
            keyBtn.BackgroundColor3 = colors.primary
            keyBtn.Position = UDim2.new(1, -90, 0, 15)
            keyBtn.Size = UDim2.new(0, 70, 0, 30)
            keyBtn.Text = features[id].key and getKeyName(features[id].key) or "SET"
            keyBtn.TextColor3 = colors.bg
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.TextSize = 12
            
            local keyBtnCorner = Instance.new("UICorner")
            keyBtnCorner.CornerRadius = UDim.new(0, 4)
            keyBtnCorner.Parent = keyBtn
            
            local clearBtn = Instance.new("TextButton")
            clearBtn.Parent = keyFrame
            clearBtn.BackgroundColor3 = colors.danger
            clearBtn.Position = UDim2.new(1, -160, 0, 15)
            clearBtn.Size = UDim2.new(0, 30, 0, 30)
            clearBtn.Text = "✕"
            clearBtn.TextColor3 = colors.text
            clearBtn.Font = Enum.Font.GothamBold
            clearBtn.TextSize = 14
            
            local clearCorner = Instance.new("UICorner")
            clearCorner.CornerRadius = UDim.new(0, 4)
            clearCorner.Parent = clearBtn
            
            clearBtn.MouseButton1Click:Connect(function()
                features[id].key = nil
                keyBtn.Text = "SET"
                keyLabel.Text = "─"
            end)
            
            keyBtn.MouseButton1Click:Connect(function()
                keyBtn.Text = "..."
                local con
                con = UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.Escape then
                        con:Disconnect()
                        keyBtn.Text = features[id].key and getKeyName(features[id].key) or "SET"
                    elseif input.UserInputType == Enum.UserInputType.Keyboard then
                        features[id].key = input.KeyCode
                        keyBtn.Text = getKeyName(input.KeyCode)
                        keyLabel.Text = getKeyName(input.KeyCode)
                        con:Disconnect()
                    end
                end)
            end)
            
            yPos = yPos + 70
            
            if id == "aimbot" then
                local smoothFrame = Instance.new("Frame")
                smoothFrame.Parent = menu
                smoothFrame.BackgroundColor3 = colors.card
                smoothFrame.BorderColor3 = colors.primary
                smoothFrame.Position = UDim2.new(0, 10, 0, yPos)
                smoothFrame.Size = UDim2.new(1, -20, 0, 70)
                
                local smoothCorner = Instance.new("UICorner")
                smoothCorner.CornerRadius = UDim.new(0, 6)
                smoothCorner.Parent = smoothFrame
                
                local smoothTitle = Instance.new("TextLabel")
                smoothTitle.Parent = smoothFrame
                smoothTitle.BackgroundTransparency = 1
                smoothTitle.Position = UDim2.new(0, 10, 0, 5)
                smoothTitle.Size = UDim2.new(1, -20, 0, 20)
                smoothTitle.Text = "SMOOTHNESS: " .. features.aimbot.smoothness
                smoothTitle.TextColor3 = colors.primary
                smoothTitle.TextSize = 14
                smoothTitle.Font = Enum.Font.GothamBold
                smoothTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local smoothSliderBg = Instance.new("Frame")
                smoothSliderBg.Parent = smoothFrame
                smoothSliderBg.BackgroundColor3 = colors.bg
                smoothSliderBg.BorderColor3 = colors.primary
                smoothSliderBg.Position = UDim2.new(0, 10, 0, 30)
                smoothSliderBg.Size = UDim2.new(1, -20, 0, 20)
                
                local smoothSliderBgCorner = Instance.new("UICorner")
                smoothSliderBgCorner.CornerRadius = UDim.new(0, 4)
                smoothSliderBgCorner.Parent = smoothSliderBg
                
                local smoothSlider = Instance.new("Frame")
                smoothSlider.Parent = smoothSliderBg
                smoothSlider.BackgroundColor3 = colors.primary
                smoothSlider.Size = UDim2.new(features.aimbot.smoothness / 20, 0, 1, 0)
                
                local smoothSliderCorner = Instance.new("UICorner")
                smoothSliderCorner.CornerRadius = UDim.new(0, 4)
                smoothSliderCorner.Parent = smoothSlider
                
                local dragging = false
                smoothSliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                smoothSliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = smoothSliderBg.AbsolutePosition
                        local relX = math.clamp(mousePos.X - absPos.X, 0, smoothSliderBg.AbsoluteSize.X)
                        local percent = relX / smoothSliderBg.AbsoluteSize.X
                        local value = math.floor(percent * 20)
                        smoothSlider.Size = UDim2.new(percent, 0, 1, 0)
                        smoothTitle.Text = "SMOOTHNESS: " .. value
                        features.aimbot.smoothness = value
                    end
                end)
                
                yPos = yPos + 80
                
                local wallFrame = Instance.new("Frame")
                wallFrame.Parent = menu
                wallFrame.BackgroundColor3 = colors.card
                wallFrame.BorderColor3 = colors.primary
                wallFrame.Position = UDim2.new(0, 10, 0, yPos)
                wallFrame.Size = UDim2.new(1, -20, 0, 60)
                
                local wallCorner = Instance.new("UICorner")
                wallCorner.CornerRadius = UDim.new(0, 6)
                wallCorner.Parent = wallFrame
                
                local wallTitle = Instance.new("TextLabel")
                wallTitle.Parent = wallFrame
                wallTitle.BackgroundTransparency = 1
                wallTitle.Position = UDim2.new(0, 10, 0, 5)
                wallTitle.Size = UDim2.new(1, -130, 0, 20)
                wallTitle.Text = "WALL CHECK"
                wallTitle.TextColor3 = colors.primary
                wallTitle.TextSize = 14
                wallTitle.Font = Enum.Font.GothamBold
                wallTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local wallBtn = Instance.new("TextButton")
                wallBtn.Parent = wallFrame
                wallBtn.BackgroundColor3 = features.aimbot.wallCheck and colors.success or colors.danger
                wallBtn.Position = UDim2.new(1, -90, 0, 15)
                wallBtn.Size = UDim2.new(0, 70, 0, 30)
                wallBtn.Text = features.aimbot.wallCheck and "ON" or "OFF"
                wallBtn.TextColor3 = colors.text
                wallBtn.Font = Enum.Font.GothamBold
                wallBtn.TextSize = 12
                
                local wallBtnCorner = Instance.new("UICorner")
                wallBtnCorner.CornerRadius = UDim.new(0, 4)
                wallBtnCorner.Parent = wallBtn
                
                wallBtn.MouseButton1Click:Connect(function()
                    features.aimbot.wallCheck = not features.aimbot.wallCheck
                    wallBtn.BackgroundColor3 = features.aimbot.wallCheck and colors.success or colors.danger
                    wallBtn.Text = features.aimbot.wallCheck and "ON" or "OFF"
                end)
                
                yPos = yPos + 70
                
                local modeFrame = Instance.new("Frame")
                modeFrame.Parent = menu
                modeFrame.BackgroundColor3 = colors.card
                modeFrame.BorderColor3 = colors.primary
                modeFrame.Position = UDim2.new(0, 10, 0, yPos)
                modeFrame.Size = UDim2.new(1, -20, 0, 60)
                
                local modeCorner = Instance.new("UICorner")
                modeCorner.CornerRadius = UDim.new(0, 6)
                modeCorner.Parent = modeFrame
                
                local modeTitle = Instance.new("TextLabel")
                modeTitle.Parent = modeFrame
                modeTitle.BackgroundTransparency = 1
                modeTitle.Position = UDim2.new(0, 10, 0, 5)
                modeTitle.Size = UDim2.new(1, -130, 0, 20)
                modeTitle.Text = "MODE"
                modeTitle.TextColor3 = colors.primary
                modeTitle.TextSize = 14
                modeTitle.Font = Enum.Font.GothamBold
                modeTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local modeBtn = Instance.new("TextButton")
                modeBtn.Parent = modeFrame
                modeBtn.BackgroundColor3 = colors.primary
                modeBtn.Position = UDim2.new(1, -90, 0, 15)
                modeBtn.Size = UDim2.new(0, 70, 0, 30)
                modeBtn.Text = features.aimbot.mode == "camera" and "CAMERA" or "MOUSE"
                modeBtn.TextColor3 = colors.bg
                modeBtn.Font = Enum.Font.GothamBold
                modeBtn.TextSize = 12
                
                local modeBtnCorner = Instance.new("UICorner")
                modeBtnCorner.CornerRadius = UDim.new(0, 4)
                modeBtnCorner.Parent = modeBtn
                
                modeBtn.MouseButton1Click:Connect(function()
                    features.aimbot.mode = features.aimbot.mode == "camera" and "mouse" or "camera"
                    modeBtn.Text = features.aimbot.mode == "camera" and "CAMERA" or "MOUSE"
                end)
                
            elseif id == "triggerbot" then
                local rangeFrame = Instance.new("Frame")
                rangeFrame.Parent = menu
                rangeFrame.BackgroundColor3 = colors.card
                rangeFrame.BorderColor3 = colors.primary
                rangeFrame.Position = UDim2.new(0, 10, 0, yPos)
                rangeFrame.Size = UDim2.new(1, -20, 0, 70)
                
                local rangeCorner = Instance.new("UICorner")
                rangeCorner.CornerRadius = UDim.new(0, 6)
                rangeCorner.Parent = rangeFrame
                
                local rangeTitle = Instance.new("TextLabel")
                rangeTitle.Parent = rangeFrame
                rangeTitle.BackgroundTransparency = 1
                rangeTitle.Position = UDim2.new(0, 10, 0, 5)
                rangeTitle.Size = UDim2.new(1, -20, 0, 20)
                rangeTitle.Text = "RANGE: " .. features.triggerbot.range
                rangeTitle.TextColor3 = colors.primary
                rangeTitle.TextSize = 14
                rangeTitle.Font = Enum.Font.GothamBold
                rangeTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local rangeSliderBg = Instance.new("Frame")
                rangeSliderBg.Parent = rangeFrame
                rangeSliderBg.BackgroundColor3 = colors.bg
                rangeSliderBg.BorderColor3 = colors.primary
                rangeSliderBg.Position = UDim2.new(0, 10, 0, 30)
                rangeSliderBg.Size = UDim2.new(1, -20, 0, 20)
                
                local rangeSliderBgCorner = Instance.new("UICorner")
                rangeSliderBgCorner.CornerRadius = UDim.new(0, 4)
                rangeSliderBgCorner.Parent = rangeSliderBg
                
                local rangeSlider = Instance.new("Frame")
                rangeSlider.Parent = rangeSliderBg
                rangeSlider.BackgroundColor3 = colors.primary
                rangeSlider.Size = UDim2.new(features.triggerbot.range / 500, 0, 1, 0)
                
                local rangeSliderCorner = Instance.new("UICorner")
                rangeSliderCorner.CornerRadius = UDim.new(0, 4)
                rangeSliderCorner.Parent = rangeSlider
                
                local dragging = false
                rangeSliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                rangeSliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = rangeSliderBg.AbsolutePosition
                        local relX = math.clamp(mousePos.X - absPos.X, 0, rangeSliderBg.AbsoluteSize.X)
                        local percent = relX / rangeSliderBg.AbsoluteSize.X
                        local value = math.floor(percent * 500)
                        rangeSlider.Size = UDim2.new(percent, 0, 1, 0)
                        rangeTitle.Text = "RANGE: " .. value
                        features.triggerbot.range = value
                    end
                end)
                
                yPos = yPos + 80
                
                local wallFrame = Instance.new("Frame")
                wallFrame.Parent = menu
                wallFrame.BackgroundColor3 = colors.card
                wallFrame.BorderColor3 = colors.primary
                wallFrame.Position = UDim2.new(0, 10, 0, yPos)
                wallFrame.Size = UDim2.new(1, -20, 0, 60)
                
                local wallCorner = Instance.new("UICorner")
                wallCorner.CornerRadius = UDim.new(0, 6)
                wallCorner.Parent = wallFrame
                
                local wallTitle = Instance.new("TextLabel")
                wallTitle.Parent = wallFrame
                wallTitle.BackgroundTransparency = 1
                wallTitle.Position = UDim2.new(0, 10, 0, 5)
                wallTitle.Size = UDim2.new(1, -130, 0, 20)
                wallTitle.Text = "WALL CHECK"
                wallTitle.TextColor3 = colors.primary
                wallTitle.TextSize = 14
                wallTitle.Font = Enum.Font.GothamBold
                wallTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local wallBtn = Instance.new("TextButton")
                wallBtn.Parent = wallFrame
                wallBtn.BackgroundColor3 = features.triggerbot.wallCheck and colors.success or colors.danger
                wallBtn.Position = UDim2.new(1, -90, 0, 15)
                wallBtn.Size = UDim2.new(0, 70, 0, 30)
                wallBtn.Text = features.triggerbot.wallCheck and "ON" or "OFF"
                wallBtn.TextColor3 = colors.text
                wallBtn.Font = Enum.Font.GothamBold
                wallBtn.TextSize = 12
                
                local wallBtnCorner = Instance.new("UICorner")
                wallBtnCorner.CornerRadius = UDim.new(0, 4)
                wallBtnCorner.Parent = wallBtn
                
                wallBtn.MouseButton1Click:Connect(function()
                    features.triggerbot.wallCheck = not features.triggerbot.wallCheck
                    wallBtn.BackgroundColor3 = features.triggerbot.wallCheck and colors.success or colors.danger
                    wallBtn.Text = features.triggerbot.wallCheck and "ON" or "OFF"
                end)
                
            elseif id == "fly" then
                local speedFrame = Instance.new("Frame")
                speedFrame.Parent = menu
                speedFrame.BackgroundColor3 = colors.card
                speedFrame.BorderColor3 = colors.primary
                speedFrame.Position = UDim2.new(0, 10, 0, yPos)
                speedFrame.Size = UDim2.new(1, -20, 0, 70)
                
                local speedCorner = Instance.new("UICorner")
                speedCorner.CornerRadius = UDim.new(0, 6)
                speedCorner.Parent = speedFrame
                
                local speedTitle = Instance.new("TextLabel")
                speedTitle.Parent = speedFrame
                speedTitle.BackgroundTransparency = 1
                speedTitle.Position = UDim2.new(0, 10, 0, 5)
                speedTitle.Size = UDim2.new(1, -20, 0, 20)
                speedTitle.Text = "SPEED: " .. features.fly.speed
                speedTitle.TextColor3 = colors.primary
                speedTitle.TextSize = 14
                speedTitle.Font = Enum.Font.GothamBold
                speedTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local speedSliderBg = Instance.new("Frame")
                speedSliderBg.Parent = speedFrame
                speedSliderBg.BackgroundColor3 = colors.bg
                speedSliderBg.BorderColor3 = colors.primary
                speedSliderBg.Position = UDim2.new(0, 10, 0, 30)
                speedSliderBg.Size = UDim2.new(1, -20, 0, 20)
                
                local speedSliderBgCorner = Instance.new("UICorner")
                speedSliderBgCorner.CornerRadius = UDim.new(0, 4)
                speedSliderBgCorner.Parent = speedSliderBg
                
                local speedSlider = Instance.new("Frame")
                speedSlider.Parent = speedSliderBg
                speedSlider.BackgroundColor3 = colors.primary
                speedSlider.Size = UDim2.new(features.fly.speed / 100, 0, 1, 0)
                
                local speedSliderCorner = Instance.new("UICorner")
                speedSliderCorner.CornerRadius = UDim.new(0, 4)
                speedSliderCorner.Parent = speedSlider
                
                local dragging = false
                speedSliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                speedSliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = speedSliderBg.AbsolutePosition
                        local relX = math.clamp(mousePos.X - absPos.X, 0, speedSliderBg.AbsoluteSize.X)
                        local percent = relX / speedSliderBg.AbsoluteSize.X
                        local value = math.floor(percent * 100)
                        speedSlider.Size = UDim2.new(percent, 0, 1, 0)
                        speedTitle.Text = "SPEED: " .. value
                        features.fly.speed = value
                    end
                end)
                
            elseif id == "speed" then
                local speedFrame = Instance.new("Frame")
                speedFrame.Parent = menu
                speedFrame.BackgroundColor3 = colors.card
                speedFrame.BorderColor3 = colors.primary
                speedFrame.Position = UDim2.new(0, 10, 0, yPos)
                speedFrame.Size = UDim2.new(1, -20, 0, 70)
                
                local speedCorner = Instance.new("UICorner")
                speedCorner.CornerRadius = UDim.new(0, 6)
                speedCorner.Parent = speedFrame
                
                local speedTitle = Instance.new("TextLabel")
                speedTitle.Parent = speedFrame
                speedTitle.BackgroundTransparency = 1
                speedTitle.Position = UDim2.new(0, 10, 0, 5)
                speedTitle.Size = UDim2.new(1, -20, 0, 20)
                speedTitle.Text = "MULTIPLIER: " .. features.speed.multiplier
                speedTitle.TextColor3 = colors.primary
                speedTitle.TextSize = 14
                speedTitle.Font = Enum.Font.GothamBold
                speedTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local speedSliderBg = Instance.new("Frame")
                speedSliderBg.Parent = speedFrame
                speedSliderBg.BackgroundColor3 = colors.bg
                speedSliderBg.BorderColor3 = colors.primary
                speedSliderBg.Position = UDim2.new(0, 10, 0, 30)
                speedSliderBg.Size = UDim2.new(1, -20, 0, 20)
                
                local speedSliderBgCorner = Instance.new("UICorner")
                speedSliderBgCorner.CornerRadius = UDim.new(0, 4)
                speedSliderBgCorner.Parent = speedSliderBg
                
                local speedSlider = Instance.new("Frame")
                speedSlider.Parent = speedSliderBg
                speedSlider.BackgroundColor3 = colors.primary
                speedSlider.Size = UDim2.new(features.speed.multiplier / 100, 0, 1, 0)
                
                local speedSliderCorner = Instance.new("UICorner")
                speedSliderCorner.CornerRadius = UDim.new(0, 4)
                speedSliderCorner.Parent = speedSlider
                
                local dragging = false
                speedSliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                speedSliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = speedSliderBg.AbsolutePosition
                        local relX = math.clamp(mousePos.X - absPos.X, 0, speedSliderBg.AbsoluteSize.X)
                        local percent = relX / speedSliderBg.AbsoluteSize.X
                        local value = math.floor(percent * 100)
                        speedSlider.Size = UDim2.new(percent, 0, 1, 0)
                        speedTitle.Text = "MULTIPLIER: " .. value
                        features.speed.multiplier = value
                    end
                end)
                
            elseif id == "jumpBoost" then
                local powerFrame = Instance.new("Frame")
                powerFrame.Parent = menu
                powerFrame.BackgroundColor3 = colors.card
                powerFrame.BorderColor3 = colors.primary
                powerFrame.Position = UDim2.new(0, 10, 0, yPos)
                powerFrame.Size = UDim2.new(1, -20, 0, 70)
                
                local powerCorner = Instance.new("UICorner")
                powerCorner.CornerRadius = UDim.new(0, 6)
                powerCorner.Parent = powerFrame
                
                local powerTitle = Instance.new("TextLabel")
                powerTitle.Parent = powerFrame
                powerTitle.BackgroundTransparency = 1
                powerTitle.Position = UDim2.new(0, 10, 0, 5)
                powerTitle.Size = UDim2.new(1, -20, 0, 20)
                powerTitle.Text = "POWER: " .. features.jumpBoost.power
                powerTitle.TextColor3 = colors.primary
                powerTitle.TextSize = 14
                powerTitle.Font = Enum.Font.GothamBold
                powerTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local powerSliderBg = Instance.new("Frame")
                powerSliderBg.Parent = powerFrame
                powerSliderBg.BackgroundColor3 = colors.bg
                powerSliderBg.BorderColor3 = colors.primary
                powerSliderBg.Position = UDim2.new(0, 10, 0, 30)
                powerSliderBg.Size = UDim2.new(1, -20, 0, 20)
                
                local powerSliderBgCorner = Instance.new("UICorner")
                powerSliderBgCorner.CornerRadius = UDim.new(0, 4)
                powerSliderBgCorner.Parent = powerSliderBg
                
                local powerSlider = Instance.new("Frame")
                powerSlider.Parent = powerSliderBg
                powerSlider.BackgroundColor3 = colors.primary
                powerSlider.Size = UDim2.new(features.jumpBoost.power / 200, 0, 1, 0)
                
                local powerSliderCorner = Instance.new("UICorner")
                powerSliderCorner.CornerRadius = UDim.new(0, 4)
                powerSliderCorner.Parent = powerSlider
                
                local dragging = false
                powerSliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                powerSliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = powerSliderBg.AbsolutePosition
                        local relX = math.clamp(mousePos.X - absPos.X, 0, powerSliderBg.AbsoluteSize.X)
                        local percent = relX / powerSliderBg.AbsoluteSize.X
                        local value = math.floor(percent * 200)
                        powerSlider.Size = UDim2.new(percent, 0, 1, 0)
                        powerTitle.Text = "POWER: " .. value
                        features.jumpBoost.power = value
                    end
                end)
            end
            
            menu.Size = UDim2.new(0, 280, 0, yPos + 20)
        end)
        
        btn.Visible = (category == "COMBAT")
        return btn
    end

    local function createTrollButton(id, name, icon)
        local btn = Instance.new("TextButton")
        btn.Name = id .. "_TROLL"
        btn.Parent = scrollFrame
        btn.BackgroundColor3 = colors.bg
        btn.BorderColor3 = colors.primary
        btn.Size = UDim2.new(1, -10, 0, 70)
        btn.Text = ""
        btn.ZIndex = 13
        btn.Visible = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        trollButtonRefs[id] = btn
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Parent = btn
        iconLabel.BackgroundTransparency = 1
        iconLabel.Position = UDim2.new(0, 10, 0, 10)
        iconLabel.Size = UDim2.new(0, 30, 0, 30)
        iconLabel.Text = icon
        iconLabel.TextColor3 = colors.primary
        iconLabel.TextSize = 20
        iconLabel.ZIndex = 14
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = btn
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 50, 0, 10)
        nameLabel.Size = UDim2.new(1, -200, 0, 20)
        nameLabel.Text = name
        nameLabel.TextColor3 = colors.text
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 14
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = btn
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 50, 0, 30)
        descLabel.Size = UDim2.new(1, -200, 0, 20)
        descLabel.Text = id == "fling" and "Launch yourself" or id == "spin" and "Spin around" or id == "sizeChanger" and "Change size" or id == "headless" and "Remove head" or id == "freeze" and "Freeze in place" or ""
        descLabel.TextColor3 = colors.textDim
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 14
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Parent = btn
        keyLabel.BackgroundColor3 = colors.card
        keyLabel.BorderColor3 = colors.primary
        keyLabel.Position = UDim2.new(1, -120, 0, 15)
        keyLabel.Size = UDim2.new(0, 40, 0, 25)
        keyLabel.Text = troll[id].key and getKeyName(troll[id].key) or "─"
        keyLabel.TextColor3 = colors.primary
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.TextSize = 12
        keyLabel.ZIndex = 14
        
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 4)
        keyCorner.Parent = keyLabel
        
        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Parent = btn
        status.BackgroundColor3 = troll[id].enabled and colors.success or colors.danger
        status.Position = UDim2.new(1, -70, 0, 15)
        status.Size = UDim2.new(0, 60, 0, 25)
        status.Text = troll[id].enabled and "ON" or "OFF"
        status.TextColor3 = colors.text
        status.Font = Enum.Font.GothamBold
        status.TextSize = 12
        status.ZIndex = 14
        
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 4)
        statusCorner.Parent = status
        
        btn.MouseButton1Click:Connect(function()
            troll[id].enabled = not troll[id].enabled
            status.BackgroundColor3 = troll[id].enabled and colors.success or colors.danger
            status.Text = troll[id].enabled and "ON" or "OFF"
            if id == "headless" then
                if troll.headless.enabled then makeHeadless() else restoreHead() end
            elseif id == "sizeChanger" then
                if troll.sizeChanger.enabled then saveOriginalSizes() else restoreOriginalSizes() end
            end
        end)
        
        btn.MouseButton2Click:Connect(function()
            if _G.trollSettings then _G.trollSettings:Destroy() _G.trollSettings = nil end
            local menu = Instance.new("Frame")
            menu.Parent = screenGui
            menu.BackgroundColor3 = colors.bg
            menu.BorderColor3 = colors.primary
            menu.BorderSizePixel = 2
            menu.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
            menu.Size = UDim2.new(0, 280, 0, id == "spin" and 180 or 120)
            menu.ZIndex = 200
            menu.Active = true
            menu.Draggable = true
            _G.trollSettings = menu
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local header = Instance.new("Frame")
            header.Parent = menu
            header.BackgroundColor3 = colors.primary
            header.Size = UDim2.new(1, 0, 0, 30)
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 8)
            headerCorner.Parent = header
            
            local headerTitle = Instance.new("TextLabel")
            headerTitle.Parent = header
            headerTitle.BackgroundTransparency = 1
            headerTitle.Position = UDim2.new(0, 10, 0, 0)
            headerTitle.Size = UDim2.new(1, -50, 1, 0)
            headerTitle.Text = name .. " SETTINGS"
            headerTitle.TextColor3 = colors.bg
            headerTitle.Font = Enum.Font.GothamBold
            headerTitle.TextSize = 14
            headerTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local closeHeader = Instance.new("TextButton")
            closeHeader.Parent = header
            closeHeader.BackgroundColor3 = colors.danger
            closeHeader.Position = UDim2.new(1, -30, 0, 0)
            closeHeader.Size = UDim2.new(0, 30, 0, 30)
            closeHeader.Text = "✕"
            closeHeader.TextColor3 = colors.text
            closeHeader.Font = Enum.Font.GothamBold
            closeHeader.ZIndex = 201
            closeHeader.MouseButton1Click:Connect(function() menu:Destroy() _G.trollSettings = nil end)
            
            local closeHeaderCorner = Instance.new("UICorner")
            closeHeaderCorner.CornerRadius = UDim.new(0, 6)
            closeHeaderCorner.Parent = closeHeader
            
            local yPos = 40
            
            local keyFrame = Instance.new("Frame")
            keyFrame.Parent = menu
            keyFrame.BackgroundColor3 = colors.card
            keyFrame.BorderColor3 = colors.primary
            keyFrame.Position = UDim2.new(0, 10, 0, yPos)
            keyFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 6)
            keyCorner.Parent = keyFrame
            
            local keyTitle = Instance.new("TextLabel")
            keyTitle.Parent = keyFrame
            keyTitle.BackgroundTransparency = 1
            keyTitle.Position = UDim2.new(0, 10, 0, 5)
            keyTitle.Size = UDim2.new(1, -130, 0, 20)
            keyTitle.Text = "KEYBIND"
            keyTitle.TextColor3 = colors.primary
            keyTitle.TextSize = 14
            keyTitle.Font = Enum.Font.GothamBold
            keyTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Parent = keyFrame
            keyBtn.BackgroundColor3 = colors.primary
            keyBtn.Position = UDim2.new(1, -90, 0, 15)
            keyBtn.Size = UDim2.new(0, 70, 0, 30)
            keyBtn.Text = troll[id].key and getKeyName(troll[id].key) or "SET"
            keyBtn.TextColor3 = colors.bg
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.TextSize = 12
            
            local keyBtnCorner = Instance.new("UICorner")
            keyBtnCorner.CornerRadius = UDim.new(0, 4)
            keyBtnCorner.Parent = keyBtn
            
            local clearBtn = Instance.new("TextButton")
            clearBtn.Parent = keyFrame
            clearBtn.BackgroundColor3 = colors.danger
            clearBtn.Position = UDim2.new(1, -160, 0, 15)
            clearBtn.Size = UDim2.new(0, 30, 0, 30)
            clearBtn.Text = "✕"
            clearBtn.TextColor3 = colors.text
            clearBtn.Font = Enum.Font.GothamBold
            clearBtn.TextSize = 14
            
            local clearCorner = Instance.new("UICorner")
            clearCorner.CornerRadius = UDim.new(0, 4)
            clearCorner.Parent = clearBtn
            
            clearBtn.MouseButton1Click:Connect(function()
                troll[id].key = nil
                keyBtn.Text = "SET"
                keyLabel.Text = "─"
            end)
            
            keyBtn.MouseButton1Click:Connect(function()
                keyBtn.Text = "..."
                local con
                con = UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.Escape then
                        con:Disconnect()
                        keyBtn.Text = troll[id].key and getKeyName(troll[id].key) or "SET"
                    elseif input.UserInputType == Enum.UserInputType.Keyboard then
                        troll[id].key = input.KeyCode
                        keyBtn.Text = getKeyName(input.KeyCode)
                        keyLabel.Text = getKeyName(input.KeyCode)
                        con:Disconnect()
                    end
                end)
            end)
            
            yPos = yPos + 70
            
            if id == "spin" then
                local speedFrame = Instance.new("Frame")
                speedFrame.Parent = menu
                speedFrame.BackgroundColor3 = colors.card
                speedFrame.BorderColor3 = colors.primary
                speedFrame.Position = UDim2.new(0, 10, 0, yPos)
                speedFrame.Size = UDim2.new(1, -20, 0, 70)
                
                local speedCorner = Instance.new("UICorner")
                speedCorner.CornerRadius = UDim.new(0, 6)
                speedCorner.Parent = speedFrame
                
                local speedTitle = Instance.new("TextLabel")
                speedTitle.Parent = speedFrame
                speedTitle.BackgroundTransparency = 1
                speedTitle.Position = UDim2.new(0, 10, 0, 5)
                speedTitle.Size = UDim2.new(1, -20, 0, 20)
                speedTitle.Text = "SPEED: " .. troll.spin.speed
                speedTitle.TextColor3 = colors.primary
                speedTitle.TextSize = 14
                speedTitle.Font = Enum.Font.GothamBold
                speedTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local speedSliderBg = Instance.new("Frame")
                speedSliderBg.Parent = speedFrame
                speedSliderBg.BackgroundColor3 = colors.bg
                speedSliderBg.BorderColor3 = colors.primary
                speedSliderBg.Position = UDim2.new(0, 10, 0, 30)
                speedSliderBg.Size = UDim2.new(1, -20, 0, 20)
                
                local speedSliderBgCorner = Instance.new("UICorner")
                speedSliderBgCorner.CornerRadius = UDim.new(0, 4)
                speedSliderBgCorner.Parent = speedSliderBg
                
                local speedSlider = Instance.new("Frame")
                speedSlider.Parent = speedSliderBg
                speedSlider.BackgroundColor3 = colors.primary
                speedSlider.Size = UDim2.new(troll.spin.speed / 50, 0, 1, 0)
                
                local speedSliderCorner = Instance.new("UICorner")
                speedSliderCorner.CornerRadius = UDim.new(0, 4)
                speedSliderCorner.Parent = speedSlider
                
                local dragging = false
                speedSliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                speedSliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = speedSliderBg.AbsolutePosition
                        local relX = math.clamp(mousePos.X - absPos.X, 0, speedSliderBg.AbsoluteSize.X)
                        local percent = relX / speedSliderBg.AbsoluteSize.X
                        local value = math.floor(percent * 50)
                        speedSlider.Size = UDim2.new(percent, 0, 1, 0)
                        speedTitle.Text = "SPEED: " .. value
                        troll.spin.speed = value
                    end
                end)
                
                menu.Size = UDim2.new(0, 280, 0, yPos + 80)
            end
        end)
        
        return btn
    end

    local function createClickTeleportButton()
        local btn = Instance.new("TextButton")
        btn.Name = "clickTeleport_UTILITY"
        btn.Parent = scrollFrame
        btn.BackgroundColor3 = colors.bg
        btn.BorderColor3 = colors.primary
        btn.Size = UDim2.new(1, -10, 0, 70)
        btn.Text = ""
        btn.ZIndex = 13
        btn.Visible = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Parent = btn
        iconLabel.BackgroundTransparency = 1
        iconLabel.Position = UDim2.new(0, 10, 0, 10)
        iconLabel.Size = UDim2.new(0, 30, 0, 30)
        iconLabel.Text = "👆"
        iconLabel.TextColor3 = colors.primary
        iconLabel.TextSize = 20
        iconLabel.ZIndex = 14
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = btn
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 50, 0, 10)
        nameLabel.Size = UDim2.new(1, -200, 0, 20)
        nameLabel.Text = "CLICK TP"
        nameLabel.TextColor3 = colors.text
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 14
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = btn
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 50, 0, 30)
        descLabel.Size = UDim2.new(1, -200, 0, 20)
        descLabel.Text = clickTeleport.mode == "mouse" and "Left click teleport" or "Key teleport"
        descLabel.TextColor3 = colors.textDim
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 14
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Parent = btn
        keyLabel.BackgroundColor3 = colors.card
        keyLabel.BorderColor3 = colors.primary
        keyLabel.Position = UDim2.new(1, -120, 0, 15)
        keyLabel.Size = UDim2.new(0, 40, 0, 25)
        keyLabel.Text = clickTeleport.mode == "mouse" and "LMB" or (clickTeleport.key and getKeyName(clickTeleport.key) or "─")
        keyLabel.TextColor3 = colors.primary
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.TextSize = 12
        keyLabel.ZIndex = 14
        
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 4)
        keyCorner.Parent = keyLabel
        
        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Parent = btn
        status.BackgroundColor3 = clickTeleport.enabled and colors.success or colors.danger
        status.Position = UDim2.new(1, -70, 0, 15)
        status.Size = UDim2.new(0, 60, 0, 25)
        status.Text = clickTeleport.enabled and "ON" or "OFF"
        status.TextColor3 = colors.text
        status.Font = Enum.Font.GothamBold
        status.TextSize = 12
        status.ZIndex = 14
        
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 4)
        statusCorner.Parent = status
        
        btn.MouseButton1Click:Connect(function()
            clickTeleport.enabled = not clickTeleport.enabled
            status.BackgroundColor3 = clickTeleport.enabled and colors.success or colors.danger
            status.Text = clickTeleport.enabled and "ON" or "OFF"
        end)
        
        btn.MouseButton2Click:Connect(function()
            if _G.teleportSettings then _G.teleportSettings:Destroy() _G.teleportSettings = nil end
            local menu = Instance.new("Frame")
            menu.Parent = screenGui
            menu.BackgroundColor3 = colors.bg
            menu.BorderColor3 = colors.primary
            menu.BorderSizePixel = 2
            menu.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
            menu.Size = UDim2.new(0, 250, 0, 180)
            menu.ZIndex = 200
            menu.Active = true
            menu.Draggable = true
            _G.teleportSettings = menu
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local header = Instance.new("Frame")
            header.Parent = menu
            header.BackgroundColor3 = colors.primary
            header.Size = UDim2.new(1, 0, 0, 30)
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 8)
            headerCorner.Parent = header
            
            local headerTitle = Instance.new("TextLabel")
            headerTitle.Parent = header
            headerTitle.BackgroundTransparency = 1
            headerTitle.Position = UDim2.new(0, 10, 0, 0)
            headerTitle.Size = UDim2.new(1, -50, 1, 0)
            headerTitle.Text = "CLICK TP SETTINGS"
            headerTitle.TextColor3 = colors.bg
            headerTitle.Font = Enum.Font.GothamBold
            headerTitle.TextSize = 14
            headerTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local closeHeader = Instance.new("TextButton")
            closeHeader.Parent = header
            closeHeader.BackgroundColor3 = colors.danger
            closeHeader.Position = UDim2.new(1, -30, 0, 0)
            closeHeader.Size = UDim2.new(0, 30, 0, 30)
            closeHeader.Text = "✕"
            closeHeader.TextColor3 = colors.text
            closeHeader.Font = Enum.Font.GothamBold
            closeHeader.ZIndex = 201
            closeHeader.MouseButton1Click:Connect(function() menu:Destroy() _G.teleportSettings = nil end)
            
            local closeHeaderCorner = Instance.new("UICorner")
            closeHeaderCorner.CornerRadius = UDim.new(0, 6)
            closeHeaderCorner.Parent = closeHeader
            
            local yPos = 40
            
            local modeFrame = Instance.new("Frame")
            modeFrame.Parent = menu
            modeFrame.BackgroundColor3 = colors.card
            modeFrame.BorderColor3 = colors.primary
            modeFrame.Position = UDim2.new(0, 10, 0, yPos)
            modeFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local modeCorner = Instance.new("UICorner")
            modeCorner.CornerRadius = UDim.new(0, 6)
            modeCorner.Parent = modeFrame
            
            local modeTitle = Instance.new("TextLabel")
            modeTitle.Parent = modeFrame
            modeTitle.BackgroundTransparency = 1
            modeTitle.Position = UDim2.new(0, 10, 0, 5)
            modeTitle.Size = UDim2.new(1, -130, 0, 20)
            modeTitle.Text = "MODE"
            modeTitle.TextColor3 = colors.primary
            modeTitle.TextSize = 14
            modeTitle.Font = Enum.Font.GothamBold
            modeTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local mouseBtn = Instance.new("TextButton")
            mouseBtn.Parent = modeFrame
            mouseBtn.BackgroundColor3 = clickTeleport.mode == "mouse" and colors.success or colors.card
            mouseBtn.Position = UDim2.new(1, -180, 0, 15)
            mouseBtn.Size = UDim2.new(0, 50, 0, 30)
            mouseBtn.Text = "LMB"
            mouseBtn.TextColor3 = colors.text
            mouseBtn.Font = Enum.Font.GothamBold
            mouseBtn.TextSize = 12
            
            local mouseBtnCorner = Instance.new("UICorner")
            mouseBtnCorner.CornerRadius = UDim.new(0, 4)
            mouseBtnCorner.Parent = mouseBtn
            
            local keyBtn = Instance.new("TextButton")
            keyBtn.Parent = modeFrame
            keyBtn.BackgroundColor3 = clickTeleport.mode == "key" and colors.success or colors.card
            keyBtn.Position = UDim2.new(1, -120, 0, 15)
            keyBtn.Size = UDim2.new(0, 50, 0, 30)
            keyBtn.Text = "KEY"
            keyBtn.TextColor3 = colors.text
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.TextSize = 12
            
            local keyBtnCorner = Instance.new("UICorner")
            keyBtnCorner.CornerRadius = UDim.new(0, 4)
            keyBtnCorner.Parent = keyBtn
            
            mouseBtn.MouseButton1Click:Connect(function()
                clickTeleport.mode = "mouse"
                mouseBtn.BackgroundColor3 = colors.success
                keyBtn.BackgroundColor3 = colors.card
                descLabel.Text = "Left click teleport"
                keyLabel.Text = "LMB"
            end)
            
            keyBtn.MouseButton1Click:Connect(function()
                clickTeleport.mode = "key"
                mouseBtn.BackgroundColor3 = colors.card
                keyBtn.BackgroundColor3 = colors.success
                descLabel.Text = "Key teleport"
            end)
            
            yPos = yPos + 70
            
            local keyFrame = Instance.new("Frame")
            keyFrame.Parent = menu
            keyFrame.BackgroundColor3 = colors.card
            keyFrame.BorderColor3 = colors.primary
            keyFrame.Position = UDim2.new(0, 10, 0, yPos)
            keyFrame.Size = UDim2.new(1, -20, 0, 60)
            keyFrame.Visible = clickTeleport.mode == "key"
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 6)
            keyCorner.Parent = keyFrame
            
            local keyTitle = Instance.new("TextLabel")
            keyTitle.Parent = keyFrame
            keyTitle.BackgroundTransparency = 1
            keyTitle.Position = UDim2.new(0, 10, 0, 5)
            keyTitle.Size = UDim2.new(1, -130, 0, 20)
            keyTitle.Text = "KEY"
            keyTitle.TextColor3 = colors.primary
            keyTitle.TextSize = 14
            keyTitle.Font = Enum.Font.GothamBold
            keyTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local keySetBtn = Instance.new("TextButton")
            keySetBtn.Parent = keyFrame
            keySetBtn.BackgroundColor3 = colors.primary
            keySetBtn.Position = UDim2.new(1, -90, 0, 15)
            keySetBtn.Size = UDim2.new(0, 70, 0, 30)
            keySetBtn.Text = clickTeleport.key and getKeyName(clickTeleport.key) or "SET"
            keySetBtn.TextColor3 = colors.bg
            keySetBtn.Font = Enum.Font.GothamBold
            keySetBtn.TextSize = 12
            
            local keySetBtnCorner = Instance.new("UICorner")
            keySetBtnCorner.CornerRadius = UDim.new(0, 4)
            keySetBtnCorner.Parent = keySetBtn
            
            local clearBtn = Instance.new("TextButton")
            clearBtn.Parent = keyFrame
            clearBtn.BackgroundColor3 = colors.danger
            clearBtn.Position = UDim2.new(1, -160, 0, 15)
            clearBtn.Size = UDim2.new(0, 30, 0, 30)
            clearBtn.Text = "✕"
            clearBtn.TextColor3 = colors.text
            clearBtn.Font = Enum.Font.GothamBold
            clearBtn.TextSize = 14
            
            local clearCorner = Instance.new("UICorner")
            clearCorner.CornerRadius = UDim.new(0, 4)
            clearCorner.Parent = clearBtn
            
            clearBtn.MouseButton1Click:Connect(function()
                clickTeleport.key = nil
                keySetBtn.Text = "SET"
                if clickTeleport.mode == "key" then
                    keyLabel.Text = "─"
                end
            end)
            
            keySetBtn.MouseButton1Click:Connect(function()
                keySetBtn.Text = "..."
                local con
                con = UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.Escape then
                        con:Disconnect()
                        keySetBtn.Text = clickTeleport.key and getKeyName(clickTeleport.key) or "SET"
                    elseif input.UserInputType == Enum.UserInputType.Keyboard then
                        clickTeleport.key = input.KeyCode
                        keySetBtn.Text = getKeyName(input.KeyCode)
                        if clickTeleport.mode == "key" then
                            keyLabel.Text = getKeyName(input.KeyCode)
                        end
                        con:Disconnect()
                    end
                end)
            end)
            
            local modeChanged = mouseBtn.MouseButton1Click:Connect(function()
                keyFrame.Visible = false
            end)
            
            keyBtn.MouseButton1Click:Connect(function()
                keyFrame.Visible = true
            end)
            
            menu.Size = UDim2.new(0, 250, 0, yPos + 80)
        end)
        
        return btn
    end

    local function createGuiKeyButton()
        local btn = Instance.new("TextButton")
        btn.Name = "guiKey_UTILITY"
        btn.Parent = scrollFrame
        btn.BackgroundColor3 = colors.bg
        btn.BorderColor3 = colors.primary
        btn.Size = UDim2.new(1, -10, 0, 70)
        btn.Text = ""
        btn.ZIndex = 13
        btn.Visible = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Parent = btn
        iconLabel.BackgroundTransparency = 1
        iconLabel.Position = UDim2.new(0, 10, 0, 10)
        iconLabel.Size = UDim2.new(0, 30, 0, 30)
        iconLabel.Text = "🔑"
        iconLabel.TextColor3 = colors.primary
        iconLabel.TextSize = 20
        iconLabel.ZIndex = 14
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = btn
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 50, 0, 10)
        nameLabel.Size = UDim2.new(1, -200, 0, 20)
        nameLabel.Text = "GUI KEY"
        nameLabel.TextColor3 = colors.text
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 14
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = btn
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 50, 0, 30)
        descLabel.Size = UDim2.new(1, -200, 0, 20)
        descLabel.Text = "Toggle panel key"
        descLabel.TextColor3 = colors.textDim
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 14
        
        local keyLabel = Instance.new("TextLabel")
        keyLabel.Parent = btn
        keyLabel.BackgroundColor3 = colors.card
        keyLabel.BorderColor3 = colors.primary
        keyLabel.Position = UDim2.new(1, -70, 0, 15)
        keyLabel.Size = UDim2.new(0, 60, 0, 25)
        keyLabel.Text = getKeyName(guiKey)
        keyLabel.TextColor3 = colors.primary
        keyLabel.Font = Enum.Font.GothamBold
        keyLabel.TextSize = 12
        keyLabel.ZIndex = 14
        
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 4)
        keyCorner.Parent = keyLabel
        
        btn.MouseButton2Click:Connect(function()
            if _G.guiKeySettings then _G.guiKeySettings:Destroy() _G.guiKeySettings = nil end
            local menu = Instance.new("Frame")
            menu.Parent = screenGui
            menu.BackgroundColor3 = colors.bg
            menu.BorderColor3 = colors.primary
            menu.BorderSizePixel = 2
            menu.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
            menu.Size = UDim2.new(0, 250, 0, 120)
            menu.ZIndex = 200
            menu.Active = true
            menu.Draggable = true
            _G.guiKeySettings = menu
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local header = Instance.new("Frame")
            header.Parent = menu
            header.BackgroundColor3 = colors.primary
            header.Size = UDim2.new(1, 0, 0, 30)
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 8)
            headerCorner.Parent = header
            
            local headerTitle = Instance.new("TextLabel")
            headerTitle.Parent = header
            headerTitle.BackgroundTransparency = 1
            headerTitle.Position = UDim2.new(0, 10, 0, 0)
            headerTitle.Size = UDim2.new(1, -50, 1, 0)
            headerTitle.Text = "GUI KEY SETTINGS"
            headerTitle.TextColor3 = colors.bg
            headerTitle.Font = Enum.Font.GothamBold
            headerTitle.TextSize = 14
            headerTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local closeHeader = Instance.new("TextButton")
            closeHeader.Parent = header
            closeHeader.BackgroundColor3 = colors.danger
            closeHeader.Position = UDim2.new(1, -30, 0, 0)
            closeHeader.Size = UDim2.new(0, 30, 0, 30)
            closeHeader.Text = "✕"
            closeHeader.TextColor3 = colors.text
            closeHeader.Font = Enum.Font.GothamBold
            closeHeader.ZIndex = 201
            closeHeader.MouseButton1Click:Connect(function() menu:Destroy() _G.guiKeySettings = nil end)
            
            local closeHeaderCorner = Instance.new("UICorner")
            closeHeaderCorner.CornerRadius = UDim.new(0, 6)
            closeHeaderCorner.Parent = closeHeader
            
            local keyFrame = Instance.new("Frame")
            keyFrame.Parent = menu
            keyFrame.BackgroundColor3 = colors.card
            keyFrame.BorderColor3 = colors.primary
            keyFrame.Position = UDim2.new(0, 10, 0, 40)
            keyFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 6)
            keyCorner.Parent = keyFrame
            
            local keyTitle = Instance.new("TextLabel")
            keyTitle.Parent = keyFrame
            keyTitle.BackgroundTransparency = 1
            keyTitle.Position = UDim2.new(0, 10, 0, 5)
            keyTitle.Size = UDim2.new(1, -130, 0, 20)
            keyTitle.Text = "KEY"
            keyTitle.TextColor3 = colors.primary
            keyTitle.TextSize = 14
            keyTitle.Font = Enum.Font.GothamBold
            keyTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local keySetBtn = Instance.new("TextButton")
            keySetBtn.Parent = keyFrame
            keySetBtn.BackgroundColor3 = colors.primary
            keySetBtn.Position = UDim2.new(1, -90, 0, 15)
            keySetBtn.Size = UDim2.new(0, 70, 0, 30)
            keySetBtn.Text = getKeyName(guiKey)
            keySetBtn.TextColor3 = colors.bg
            keySetBtn.Font = Enum.Font.GothamBold
            keySetBtn.TextSize = 12
            
            local keySetBtnCorner = Instance.new("UICorner")
            keySetBtnCorner.CornerRadius = UDim.new(0, 4)
            keySetBtnCorner.Parent = keySetBtn
            
            local clearBtn = Instance.new("TextButton")
            clearBtn.Parent = keyFrame
            clearBtn.BackgroundColor3 = colors.danger
            clearBtn.Position = UDim2.new(1, -160, 0, 15)
            clearBtn.Size = UDim2.new(0, 30, 0, 30)
            clearBtn.Text = "✕"
            clearBtn.TextColor3 = colors.text
            clearBtn.Font = Enum.Font.GothamBold
            clearBtn.TextSize = 14
            
            local clearCorner = Instance.new("UICorner")
            clearCorner.CornerRadius = UDim.new(0, 4)
            clearCorner.Parent = clearBtn
            
            clearBtn.MouseButton1Click:Connect(function()
                guiKey = Enum.KeyCode.G
                keySetBtn.Text = "G"
                keyLabel.Text = "G"
            end)
            
            keySetBtn.MouseButton1Click:Connect(function()
                keySetBtn.Text = "..."
                local con
                con = UserInputService.InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.Escape then
                        con:Disconnect()
                        keySetBtn.Text = getKeyName(guiKey)
                    elseif input.UserInputType == Enum.UserInputType.Keyboard then
                        guiKey = input.KeyCode
                        keySetBtn.Text = getKeyName(input.KeyCode)
                        keyLabel.Text = getKeyName(input.KeyCode)
                        con:Disconnect()
                    end
                end)
            end)
        end)
        
        return btn
    end

    local function createFriendListButton()
        local btn = Instance.new("TextButton")
        btn.Name = "friendList_UTILITY"
        btn.Parent = scrollFrame
        btn.BackgroundColor3 = colors.bg
        btn.BorderColor3 = colors.primary
        btn.Size = UDim2.new(1, -10, 0, 70)
        btn.Text = ""
        btn.ZIndex = 13
        btn.Visible = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Parent = btn
        iconLabel.BackgroundTransparency = 1
        iconLabel.Position = UDim2.new(0, 10, 0, 10)
        iconLabel.Size = UDim2.new(0, 30, 0, 30)
        iconLabel.Text = "👥"
        iconLabel.TextColor3 = colors.primary
        iconLabel.TextSize = 20
        iconLabel.ZIndex = 14
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = btn
        nameLabel.BackgroundTransparency = 1
        nameLabel.Position = UDim2.new(0, 50, 0, 10)
        nameLabel.Size = UDim2.new(1, -200, 0, 20)
        nameLabel.Text = "FRIEND LIST"
        nameLabel.TextColor3 = colors.text
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 14
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = btn
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 50, 0, 30)
        descLabel.Size = UDim2.new(1, -200, 0, 20)
        descLabel.Text = "Don't target friends"
        descLabel.TextColor3 = colors.textDim
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.ZIndex = 14
        
        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Parent = btn
        status.BackgroundColor3 = manualTeam.enabled and colors.success or colors.danger
        status.Position = UDim2.new(1, -70, 0, 15)
        status.Size = UDim2.new(0, 60, 0, 25)
        status.Text = manualTeam.enabled and "ON" or "OFF"
        status.TextColor3 = colors.text
        status.Font = Enum.Font.GothamBold
        status.TextSize = 12
        status.ZIndex = 14
        
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 4)
        statusCorner.Parent = status
        
        btn.MouseButton1Click:Connect(function()
            manualTeam.enabled = not manualTeam.enabled
            status.BackgroundColor3 = manualTeam.enabled and colors.success or colors.danger
            status.Text = manualTeam.enabled and "ON" or "OFF"
            friendsLabel.Text = "Friend List: " .. (manualTeam.enabled and "ON" or "OFF")
            friendsLabel.TextColor3 = manualTeam.enabled and colors.success or colors.danger
        end)
        
        btn.MouseButton2Click:Connect(function()
            if _G.friendMenu then _G.friendMenu:Destroy() _G.friendMenu = nil end
            local menu = Instance.new("Frame")
            menu.Name = "FriendMenu"
            menu.Parent = screenGui
            menu.BackgroundColor3 = colors.bg
            menu.BorderColor3 = colors.primary
            menu.BorderSizePixel = 3
            menu.Position = UDim2.new(0.3, 0, 0.2, 0)
            menu.Size = UDim2.new(0, 350, 0, 450)
            menu.ZIndex = 200
            menu.Active = true
            menu.Draggable = true
            _G.friendMenu = menu
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local header = Instance.new("Frame")
            header.Parent = menu
            header.BackgroundColor3 = colors.primary
            header.Size = UDim2.new(1, 0, 0, 40)
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 8)
            headerCorner.Parent = header
            
            local title = Instance.new("TextLabel")
            title.Parent = header
            title.BackgroundTransparency = 1
            title.Position = UDim2.new(0, 10, 0, 0)
            title.Size = UDim2.new(1, -50, 1, 0)
            title.Text = "FRIEND LIST"
            title.TextColor3 = colors.bg
            title.Font = Enum.Font.GothamBold
            title.TextSize = 16
            title.TextXAlignment = Enum.TextXAlignment.Left
            
            local close = Instance.new("TextButton")
            close.Parent = header
            close.BackgroundColor3 = colors.danger
            close.Position = UDim2.new(1, -35, 0, 5)
            close.Size = UDim2.new(0, 30, 0, 30)
            close.Text = "✕"
            close.TextColor3 = colors.text
            close.Font = Enum.Font.GothamBold
            close.MouseButton1Click:Connect(function() menu:Destroy() _G.friendMenu = nil end)
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(0, 6)
            closeCorner.Parent = close
            
            local search = Instance.new("TextBox")
            search.Parent = menu
            search.BackgroundColor3 = colors.card
            search.BorderColor3 = colors.primary
            search.Position = UDim2.new(0, 10, 0, 50)
            search.Size = UDim2.new(1, -20, 0, 35)
            search.PlaceholderText = "Search player..."
            search.PlaceholderColor3 = colors.textDim
            search.TextColor3 = colors.text
            search.Text = ""
            search.Font = Enum.Font.Gotham
            
            local searchCorner = Instance.new("UICorner")
            searchCorner.CornerRadius = UDim.new(0, 6)
            searchCorner.Parent = search
            
            local list = Instance.new("ScrollingFrame")
            list.Parent = menu
            list.BackgroundColor3 = colors.card
            list.Position = UDim2.new(0, 10, 0, 95)
            list.Size = UDim2.new(1, -20, 1, -105)
            list.CanvasSize = UDim2.new(0, 0, 0, 0)
            list.ScrollBarThickness = 4
            list.ScrollBarImageColor3 = colors.primary
            
            local function refresh(searchText)
                for _,v in pairs(list:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
                local y, s = 5, searchText:lower()
                for _,v in pairs(Players:GetPlayers()) do
                    if v ~= player then
                        local name = v.Name:lower()
                        if searchText == "" or name:find(s,1,true) then
                            local frame = Instance.new("Frame")
                            frame.Parent = list
                            frame.BackgroundColor3 = colors.bg
                            frame.BorderColor3 = colors.primary
                            frame.Position = UDim2.new(0,5,0,y)
                            frame.Size = UDim2.new(1,-10,0,40)
                            
                            local frameCorner = Instance.new("UICorner")
                            frameCorner.CornerRadius = UDim.new(0, 6)
                            frameCorner.Parent = frame
                            
                            local nameLbl = Instance.new("TextLabel")
                            nameLbl.Parent = frame
                            nameLbl.BackgroundTransparency = 1
                            nameLbl.Position = UDim2.new(0,10,0,0)
                            nameLbl.Size = UDim2.new(1,-100,1,0)
                            nameLbl.Text = v.Name
                            nameLbl.TextColor3 = colors.primary
                            nameLbl.TextSize = 14
                            nameLbl.Font = Enum.Font.GothamBold
                            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
                            
                            local statusBtn = Instance.new("TextButton")
                            statusBtn.Parent = frame
                            statusBtn.BackgroundColor3 = manualFriends[v] and colors.danger or colors.success
                            statusBtn.Position = UDim2.new(1,-80,0,5)
                            statusBtn.Size = UDim2.new(0,70,0,30)
                            statusBtn.Text = manualFriends[v] and "REMOVE" or "ADD"
                            statusBtn.TextColor3 = colors.text
                            statusBtn.Font = Enum.Font.GothamBold
                            statusBtn.TextSize = 12
                            
                            local statusBtnCorner = Instance.new("UICorner")
                            statusBtnCorner.CornerRadius = UDim.new(0, 4)
                            statusBtnCorner.Parent = statusBtn
                            
                            statusBtn.MouseButton1Click:Connect(function()
                                if manualFriends[v] then
                                    manualFriends[v] = nil
                                else
                                    manualFriends[v] = true
                                end
                                refresh(search.Text)
                            end)
                            
                            y = y + 50
                        end
                    end
                end
                list.CanvasSize = UDim2.new(0,0,0,y+10)
            end
            
            search.Changed:Connect(function(p) if p == "Text" then refresh(search.Text) end end)
            refresh("")
        end)
        
        return btn
    end

    mouse.Button2Down:Connect(function()
        if not screenGui.Enabled or not manualTeam.enabled then return end
        local mousePos = Vector2.new(mouse.X, mouse.Y)
        local closest, minDist = nil, 50
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                local pos = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                if pos.Z > 0 then
                    local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if dist < minDist then closest, minDist = v, dist end
                end
            end
        end
        if closest then
            local menu = Instance.new("Frame")
            menu.Parent = screenGui
            menu.BackgroundColor3 = colors.bg
            menu.BorderColor3 = colors.primary
            menu.BorderSizePixel = 2
            menu.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
            menu.Size = UDim2.new(0, 200, 0, 90)
            menu.ZIndex = 200
            menu.Active = true
            
            local menuCorner = Instance.new("UICorner")
            menuCorner.CornerRadius = UDim.new(0, 8)
            menuCorner.Parent = menu
            
            local header = Instance.new("TextLabel")
            header.Parent = menu
            header.BackgroundColor3 = colors.primary
            header.Size = UDim2.new(1,0,0,30)
            header.Text = closest.Name
            header.TextColor3 = colors.bg
            header.Font = Enum.Font.GothamBold
            
            local friend = Instance.new("TextButton")
            friend.Parent = menu
            friend.BackgroundColor3 = manualFriends[closest] and colors.danger or colors.success
            friend.Position = UDim2.new(0,5,0,35)
            friend.Size = UDim2.new(1,-10,0,40)
            friend.Text = manualFriends[closest] and "REMOVE FRIEND" or "ADD FRIEND"
            friend.TextColor3 = colors.text
            friend.Font = Enum.Font.GothamBold
            friend.TextSize = 12
            
            local friendCorner = Instance.new("UICorner")
            friendCorner.CornerRadius = UDim.new(0, 4)
            friendCorner.Parent = friend
            
            friend.MouseButton1Click:Connect(function()
                if manualFriends[closest] then
                    manualFriends[closest] = nil
                else
                    manualFriends[closest] = true
                end
                menu:Destroy()
            end)
            
            task.spawn(function() task.wait(5) if menu then menu:Destroy() end end)
        end
    end)

    createButton("aimbot", "AIMBOT", "🎯", "COMBAT")
    createButton("triggerbot", "TRIGGERBOT", "🔫", "COMBAT")
    createButton("esp", "ESP", "👁️", "VISUAL")
    createButton("nametags", "NAME TAGS", "🏷️", "VISUAL")
    createButton("fly", "FLY", "🦅", "MOVEMENT")
    createButton("speed", "SPEED", "⚡", "MOVEMENT")
    createButton("jumpBoost", "JUMP BOOST", "📈", "MOVEMENT")
    createButton("noclip", "NO CLIP", "🚪", "MOVEMENT")
    createButton("multiJump", "MULTI JUMP", "🦘", "MOVEMENT")
    createButton("teleport", "TELEPORT", "🌍", "UTILITY")

    createTrollButton("fling", "FLING", "🌀")
    createTrollButton("spin", "SPIN", "🔄")
    createTrollButton("sizeChanger", "SIZE", "📏")
    createTrollButton("headless", "HEADLESS", "👻")
    createTrollButton("freeze", "FREEZE", "❄️")

    local friendBtn = createFriendListButton()
    local clickTpBtn = createClickTeleportButton()
    local guiKeyBtn = createGuiKeyButton()

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #scrollFrame:GetChildren() * 76)

    combatTab.MouseButton1Click:Connect(function()
        combatTab.BackgroundColor3 = colors.primary
        combatTab.TextColor3 = colors.bg
        movementTab.BackgroundColor3 = colors.card
        movementTab.TextColor3 = colors.text
        visualTab.BackgroundColor3 = colors.card
        visualTab.TextColor3 = colors.text
        utilityTab.BackgroundColor3 = colors.card
        utilityTab.TextColor3 = colors.text
        trollTab.BackgroundColor3 = colors.card
        trollTab.TextColor3 = colors.text
        settingsTab.BackgroundColor3 = colors.card
        settingsTab.TextColor3 = colors.text
        scrollFrame.Visible = true
        settingsFrame.Visible = false
        for _, btn in pairs(scrollFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.Visible = string.find(btn.Name, "COMBAT") ~= nil
            end
        end
        friendBtn.Visible = false
        clickTpBtn.Visible = false
        guiKeyBtn.Visible = false
    end)

    movementTab.MouseButton1Click:Connect(function()
        movementTab.BackgroundColor3 = colors.primary
        movementTab.TextColor3 = colors.bg
        combatTab.BackgroundColor3 = colors.card
        combatTab.TextColor3 = colors.text
        visualTab.BackgroundColor3 = colors.card
        visualTab.TextColor3 = colors.text
        utilityTab.BackgroundColor3 = colors.card
        utilityTab.TextColor3 = colors.text
        trollTab.BackgroundColor3 = colors.card
        trollTab.TextColor3 = colors.text
        settingsTab.BackgroundColor3 = colors.card
        settingsTab.TextColor3 = colors.text
        scrollFrame.Visible = true
        settingsFrame.Visible = false
        for _, btn in pairs(scrollFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.Visible = string.find(btn.Name, "MOVEMENT") ~= nil
            end
        end
        friendBtn.Visible = false
        clickTpBtn.Visible = false
        guiKeyBtn.Visible = false
    end)

    visualTab.MouseButton1Click:Connect(function()
        visualTab.BackgroundColor3 = colors.primary
        visualTab.TextColor3 = colors.bg
        combatTab.BackgroundColor3 = colors.card
        combatTab.TextColor3 = colors.text
        movementTab.BackgroundColor3 = colors.card
        movementTab.TextColor3 = colors.text
        utilityTab.BackgroundColor3 = colors.card
        utilityTab.TextColor3 = colors.text
        trollTab.BackgroundColor3 = colors.card
        trollTab.TextColor3 = colors.text
        settingsTab.BackgroundColor3 = colors.card
        settingsTab.TextColor3 = colors.text
        scrollFrame.Visible = true
        settingsFrame.Visible = false
        for _, btn in pairs(scrollFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.Visible = string.find(btn.Name, "VISUAL") ~= nil
            end
        end
        friendBtn.Visible = false
        clickTpBtn.Visible = false
        guiKeyBtn.Visible = false
    end)

    utilityTab.MouseButton1Click:Connect(function()
        utilityTab.BackgroundColor3 = colors.primary
        utilityTab.TextColor3 = colors.bg
        combatTab.BackgroundColor3 = colors.card
        combatTab.TextColor3 = colors.text
        movementTab.BackgroundColor3 = colors.card
        movementTab.TextColor3 = colors.text
        visualTab.BackgroundColor3 = colors.card
        visualTab.TextColor3 = colors.text
        trollTab.BackgroundColor3 = colors.card
        trollTab.TextColor3 = colors.text
        settingsTab.BackgroundColor3 = colors.card
        settingsTab.TextColor3 = colors.text
        scrollFrame.Visible = true
        settingsFrame.Visible = false
        for _, btn in pairs(scrollFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.Visible = string.find(btn.Name, "UTILITY") ~= nil
            end
        end
        friendBtn.Visible = true
        clickTpBtn.Visible = true
        guiKeyBtn.Visible = true
    end)

    trollTab.MouseButton1Click:Connect(function()
        trollTab.BackgroundColor3 = colors.primary
        trollTab.TextColor3 = colors.bg
        combatTab.BackgroundColor3 = colors.card
        combatTab.TextColor3 = colors.text
        movementTab.BackgroundColor3 = colors.card
        movementTab.TextColor3 = colors.text
        visualTab.BackgroundColor3 = colors.card
        visualTab.TextColor3 = colors.text
        utilityTab.BackgroundColor3 = colors.card
        utilityTab.TextColor3 = colors.text
        settingsTab.BackgroundColor3 = colors.card
        settingsTab.TextColor3 = colors.text
        scrollFrame.Visible = true
        settingsFrame.Visible = false
        for _, btn in pairs(scrollFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.Visible = string.find(btn.Name, "TROLL") ~= nil
            end
        end
        friendBtn.Visible = false
        clickTpBtn.Visible = false
        guiKeyBtn.Visible = false
    end)

    settingsTab.MouseButton1Click:Connect(function()
        settingsTab.BackgroundColor3 = colors.primary
        settingsTab.TextColor3 = colors.bg
        combatTab.BackgroundColor3 = colors.card
        combatTab.TextColor3 = colors.text
        movementTab.BackgroundColor3 = colors.card
        movementTab.TextColor3 = colors.text
        visualTab.BackgroundColor3 = colors.card
        visualTab.TextColor3 = colors.text
        utilityTab.BackgroundColor3 = colors.card
        utilityTab.TextColor3 = colors.text
        trollTab.BackgroundColor3 = colors.card
        trollTab.TextColor3 = colors.text
        scrollFrame.Visible = false
        settingsFrame.Visible = true
    end)

    local function updateButtonStatus(id, enabled)
        if buttonRefs[id] then
            for _, label in pairs(buttonRefs[id]:GetChildren()) do
                if label.Name == "Status" then
                    label.BackgroundColor3 = enabled and colors.success or colors.danger
                    label.Text = enabled and "ON" or "OFF"
                    break
                end
            end
        end
    end

    local function updateTrollButtonStatus(id, enabled)
        if trollButtonRefs[id] then
            for _, label in pairs(trollButtonRefs[id]:GetChildren()) do
                if label.Name == "Status" then
                    label.BackgroundColor3 = enabled and colors.success or colors.danger
                    label.Text = enabled and "ON" or "OFF"
                    break
                end
            end
        end
    end

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == guiKey then
            screenGui.Enabled = not screenGui.Enabled
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            for name, feature in pairs(features) do
                if feature.key and feature.key == input.KeyCode then
                    if name ~= "teleport" then
                        feature.enabled = not feature.enabled
                        updateButtonStatus(name, feature.enabled)
                        if name == "noclip" then updateNoClip()
                        elseif name == "nametags" then updateNameTags() end
                    else
                        feature.enabled = not feature.enabled
                        if feature.enabled then showTeleportMenu()
                        elseif _G.tpMenu then _G.tpMenu:Destroy() _G.tpMenu = nil end
                        updateButtonStatus("teleport", feature.enabled)
                    end
                end
            end
            for name, feature in pairs(troll) do
                if feature.key and feature.key == input.KeyCode then
                    feature.enabled = not feature.enabled
                    updateTrollButtonStatus(name, feature.enabled)
                    if name == "headless" then
                        if feature.enabled then makeHeadless() else restoreHead() end
                    elseif name == "freeze" then
                        if player.Character and player.Character:FindFirstChild("Humanoid") then
                            player.Character.Humanoid.WalkSpeed = feature.enabled and 0 or (features.speed.enabled and features.speed.multiplier or 16)
                        end
                    elseif name == "sizeChanger" then
                        if feature.enabled then saveOriginalSizes() else restoreOriginalSizes() end
                    end
                end
            end
            if clickTeleport.enabled and clickTeleport.mode == "key" and clickTeleport.key and input.KeyCode == clickTeleport.key then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local mousePos = UserInputService:GetMouseLocation()
                    local ray = workspace.CurrentCamera:ScreenPointToRay(mousePos.X, mousePos.Y)
                    local params = RaycastParams.new()
                    params.FilterDescendantsInstances = {player.Character}
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
                    if result then
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                    else
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(ray.Origin + ray.Direction * 100)
                    end
                end
            end
        end
    end)

    mouse.Button1Down:Connect(function()
        if clickTeleport.enabled and clickTeleport.mode == "mouse" then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local mousePos = Vector2.new(mouse.X, mouse.Y)
                local ray = workspace.CurrentCamera:ScreenPointToRay(mousePos.X, mousePos.Y)
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {player.Character}
                params.FilterType = Enum.RaycastFilterType.Blacklist
                local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
                if result then
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                else
                    player.Character.HumanoidRootPart.CFrame = CFrame.new(ray.Origin + ray.Direction * 100)
                end
            end
        end
    end)
end

function saveOriginalSizes()
    if player.Character then
        originalSizes = {}
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                originalSizes[part] = part.Size
            end
        end
    end
end

function restoreOriginalSizes()
    if player.Character then
        for part, originalSize in pairs(originalSizes) do
            if part and part.Parent then
                part.Size = originalSize
            end
        end
    end
end

function createNameTag(v)
    if nameTags[v] then nameTags[v]:Destroy() end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "XenaNameTag"
    billboard.Adornee = v.Character:FindFirstChild("Head") or v.Character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = v.Character
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 2
    frame.BorderColor3 = colors.primary
    frame.Parent = billboard
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.7, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = v.Name
    nameLabel.TextColor3 = colors.primary
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = frame
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.3, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.7, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "❤️ " .. math.floor(v.Character.Humanoid.Health) .. "/" .. math.floor(v.Character.Humanoid.MaxHealth)
    healthLabel.TextColor3 = Color3.new(1, 0, 0)
    healthLabel.TextSize = 10
    healthLabel.Font = Enum.Font.Gotham
    healthLabel.Parent = frame
    nameTags[v] = billboard
end

function showTeleportMenu()
    if _G.tpMenu then _G.tpMenu:Destroy() _G.tpMenu = nil end
    local tpMenu = Instance.new("Frame")
    tpMenu.Name = "TeleportMenu"
    tpMenu.Parent = screenGui
    tpMenu.BackgroundColor3 = colors.bg
    tpMenu.BorderColor3 = colors.primary
    tpMenu.BorderSizePixel = 3
    tpMenu.Position = UDim2.new(0.8, -150, 0.5, -200)
    tpMenu.Size = UDim2.new(0, 300, 0, 400)
    tpMenu.ZIndex = 200
    tpMenu.Active = true
    tpMenu.Draggable = true
    _G.tpMenu = tpMenu
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 8)
    menuCorner.Parent = tpMenu
    
    local header = Instance.new("Frame")
    header.Parent = tpMenu
    header.BackgroundColor3 = colors.primary
    header.Size = UDim2.new(1, 0, 0, 40)
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Parent = header
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Text = "TELEPORT"
    title.TextColor3 = colors.bg
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local close = Instance.new("TextButton")
    close.Parent = header
    close.BackgroundColor3 = colors.danger
    close.Position = UDim2.new(1, -35, 0, 5)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Text = "✕"
    close.TextColor3 = colors.text
    close.Font = Enum.Font.GothamBold
    close.MouseButton1Click:Connect(function()
        tpMenu:Destroy()
        _G.tpMenu = nil
        features.teleport.enabled = false
        updateButtonStatus("teleport", false)
    end)
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = close
    
    local list = Instance.new("ScrollingFrame")
    list.Parent = tpMenu
    list.BackgroundColor3 = colors.card
    list.Position = UDim2.new(0, 5, 0, 45)
    list.Size = UDim2.new(1, -10, 1, -50)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ScrollBarThickness = 4
    list.ScrollBarImageColor3 = colors.primary
    
    local y = 5
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            local btn = Instance.new("TextButton")
            btn.Parent = list
            btn.BackgroundColor3 = colors.bg
            btn.BorderColor3 = colors.primary
            btn.Position = UDim2.new(0, 5, 0, y)
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.Text = v.Name
            btn.TextColor3 = colors.text
            btn.Font = Enum.Font.Gotham
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and player.Character then
                    player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                end
            end)
            y = y + 45
        end
    end
    list.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

function updateNoClip()
    if features.noclip.enabled then
        RunService.Stepped:Connect(function()
            if features.noclip.enabled and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    elseif player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

function updateNameTags()
    if features.nametags.enabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                createNameTag(v)
            end
        end
        Players.PlayerAdded:Connect(function(v)
            v.CharacterAdded:Connect(function()
                task.wait(1)
                if features.nametags.enabled then createNameTag(v) end
            end)
        end)
    else
        for _, v in pairs(nameTags) do if v then v:Destroy() end end
        nameTags = {}
    end
end

function makeHeadless()
    if player.Character and player.Character:FindFirstChild("Head") then
        player.Character.Head.Transparency = 1
        player.Character.Head.CanCollide = false
    end
end

function restoreHead()
    if player.Character and player.Character:FindFirstChild("Head") then
        player.Character.Head.Transparency = 0
        player.Character.Head.CanCollide = true
    end
end

-- ESP (senin attığın kod - DÜZELTİLDİ)
RunService.Heartbeat:Connect(function()
    if features.esp.enabled then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character then
                if not v.Character:FindFirstChild("XenaESP") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "XenaESP"
                    highlight.Adornee = v.Character
                    highlight.Parent = v.Character
                end
                
                local highlight = v.Character:FindFirstChild("XenaESP")
                if highlight then
                    if manualTeam.enabled and manualFriends[v] then
                        highlight.FillColor = colors.success
                    else
                        highlight.FillColor = colors.danger
                    end
                    highlight.FillTransparency = 0.3
                end
            end
        end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("XenaESP") then
                v.Character.XenaESP:Destroy()
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if features.aimbot.enabled and player.Character and player.Character:FindFirstChild("Head") then
        local closest = nil
        local dist = math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                if manualTeam.enabled and manualFriends[v] then continue end
                if features.aimbot.wallCheck then
                    local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (v.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                    local hit = workspace:FindPartOnRay(ray, player.Character)
                    if hit and hit:IsA("BasePart") and not hit:IsDescendantOf(v.Character) then continue end
                end
                local d = (player.Character.Head.Position - v.Character.Head.Position).Magnitude
                if d < dist and d < 200 then dist, closest = d, v end
            end
        end
        if closest then
            if features.aimbot.mode == "camera" then
                local targetPos = closest.Character.Head.Position
                local currentCF = workspace.CurrentCamera.CFrame
                local goalCF = CFrame.new(currentCF.Position, targetPos)
                local smoothness = features.aimbot.smoothness == 0 and 1 or (features.aimbot.smoothness / 10)
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(goalCF, smoothness)
            else
                local targetPos = workspace.CurrentCamera:WorldToViewportPoint(closest.Character.Head.Position)
                local currentMousePos = Vector2.new(mouse.X, mouse.Y)
                local targetMousePos = Vector2.new(targetPos.X, targetPos.Y)
                local smoothness = features.aimbot.smoothness == 0 and 1 or (features.aimbot.smoothness / 10)
                local newX = currentMousePos.X + (targetMousePos.X - currentMousePos.X) * smoothness
                local newY = currentMousePos.Y + (targetMousePos.Y - currentMousePos.Y) * smoothness
                mousemoverel(newX - currentMousePos.X, newY - currentMousePos.Y)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if features.triggerbot.enabled and player.Character and player.Character:FindFirstChild("Head") then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                if manualTeam.enabled and manualFriends[v] then continue end
                if features.triggerbot.wallCheck then
                    local ray = Ray.new(workspace.CurrentCamera.CFrame.Position, (v.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
                    local hit = workspace:FindPartOnRay(ray, player.Character)
                    if hit and hit:IsA("BasePart") and not hit:IsDescendantOf(v.Character) then continue end
                end
                local distance = (player.Character.Head.Position - v.Character.Head.Position).Magnitude
                if distance <= features.triggerbot.range then
                    local pos = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                    local center = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
                    if (Vector2.new(pos.X, pos.Y) - center).Magnitude < 50 then
                        task.wait(features.triggerbot.delay)
                        mouse1click()
                    end
                end
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if troll.fling.enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Velocity = Vector3.new(10000, 10000, 10000)
    end
end)

RunService.Heartbeat:Connect(function()
    if troll.spin.enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(troll.spin.speed), 0)
    end
end)

RunService.Heartbeat:Connect(function()
    if features.fly.enabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        if not root:FindFirstChild("BodyVelocity") then
            local bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
            bv.Parent = root
        end
        if root:FindFirstChild("BodyVelocity") then
            local speed = features.fly.speed
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            root.BodyVelocity.Velocity = moveDir * speed
        end
    elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
        player.Character.HumanoidRootPart.BodyVelocity:Destroy()
    end
end)

RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if features.speed.enabled then
            hum.WalkSpeed = features.speed.multiplier
        elseif troll.freeze.enabled then
            hum.WalkSpeed = 0
        else
            hum.WalkSpeed = 16
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if features.jumpBoost.enabled then
            hum.JumpPower = features.jumpBoost.power
        else
            hum.JumpPower = 50
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if features.multiJump.enabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if hum.FloorMaterial == Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if troll.sizeChanger.enabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = Vector3.new(troll.sizeChanger.size,	 troll.sizeChanger.size, troll.sizeChanger.size)
            end
        end
    end
end)
