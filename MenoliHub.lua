-- language: Lua, target: Roblox Delta Executor
-- V52: Layout espaçado, FPS/Fog na Config, Tema Global e Hatch Rápido.

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
    SliderBg = Color3.fromRGB(30, 25, 40),
    Success = Color3.fromRGB(45, 180, 90),
}

-- ==========================================
-- UI BASE
-- ==========================================
local MainFrame = Instance.new("Frame", CORE_GUI)
MainFrame.Size = UDim2.new(0, 500, 0, 380) -- Aumentei pra caber tudo com espaço
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Theme.Box
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MENOLI V52 - PRO UI"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 5)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() CORE_GUI:Destroy() end)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
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

local floatMoved = false
local fDrag, fStart, fPos
FloatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDrag = true floatMoved = false fStart = input.Position fPos = FloatBtn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and fDrag then
        local delta = input.Position - fStart
        if delta.Magnitude > 6 then floatMoved = true end
        FloatBtn.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + delta.X, fPos.Y.Scale, fPos.Y.Offset + delta.Y)
    end
end)
FloatBtn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then fDrag = false end end)
MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false FloatBtn.Visible = true end)
FloatBtn.MouseButton1Click:Connect(function() if not floatMoved then MainFrame.Visible = true FloatBtn.Visible = false end end)

-- Sistema de Abas
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1

local TabContainer = Instance.new("ScrollingFrame", ContentFrame)
TabContainer.Size = UDim2.new(1, 0, 0, 35)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 600, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.ScrollingDirection = Enum.ScrollingDirection.X

local UIListTabs = Instance.new("UIListLayout", TabContainer)
UIListTabs.FillDirection = Enum.FillDirection.Horizontal
UIListTabs.Padding = UDim.new(0, 6)

local UIPadTabs = Instance.new("UIPadding", TabContainer)
UIPadTabs.PaddingLeft = UDim.new(0, 10)
UIPadTabs.PaddingTop = UDim.new(0, 4)

local PagesContainer = Instance.new("Frame", ContentFrame)
PagesContainer.Size = UDim2.new(1, 0, 1, -40)
PagesContainer.Position = UDim2.new(0, 0, 0, 40)
PagesContainer.BackgroundTransparency = 1

local function createPage(name)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.Visible = false
    
    -- Aumentei o espaçamento (Padding) aqui
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 12) 
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 15)
    pad.PaddingRight = UDim.new(0, 15)
    pad.PaddingTop = UDim.new(0, 10)
    return page
end

local CombatPage = createPage("Combat")
local MovePage = createPage("Move")
local VisualPage = createPage("Visual")
local EggPage = createPage("Eggs")
local TpPage = createPage("Teleport")
local ConfigPage = createPage("Config")

local function createTabBtn(text, page)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(0, 80, 0, 28)
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
            if b:IsA("TextButton") then 
                b.BackgroundColor3 = Theme.Box 
                b.TextColor3 = Theme.Text
            end
        end
        page.Visible = true
        btn.BackgroundColor3 = Theme.Accent
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    return btn
end

local btn1 = createTabBtn("Combate", CombatPage)
local btn2 = createTabBtn("Movimento", MovePage)
local btn3 = createTabBtn("Visual", VisualPage)
local btn4 = createTabBtn("Ovos", EggPage)
local btn5 = createTabBtn("Teleporte", TpPage)
local btn6 = createTabBtn("Config", ConfigPage)

CombatPage.Visible = true
btn1.BackgroundColor3 = Theme.Accent

-- Componentes
local function makeLabel(parent, text)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Accent
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local function makeToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Theme.Box
    btn.Text = text .. " [OFF]"
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Theme.Success or Theme.Box
        if callback then callback(state) end
    end)
    return btn
end

local function makeSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(1, 0, 0, 48)
    SliderFrame.BackgroundTransparency = 1

    local TextLabel = Instance.new("TextLabel", SliderFrame)
    TextLabel.Size = UDim2.new(1, 0, 0, 18)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text .. ": " .. default
    TextLabel.TextColor3 = Theme.Text
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 12
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBtn = Instance.new("TextButton", SliderFrame)
    SliderBtn.Size = UDim2.new(1, 0, 0, 20)
    SliderBtn.Position = UDim2.new(0, 0, 0, 22)
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
-- ABA 1: COMBATE
-- ==========================================
makeLabel(CombatPage, "Combate")
local HitkillEnabled = false
makeToggle(CombatPage, "Hitkill em Mobs", function(state) HitkillEnabled = state end)

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

makeLabel(CombatPage, "Movimentação")
local NoclipEnabled = false
makeToggle(CombatPage, "NoClip", function(state) NoclipEnabled = state end)

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
-- ABA 2: MOVIMENTO
-- ==========================================
makeLabel(MovePage, "Velocidade")
local SpeedEnabled = false
local CurrentSpeed = 16

makeToggle(MovePage, "Speed Hack", function(state) SpeedEnabled = state end)
makeSlider(MovePage, "WalkSpeed", 16, 250, 16, function(val) CurrentSpeed = val end)

RunService.Heartbeat:Connect(function()
    if SpeedEnabled and LocalPlayer.Character then
        pcall(function()
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = CurrentSpeed end
        end)
    end
end)

makeLabel(MovePage, "Voo")
local FlyEnabled = false
local FlySpeed = 50
local bg, bv

makeToggle(MovePage, "Ativar Fly", function(state)
    FlyEnabled = state
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    
    if FlyEnabled then
        bg = Instance.new("BodyGyro", root) bg.P = 9e4 bg.maxTorque = Vector3.new(9e9, 9e9, 9e9) bg.cframe = root.CFrame
        bv = Instance.new("BodyVelocity", root) bv.velocity = Vector3.new(0, 0.1, 0) bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
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
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end)
    else
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end)

makeSlider(MovePage, "Velocidade do Voo", 10, 200, 50, function(val) FlySpeed = val end)

-- ==========================================
-- ABA 3: VISUAL (Limpa)
-- ==========================================
makeLabel(VisualPage, "Visual")
-- Deixei a aba visual só com espaço pra futuras atualizações, já que o FPS foi pra Config

-- ==========================================
-- ABA 4: AUTO OVOS (Rápido)
-- ==========================================
makeLabel(EggPage, "Automação de Ovos")
local AutoHatchEnabled = false
makeToggle(EggPage, "Auto Hatch (Automático)", function(state) AutoHatchEnabled = state end)

-- Botão pra mudar a velocidade
local HatchSpeed = 0.1
makeSlider(EggPage, "Velocidade do Hatch", 1, 20, 10, function(val) 
    HatchSpeed = 1 / val -- Inverte pra quanto maior o slider, menor o tempo
end)

task.spawn(function()
    while true do
        if AutoHatchEnabled then
            pcall(function()
                local packages = ReplicatedStorage:FindFirstChild("Packages")
                local index = packages and packages:FindFirstChild("_Index")
                local knitPkg = index and index:FindFirstChild("sleitnick_knit@1.5.1")
                local knit = knitPkg and knitPkg:FindFirstChild("Knit")
                local services = knit and knit:FindFirstChild("Services")
                local eggService = services and services:FindFirstChild("EggHatchService")
                local re = eggService and eggService:FindFirstChild("RE")
                local hatchRemote = re and re:FindFirstChild("Hatch")
                
                if hatchRemote then
                    hatchRemote:FireServer("Egg_4_1", 1)
                end
            end)
        end
        task.wait(HatchSpeed)
    end
end)

-- ==========================================
-- ABA 5: TELEPORTE
-- ==========================================
makeLabel(TpPage, "Lista de Jogadores")

local function refreshPlayerList()
    for _, child in ipairs(TpPage:GetChildren()) do
        if child:IsA("TextButton") and child.Name == "PlayerTpBtn" then child:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", TpPage)
            pBtn.Name = "PlayerTpBtn"
            pBtn.Size = UDim2.new(1, 0, 0, 38)
            pBtn.BackgroundColor3 = Theme.Box
            pBtn.Text = "Ir até: " .. plr.Name
            pBtn.TextColor3 = Theme.Text
            pBtn.Font = Enum.Font.GothamBold
            pBtn.TextSize = 12
            pBtn.AutoButtonColor = false
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
            
            pBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end)
            end)
        end
    end
end

local RefreshBtn = Instance.new("TextButton", TpPage)
RefreshBtn.Size = UDim2.new(1, 0, 0, 38)
RefreshBtn.BackgroundColor3 = Theme.Accent
RefreshBtn.Text = "🔄 Atualizar Lista"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 12
RefreshBtn.AutoButtonColor = false
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 6)
RefreshBtn.MouseButton1Click:Connect(refreshPlayerList)
task.spawn(function() while true do refreshPlayerList() task.wait(5) end end)

-- ==========================================
-- ABA 6: CONFIG (Temas e FPS movidos pra cá)
-- ==========================================
makeLabel(ConfigPage, "Temas do Painel")

local function updateTheme(newAccent)
    Theme.Accent = newAccent
    Title.TextColor3 = Theme.Accent
    MinBtn.TextColor3 = Theme.Accent
    FloatBtn.BackgroundColor3 = Theme.Accent
    btn1.BackgroundColor3 = Theme.Accent
    
    -- Atualiza todas as barras de slider e botões ativos
    for _, p in ipairs(PagesContainer:GetChildren()) do
        if p:IsA("ScrollingFrame") then
            for _, obj in ipairs(p:GetDescendants()) do
                if obj:IsA("Frame") and obj.Name == "Fill" then obj.BackgroundColor3 = Theme.Accent end
                if obj:IsA("TextLabel") and obj.Text:find("Tema") then obj.TextColor3 = Theme.Accent end
            end
        end
    end
end

local btnBlue = Instance.new("TextButton", ConfigPage)
btnBlue.Size = UDim2.new(1, 0, 0, 38)
btnBlue.BackgroundColor3 = Color3.fromRGB(50, 100, 255)
btnBlue.Text = "Tema Azul"
btnBlue.TextColor3 = Theme.Text
btnBlue.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnBlue).CornerRadius = UDim.new(0, 6)
btnBlue.MouseButton1Click:Connect(function() updateTheme(Color3.fromRGB(50, 100, 255)) end)

local btnRed = Instance.new("TextButton", ConfigPage)
btnRed.Size = UDim2.new(1, 0, 0, 38)
btnRed.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
btnRed.Text = "Tema Vermelho"
btnRed.TextColor3 = Theme.Text
btnRed.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnRed).CornerRadius = UDim.new(0, 6)
btnRed.MouseButton1Click:Connect(function() updateTheme(Color3.fromRGB(200, 50, 50)) end)

local btnGreen = Instance.new("TextButton", ConfigPage)
btnGreen.Size = UDim2.new(1, 0, 0, 38)
btnGreen.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
btnGreen.Text = "Tema Verde"
btnGreen.TextColor3 = Theme.Text
btnGreen.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnGreen).CornerRadius = UDim.new(0, 6)
btnGreen.MouseButton1Click:Connect(function() updateTheme(Color3.fromRGB(50, 200, 100)) end)

local btnPurple = Instance.new("TextButton", ConfigPage)
btnPurple.Size = UDim2.new(1, 0, 0, 38)
btnPurple.BackgroundColor3 = Color3.fromRGB(150, 50, 255)
btnPurple.Text = "Tema Original (Roxo)"
btnPurple.TextColor3 = Theme.Text
btnPurple.Font = Enum.Font.GothamBold
Instance.new("UICorner", btnPurple).CornerRadius = UDim.new(0, 6)
btnPurple.MouseButton1Click:Connect(function() updateTheme(Color3.fromRGB(150, 50, 255)) end)

makeLabel(ConfigPage, "Desempenho")

makeToggle(ConfigPage, "Ativar FPS Boost", function(state)
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                if state then
                    if v.Material ~= Enum.Material.SmoothPlastic then v.Material = Enum.Material.SmoothPlastic end
                    v.Reflectance = 0
                end
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = state and 1 or 0
            end
        end
        if state then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        end
    end)
end)

makeToggle(ConfigPage, "Remover Nevoeiro (Fog)", function(state)
    pcall(function()
        if state then
            Lighting.FogEnd = 999999
            Lighting.GlobalShadows = false
            for _, v in ipairs(Lighting:GetChildren()) do
                if v:IsA("Atmosphere") or v:IsA("Sky") then v.Parent = nil end
            end
        else
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true
        end
    end)
end)