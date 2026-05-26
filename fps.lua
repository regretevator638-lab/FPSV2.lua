-- ใส่สคริปต์นี้ใน StarterCharacterScripts เพื่อให้ใช้งานได้ทันทีกับตัวละคร
local player = game.Players.LocalPlayer
local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ปรับแต่งค่าได้ตรงนี้
local flying = false
local speed = 100 -- ปรับความเร็วการบินที่นี่

local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.new(0, 0, 0)
bv.Parent = rootPart

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(0, 0, 0)
bg.P = 10000
bg.D = 100
bg.Parent = rootPart

-- ฟังก์ชันกดปุ่มเพื่อเริ่ม/หยุดบิน (ตัวอย่าง: กดปุ่ม 'F')
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F then
		flying = not flying
		
		if flying then
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			humanoid.PlatformStand = true
		else
			bv.MaxForce = Vector3.new(0, 0, 0)
			bg.MaxTorque = Vector3.new(0, 0, 0)
			humanoid.PlatformStand = false
		end
	end
end)

-- อัปเดตทิศทาง
game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		local camera = workspace.CurrentCamera
		bv.Velocity = camera.CFrame.LookVector * speed
		bg.CFrame = camera.CFrame
	end
end)
