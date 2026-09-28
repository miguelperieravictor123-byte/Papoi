-- ============================================
-- SACRIFICE HUB
-- ============================================

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variáveis de controle
local SpeedEnabled = false
local ESPEnabled = false
local TeleportEnabled = false
local ClickEnabled = false
local SpeedValue = 50
local ESPObjects = {}

-- ============================================
-- CRIAÇÃO DA GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SacrificeHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Proteção contra detecção (tenta usar CoreGui)
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ============================================
-- PAINEL PRINCIPAL
-- ============================================

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 340)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Borda arredondada do painel
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Gradiente sutil de fundo
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20)),
})
MainGradient.Rotation = 90
MainGradient.Parent = MainFrame

-- Stroke (contorno)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(180, 30, 60)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = MainFrame

-- ============================================
-- BARRA DE TÍTULO
-- ============================================

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Corrige o canto inferior da barra de título
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SACRIFICE HUB"
Title.TextColor3 = Color3.fromRGB(220, 40, 70)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Linha decorativa
local TitleLine = Instance.new("Frame")
TitleLine.Size = UDim2.new(1, -30, 0, 1)
TitleLine.Position = UDim2.new(0, 15, 1, -1)
TitleLine.BackgroundColor3 = Color3.fromRGB(180, 30, 60)
TitleLine.BackgroundTransparency = 0.5
TitleLine.BorderSizePixel = 0
TitleLine.Parent = TitleBar

-- Botão de minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -38, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeBtn.Text = "–"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- ============================================
-- CONTAINER DE BOTÕES
-- ============================================

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, -30, 1, -65)
ButtonContainer.Position = UDim2.new(0, 15, 0, 55)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 10)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ButtonContainer

-- ============================================
-- FUNÇÃO PARA CRIAR BOTÕES
-- ============================================

local function CreateButton(name, order)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Btn"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(220, 220, 220)
    Button.TextSize = 15
    Button.Font = Enum.Font.GothamMedium
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.LayoutOrder = order
    Button.Parent = ButtonContainer

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Button

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(80, 80, 100)
    Stroke.Thickness = 1
    Stroke.Transparency = 0.6
    Stroke.Parent = Button

    -- Hover
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        }):Play()
    end)

    Button.MouseLeave:Connect(function()
        if Button:GetAttribute("Active") then return end
        TweenService:Create(Button, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        }):Play()
    end)

    return Button, Stroke
end

-- ============================================
-- FUNÇÃO DE TOGGLE (ativa/desativa)
-- ============================================

local function SetButtonState(button, stroke, state, callback)
    button:SetAttribute("Active", state)
    if state then
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(120, 20, 45)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(220, 40, 70),
            Transparency = 0.2
        }):Play()
    else
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        }):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(80, 80, 100),
            Transparency = 0.6
        }):Play()
    end
    if callback then callback(state) end
end

-- ============================================
-- BOTÕES
-- ============================================

-- -------- SPEED --------
local SpeedBtn, SpeedStroke = CreateButton("Speed", 1)
SpeedBtn.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    SetButtonState(SpeedBtn, SpeedStroke, SpeedEnabled)
end)

-- -------- ESP --------
local ESPBtn, ESPStroke = CreateButton("ESP", 2)

local function CreateESP(plr)
    if plr == LocalPlayer then return end
    if ESPObjects[plr] then return end

    local Highlight = Instance.new("Highlight")
    Highlight.Name = "SacrificeESP"
    Highlight.FillColor = Color3.fromRGB(220, 40, 70)
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.6
    Highlight.OutlineTransparency = 0
    Highlight.Parent = plr.Character or plr

    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "SacrificeName"
    Billboard.Size = UDim2.new(0, 200, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = plr.Character or plr

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = plr.Name
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextStrokeTransparency = 0
    NameLabel.TextSize = 14
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Parent = Billboard

    ESPObjects[plr] = {Highlight = Highlight, Billboard = Billboard}
end

local function RemoveESP(plr)
    if ESPObjects[plr] then
        pcall(function()
            ESPObjects[plr].Highlight:Destroy()
            ESPObjects[plr].Billboard:Destroy()
        end)
        ESPObjects[plr] = nil
    end
end

local function UpdateESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            if ESPEnabled then
                if not ESPObjects[plr] then
                    CreateESP(plr)
                end
            else
                RemoveESP(plr)
            end
        end
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    SetButtonState(ESPBtn, ESPStroke, ESPEnabled)
    if not ESPEnabled then
        for plr, _ in pairs(ESPObjects) do
            RemoveESP(plr)
        end
    end
end)

-- -------- TELEPORT --------
local TeleportBtn, TeleportStroke = CreateButton("Teleport", 3)
TeleportEnabled = false

TeleportBtn.MouseButton1Click:Connect(function()
    TeleportEnabled = not TeleportEnabled
    SetButtonState(TeleportBtn, TeleportStroke, TeleportEnabled)
end)

-- ============================================
-- CLICK TELEPORT (função "click" - teleporta onde clicar)
-- ============================================

local ClickBtn, ClickStroke = CreateButton("Click Teleport", 4)

ClickBtn.MouseButton1Click:Connect(function()
    ClickEnabled = not ClickEnabled
    SetButtonState(ClickBtn, ClickStroke, ClickEnabled)
end)

-- ============================================
-- LOOP PRINCIPAL
-- ============================================

RunService.Heartbeat:Connect(function()
    -- SPEED
    if SpeedEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = SpeedValue
        end
    elseif not SpeedEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
        end
    end

    -- ESP
    UpdateESP()

    -- TELEPORT (auto - teleporta para o jogador mais próximo)
    if TeleportEnabled and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local closest, dist = nil, math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = plr
                    end
                end
            end
            if closest and dist > 5 then
                root.CFrame = closest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
    end
end)

-- CLICK TELEPORT via Mouse
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and ClickEnabled then
        local mousePos = UserInputService:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {LocalPlayer.Character}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
        if result and LocalPlayer.Character then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end)

-- Atualiza ESP quando alguém entra/sai
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        if ESPEnabled then CreateESP(plr) end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    RemoveESP(plr)
end)

-- ============================================
-- MINIMIZAR
-- ============================================

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 260, 0, 45)
        }):Play()
        ButtonContainer.Visible = false
        MinimizeBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 260, 0, 340)
        }):Play()
        task.wait(0.1)
        ButtonContainer.Visible = true
        MinimizeBtn.Text = "–"
    end
end)

-- ============================================
-- NOTIFICAÇÃO DE CARREGAMENTO
-- ============================================

print("[Sacrifice Hub] Carregado com sucesso!")
print("[Sacrifice Hub] Funções: Speed | ESP | Teleport | Click Teleport")
