-- language: Lua, target: Roblox Delta Executor
-- Trava o personagem no topo do mapa pra ganhar o multiplicador máximo.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
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
Title.Text = "MENOLI V60 - MAX HEIGHT MONEY"
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

-- Layout
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -40)
ContentFrame.Position = UDim2.new(0, 0, 0, 40)
ContentFrame.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", ContentFrame)
TabContainer.Size = UDim2.new(0, 120, 1, 0)
TabContainer.BackgroundTransparency = 1

local UIPadTabs = Instance.new("UIPadding", TabContainer)
UIPadTabs.PaddingLeft = UDim.new(0, 8)
UIPadTabs.PaddingTop = UDim.new(0, 10)

local UIListTabs = Instance.new("UIListLayout", TabContainer)
UIListTabs.FillDirection = Enum.FillDirection.Vertical
UIListTabs.Padding = UDim.new(0, 8)

local PagesContainer = Instance.new("Frame", ContentFrame)
PagesContainer.Size = UDim2.new(1, -120, 1, 0)
PagesContainer.Position = UDim2.new(0, 120, 0, 0)
PagesContainer.BackgroundTransparency = 1

local function createPage(name)
    local page = Instance.new("ScrollingFrame", PagesContainer)
    page.Name = name
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.Visible = false
    
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pad = Instance.new("UIPadding", page)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 5)
    return page
end

local CombatPage = createPage("Combat")
local MovePage = createPage("Move")
local TpPage = createPage("Tp")
local ConfigPage = createPage("Config")

local function createTabBtn(text, page)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 35)
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

createTabBtn("Combate", CombatPage)
createTabBtn("Movimento", MovePage)
createTabBtn("Teleporte", TpPage)
createTabBtn("Config", ConfigPage)

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

-- ==========================================
-- ABA DE TELEPORTE (Max Height)
-- ==========================================
makeLabel(TpPage, "Farm de Altura (Max)")

local MaxHeightEnabled = false
makeToggle(TpPage, "Ativar Farm Max Height", function(state) MaxHeightEnabled = state end)

-- Pega a coordenada exata do TOPO do mapa (a Part lá em cima)
local topPosition = Vector3.new(-56.176, 11530, 855.6) -- Substitua pelas coordenadas do Topo (CFrame da Part)
local bottomPosition = Vector3.new(-56.176, 11530 - 100, 855.6) -- Base do tapete (CFrame da Part2)

task.spawn(function()
    while true do
        if MaxHeightEnabled and LocalPlayer.Character then
            local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                -- 1. Cola no topo do mapa
                myRoot.CFrame = CFrame.new(topPosition)
                
                -- 2. Dá um "pulinho" de 0.1 stud pra forçar o servidor a recalcular a altura
                task.wait(0.1)
                myRoot.CFrame = CFrame.new(topPosition + Vector3.new(0, 0.1, 0))
                
                -- 3. Volta pro topo pra garantir que não vai cair
                task.wait(0.1)
                myRoot.CFrame = CFrame.new(topPosition)
            end
        end
        task.wait(0.2)
    end
end)

-- ==========================================
-- ABA DE COMBATE (Hitkill)
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
                                    hum.Health = 0
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1)
    end
end)

-- ==========================================
-- ABA DE MOVIMENTO (Speed)
-- ==========================================
makeLabel(MovePage, "Velocidade")
local SpeedEnabled = false
local CurrentSpeed = 16

makeToggle(MovePage, "Speed Hack", function(state) SpeedEnabled = state end)
makeSlider = function(parent, text, min, max, default, callback)
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

makeSlider(MovePage, "WalkSpeed", 16, 250, 16, function(val) CurrentSpeed = val end)

RunService.Heartbeat:Connect(function()
    if SpeedEnabled and LocalPlayer.Character then
        pcall(function()
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = CurrentSpeed end
        end)
    end
end)

-- ==========================================
-- ABA DE CONFIG (Temas)
-- ==========================================
makeLabel(ConfigPage, "Temas do Painel")

local function updateTheme(newAccent)
    Theme.Accent = newAccent
    Title.TextColor3 = Theme.Accent
    MinBtn.TextColor3 = Theme.Accent
    FloatBtn.BackgroundColor3 = Theme.Accent
    TabContainer:GetChildren()[1].BackgroundColor3 = Theme.Accent
    
    for _, p in ipairs(PagesContainer:GetChildren()) do
        if p:IsA("ScrollingFrame") then
            for _, obj in ipairs(p:GetDescendants()) do
                if obj:IsA("Frame") and obj.Name == "Fill" then obj.BackgroundColor3 = Theme.Accent end
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