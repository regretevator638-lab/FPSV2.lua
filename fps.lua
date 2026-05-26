-- [[ FLIGHT PANEL UI V2 - ADAPTIVE & DRAGGABLE & LOCKABLE ]] --
-- [[ โดยพี่ที่คุณก็รู้ว่าใคร :P ]] --
-- ABCD ABCD ABCD จัดให้ลากได้ ล็อคได้!!

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlightPanelGui_V2_Lockable"
ScreenGui.ResetOnSpawn = false

-- Asset ID สำหรับแม่กุญแจ (Roblox Free Icons)
local LOCKET_ICON = "rbxassetid://131665489" -- Locked
local UNLOCKET_ICON = "rbxassetid://131665407" -- Unlocked

-- เฟรมหลัก (Main Frame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.35, 0, 0.45, 0) -- ขนาดเริ่มต้น adaptive
MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0) 
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 20)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- จำเป็นเพื่อให้ UserInput Service ดักจับinputได้ถูกต้อง
MainFrame.Parent = ScreenGui

local UIConstraint = Instance.new("UISizeConstraint")
UIConstraint.MinSize = Vector2.new(250, 200)
UIConstraint.MaxSize = Vector2.new(800, 600)
UIConstraint.Parent = MainFrame

local Border = Instance.new("UIStroke")
Border.Name = "Border"
Border.Color = Color3.fromRGB(50, 255, 100)
Border.Thickness = 2
Border.Parent = MainFrame

-- แถบหัวข้อ (Title Bar) - สำหรับลาก
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0.8, -10, 1, 0) -- เหลือพื้นที่ด้านขวาสำหรับปุ่มล็อค
TitleLabel.Position = UDim2.new(0, 5, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "FLY Panel v3.0 [MOBILE]"
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 12
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left -- ชิดซ้าย
TitleLabel.Parent = TitleBar

-- ปุ่มล็อคกุญแจ (Lock Toggle Button)
local LockButton = Instance.new("ImageButton")
LockButton.Name = "LockButton"
LockButton.Size = UDim2.new(0, 20, 0, 20)
LockButton.Position = UDim2.new(1, -25, 0, 2.5) -- มุมขวาบน
LockButton.BackgroundTransparency = 1
LockButton.Image = UNLOCKET_ICON -- เริ่มต้นปลดล็อค
LockButton.ImageColor3 = Color3.new(1, 1, 1) -- สีขาว
LockButton.Parent = TitleBar

-- --- องค์ประกอบด้านซ้าย ---
-- (เหมือนเดิม ปรับขนาดนิดหน่อย)

local ScriptInputBox = Instance.new("TextBox")
ScriptInputBox.Name = "ScriptInputBox"
ScriptInputBox.Size = UDim2.new(0.45, 0, 0.35, 0)
ScriptInputBox.Position = UDim2.new(0.02, 0, 0.12, 0)
ScriptInputBox.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
ScriptInputBox.Text = ""
ScriptInputBox.PlaceholderText = "Enter script code (e.g., ABCD)..."
ScriptInputBox.Font = Enum.Font.Code
ScriptInputBox.TextSize = 10
ScriptInputBox.TextColor3 = Color3.new(1, 1, 1)
ScriptInputBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptInputBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptInputBox.ClearTextOnFocus = false
ScriptInputBox.Parent = MainFrame

local ConsoleLogFrame = Instance.new("ScrollingFrame")
ConsoleLogFrame.Name = "ConsoleLogFrame"
ConsoleLogFrame.Size = UDim2.new(0.45, 0, 0.35, 0)
ConsoleLogFrame.Position = UDim2.new(0.02, 0, 0.52, 0)
ConsoleLogFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
ConsoleLogFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
ConsoleLogFrame.ScrollBarThickness = 3
ConsoleLogFrame.Parent = MainFrame

local ConsoleText = Instance.new("TextLabel")
ConsoleText.Name = "ConsoleText"
ConsoleText.Size = UDim2.new(1, -6, 1, 0)
ConsoleText.Position = UDim2.new(0, 3, 0, 0)
ConsoleText.BackgroundTransparency = 1
ConsoleText.Text = "[FLY] V2 Lockable ready.\nABCD mode."
ConsoleText.Font = Enum.Font.Code
ConsoleText.TextSize = 9
ConsoleText.TextColor3 = Color3.new(1, 1, 1)
ConsoleText.TextXAlignment = Enum.TextXAlignment.Left
ConsoleText.TextYAlignment = Enum.TextYAlignment.Top
ConsoleText.Parent = ConsoleLogFrame

local ClearConsoleLeft = Instance.new("TextButton")
ClearConsoleLeft.Name = "ClearConsoleLeft"
ClearConsoleLeft.Size = UDim2.new(0, 60, 0, 18)
ClearConsoleLeft.Position = UDim2.new(0.02, 0, 0.9, 0)
ClearConsoleLeft.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
ClearConsoleLeft.Text = "Clear"
ClearConsoleLeft.Font = Enum.Font.GothamMedium
ClearConsoleLeft.TextSize = 9
ClearConsoleLeft.TextColor3 = Color3.new(1, 1, 1)
ClearConsoleLeft.Parent = MainFrame

-- --- องค์ประกอบด้านขวา ---
local RightGroup = Instance.new("Frame")
RightGroup.Name = "RightGroup"
RightGroup.Size = UDim2.new(0.45, 0, 0.8, 0)
RightGroup.Position = UDim2.new(0.53, 0, 0.12, 0)
RightGroup.BackgroundTransparency = 1
RightGroup.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 4)
UIList.Parent = RightGroup

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 10)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed"
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.TextSize = 10
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = RightGroup

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Size = UDim2.new(1, 0, 0, 8)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
SpeedSlider.Parent = RightGroup

local SpeedSliderBar = Instance.new("Frame")
SpeedSliderBar.Size = UDim2.new(0.6, 0, 1, 0)
SpeedSliderBar.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
SpeedSliderBar.Parent = SpeedSlider

local EnableFly = Instance.new("TextButton")
EnableFly.Size = UDim2.new(1, 0, 0, 18)
EnableFly.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
EnableFly.Text = "Enable Fly"
EnableFly.Font = Enum.Font.GothamMedium
EnableFly.TextSize = 10
EnableFly.TextColor3 = Color3.new(1, 1, 1)
EnableFly.Parent = RightGroup

local Settings = Instance.new("TextButton")
Settings.Size = UDim2.new(1, 0, 0, 18)
Settings.BackgroundColor3 = Color3.fromRGB(10, 15, 12)
Settings.Text = "Settings"
Settings.Font = Enum.Font.GothamMedium
Settings.TextSize = 10
Settings.TextColor3 = Color3.new(1, 1, 1)
Settings.Parent = RightGroup

-- --- องค์ประกอบสำหรับ RESIZE ---
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 12, 0, 12)
ResizeHandle.Position = UDim2.new(1, -12, 1, -12)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(50, 255, 100)
ResizeHandle.Text = "⌟"
ResizeHandle.Font = Enum.Font.GothamBlack
ResizeHandle.TextSize = 10
ResizeHandle.TextColor3 = Color3.fromRGB(10, 15, 12)
ResizeHandle.ZIndex = 5
ResizeHandle.Parent = MainFrame

-- จัดการ Hierarchy
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- [[ ระบบสคริปต์ควบคุม (ลาก & ล็อค & ย่อ) ]]
-- ==========================================

local UserInputService = game:GetService("UserInputService")

-- สถานะการล็อค
local isLocked = false -- เริ่มต้นปลดล็อค

-- 0. ฟังก์ชันล็อค/ปลดล็อค
LockButton.MouseButton1Click:Connect(function()
	isLocked = not isLocked
	
	if isLocked then
		LockButton.Image = LOCKET_ICON
		LockButton.ImageColor3 = Color3.fromRGB(50, 255, 100) -- เปลี่ยนเป็นสีเขียวเมื่อล็อค
		ConsoleText.Text = ConsoleText.Text .. "\n[FLY] Panel Locked."
	else
		LockButton.Image = UNLOCKET_ICON
		LockButton.ImageColor3 = Color3.new(1, 1, 1) -- สีขาวเมื่อปลดล็อค
		ConsoleText.Text = ConsoleText.Text .. "\n[FLY] Panel Unlocked."
	end
end)

-- 1. ระบบลากย้ายที่ (Dragging) - จิ้มที่ TitleBar
local draggingFrame = false
local dragStartPos = nil
local frameStartPos = nil

TitleBar.InputBegan:Connect(function(input)
	-- ถ้าล็อคอยู่ หรือไม่ใช่ Mouse1/Touch ก็ไม่ต้องลาก
	if isLocked then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFrame = true
		dragStartPos = input.Position
		frameStartPos = MainFrame.Position
	end
end)

-- 2. ระบบย่อ-ขยาย (Resizing) - จิ้มที่ ResizeHandle
local resizingFrame = false
local resizeStartPos = nil
local frameStartSize = nil

ResizeHandle.InputBegan:Connect(function(input)
	-- แม้จะล็อคลาก แต่ยังให้ย่อขยายได้ (ถ้าไม่ต้องการให้ย่อ ให้ใส่ `if isLocked then return end` ตรงนี้)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizingFrame = true
		resizeStartPos = input.Position
		frameStartSize = MainFrame.AbsoluteSize
	end
end)

-- จัดการ input จบสำหรับทั้งลากและขยาย
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFrame = false
		resizingFrame = false
	end
end)

-- จัดการการเคลื่อนที่
UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.TouchMove then
		-- จัดการการลากย้ายที่
		if draggingFrame and dragStartPos and frameStartPos and not isLocked then
			local delta = input.Position - dragStartPos
			MainFrame.Position = UDim2.new(
				frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X,
				frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y
			)
		-- จัดการการย่อ-ขยาย
		elseif resizingFrame and resizeStartPos and frameStartSize then
			local delta = input.Position - resizeStartPos
			local newSizeXOffset = frameStartSize.X + delta.X
			local newSizeYOffset = frameStartSize.Y + delta.Y
			
			MainFrame.Size = UDim2.new(
				0, newSizeXOffset,
				0, newSizeYOffset
			)
		end
	end
end)

-- --- ฟังก์ชันปุ่มพื้นฐาน ---
ClearConsoleLeft.MouseButton1Click:Connect(function()
	ConsoleText.Text = ""
end)

EnableFly.MouseButton1Click:Connect(function()
	ConsoleText.Text = ConsoleText.Text .. "\n[DEBUG] Fly Enabled (Sim)."
end)
