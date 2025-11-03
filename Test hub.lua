task.wait(6)

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "StatusGui"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

-- Panel góc màn hình
local panel = Instance.new("Frame")
panel.Position = UDim2.new(0, 0, 0, 0)
panel.Size = UDim2.fromOffset(260, 110)
panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

-- Status
local statusLabel = Instance.new("TextLabel")
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0, 14, 0, 12)
statusLabel.Size = UDim2.fromOffset(232, 24)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "status: 🔴"
statusLabel.TextSize = 20
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = panel

-- by PhongScript
local byLabel = Instance.new("TextLabel")
byLabel.BackgroundTransparency = 1
byLabel.Position = UDim2.new(0, 14, 0, 40)
byLabel.Size = UDim2.fromOffset(232, 20)
byLabel.Font = Enum.Font.GothamSemibold
byLabel.Text = "by PhongScript"
byLabel.TextSize = 16
byLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
byLabel.TextXAlignment = Enum.TextXAlignment.Left
byLabel.Parent = panel

-- Nút Send Link
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -28, 0, 46)
button.Position = UDim2.new(0, 14, 0, 64)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.BorderSizePixel = 0
button.Text = "Send link"
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = panel
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

local grad = Instance.new("UIGradient", button)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,200)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0,170,255))
}

-- Chữ “PhongScript” nhỏ, neon 7 màu
local neonText = Instance.new("TextLabel")
neonText.AnchorPoint = Vector2.new(0.5, 0)
neonText.Position = UDim2.new(0.5, 0, 0.05, 0)
neonText.Size = UDim2.fromOffset(300, 40)
neonText.BackgroundTransparency = 1
neonText.Text = "PhongScript"
neonText.Font = Enum.Font.GothamBlack
neonText.TextScaled = true
neonText.TextTransparency = 1
neonText.Parent = gui

local stroke = Instance.new("UIStroke", neonText)
stroke.Thickness = 2
stroke.Color = Color3.new(1,1,1)

local colors = {
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,128,0),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,255,255),
	Color3.fromRGB(0,128,255),
	Color3.fromRGB(255,0,255)
}

local function rainbow()
	while neonText.Visible do
		for _,c in ipairs(colors) do
			TweenService:Create(neonText, TweenInfo.new(0.4), {TextColor3 = c}):Play()
			TweenService:Create(stroke, TweenInfo.new(0.4), {Color = c}):Play()
			task.wait(0.4)
		end
	end
end

-- Dòng “Đã gửi tới...”
local bigCounter = Instance.new("TextLabel")
bigCounter.AnchorPoint = Vector2.new(0.5, 0.5)
bigCounter.Position = UDim2.fromScale(0.5, 0.45)
bigCounter.Size = UDim2.fromOffset(600, 80)
bigCounter.BackgroundTransparency = 1
bigCounter.Text = "Đã gửi tới 0 server"
bigCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
bigCounter.Font = Enum.Font.GothamBold
bigCounter.TextScaled = true
bigCounter.Visible = false
bigCounter.ZIndex = 20
bigCounter.Parent = gui
local stroke2 = Instance.new("UIStroke", bigCounter)
stroke2.Thickness = 2
stroke2.Color = Color3.fromRGB(0, 0, 0)

-- Nút chỉ ấn 1 lần
local clicked = false

button.MouseButton1Click:Connect(function()
	if clicked then return end
	clicked = true
	button.Active = false
	button.Text = "🟡 Pending.."
	statusLabel.Text = "status: 🟡 Pending.."
	bigCounter.Visible = true
	neonText.Visible = true
	TweenService:Create(neonText, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
	task.spawn(rainbow)

	local START, ENDV, DURATION = 1, 2100, 10
	local t0 = os.clock()
	local last = 0
	local hb
	hb = RunService.Heartbeat:Connect(function()
		local el = os.clock() - t0
		if el >= DURATION then
			bigCounter.Text = "Đã gửi tới 2100 server"
			if hb then hb:Disconnect() end
			task.delay(1, function()
				TweenService:Create(bigCounter, TweenInfo.new(1.5), {TextTransparency = 1}):Play()
				TweenService:Create(neonText, TweenInfo.new(1.5), {TextTransparency = 1}):Play()
			end)
			return
		end
		local val = START + math.floor((ENDV - START) * (el / DURATION))
		if val ~= last then
			last = val
			bigCounter.Text = "Đã gửi tới " .. val .. " server"
		end
	end)
end)
