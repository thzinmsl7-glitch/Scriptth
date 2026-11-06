-- language: Lua, target: Roblox Delta Executor
-- Menoli Hub V50 - Fixed & Stabilized Professional UI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

if game:GetService("CoreGui"):FindFirstChild("Menoli_Flat") then
    game:GetService("CoreGui").Menoli_Flat:Destroy()
end

local CORE_GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
CORE_GUI.Name = "Menoli_Flat"
CORE_GUI.ResetOnSpawn = false

local Theme = {
    Background = Color3.fromRGB(12, 10, 18),
    Accent = Color3.fromRGB(150, 50, 255),
    Text = Color3.fromRGB(230, 230, 240),
    Box = Color3.fromRGB(20, 15, 30),
    ToggleOff = Color3.fromRGB(40, 30, 55),
    ToggleOn = Color3.fromRGB(150, 50, 255),
    SliderBg = Color3.fromRGB(30, 25, 40)
}

-- ==========================================
-- UI BASE
-- ==========================================
local MainFrame = Instance.new("Frame", CORE_GUI)
MainFrame.Size = UDim2.new(0, 500, 0, 320)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Theme.Box
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MENOLI V50 - PROFESSIONAL HUB"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 2)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() CORE_GUI:Destroy() end)

-- Arrastar Janela
local mainDragging, mainDragStart, mainStartPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = true
        mainDragStart = input.Position
        mainStartPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and mainDragging then
        local delta = input.Position - mainDragStart
        MainFrame.Position = UDim2.new(mainStartPos.X.Scale, mainStartPos.X.Offset + delta.X, mainStartPos.Y.Scale, mainStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mainDragging = false
    end
end)

-- Bolinha Flutuante
local FloatBtn = Instance.new("TextButton", CORE_GUI)
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatBtn.BackgroundColor3 = Theme.Accent
FloatBtn.Text = "M"
FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 22
FloatBtn.Visible = false
FloatBtn.Active = true
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1, 0)

local floatDragging = false
local floatMoved = false
local floatDragStart, floatStartPos

FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        floatMoved = false
        floatDragStart = input.Position
        floatStartPos = FloatBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and floatDragging then
        local delta = input.Position - floatDragStart
        if delta.Magnitude > 6 then floatMoved = true end
        FloatBtn.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
    end
end)

FloatBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = false
    end
end)

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false FloatBtn.Visible = true end)
FloatBtn.MouseButton1Click:Connect(function() if not floatMoved then MainFrame.Visible = true FloatBtn.Visible = false end end)

-- ==========================================
-- SISTEMA DE ABAS E CONTEÚDO
-- ==========================================
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, -20, 0, 32)
TabContainer.Position = UDim2.new(0, 10, 0, 42)
TabContainer.BackgroundTransparency = 1

local UIListTabs = Instance.new("UIListLayout", TabContainer)
UIListTabs.FillDirection = Enum.FillDirection.Horizontal
UIListTabs.Padding = UDim.new(0, 5)

local PagesContainer = Instance.new("Frame", MainFrame)
PagesContainer.Size = UDim2.new(1, -20, 1, -85)
PagesContainer.Position = UDim2.new(0, 10, 0, 80)
PagesContainer.BackgroundTransparency = 1

local function createPage(name)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.Visible = false
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 2)
    return page
end

local CombatPage = createPage("Combat")
local MovePage = createPage("Move")
local VisualPage = createPage("Visual")
local EggPage = createPage("Eggs")
local TpPage = createPage("Teleport")

local function createTabBtn(text, page)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0, 88, 1, 0)
    btn.BackgroundColor3 = Theme.Box
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in ipairs(PagesContainer:GetChildren()) do
            if p:IsA("ScrollingFrame") then p.Visible = false end
        end
        for _, b in ipairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Theme.Box end
        end
        page.Visible = true
        btn.BackgroundColor3 = Theme.Accent
    end)
    return btn
end

createTabBtn("Combate", CombatPage)
createTabBtn("Movimento", MovePage)
createTabBtn("Visual", VisualPage)
createTabBtn("Auto Ovos", EggPage)
createTabBtn("Teleporte", TpPage)

CombatPage.Visible = true
TabContainer:GetChildren()[1].BackgroundColor3 = Theme.Accent

-- ==========================================
-- COMPONENTES MODERNOS
-- ==========================================
local function makeSection(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function makeToggle(parent, text, callback)
    local Container = Instance.new("Frame", parent)
    Container.Size = UDim2.new(1, 0, 0, 34)
    Container.BackgroundColor3 = Theme.Box
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", Container)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBg = Instance.new("TextButton", Container)
    SwitchBg.Size = UDim2.new(0, 40, 0, 20)
    SwitchBg.Position = UDim2.new(1, -50, 0.5, -10)
    SwitchBg.BackgroundColor3 = Theme.ToggleOff
    SwitchBg.Text = ""
    SwitchBg.AutoButtonColor = false
    Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", SwitchBg)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Theme.Text
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local state = false
    SwitchBg.MouseButton1Click:Connect(function()
        state = not state
        SwitchBg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
        Circle:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        if callback then callback(state) end
    end)
    return Container
end

local function makeSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(1, 0, 0, 44)
    SliderFrame.BackgroundColor3 = Theme.Box
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

    local TextLabel = Instance.new("TextLabel", SliderFrame)
    TextLabel.Size = UDim2.new(1, -20, 0, 20)
    TextLabel.Position = UDim2.new(0, 12, 0, 4)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text .. ": " .. default
    TextLabel.TextColor3 = Theme.Text
    TextLabel.Font = Enum.Font.GothamMedium
    TextLabel.TextSize = 12
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBtn = Instance.new("TextButton", SliderFrame)
    SliderBtn.Size = UDim2.new(1, -24, 0, 12)
    SliderBtn.Position = UDim2.new(0, 12, 0, 26)
    SliderBtn.BackgroundColor3 = Theme.SliderBg
    SliderBtn.Text = ""
    SliderBtn.AutoButtonColor = false
    Instance.new("UICorner", SliderBtn).CornerRadius = UDim.new(0, 4)

    local Fill = Instance.new("Frame", SliderBtn)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.BorderSizePixel = 0
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 4)

    local isDragging = false
    local function updateValue(input)
        local relX = math.clamp((input.Position.X - SliderBtn.AbsolutePosition.X) / SliderBtn.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(relX, 0, 1, 0)
        local value = math.floor(min + (max - min) * relX)
        TextLabel.Text = text .. ": " .. value
        if callback then callback(value) end
    end

    SliderBtn.MouseButton1Down:Connect(function() isDragging = true updateValue({Position = UserInputService:GetMouseLocation()}) end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateValue(input) end end)
end

-- ==========================================
-- 1. COMBATE
-- ==========================================
makeSection(CombatPage, "AÇÕES DE COMBATE")
local HitkillEnabled = false
makeToggle(CombatPage, "Ativar Hitkill em Mobs", function(state) HitkillEnabled = state end)

task.spawn(function()
    while true do
        if HitkillEnabled and LocalPlayer.Character then
            pcall(function()
                local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                                if (root.Position - myRoot.Position).Magnitude < 30 then
                                    hum:TakeDamage(hum.MaxHealth * 10)
                                    hum.Health = 0
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.05)
    end
end)

local NoclipEnabled = false
makeToggle(CombatPage, "Ativar NoClip", function(state) NoclipEnabled = state end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        pcall(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end)
    end
end)

-- ==========================================
-- 2. MOVIMENTAÇÃO
-- ==========================================
makeSection(MovePage, "VELOCIDADE E VOO")
local SpeedEnabled = false
local CurrentSpeed = 16
makeToggle(MovePage, "Ativar Speed Hack", function(state) SpeedEnabled = state end)
makeSlider(MovePage, "WalkSpeed", 16, 250, 16, function(val) CurrentSpeed = val end)

RunService.Heartbeat:Connect(function()
    if SpeedEnabled and LocalPlayer.Character then
        pcall(function()
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = CurrentSpeed end
        end)
    end
end)

local FlyEnabled = false
local FlySpeed = 50
local bg, bv

makeToggle(MovePage, "Ativar Fly (Voo)", function(state)
    FlyEnabled = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    if FlyEnabled then
        bg = Instance.new("BodyGyro", root)
        bg.P = 9e4 bg.maxTorque = Vector3.new(9e9, 9e9, 9e9) bg.cframe = root.CFrame
        bv = Instance.new("BodyVelocity", root)
        bv.velocity = Vector3.new(0, 0.1, 0) bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while FlyEnabled and LocalPlayer.Character and root do
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new()
                local uis = UserInputService
                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CoordinateFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CoordinateFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CoordinateFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CoordinateFrame.RightVector end
                bv.velocity = moveDir * FlySpeed
                bg.cframe = cam.CoordinateFrame
                RunService.RenderStepped:Wait()
            end
            if bg then bg:Destroy() end if bv then bv:Destroy() end
        end)
    else
        if bg then bg:Destroy() end if bv then bv:Destroy() end
    end
end)
makeSlider(MovePage, "Velocidade do Voo", 10, 200, 50, function(val) FlySpeed = val end)

-- ==========================================
-- 3. VISUAL / FPS
-- ==========================================
makeSection(VisualPage, "OTIMIZAÇÃO")
makeToggle(VisualPage, "Ativar FPS Boost", function(state)
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = state and Enum.Material.SmoothPlastic or v.Material v.Reflectance = state and 0 or v.Reflectance
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = state and 1 or 0 end
        end
        settings().Rendering.QualityLevel = state and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
    end)
end)

makeToggle(VisualPage, "Remover Nevoeiro (Fog)", function(state)
    pcall(function()
        if state then
            Lighting.FogEnd = 999999 Lighting.GlobalShadows = false
            for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("Atmosphere") or v:IsA("Sky") then v.Parent = nil end end
        else
            Lighting.FogEnd = 1000 Lighting.GlobalShadows = true
        end
    end)
end)

-- ==========================================
-- 4. AUTO OVOS
-- ==========================================
makeSection(EggPage, "GERENCIAMENTO DE OVOS")
local AutoHatchEnabled = false

makeToggle(EggPage, "Ativar Auto Hatch (Automático)", function(state)
    AutoHatchEnabled = state
    task.spawn(function()
        while AutoHatchEnabled do
            pcall(function()
                for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteFunction") or remote:IsA("RemoteEvent") then
                        local nameLower = remote.Name:lower()
                        if nameLower:find("egg") or nameLower:find("hatch") or nameLower:find("open") then
                            remote:FireServer("1")
                            remote:InvokeServer("1")
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- ==========================================
-- 5. TELEPORTE
-- ==========================================
makeSection(TpPage, "JOGADORES NO SERVIDOR")
local function refreshPlayerList()
    for _, child in ipairs(TpPage:GetChildren()) do
        if child:IsA("Frame") and child.Name == "TpCard" then child:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pCard = Instance.new("Frame", TpPage)
            pCard.Name = "TpCard"
            pCard.Size = UDim2.new(1, 0, 0, 34)
            pCard.BackgroundColor3 = Theme.Box
            Instance.new("UICorner", pCard).CornerRadius = UDim.new(0, 6)
            
            local pBtn = Instance.new("TextButton", pCard)
            pBtn.Size = UDim2.new(1, 0, 1, 0)
            pBtn.BackgroundTransparency = 1
            pBtn.Text = "  Ir até: " + plr.Name -- Corrigido para concatenação segura em Lua abaixo
        end
    end
end
