local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "XenaUltimate" then
        v:Destroy()
    end
end

local colors = {
    primary = Color3.fromRGB(255, 140, 0),
    bg = Color3.fromRGB(15, 15, 15),
    card = Color3.fromRGB(25, 25, 25),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(150, 150, 150),
    success = Color3.fromRGB(0, 255, 0),
    danger = Color3.fromRGB(255, 0, 0)
}

local features = {
    aimbot = {enabled = false, key = nil, teamCheck = true, wallCheck = true, mode = "camera"},
    triggerbot = {enabled = false, key = nil, teamCheck = true, wallCheck = true, delay = 0.1, range = 100},
    esp = {enabled = false, key = nil, teamCheck = true},
    nametags = {enabled = false, key = nil},
    fly = {enabled = false, key = nil, speed = 5},
    speed = {enabled = false, key = nil, multiplier = 5},
    jumpBoost = {enabled = false, key = nil, multiplier = 5},
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
    mode = "mouse", -- "mouse" veya "key"
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
screenGui.Name = "XenaUltimate"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.Enabled = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = colors.bg
mainFrame.BorderColor3 = colors.primary
mainFrame.BorderSizePixel = 3
mainFrame.Position = UDim2.new(0.5, -400, 0.5, -350)
mainFrame.Size = UDim2.new(0, 800, 0, 700)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ZIndex = 10

local titleBar = Instance.new("Frame")
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = colors.primary
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.ZIndex = 11

local title = Instance.new("TextLabel")
title.Parent = titleBar
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 450, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "XENA ULTIMATE | Developer: Yetri"
title.TextColor3 = colors.bg
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12

local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleBar
closeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 10)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Text = "X"
closeBtn.TextColor3 = colors.text
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 12
closeBtn.MouseButton1Click:Connect(function() screenGui.Enabled = false end)

local tabFrame = Instance.new("Frame")
tabFrame.Parent = mainFrame
tabFrame.BackgroundColor3 = colors.card
tabFrame.Position = UDim2.new(0, 10, 0, 60)
tabFrame.Size = UDim2.new(1, -20, 0, 50)
tabFrame.ZIndex = 11

local combatTab = Instance.new("TextButton")
combatTab.Parent = tabFrame
combatTab.BackgroundColor3 = colors.primary
combatTab.Position = UDim2.new(0, 5, 0, 5)
combatTab.Size = UDim2.new(0, 120, 0, 40)
combatTab.Text = "⚔️ COMBAT"
combatTab.TextColor3 = colors.bg
combatTab.Font = Enum.Font.GothamBold
combatTab.ZIndex = 12

local movementTab = Instance.new("TextButton")
movementTab.Parent = tabFrame
movementTab.BackgroundColor3 = colors.card
movementTab.Position = UDim2.new(0, 135, 0, 5)
movementTab.Size = UDim2.new(0, 120, 0, 40)
movementTab.Text = "🏃 MOVEMENT"
movementTab.TextColor3 = colors.text
movementTab.Font = Enum.Font.GothamBold
movementTab.ZIndex = 12

local visualTab = Instance.new("TextButton")
visualTab.Parent = tabFrame
visualTab.BackgroundColor3 = colors.card
visualTab.Position = UDim2.new(0, 265, 0, 5)
visualTab.Size = UDim2.new(0, 120, 0, 40)
visualTab.Text = "👁️ VISUAL"
visualTab.TextColor3 = colors.text
visualTab.Font = Enum.Font.GothamBold
visualTab.ZIndex = 12

local utilityTab = Instance.new("TextButton")
utilityTab.Parent = tabFrame
utilityTab.BackgroundColor3 = colors.card
utilityTab.Position = UDim2.new(0, 395, 0, 5)
utilityTab.Size = UDim2.new(0, 120, 0, 40)
utilityTab.Text = "🔧 UTILITY"
utilityTab.TextColor3 = colors.text
utilityTab.Font = Enum.Font.GothamBold
utilityTab.ZIndex = 12

local trollTab = Instance.new("TextButton")
trollTab.Parent = tabFrame
trollTab.BackgroundColor3 = colors.card
trollTab.Position = UDim2.new(0, 525, 0, 5)
trollTab.Size = UDim2.new(0, 120, 0, 40)
trollTab.Text = "🤡 TROLL"
trollTab.TextColor3 = colors.text
trollTab.Font = Enum.Font.GothamBold
trollTab.ZIndex = 12

local contentFrame = Instance.new("Frame")
contentFrame.Parent = mainFrame
contentFrame.BackgroundColor3 = colors.card
contentFrame.Position = UDim2.new(0, 10, 0, 120)
contentFrame.Size = UDim2.new(1, -20, 1, -130)
contentFrame.ZIndex = 11

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = contentFrame
scrollFrame.BackgroundTransparency = 1
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = colors.primary
scrollFrame.ZIndex = 12

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function getKeyName(key)
    if not key then return "─" end
    local names = {
        [Enum.KeyCode.One] = "1", [Enum.KeyCode.Two] = "2", [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4", [Enum.KeyCode.Five] = "5", [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7", [Enum.KeyCode.Eight] = "8", [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0", [Enum.KeyCode.Q] = "Q", [Enum.KeyCode.W] = "W",
        [Enum.KeyCode.E] = "E", [Enum.KeyCode.R] = "R", [Enum.KeyCode.T] = "T",
        [Enum.KeyCode.Y] = "Y", [Enum.KeyCode.U] = "U", [Enum.KeyCode.I] = "I",
        [Enum.KeyCode.O] = "O", [Enum.KeyCode.P] = "P", [Enum.KeyCode.A] = "A",
        [Enum.KeyCode.S] = "S", [Enum.KeyCode.D] = "D", [Enum.KeyCode.F] = "F",
        [Enum.KeyCode.G] = "G", [Enum.KeyCode.H] = "H", [Enum.KeyCode.J] = "J",
        [Enum.KeyCode.K] = "K", [Enum.KeyCode.L] = "L", [Enum.KeyCode.Z] = "Z",
        [Enum.KeyCode.X] = "X", [Enum.KeyCode.C] = "C", [Enum.KeyCode.V] = "V",
        [Enum.KeyCode.B] = "B", [Enum.KeyCode.N] = "N", [Enum.KeyCode.M] = "M",
        [Enum.KeyCode.LeftShift] = "LShift", [Enum.KeyCode.RightShift] = "RShift",
        [Enum.KeyCode.LeftControl] = "LCtrl", [Enum.KeyCode.RightControl] = "RCtrl",
        [Enum.KeyCode.LeftAlt] = "LAlt", [Enum.KeyCode.RightAlt] = "RAlt",
        [Enum.KeyCode.Space] = "Space", [Enum.KeyCode.Return] = "Enter",
        [Enum.KeyCode.Backspace] = "Backspace", [Enum.KeyCode.Tab] = "Tab",
        [Enum.KeyCode.F1] = "F1", [Enum.KeyCode.F2] = "F2", [Enum.KeyCode.F3] = "F3",
        [Enum.KeyCode.F4] = "F4", [Enum.KeyCode.F5] = "F5", [Enum.KeyCode.F6] = "F6",
        [Enum.KeyCode.F7] = "F7", [Enum.KeyCode.F8] = "F8", [Enum.KeyCode.F9] = "F9",
        [Enum.KeyCode.F10] = "F10", [Enum.KeyCode.F11] = "F11", [Enum.KeyCode.F12] = "F12",
        [Enum.KeyCode.Insert] = "Ins", [Enum.KeyCode.Home] = "Home", [Enum.KeyCode.PageUp] = "PgUp",
        [Enum.KeyCode.Delete] = "Del", [Enum.KeyCode.End] = "End", [Enum.KeyCode.PageDown] = "PgDn",
        [Enum.KeyCode.Up] = "↑", [Enum.KeyCode.Down] = "↓", [Enum.KeyCode.Left] = "←", [Enum.KeyCode.Right] = "→"
    }
    return names[key] or key.Name:gsub("KeyCode.", "")
end

local function createClickTeleportButton()
    local btn = Instance.new("TextButton")
    btn.Name = "clickTeleport_UTILITY"
    btn.Parent = scrollFrame
    btn.BackgroundColor3 = colors.bg
    btn.BorderColor3 = colors.primary
    btn.Size = UDim2.new(1, -10, 0, 80)
    btn.Text = ""
    btn.ZIndex = 13
    btn.Visible = false
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = btn
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 10, 0, 15)
    iconLabel.Size = UDim2.new(0, 50, 0, 50)
    iconLabel.Text = "👆"
    iconLabel.TextColor3 = colors.primary
    iconLabel.TextSize = 30
    iconLabel.ZIndex = 14
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 70, 0, 15)
    nameLabel.Size = UDim2.new(1, -200, 0, 25)
    nameLabel.Text = "CLICK TELEPORT"
    nameLabel.TextColor3 = colors.text
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = btn
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 70, 0, 40)
    descLabel.Size = UDim2.new(1, -200, 0, 25)
    descLabel.Text = clickTeleport.mode == "mouse" and "Sol tıkla ışınlan" or "Tuşla ışınlan"
    descLabel.TextColor3 = colors.textDim
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 14
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Parent = btn
    keyLabel.BackgroundColor3 = colors.card
    keyLabel.BorderColor3 = colors.primary
    keyLabel.Position = UDim2.new(1, -140, 0, 15)
    keyLabel.Size = UDim2.new(0, 50, 0, 25)
    keyLabel.Text = clickTeleport.mode == "mouse" and "SOL" or (clickTeleport.key and getKeyName(clickTeleport.key) or "─")
    keyLabel.TextColor3 = colors.primary
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.ZIndex = 14
    
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = btn
    status.BackgroundColor3 = clickTeleport.enabled and colors.success or colors.danger
    status.Position = UDim2.new(1, -80, 0, 15)
    status.Size = UDim2.new(0, 70, 0, 25)
    status.Text = clickTeleport.enabled and "AKTİF" or "PASİF"
    status.TextColor3 = colors.text
    status.Font = Enum.Font.GothamBold
    status.ZIndex = 14
    
    btn.MouseButton1Click:Connect(function()
        clickTeleport.enabled = not clickTeleport.enabled
        status.BackgroundColor3 = clickTeleport.enabled and colors.success or colors.danger
        status.Text = clickTeleport.enabled and "AKTİF" or "PASİF"
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
        
        local header = Instance.new("Frame")
        header.Parent = menu
        header.BackgroundColor3 = colors.primary
        header.Size = UDim2.new(1, 0, 0, 30)
        
        local headerTitle = Instance.new("TextLabel")
        headerTitle.Parent = header
        headerTitle.BackgroundTransparency = 1
        headerTitle.Position = UDim2.new(0, 10, 0, 0)
        headerTitle.Size = UDim2.new(1, -50, 1, 0)
        headerTitle.Text = "CLICK TELEPORT AYARLARI"
        headerTitle.TextColor3 = colors.bg
        headerTitle.Font = Enum.Font.GothamBold
        headerTitle.TextSize = 12
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local closeHeader = Instance.new("TextButton")
        closeHeader.Parent = header
        closeHeader.BackgroundColor3 = colors.danger
        closeHeader.Position = UDim2.new(1, -30, 0, 0)
        closeHeader.Size = UDim2.new(0, 30, 0, 30)
        closeHeader.Text = "X"
        closeHeader.TextColor3 = colors.text
        closeHeader.Font = Enum.Font.GothamBold
        closeHeader.MouseButton1Click:Connect(function() menu:Destroy() _G.teleportSettings = nil end)
        
        local yPos = 40
        
        local modeFrame = Instance.new("Frame")
        modeFrame.Parent = menu
        modeFrame.BackgroundColor3 = colors.card
        modeFrame.BorderColor3 = colors.primary
        modeFrame.Position = UDim2.new(0, 10, 0, yPos)
        modeFrame.Size = UDim2.new(1, -20, 0, 60)
        
        local modeTitle = Instance.new("TextLabel")
        modeTitle.Parent = modeFrame
        modeTitle.BackgroundTransparency = 1
        modeTitle.Position = UDim2.new(0, 10, 0, 5)
        modeTitle.Size = UDim2.new(1, -130, 0, 20)
        modeTitle.Text = "MOD"
        modeTitle.TextColor3 = colors.primary
        modeTitle.TextSize = 14
        modeTitle.Font = Enum.Font.GothamBold
        modeTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local mouseBtn = Instance.new("TextButton")
        mouseBtn.Parent = modeFrame
        mouseBtn.BackgroundColor3 = clickTeleport.mode == "mouse" and colors.success or colors.card
        mouseBtn.Position = UDim2.new(1, -180, 0, 15)
        mouseBtn.Size = UDim2.new(0, 50, 0, 30)
        mouseBtn.Text = "SOL"
        mouseBtn.TextColor3 = colors.text
        mouseBtn.Font = Enum.Font.GothamBold
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Parent = modeFrame
        keyBtn.BackgroundColor3 = clickTeleport.mode == "key" and colors.success or colors.card
        keyBtn.Position = UDim2.new(1, -120, 0, 15)
        keyBtn.Size = UDim2.new(0, 50, 0, 30)
        keyBtn.Text = "TUŞ"
        keyBtn.TextColor3 = colors.text
        keyBtn.Font = Enum.Font.GothamBold
        
        mouseBtn.MouseButton1Click:Connect(function()
            clickTeleport.mode = "mouse"
            mouseBtn.BackgroundColor3 = colors.success
            keyBtn.BackgroundColor3 = colors.card
            descLabel.Text = "Sol tıkla ışınlan"
            keyLabel.Text = "SOL"
        end)
        
        keyBtn.MouseButton1Click:Connect(function()
            clickTeleport.mode = "key"
            mouseBtn.BackgroundColor3 = colors.card
            keyBtn.BackgroundColor3 = colors.success
            descLabel.Text = "Tuşla ışınlan"
        end)
        
        yPos = yPos + 70
        
        local keyFrame = Instance.new("Frame")
        keyFrame.Parent = menu
        keyFrame.BackgroundColor3 = colors.card
        keyFrame.BorderColor3 = colors.primary
        keyFrame.Position = UDim2.new(0, 10, 0, yPos)
        keyFrame.Size = UDim2.new(1, -20, 0, 60)
        keyFrame.Visible = clickTeleport.mode == "key"
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Parent = keyFrame
        keyTitle.BackgroundTransparency = 1
        keyTitle.Position = UDim2.new(0, 10, 0, 5)
        keyTitle.Size = UDim2.new(1, -130, 0, 20)
        keyTitle.Text = "TUŞ"
        keyTitle.TextColor3 = colors.primary
        keyTitle.TextSize = 14
        keyTitle.Font = Enum.Font.GothamBold
        keyTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local keySetBtn = Instance.new("TextButton")
        keySetBtn.Parent = keyFrame
        keySetBtn.BackgroundColor3 = colors.primary
        keySetBtn.Position = UDim2.new(1, -90, 0, 15)
        keySetBtn.Size = UDim2.new(0, 70, 0, 30)
        keySetBtn.Text = clickTeleport.key and getKeyName(clickTeleport.key) or "ATA"
        keySetBtn.TextColor3 = colors.bg
        keySetBtn.Font = Enum.Font.GothamBold
        
        local clearBtn = Instance.new("TextButton")
        clearBtn.Parent = keyFrame
        clearBtn.BackgroundColor3 = colors.danger
        clearBtn.Position = UDim2.new(1, -160, 0, 15)
        clearBtn.Size = UDim2.new(0, 30, 0, 30)
        clearBtn.Text = "X"
        clearBtn.TextColor3 = colors.text
        clearBtn.Font = Enum.Font.GothamBold
        clearBtn.MouseButton1Click:Connect(function()
            clickTeleport.key = nil
            keySetBtn.Text = "ATA"
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
                    keySetBtn.Text = clickTeleport.key and getKeyName(clickTeleport.key) or "ATA"
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
    btn.Size = UDim2.new(1, -10, 0, 80)
    btn.Text = ""
    btn.ZIndex = 13
    btn.Visible = false
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = btn
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 10, 0, 15)
    iconLabel.Size = UDim2.new(0, 50, 0, 50)
    iconLabel.Text = "🔑"
    iconLabel.TextColor3 = colors.primary
    iconLabel.TextSize = 30
    iconLabel.ZIndex = 14
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 70, 0, 15)
    nameLabel.Size = UDim2.new(1, -200, 0, 25)
    nameLabel.Text = "GUI TUŞU"
    nameLabel.TextColor3 = colors.text
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = btn
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 70, 0, 40)
    descLabel.Size = UDim2.new(1, -200, 0, 25)
    descLabel.Text = "Paneli aç/kapat tuşu"
    descLabel.TextColor3 = colors.textDim
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 14
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Parent = btn
    keyLabel.BackgroundColor3 = colors.card
    keyLabel.BorderColor3 = colors.primary
    keyLabel.Position = UDim2.new(1, -140, 0, 15)
    keyLabel.Size = UDim2.new(0, 50, 0, 25)
    keyLabel.Text = getKeyName(guiKey)
    keyLabel.TextColor3 = colors.primary
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.ZIndex = 14
    
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
        
        local header = Instance.new("Frame")
        header.Parent = menu
        header.BackgroundColor3 = colors.primary
        header.Size = UDim2.new(1, 0, 0, 30)
        
        local headerTitle = Instance.new("TextLabel")
        headerTitle.Parent = header
        headerTitle.BackgroundTransparency = 1
        headerTitle.Position = UDim2.new(0, 10, 0, 0)
        headerTitle.Size = UDim2.new(1, -50, 1, 0)
        headerTitle.Text = "GUI TUŞU AYARI"
        headerTitle.TextColor3 = colors.bg
        headerTitle.Font = Enum.Font.GothamBold
        headerTitle.TextSize = 12
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local closeHeader = Instance.new("TextButton")
        closeHeader.Parent = header
        closeHeader.BackgroundColor3 = colors.danger
        closeHeader.Position = UDim2.new(1, -30, 0, 0)
        closeHeader.Size = UDim2.new(0, 30, 0, 30)
        closeHeader.Text = "X"
        closeHeader.TextColor3 = colors.text
        closeHeader.Font = Enum.Font.GothamBold
        closeHeader.MouseButton1Click:Connect(function() menu:Destroy() _G.guiKeySettings = nil end)
        
        local keyFrame = Instance.new("Frame")
        keyFrame.Parent = menu
        keyFrame.BackgroundColor3 = colors.card
        keyFrame.BorderColor3 = colors.primary
        keyFrame.Position = UDim2.new(0, 10, 0, 40)
        keyFrame.Size = UDim2.new(1, -20, 0, 60)
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Parent = keyFrame
        keyTitle.BackgroundTransparency = 1
        keyTitle.Position = UDim2.new(0, 10, 0, 5)
        keyTitle.Size = UDim2.new(1, -130, 0, 20)
        keyTitle.Text = "TUŞ"
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
        
        local clearBtn = Instance.new("TextButton")
        clearBtn.Parent = keyFrame
        clearBtn.BackgroundColor3 = colors.danger
        clearBtn.Position = UDim2.new(1, -160, 0, 15)
        clearBtn.Size = UDim2.new(0, 30, 0, 30)
        clearBtn.Text = "X"
        clearBtn.TextColor3 = colors.text
        clearBtn.Font = Enum.Font.GothamBold
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

local function createButton(id, name, icon, category)
    local btn = Instance.new("TextButton")
    btn.Name = id .. "_" .. category
    btn.Parent = scrollFrame
    btn.BackgroundColor3 = colors.bg
    btn.BorderColor3 = colors.primary
    btn.Size = UDim2.new(1, -10, 0, 80)
    btn.Text = ""
    btn.ZIndex = 13
    
    buttonRefs[id] = btn
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = btn
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 10, 0, 15)
    iconLabel.Size = UDim2.new(0, 50, 0, 50)
    iconLabel.Text = icon
    iconLabel.TextColor3 = colors.primary
    iconLabel.TextSize = 30
    iconLabel.ZIndex = 14
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 70, 0, 15)
    nameLabel.Size = UDim2.new(1, -200, 0, 25)
    nameLabel.Text = name
    nameLabel.TextColor3 = colors.text
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = btn
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 70, 0, 40)
    descLabel.Size = UDim2.new(1, -200, 0, 25)
    descLabel.Text = id == "aimbot" and "Otomatik nişan" or id == "triggerbot" and "Otomatik ateş" or id == "esp" and "Oyuncu işaretle" or id == "nametags" and "İsim gösterme" or id == "fly" and "Uçma" or id == "speed" and "Hız" or id == "jumpBoost" and "Zıplama" or id == "noclip" and "Duvardan geçme" or id == "multiJump" and "Çoklu zıplama" or id == "teleport" and "Işınlanma" or ""
    descLabel.TextColor3 = colors.textDim
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 14
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Parent = btn
    keyLabel.BackgroundColor3 = colors.card
    keyLabel.BorderColor3 = colors.primary
    keyLabel.Position = UDim2.new(1, -140, 0, 15)
    keyLabel.Size = UDim2.new(0, 50, 0, 25)
    keyLabel.Text = features[id].key and getKeyName(features[id].key) or "─"
    keyLabel.TextColor3 = colors.primary
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.ZIndex = 14
    
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = btn
    status.BackgroundColor3 = features[id].enabled and colors.success or colors.danger
    status.Position = UDim2.new(1, -80, 0, 15)
    status.Size = UDim2.new(0, 70, 0, 25)
    status.Text = features[id].enabled and "AKTİF" or "PASİF"
    status.TextColor3 = colors.text
    status.Font = Enum.Font.GothamBold
    status.ZIndex = 14
    
    btn.MouseButton1Click:Connect(function()
        features[id].enabled = not features[id].enabled
        status.BackgroundColor3 = features[id].enabled and colors.success or colors.danger
        status.Text = features[id].enabled and "AKTİF" or "PASİF"
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
        menu.Size = UDim2.new(0, 280, 0, 320)
        menu.ZIndex = 200
        menu.Active = true
        menu.Draggable = true
        _G.settingsMenu = menu
        
        local header = Instance.new("Frame")
        header.Parent = menu
        header.BackgroundColor3 = colors.primary
        header.Size = UDim2.new(1, 0, 0, 30)
        
        local headerTitle = Instance.new("TextLabel")
        headerTitle.Parent = header
        headerTitle.BackgroundTransparency = 1
        headerTitle.Position = UDim2.new(0, 10, 0, 0)
        headerTitle.Size = UDim2.new(1, -50, 1, 0)
        headerTitle.Text = name .. " AYARLARI"
        headerTitle.TextColor3 = colors.bg
        headerTitle.Font = Enum.Font.GothamBold
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local closeHeader = Instance.new("TextButton")
        closeHeader.Parent = header
        closeHeader.BackgroundColor3 = colors.danger
        closeHeader.Position = UDim2.new(1, -30, 0, 0)
        closeHeader.Size = UDim2.new(0, 30, 0, 30)
        closeHeader.Text = "X"
        closeHeader.TextColor3 = colors.text
        closeHeader.Font = Enum.Font.GothamBold
        closeHeader.MouseButton1Click:Connect(function() menu:Destroy() _G.settingsMenu = nil end)
        
        local yPos = 40
        local keyFrame = Instance.new("Frame")
        keyFrame.Parent = menu
        keyFrame.BackgroundColor3 = colors.card
        keyFrame.BorderColor3 = colors.primary
        keyFrame.Position = UDim2.new(0, 10, 0, yPos)
        keyFrame.Size = UDim2.new(1, -20, 0, 60)
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Parent = keyFrame
        keyTitle.BackgroundTransparency = 1
        keyTitle.Position = UDim2.new(0, 10, 0, 5)
        keyTitle.Size = UDim2.new(1, -130, 0, 20)
        keyTitle.Text = "TUŞ"
        keyTitle.TextColor3 = colors.primary
        keyTitle.TextSize = 14
        keyTitle.Font = Enum.Font.GothamBold
        keyTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Parent = keyFrame
        keyBtn.BackgroundColor3 = colors.primary
        keyBtn.Position = UDim2.new(1, -90, 0, 15)
        keyBtn.Size = UDim2.new(0, 70, 0, 30)
        keyBtn.Text = features[id].key and getKeyName(features[id].key) or "ATA"
        keyBtn.TextColor3 = colors.bg
        keyBtn.Font = Enum.Font.GothamBold
        
        local clearBtn = Instance.new("TextButton")
        clearBtn.Parent = keyFrame
        clearBtn.BackgroundColor3 = colors.danger
        clearBtn.Position = UDim2.new(1, -160, 0, 15)
        clearBtn.Size = UDim2.new(0, 30, 0, 30)
        clearBtn.Text = "X"
        clearBtn.TextColor3 = colors.text
        clearBtn.Font = Enum.Font.GothamBold
        clearBtn.MouseButton1Click:Connect(function()
            features[id].key = nil
            keyBtn.Text = "ATA"
            keyLabel.Text = "─"
        end)
        
        keyBtn.MouseButton1Click:Connect(function()
            keyBtn.Text = "..."
            local con
            con = UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Escape then
                    con:Disconnect()
                    keyBtn.Text = features[id].key and getKeyName(features[id].key) or "ATA"
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
            local teamFrame = Instance.new("Frame")
            teamFrame.Parent = menu
            teamFrame.BackgroundColor3 = colors.card
            teamFrame.BorderColor3 = colors.primary
            teamFrame.Position = UDim2.new(0, 10, 0, yPos)
            teamFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local teamTitle = Instance.new("TextLabel")
            teamTitle.Parent = teamFrame
            teamTitle.BackgroundTransparency = 1
            teamTitle.Position = UDim2.new(0, 10, 0, 5)
            teamTitle.Size = UDim2.new(1, -130, 0, 20)
            teamTitle.Text = "TAKIM KONTROLÜ"
            teamTitle.TextColor3 = colors.primary
            teamTitle.TextSize = 14
            teamTitle.Font = Enum.Font.GothamBold
            teamTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local teamBtn = Instance.new("TextButton")
            teamBtn.Parent = teamFrame
            teamBtn.BackgroundColor3 = features.aimbot.teamCheck and colors.success or colors.danger
            teamBtn.Position = UDim2.new(1, -90, 0, 15)
            teamBtn.Size = UDim2.new(0, 70, 0, 30)
            teamBtn.Text = features.aimbot.teamCheck and "AKTİF" or "PASİF"
            teamBtn.TextColor3 = colors.text
            teamBtn.Font = Enum.Font.GothamBold
            teamBtn.MouseButton1Click:Connect(function()
                features.aimbot.teamCheck = not features.aimbot.teamCheck
                teamBtn.BackgroundColor3 = features.aimbot.teamCheck and colors.success or colors.danger
                teamBtn.Text = features.aimbot.teamCheck and "AKTİF" or "PASİF"
            end)
            
            yPos = yPos + 70
            
            local wallFrame = Instance.new("Frame")
            wallFrame.Parent = menu
            wallFrame.BackgroundColor3 = colors.card
            wallFrame.BorderColor3 = colors.primary
            wallFrame.Position = UDim2.new(0, 10, 0, yPos)
            wallFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local wallTitle = Instance.new("TextLabel")
            wallTitle.Parent = wallFrame
            wallTitle.BackgroundTransparency = 1
            wallTitle.Position = UDim2.new(0, 10, 0, 5)
            wallTitle.Size = UDim2.new(1, -130, 0, 20)
            wallTitle.Text = "DUVAR KONTROLÜ"
            wallTitle.TextColor3 = colors.primary
            wallTitle.TextSize = 14
            wallTitle.Font = Enum.Font.GothamBold
            wallTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local wallBtn = Instance.new("TextButton")
            wallBtn.Parent = wallFrame
            wallBtn.BackgroundColor3 = features.aimbot.wallCheck and colors.success or colors.danger
            wallBtn.Position = UDim2.new(1, -90, 0, 15)
            wallBtn.Size = UDim2.new(0, 70, 0, 30)
            wallBtn.Text = features.aimbot.wallCheck and "AKTİF" or "PASİF"
            wallBtn.TextColor3 = colors.text
            wallBtn.Font = Enum.Font.GothamBold
            wallBtn.MouseButton1Click:Connect(function()
                features.aimbot.wallCheck = not features.aimbot.wallCheck
                wallBtn.BackgroundColor3 = features.aimbot.wallCheck and colors.success or colors.danger
                wallBtn.Text = features.aimbot.wallCheck and "AKTİF" or "PASİF"
            end)
            
            yPos = yPos + 70
            
            local modeFrame = Instance.new("Frame")
            modeFrame.Parent = menu
            modeFrame.BackgroundColor3 = colors.card
            modeFrame.BorderColor3 = colors.primary
            modeFrame.Position = UDim2.new(0, 10, 0, yPos)
            modeFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local modeTitle = Instance.new("TextLabel")
            modeTitle.Parent = modeFrame
            modeTitle.BackgroundTransparency = 1
            modeTitle.Position = UDim2.new(0, 10, 0, 5)
            modeTitle.Size = UDim2.new(1, -130, 0, 20)
            modeTitle.Text = "MOD"
            modeTitle.TextColor3 = colors.primary
            modeTitle.TextSize = 14
            modeTitle.Font = Enum.Font.GothamBold
            modeTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local modeBtn = Instance.new("TextButton")
            modeBtn.Parent = modeFrame
            modeBtn.BackgroundColor3 = colors.primary
            modeBtn.Position = UDim2.new(1, -90, 0, 15)
            modeBtn.Size = UDim2.new(0, 70, 0, 30)
            modeBtn.Text = features.aimbot.mode == "camera" and "KAMERA" or "FARE"
            modeBtn.TextColor3 = colors.bg
            modeBtn.Font = Enum.Font.GothamBold
            modeBtn.MouseButton1Click:Connect(function()
                features.aimbot.mode = features.aimbot.mode == "camera" and "mouse" or "camera"
                modeBtn.Text = features.aimbot.mode == "camera" and "KAMERA" or "FARE"
            end)
            
        elseif id == "triggerbot" then
            local teamFrame = Instance.new("Frame")
            teamFrame.Parent = menu
            teamFrame.BackgroundColor3 = colors.card
            teamFrame.BorderColor3 = colors.primary
            teamFrame.Position = UDim2.new(0, 10, 0, yPos)
            teamFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local teamTitle = Instance.new("TextLabel")
            teamTitle.Parent = teamFrame
            teamTitle.BackgroundTransparency = 1
            teamTitle.Position = UDim2.new(0, 10, 0, 5)
            teamTitle.Size = UDim2.new(1, -130, 0, 20)
            teamTitle.Text = "TAKIM KONTROLÜ"
            teamTitle.TextColor3 = colors.primary
            teamTitle.TextSize = 14
            teamTitle.Font = Enum.Font.GothamBold
            teamTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local teamBtn = Instance.new("TextButton")
            teamBtn.Parent = teamFrame
            teamBtn.BackgroundColor3 = features.triggerbot.teamCheck and colors.success or colors.danger
            teamBtn.Position = UDim2.new(1, -90, 0, 15)
            teamBtn.Size = UDim2.new(0, 70, 0, 30)
            teamBtn.Text = features.triggerbot.teamCheck and "AKTİF" or "PASİF"
            teamBtn.TextColor3 = colors.text
            teamBtn.Font = Enum.Font.GothamBold
            teamBtn.MouseButton1Click:Connect(function()
                features.triggerbot.teamCheck = not features.triggerbot.teamCheck
                teamBtn.BackgroundColor3 = features.triggerbot.teamCheck and colors.success or colors.danger
                teamBtn.Text = features.triggerbot.teamCheck and "AKTİF" or "PASİF"
            end)
            
            yPos = yPos + 70
            
            local wallFrame = Instance.new("Frame")
            wallFrame.Parent = menu
            wallFrame.BackgroundColor3 = colors.card
            wallFrame.BorderColor3 = colors.primary
            wallFrame.Position = UDim2.new(0, 10, 0, yPos)
            wallFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local wallTitle = Instance.new("TextLabel")
            wallTitle.Parent = wallFrame
            wallTitle.BackgroundTransparency = 1
            wallTitle.Position = UDim2.new(0, 10, 0, 5)
            wallTitle.Size = UDim2.new(1, -130, 0, 20)
            wallTitle.Text = "DUVAR KONTROLÜ"
            wallTitle.TextColor3 = colors.primary
            wallTitle.TextSize = 14
            wallTitle.Font = Enum.Font.GothamBold
            wallTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local wallBtn = Instance.new("TextButton")
            wallBtn.Parent = wallFrame
            wallBtn.BackgroundColor3 = features.triggerbot.wallCheck and colors.success or colors.danger
            wallBtn.Position = UDim2.new(1, -90, 0, 15)
            wallBtn.Size = UDim2.new(0, 70, 0, 30)
            wallBtn.Text = features.triggerbot.wallCheck and "AKTİF" or "PASİF"
            wallBtn.TextColor3 = colors.text
            wallBtn.Font = Enum.Font.GothamBold
            wallBtn.MouseButton1Click:Connect(function()
                features.triggerbot.wallCheck = not features.triggerbot.wallCheck
                wallBtn.BackgroundColor3 = features.triggerbot.wallCheck and colors.success or colors.danger
                wallBtn.Text = features.triggerbot.wallCheck and "AKTİF" or "PASİF"
            end)
            
            yPos = yPos + 70
            
            local delayFrame = Instance.new("Frame")
            delayFrame.Parent = menu
            delayFrame.BackgroundColor3 = colors.card
            delayFrame.BorderColor3 = colors.primary
            delayFrame.Position = UDim2.new(0, 10, 0, yPos)
            delayFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local delayTitle = Instance.new("TextLabel")
            delayTitle.Parent = delayFrame
            delayTitle.BackgroundTransparency = 1
            delayTitle.Position = UDim2.new(0, 10, 0, 5)
            delayTitle.Size = UDim2.new(1, -130, 0, 20)
            delayTitle.Text = "GECİKME: " .. (features.triggerbot.delay * 1000) .. "ms"
            delayTitle.TextColor3 = colors.primary
            delayTitle.TextSize = 14
            delayTitle.Font = Enum.Font.GothamBold
            delayTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local delaySliderBg = Instance.new("Frame")
            delaySliderBg.Parent = delayFrame
            delaySliderBg.BackgroundColor3 = colors.bg
            delaySliderBg.BorderColor3 = colors.primary
            delaySliderBg.Position = UDim2.new(0, 10, 0, 30)
            delaySliderBg.Size = UDim2.new(1, -120, 0, 20)
            
            local delaySlider = Instance.new("Frame")
            delaySlider.Parent = delaySliderBg
            delaySlider.BackgroundColor3 = colors.primary
            delaySlider.Size = UDim2.new(features.triggerbot.delay / 0.5, 0, 1, 0)
            
            local dragging = false
            delaySliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            delaySliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local absPos = delaySliderBg.AbsolutePosition
                    local relX = math.clamp(mousePos.X - absPos.X, 0, delaySliderBg.AbsoluteSize.X)
                    local percent = relX / delaySliderBg.AbsoluteSize.X
                    local value = percent * 0.5
                    delaySlider.Size = UDim2.new(percent, 0, 1, 0)
                    delayTitle.Text = "GECİKME: " .. math.floor(value * 1000) .. "ms"
                    features.triggerbot.delay = value
                end
            end)
            
            yPos = yPos + 70
            
            local rangeFrame = Instance.new("Frame")
            rangeFrame.Parent = menu
            rangeFrame.BackgroundColor3 = colors.card
            rangeFrame.BorderColor3 = colors.primary
            rangeFrame.Position = UDim2.new(0, 10, 0, yPos)
            rangeFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local rangeTitle = Instance.new("TextLabel")
            rangeTitle.Parent = rangeFrame
            rangeTitle.BackgroundTransparency = 1
            rangeTitle.Position = UDim2.new(0, 10, 0, 5)
            rangeTitle.Size = UDim2.new(1, -130, 0, 20)
            rangeTitle.Text = "MESAFE: " .. features.triggerbot.range
            rangeTitle.TextColor3 = colors.primary
            rangeTitle.TextSize = 14
            rangeTitle.Font = Enum.Font.GothamBold
            rangeTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local rangeSliderBg = Instance.new("Frame")
            rangeSliderBg.Parent = rangeFrame
            rangeSliderBg.BackgroundColor3 = colors.bg
            rangeSliderBg.BorderColor3 = colors.primary
            rangeSliderBg.Position = UDim2.new(0, 10, 0, 30)
            rangeSliderBg.Size = UDim2.new(1, -120, 0, 20)
            
            local rangeSlider = Instance.new("Frame")
            rangeSlider.Parent = rangeSliderBg
            rangeSlider.BackgroundColor3 = colors.primary
            rangeSlider.Size = UDim2.new(features.triggerbot.range / 200, 0, 1, 0)
            
            local rangeDragging = false
            rangeSliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then rangeDragging = true end
            end)
            rangeSliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then rangeDragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if rangeDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local absPos = rangeSliderBg.AbsolutePosition
                    local relX = math.clamp(mousePos.X - absPos.X, 0, rangeSliderBg.AbsoluteSize.X)
                    local percent = relX / rangeSliderBg.AbsoluteSize.X
                    local value = math.floor(percent * 200)
                    rangeSlider.Size = UDim2.new(percent, 0, 1, 0)
                    rangeTitle.Text = "MESAFE: " .. value
                    features.triggerbot.range = value
                end
            end)
            
        elseif id == "esp" then
            local teamFrame = Instance.new("Frame")
            teamFrame.Parent = menu
            teamFrame.BackgroundColor3 = colors.card
            teamFrame.BorderColor3 = colors.primary
            teamFrame.Position = UDim2.new(0, 10, 0, yPos)
            teamFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local teamTitle = Instance.new("TextLabel")
            teamTitle.Parent = teamFrame
            teamTitle.BackgroundTransparency = 1
            teamTitle.Position = UDim2.new(0, 10, 0, 5)
            teamTitle.Size = UDim2.new(1, -130, 0, 20)
            teamTitle.Text = "TAKIM KONTROLÜ"
            teamTitle.TextColor3 = colors.primary
            teamTitle.TextSize = 14
            teamTitle.Font = Enum.Font.GothamBold
            teamTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local teamBtn = Instance.new("TextButton")
            teamBtn.Parent = teamFrame
            teamBtn.BackgroundColor3 = features.esp.teamCheck and colors.success or colors.danger
            teamBtn.Position = UDim2.new(1, -90, 0, 15)
            teamBtn.Size = UDim2.new(0, 70, 0, 30)
            teamBtn.Text = features.esp.teamCheck and "AKTİF" or "PASİF"
            teamBtn.TextColor3 = colors.text
            teamBtn.Font = Enum.Font.GothamBold
            teamBtn.MouseButton1Click:Connect(function()
                features.esp.teamCheck = not features.esp.teamCheck
                teamBtn.BackgroundColor3 = features.esp.teamCheck and colors.success or colors.danger
                teamBtn.Text = features.esp.teamCheck and "AKTİF" or "PASİF"
            end)
            
        elseif id == "fly" or id == "speed" or id == "jumpBoost" then
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = menu
            sliderFrame.BackgroundColor3 = colors.card
            sliderFrame.BorderColor3 = colors.primary
            sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
            sliderFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local currentVal = (id == "fly" and features.fly.speed) or (id == "speed" and features.speed.multiplier) or (id == "jumpBoost" and features.jumpBoost.multiplier) or 5
            
            local sliderTitle = Instance.new("TextLabel")
            sliderTitle.Parent = sliderFrame
            sliderTitle.BackgroundTransparency = 1
            sliderTitle.Position = UDim2.new(0, 10, 0, 5)
            sliderTitle.Size = UDim2.new(1, -130, 0, 20)
            sliderTitle.Text = "HIZ: " .. currentVal .. "x"
            sliderTitle.TextColor3 = colors.primary
            sliderTitle.TextSize = 14
            sliderTitle.Font = Enum.Font.GothamBold
            sliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Parent = sliderFrame
            sliderBg.BackgroundColor3 = colors.bg
            sliderBg.BorderColor3 = colors.primary
            sliderBg.Position = UDim2.new(0, 10, 0, 30)
            sliderBg.Size = UDim2.new(1, -120, 0, 20)
            
            local slider = Instance.new("Frame")
            slider.Parent = sliderBg
            slider.BackgroundColor3 = colors.primary
            slider.Size = UDim2.new(currentVal / 10, 0, 1, 0)
            
            local dragging = false
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
            end)
            sliderBg.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local absPos = sliderBg.AbsolutePosition
                    local relX = math.clamp(mousePos.X - absPos.X, 0, sliderBg.AbsoluteSize.X)
                    local percent = relX / sliderBg.AbsoluteSize.X
                    local value = math.floor(percent * 90 + 10) / 10
                    slider.Size = UDim2.new(percent, 0, 1, 0)
                    sliderTitle.Text = "HIZ: " .. value .. "x"
                    if id == "fly" then features.fly.speed = value
                    elseif id == "speed" then features.speed.multiplier = value
                    elseif id == "jumpBoost" then features.jumpBoost.multiplier = value end
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
    btn.Size = UDim2.new(1, -10, 0, 80)
    btn.Text = ""
    btn.ZIndex = 13
    btn.Visible = false
    
    trollButtonRefs[id] = btn
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = btn
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 10, 0, 15)
    iconLabel.Size = UDim2.new(0, 50, 0, 50)
    iconLabel.Text = icon
    iconLabel.TextColor3 = colors.primary
    iconLabel.TextSize = 30
    iconLabel.ZIndex = 14
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 70, 0, 15)
    nameLabel.Size = UDim2.new(1, -200, 0, 25)
    nameLabel.Text = name
    nameLabel.TextColor3 = colors.text
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = btn
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 70, 0, 40)
    descLabel.Size = UDim2.new(1, -200, 0, 25)
    descLabel.Text = id == "fling" and "Kendini fırlat" or id == "spin" and "Dönme" or id == "sizeChanger" and "Boyut değiştir" or id == "headless" and "Kafasız" or id == "freeze" and "Dondur" or ""
    descLabel.TextColor3 = colors.textDim
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 14
    
    local keyLabel = Instance.new("TextLabel")
    keyLabel.Parent = btn
    keyLabel.BackgroundColor3 = colors.card
    keyLabel.BorderColor3 = colors.primary
    keyLabel.Position = UDim2.new(1, -140, 0, 15)
    keyLabel.Size = UDim2.new(0, 50, 0, 25)
    keyLabel.Text = troll[id].key and getKeyName(troll[id].key) or "─"
    keyLabel.TextColor3 = colors.primary
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.ZIndex = 14
    
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = btn
    status.BackgroundColor3 = troll[id].enabled and colors.success or colors.danger
    status.Position = UDim2.new(1, -80, 0, 15)
    status.Size = UDim2.new(0, 70, 0, 25)
    status.Text = troll[id].enabled and "AKTİF" or "PASİF"
    status.TextColor3 = colors.text
    status.Font = Enum.Font.GothamBold
    status.ZIndex = 14
    
    btn.MouseButton1Click:Connect(function()
        troll[id].enabled = not troll[id].enabled
        status.BackgroundColor3 = troll[id].enabled and colors.success or colors.danger
        status.Text = troll[id].enabled and "AKTİF" or "PASİF"
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
        
        local header = Instance.new("Frame")
        header.Parent = menu
        header.BackgroundColor3 = colors.primary
        header.Size = UDim2.new(1, 0, 0, 30)
        
        local headerTitle = Instance.new("TextLabel")
        headerTitle.Parent = header
        headerTitle.BackgroundTransparency = 1
        headerTitle.Position = UDim2.new(0, 10, 0, 0)
        headerTitle.Size = UDim2.new(1, -50, 1, 0)
        headerTitle.Text = name .. " AYARLARI"
        headerTitle.TextColor3 = colors.bg
        headerTitle.Font = Enum.Font.GothamBold
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local closeHeader = Instance.new("TextButton")
        closeHeader.Parent = header
        closeHeader.BackgroundColor3 = colors.danger
        closeHeader.Position = UDim2.new(1, -30, 0, 0)
        closeHeader.Size = UDim2.new(0, 30, 0, 30)
        closeHeader.Text = "X"
        closeHeader.TextColor3 = colors.text
        closeHeader.Font = Enum.Font.GothamBold
        closeHeader.MouseButton1Click:Connect(function() menu:Destroy() _G.trollSettings = nil end)
        
        local yPos = 40
        local keyFrame = Instance.new("Frame")
        keyFrame.Parent = menu
        keyFrame.BackgroundColor3 = colors.card
        keyFrame.BorderColor3 = colors.primary
        keyFrame.Position = UDim2.new(0, 10, 0, yPos)
        keyFrame.Size = UDim2.new(1, -20, 0, 60)
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Parent = keyFrame
        keyTitle.BackgroundTransparency = 1
        keyTitle.Position = UDim2.new(0, 10, 0, 5)
        keyTitle.Size = UDim2.new(1, -130, 0, 20)
        keyTitle.Text = "TUŞ"
        keyTitle.TextColor3 = colors.primary
        keyTitle.TextSize = 14
        keyTitle.Font = Enum.Font.GothamBold
        keyTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Parent = keyFrame
        keyBtn.BackgroundColor3 = colors.primary
        keyBtn.Position = UDim2.new(1, -90, 0, 15)
        keyBtn.Size = UDim2.new(0, 70, 0, 30)
        keyBtn.Text = troll[id].key and getKeyName(troll[id].key) or "ATA"
        keyBtn.TextColor3 = colors.bg
        keyBtn.Font = Enum.Font.GothamBold
        
        local clearBtn = Instance.new("TextButton")
        clearBtn.Parent = keyFrame
        clearBtn.BackgroundColor3 = colors.danger
        clearBtn.Position = UDim2.new(1, -160, 0, 15)
        clearBtn.Size = UDim2.new(0, 30, 0, 30)
        clearBtn.Text = "X"
        clearBtn.TextColor3 = colors.text
        clearBtn.Font = Enum.Font.GothamBold
        clearBtn.MouseButton1Click:Connect(function()
            troll[id].key = nil
            keyBtn.Text = "ATA"
            keyLabel.Text = "─"
        end)
        
        keyBtn.MouseButton1Click:Connect(function()
            keyBtn.Text = "..."
            local con
            con = UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Escape then
                    con:Disconnect()
                    keyBtn.Text = troll[id].key and getKeyName(troll[id].key) or "ATA"
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
            speedFrame.Size = UDim2.new(1, -20, 0, 60)
            
            local speedTitle = Instance.new("TextLabel")
            speedTitle.Parent = speedFrame
            speedTitle.BackgroundTransparency = 1
            speedTitle.Position = UDim2.new(0, 10, 0, 5)
            speedTitle.Size = UDim2.new(1, -130, 0, 20)
            speedTitle.Text = "DÖNÜŞ HIZI: " .. troll.spin.speed
            speedTitle.TextColor3 = colors.primary
            speedTitle.TextSize = 14
            speedTitle.Font = Enum.Font.GothamBold
            speedTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local speedSliderBg = Instance.new("Frame")
            speedSliderBg.Parent = speedFrame
            speedSliderBg.BackgroundColor3 = colors.bg
            speedSliderBg.BorderColor3 = colors.primary
            speedSliderBg.Position = UDim2.new(0, 10, 0, 30)
            speedSliderBg.Size = UDim2.new(1, -120, 0, 20)
            
            local speedSlider = Instance.new("Frame")
            speedSlider.Parent = speedSliderBg
            speedSlider.BackgroundColor3 = colors.primary
            speedSlider.Size = UDim2.new(troll.spin.speed / 20, 0, 1, 0)
            
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
                    local value = math.floor(percent * 20)
                    speedSlider.Size = UDim2.new(percent, 0, 1, 0)
                    speedTitle.Text = "DÖNÜŞ HIZI: " .. value
                    troll.spin.speed = value
                end
            end)
            
            menu.Size = UDim2.new(0, 280, 0, yPos + 80)
        end
    end)
    
    return btn
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
    
    local header = Instance.new("Frame")
    header.Parent = tpMenu
    header.BackgroundColor3 = colors.primary
    header.Size = UDim2.new(1, 0, 0, 40)
    
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
    close.Text = "X"
    close.TextColor3 = colors.text
    close.Font = Enum.Font.GothamBold
    close.MouseButton1Click:Connect(function()
        tpMenu:Destroy()
        _G.tpMenu = nil
        features.teleport.enabled = false
        updateButtonStatus("teleport", false)
    end)
    
    local list = Instance.new("ScrollingFrame")
    list.Parent = tpMenu
    list.BackgroundColor3 = colors.card
    list.Position = UDim2.new(0, 5, 0, 45)
    list.Size = UDim2.new(1, -10, 1, -50)
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ScrollBarThickness = 6
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
            btn.MouseButton1Click:Connect(function()
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and player.Character then
                    player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                end
            end)
            y = y + 40
        end
    end
    list.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

local function createFriendListButton()
    local btn = Instance.new("TextButton")
    btn.Name = "friendList_UTILITY"
    btn.Parent = scrollFrame
    btn.BackgroundColor3 = colors.bg
    btn.BorderColor3 = colors.primary
    btn.Size = UDim2.new(1, -10, 0, 80)
    btn.Text = ""
    btn.ZIndex = 13
    btn.Visible = false
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Parent = btn
    iconLabel.BackgroundTransparency = 1
    iconLabel.Position = UDim2.new(0, 10, 0, 15)
    iconLabel.Size = UDim2.new(0, 50, 0, 50)
    iconLabel.Text = "👥"
    iconLabel.TextColor3 = colors.primary
    iconLabel.TextSize = 30
    iconLabel.ZIndex = 14
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = btn
    nameLabel.BackgroundTransparency = 1
    nameLabel.Position = UDim2.new(0, 70, 0, 15)
    nameLabel.Size = UDim2.new(1, -200, 0, 25)
    nameLabel.Text = "ARKADAŞ LİSTESİ"
    nameLabel.TextColor3 = colors.text
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.ZIndex = 14
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = btn
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 70, 0, 40)
    descLabel.Size = UDim2.new(1, -200, 0, 25)
    descLabel.Text = "Arkadaş eklenenlere kitlenmez"
    descLabel.TextColor3 = colors.textDim
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 14
    
    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Parent = btn
    status.BackgroundColor3 = manualTeam.enabled and colors.success or colors.danger
    status.Position = UDim2.new(1, -80, 0, 15)
    status.Size = UDim2.new(0, 70, 0, 25)
    status.Text = manualTeam.enabled and "AKTİF" or "PASİF"
    status.TextColor3 = colors.text
    status.Font = Enum.Font.GothamBold
    status.ZIndex = 14
    
    btn.MouseButton1Click:Connect(function()
        manualTeam.enabled = not manualTeam.enabled
        status.BackgroundColor3 = manualTeam.enabled and colors.success or colors.danger
        status.Text = manualTeam.enabled and "AKTİF" or "PASİF"
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
        
        local header = Instance.new("Frame")
        header.Parent = menu
        header.BackgroundColor3 = colors.primary
        header.Size = UDim2.new(1, 0, 0, 40)
        
        local title = Instance.new("TextLabel")
        title.Parent = header
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 10, 0, 0)
        title.Size = UDim2.new(1, -50, 1, 0)
        title.Text = "ARKADAŞ LİSTESİ"
        title.TextColor3 = colors.bg
        title.Font = Enum.Font.GothamBold
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local close = Instance.new("TextButton")
        close.Parent = header
        close.BackgroundColor3 = colors.danger
        close.Position = UDim2.new(1, -35, 0, 5)
        close.Size = UDim2.new(0, 30, 0, 30)
        close.Text = "X"
        close.TextColor3 = colors.text
        close.Font = Enum.Font.GothamBold
        close.MouseButton1Click:Connect(function() menu:Destroy() _G.friendMenu = nil end)
        
        local search = Instance.new("TextBox")
        search.Parent = menu
        search.BackgroundColor3 = colors.card
        search.BorderColor3 = colors.primary
        search.Position = UDim2.new(0, 10, 0, 50)
        search.Size = UDim2.new(1, -20, 0, 35)
        search.PlaceholderText = "Oyuncu ara..."
        search.PlaceholderColor3 = colors.textDim
        search.TextColor3 = colors.text
        search.Text = ""
        search.Font = Enum.Font.Gotham
        
        local list = Instance.new("ScrollingFrame")
        list.Parent = menu
        list.BackgroundColor3 = colors.card
        list.Position = UDim2.new(0, 10, 0, 95)
        list.Size = UDim2.new(1, -20, 1, -105)
        list.CanvasSize = UDim2.new(0, 0, 0, 0)
        list.ScrollBarThickness = 6
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
                        statusBtn.Text = manualFriends[v] and "ÇIKAR" or "EKLE"
                        statusBtn.TextColor3 = colors.text
                        statusBtn.Font = Enum.Font.GothamBold
                        
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
        friend.Text = manualFriends[closest] and "ARKADAŞLIKTAN ÇIKAR" or "ARKADAŞ EKLE"
        friend.TextColor3 = colors.text
        friend.Font = Enum.Font.GothamBold
        
        friend.MouseButton1Click:Connect(function()
            if manualFriends[closest] then
                manualFriends[closest] = nil
            else
                manualFriends[closest] = true
            end
            menu:Destroy()
        end)
        
        spawn(function() wait(5) if menu then menu:Destroy() end end)
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
createTrollButton("sizeChanger", "SIZE CHANGER", "📏")
createTrollButton("headless", "HEADLESS", "👻")
createTrollButton("freeze", "FREEZE", "❄️")

local friendBtn = createFriendListButton()
local clickTpBtn = createClickTeleportButton()
local guiKeyBtn = createGuiKeyButton()

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #scrollFrame:GetChildren() * 90)

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
    for _, btn in pairs(scrollFrame:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Visible = string.find(btn.Name, "TROLL") ~= nil
        end
    end
    friendBtn.Visible = false
    clickTpBtn.Visible = false
    guiKeyBtn.Visible = false
end)

local function updateButtonStatus(id, enabled)
    if buttonRefs[id] then
        for _, label in pairs(buttonRefs[id]:GetChildren()) do
            if label.Name == "Status" then
                label.BackgroundColor3 = enabled and colors.success or colors.danger
                label.Text = enabled and "AKTİF" or "PASİF"
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
                label.Text = enabled and "AKTİF" or "PASİF"
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
                        player.Character.Humanoid.WalkSpeed = feature.enabled and 0 or (features.speed.enabled and 16 * features.speed.multiplier or 16)
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
    if clickTeleport.enabled and clickTeleport.mode == "mouse" and screenGui.Enabled then
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
                wait(1)
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
                local highlight = v.Character.XenaESP
                
                if manualTeam.enabled and manualFriends[v] then
                    highlight.FillColor = colors.success
                elseif not manualTeam.enabled and features.esp.teamCheck then
                    if (player.Team and v.Team and player.Team == v.Team) or (player.TeamColor and v.TeamColor and player.TeamColor == v.TeamColor) then
                        highlight.FillColor = colors.success
                    else
                        highlight.FillColor = colors.danger
                    end
                else
                    highlight.FillColor = colors.danger
                end
                highlight.FillTransparency = 0.3
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
                if not manualTeam.enabled and features.aimbot.teamCheck then
                    if (player.Team and v.Team and player.Team == v.Team) or (player.TeamColor and v.TeamColor and player.TeamColor == v.TeamColor) then
                        continue
                    end
                end
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
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closest.Character.Head.Position)
            else
                local pos = workspace.CurrentCamera:WorldToViewportPoint(closest.Character.Head.Position)
                mousemoverel(pos.X - mouse.X, pos.Y - mouse.Y)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if features.triggerbot.enabled and player.Character and player.Character:FindFirstChild("Head") then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                if manualTeam.enabled and manualFriends[v] then continue end
                if not manualTeam.enabled and features.triggerbot.teamCheck then
                    if (player.Team and v.Team and player.Team == v.Team) or (player.TeamColor and v.TeamColor and player.TeamColor == v.TeamColor) then
                        continue
                    end
                end
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
        if not root:FindFirstChild("BodyGyro") then
            local bg = Instance.new("BodyGyro")
            local bv = Instance.new("BodyVelocity")
            bg.Parent = root
            bv.Parent = root
            bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
            bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        end
        if root:FindFirstChild("BodyGyro") then
            local bg = root.BodyGyro
            local bv = root.BodyVelocity
            local speed = 16 * features.fly.speed
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            bv.Velocity = moveDir * speed
            bg.CFrame = CFrame.new(root.Position, root.Position + workspace.CurrentCamera.CFrame.LookVector)
        end
    elseif player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        if root:FindFirstChild("BodyGyro") then root.BodyGyro:Destroy() end
        if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
    end
end)

RunService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if features.speed.enabled then
            hum.WalkSpeed = 16 * features.speed.multiplier
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
        hum.JumpPower = features.jumpBoost.enabled and 50 * features.jumpBoost.multiplier or 50
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
                part.Size = Vector3.new(troll.sizeChanger.size, troll.sizeChanger.size, troll.sizeChanger.size)
            end
        end
    end
end)
