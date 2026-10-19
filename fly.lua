local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local speaker = Players.LocalPlayer

-- ลบ UI เก่าหากรันซ้ำ
local oldUI = CoreGui:FindFirstChild("SmoothSeatFlyUI_Speed") or speaker.PlayerGui:FindFirstChild("SmoothSeatFlyUI_Speed")
if oldUI then oldUI:Destroy() end

-- 1. สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmoothSeatFlyUI_Speed"
screenGui.ResetOnSpawn = false

pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = speaker:WaitForChild("PlayerGui") end

-- 2. สร้าง Main Frame (กรอบหน้าต่างหลัก)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 180, 0, 105)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 70)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- 3. ปุ่ม Toggle Fly
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(1, -16, 0, 40)
flyButton.Position = UDim2.new(0, 8, 0, 8)
flyButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 15
flyButton.Font = Enum.Font.SourceSansBold
flyButton.Text = "FLY : OFF"
flyButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = flyButton

-- 4. กรอบส่วนปรับ Speed
local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Size = UDim2.new(1, -16, 0, 40)
speedFrame.Position = UDim2.new(0, 8, 0, 56)
speedFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
speedFrame.BorderSizePixel = 0
speedFrame.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 50, 1, 0)
speedLabel.Position = UDim2.new(0, 8, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "SPEED:"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
speedLabel.TextSize = 13
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

-- ช่องกรอกเลข Speed
local speedInput = Instance.new("TextBox")
speedInput.Name = "SpeedInput"
speedInput.Size = UDim2.new(0, 50, 0, 26)
speedInput.Position = UDim2.new(0, 60, 0.5, -13)
speedInput.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.TextSize = 14
speedInput.Font = Enum.Font.SourceSansBold
speedInput.Text = "60"
speedInput.ClearTextOnFocus = false
speedInput.Parent = speedFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = speedInput

-- ปุ่มลด Speed (-)
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 22, 0, 26)
minusBtn.Position = UDim2.new(0, 114, 0.5, -13)
minusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextSize = 16
minusBtn.Font = Enum.Font.SourceSansBold
minusBtn.Text = "-"
minusBtn.Parent = speedFrame

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 4)
minusCorner.Parent = minusBtn

-- ปุ่มเพิ่ม Speed (+)
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 22, 0, 26)
plusBtn.Position = UDim2.new(0, 139, 0.5, -13)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextSize = 16
plusBtn.Font = Enum.Font.SourceSansBold
plusBtn.Text = "+"
plusBtn.Parent = speedFrame

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 4)
plusCorner.Parent = plusBtn

---------------------------------------------------------
-- ระบบการทำงาน (Logic)
---------------------------------------------------------
local isFlyActive = false
local CFloop = nil
local CFspeed = 60

local function setSpeed(newSpeed)
	newSpeed = tonumber(newSpeed) or CFspeed
	if newSpeed < 1 then newSpeed = 1 end
	if newSpeed > 500 then newSpeed = 500 end
	CFspeed = newSpeed
	speedInput.Text = tostring(CFspeed)
end

speedInput.FocusLost:Connect(function()
	setSpeed(speedInput.Text)
end)

minusBtn.MouseButton1Click:Connect(function()
	setSpeed(CFspeed - 10)
end)

plusBtn.MouseButton1Click:Connect(function()
	setSpeed(CFspeed + 10)
end)

local function stopFly()
	isFlyActive = false
	flyButton.Text = "FLY : OFF"
	flyButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	
	if CFloop then 
		CFloop:Disconnect() 
		CFloop = nil
	end
	
	local char = speaker.Character
	if char then
		local humanoid = char:FindFirstChildOfClass('Humanoid')
		if humanoid then humanoid.PlatformStand = false end
		
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.AssemblyLinearVelocity = Vector3.zero
				part.AssemblyAngularVelocity = Vector3.zero
			end
		end
	end
end

local function startFly()
	local char = speaker.Character or speaker.CharacterAdded:Wait()
	local humanoid = char:FindFirstChildOfClass('Humanoid')
	if not humanoid then return end
	
	isFlyActive = true
	flyButton.Text = "FLY : ON"
	flyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	
	if CFloop then CFloop:Disconnect() end
	
	CFloop = RunService.PreSimulation:Connect(function(deltaTime)
		if not speaker.Character then
			stopFly()
			return
		end
		
		local currentHum = speaker.Character:FindFirstChildOfClass('Humanoid')
		local hrp = speaker.Character:FindFirstChild("HumanoidRootPart")
		if not currentHum or not hrp or currentHum.Health <= 0 then
			stopFly()
			return
		end
		
		local camera = workspace.CurrentCamera
		local moveDirection = currentHum.MoveDirection
		
		local targetPart = (currentHum.Sit and currentHum.SeatPart) or hrp
		
		if currentHum.Sit then
			currentHum.PlatformStand = false
		else
			currentHum.PlatformStand = true
		end
		
		if moveDirection.Magnitude > 0 then
			local cameraCFrame = camera.CFrame
			local lookDir = cameraCFrame.LookVector
			local rightDir = cameraCFrame.RightVector
			
			-- คำนวณทิศทางเดินหน้า-ถอยหลัง ซ้าย-ขวา แบบตรงเป๊ะ ไม่เอียง
			local finalDirection = (rightDir * moveDirection.X) + (lookDir * -moveDirection.Z)
			
			targetPart.AssemblyLinearVelocity = finalDirection.Unit * CFspeed
		else
			targetPart.AssemblyLinearVelocity = Vector3.zero
		end
		
		targetPart.AssemblyAngularVelocity = Vector3.zero
	end)
end

flyButton.MouseButton1Click:Connect(function()
	if isFlyActive then
		stopFly()
	else
		startFly()
	end
end)
