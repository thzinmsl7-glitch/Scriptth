-- language: Lua, target: Roblox Delta Executor
-- Menoli Hub V56 (Funções Ativas)

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
MainFrame.Size = UDim2.new(0, 480, 0, 300)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -150)
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
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MENOLI V56 - HUB"
Title.TextColor3 = Theme.Accent
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Minimizar
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 2)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "-"
MinBtn.TextColor3 = Theme.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18

-- Botão Fechar
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Theme.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() CORE_GUI:Destroy() end)

-- Arrastar Janela
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Botão Flutuante (Bolinha)
local FloatBtn = Instance.new("TextButton", CORE_GUI)
FloatBtn.Size = UDim2.new(0, 45, 0, 45)
FloatBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
FloatBtn.BackgroundColor3 = Theme.Accent
FloatBtn.Text = "M"
FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 20
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
        if delta.Magnitude > 5 then floatMoved = true end
        FloatBtn.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + delta.X, fPos.Y.Scale, fPos.Y.Offset + delta.Y)
    end
end)
FloatBtn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then fDrag = false end end)

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false FloatBtn.Visible = true end)
FloatBtn.MouseButton1Click:Connect(function() if not floatMoved then MainFrame.Visible = true FloatBtn.Visible = false end end)

-- Tabs
local TabBar = Instance.new("ScrollingFrame", MainFrame)
TabBar.Size = UDim2.new(1, -16, 0, 30)
TabBar.Position = UDim2.new(0, 8, 0, 42)
TabBar.BackgroundTransparency = 1
TabBar.CanvasSize = UDim2.new(0, 450, 0, 0)
TabBar.ScrollBarThickness = 0

local TabList = Instance.new("UIListLayout", TabBar)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.Padding = UDim.new(0, 4)

local PageContainer = Instance.new("Frame", MainFrame)
PageContainer.Size = UDim2.new(1, -16, 1, -82)
PageContainer.Position = UDim2.new(0, 8, 0, 78)
PageContainer.BackgroundTransparency = 1

local function createPage(name)
    local page = Instance.new("ScrollingFrame", PageContainer)
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false

    local l = Instance.new("UIListLayout", page)
    l.Padding = UDim.new(0, 5)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return page
end

local CombatP = createPage("Combat")
local MoveP = createPage("Move")
local VisualP = createPage("Visual")
local EggP = createPage("Eggs")
local TpP = createPage("Tp")

local function addTab(name, page)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(0, 85, 1, 0)
    btn.BackgroundColor3 = Theme.Box
    btn.Text = name
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, p in ipairs(PageContainer:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        for _, b in ipairs(TabBar:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Theme.Box end end
        page.Visible = true
        btn.BackgroundColor3 = Theme.Accent
    end)
    return btn
end

addTab("Combate", CombatP)
addTab("Movimento", MoveP)
addTab("Visual", VisualP)
addTab("Auto Ovos", EggP)
addTab("Teleporte", TpP)

CombatP.Visible = true
TabBar:GetChildren()[1].BackgroundColor3 = Theme.Accent

-- Helpers
local function addToggle(parent, text, callback)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1, 0, 0, 32)
    c.BackgroundColor3 = Theme.Box
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", c)
    lbl.Size = UDim2.new(1, -55, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sw = Instance.new("TextButton", c)
    sw.Size = UDim2.new(0, 38, 0, 18)
    sw.Position = UDim2.new(1, -46, 0.5, -9)
    sw.BackgroundColor3 = Theme.ToggleOff
    sw.Text = ""
    sw.AutoButtonColor = false
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", sw)
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, 2, 0.5, -7)
    circle.BackgroundColor3 = Theme.Text
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local state = false
    sw.MouseButton1Click:Connect(function()
        state = not state
        sw.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
        circle:TweenPosition(state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        if callback then callback(state) end
    end)
end

local function addSlider(parent, text, min, max, def, callback)
    local sf = Instance.new("Frame", parent)
    sf.Size = UDim2.new(1, 0, 0, 42)
    sf.BackgroundColor3 = Theme.Box
    Instance.new("UICorner", sf).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel", sf)
    lbl.Size = UDim2.new(1, -15, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. def
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sBtn = Instance.new("TextButton", sf)
    sBtn.Size = UDim2.new(1, -20, 0, 10)
    sBtn.Position = UDim2.new(0, 10, 0, 25)
    sBtn.BackgroundColor3 = Theme.SliderBg
    sBtn.Text = ""
    sBtn.AutoButtonColor = false
    Instance.new("UICorner", sBtn).CornerRadius = UDim.new(0, 4)

    local fill = Instance.new("Frame", sBtn)
    fill.Size = UDim2.new((def - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 4)

    local draggingS = false
    local function update(input)
        local rel = math.clamp((input.Position.X - sBtn.AbsolutePosition.X) / sBtn.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        local val = math.floor(min + (max - min) * rel)
        lbl.Text = text .. ": " .. val
        if callback then callback(val) end
    end

    sBtn.MouseButton1Down:Connect(function() draggingS = true update({Position = UserInputService:GetMouseLocation()}) end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingS = false end end)
    UserInputService.InputChanged:Connect(function(input) if draggingS and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
end

-- ==========================================
-- FUNÇÕES ATIVAS
-- ==========================================

-- HITKILL
local hitkill = false
addToggle(CombatP, "Ativar Hitkill em Mobs", function(v) hitkill = v end)
task.spawn(function()
    while true do
        if hitkill and LocalPlayer.Character then
            pcall(function()
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local part = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                            if hum and part and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                                if (part.Position - root.Position).Magnitude < 35 then
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

-- NOCLIP
local noclip = false
addToggle(CombatP, "Ativar NoClip", function(v) noclip = v end)
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        pcall(function()
            for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end)
    end
end)

-- SPEED
local speedOn = false
local speedVal = 16
addToggle(MoveP, "Ativar Speed Hack", function(v) speedOn = v end)
addSlider(MoveP, "WalkSpeed", 16, 250, 16, function(v) speedVal = v end)
RunService.Heartbeat:Connect(function()
    if speedOn and LocalPlayer.Character then
        pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = speedVal end)
    end
end)

-- FLY
local flyOn = false
local flySpeed = 50
local bg, bv
addToggle(MoveP, "Ativar Fly (Voo)", function(v)
    flyOn = v
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    if flyOn then
        bg = Instance.new("BodyGyro", root) bg.P = 9e4 bg.maxTorque = Vector3.new(9e9,9e9,9e9) bg.cframe = root.CFrame
        bv = Instance.new("BodyVelocity", root) bv.velocity = Vector3.new(0,0.1,0) bv.maxForce = Vector3.new(9e9,9e9,9e9)
        task.spawn(function()
            while flyOn and LocalPlayer.Character and root do
                local cam = workspace.CurrentCamera
                local dir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CoordinateFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CoordinateFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CoordinateFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CoordinateFrame.RightVector end
                bv.velocity = dir * flySpeed
                bg.cframe = cam.CoordinateFrame
                RunService.RenderStepped:Wait()
            end
            if bg then bg:Destroy() end if bv then bv:Destroy() end
        end)
    else
        if bg then bg:Destroy() end if bv then bv:Destroy() end
    end
end)
addSlider(MoveP, "Velocidade do Voo", 10, 200, 50, function(v) flySpeed = v end)

-- VISUAL
addToggle(VisualP, "Ativar FPS Boost", function(v)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then obj.Material = v and Enum.Material.SmoothPlastic or obj.Material obj.Reflectance = v and 0 or obj.Reflectance
            elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = v and 1 or 0 end
        end
    end)
end)

addToggle(VisualP, "Remover Nevoeiro (Fog)", function(v)
    pcall(function()
        Lighting.FogEnd = v and 999999 or 1000
        Lighting.GlobalShadows = not v
    end)
end)

-- AUTO HATCH
local autoHatch = false
addToggle(EggP, "Ativar Auto Hatch (Automático)", function(v)
    autoHatch = v
    task.spawn(function()
        while autoHatch do
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
                        local n = r.Name:lower()
                        if n:find("egg") or n:find("hatch") or n:find("open") then
                            r:FireServer("1") r:InvokeServer("1")
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

-- TELEPORTE
local function refreshTp()
    for _, child in ipairs(TpP:GetChildren()) do if child:IsA("TextButton") and child.Name ~= "Ref" then child:Destroy() end end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pBtn = Instance.new("TextButton", TpP)
            pBtn.Size = UDim2.new(1, 0, 0, 32)
            pBtn.BackgroundColor3 = Theme.Box
            pBtn.Text = "Ir até: " .. plr.Name
            pBtn.TextColor3 = Theme.Text
            pBtn.Font = Enum.Font.GothamMedium
            pBtn.TextSize = 11
            Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)
            pBtn.MouseButton1Click:Connect(function()
                pcall(function()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end)
            end)
        end
    end
end

local refBtn = Instance.new("TextButton", TpP)
refBtn.Name = "Ref"
refBtn.Size = UDim2.new(1, 0, 0, 32)
refBtn.BackgroundColor3 = Theme.Accent
refBtn.Text = "Atualizar Lista de Jogadores"
refBtn.TextColor3 = Color3.fromRGB(255,255,255)
refBtn.Font = Enum.Font.GothamBold
refBtn.TextSize = 11
Instance.new("UICorner", refBtn).CornerRadius = UDim.new(0, 6)
refBtn.MouseButton1Click:Connect(refreshTp)
refreshTp()