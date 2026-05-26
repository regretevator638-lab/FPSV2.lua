-- [[ ABCD PURE SCRIPT EXECUTOR UI ]] --
-- [[ คุณสมบัติ: ลากได้, ล็อคได้, ย่อขยายมุมได้จริง 100% บนมือถือ ]] --

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ABCD_PureExecutorGui"
ScreenGui.ResetOnSpawn = false

-- ไอคอนแม่กุญแจสำหรับล็อคหน้าจอ
local LOCKET_ICON = "rbxassetid://131665489" 
local UNLOCKET_ICON = "rbxassetid://131665407" 

-- ==========================================
-- [[ 1. ตัวโครงแผงหลัก (Main Window) ]]
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.5, 0, 0.55, 0) -- ขนาดเริ่มต้นพอดีจอแลนด์สเคปมือถือ
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0) 
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 16, 15)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true 
MainFrame.Parent = ScreenGui

-- ข้อจำกัดขนาด (กันไม่ให้ย่อจนเล็กเกินไปจนมองไม่เห็นปุ่ม)
local UIConstraint = Instance.new("UISizeConstraint")
UIConstraint.MinSize = Vector2.new(300, 180)
UIConstraint.MaxSize = Vector2.new(1000, 700)
UIConstraint.Parent = MainFrame

-- เส้นขอบเรืองแสงสีเขียว
local Border = Instance.new("UIStroke")
Border.Color = Color3.fromRGB(50, 255, 120)
Border.Thickness = 2
Border.Parent = MainFrame

-- ==========================================
-- [[ 2. แถบหัวข้อด้านบน (Title Bar & Lock) ]]
-- ==========================================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(8, 10, 9)
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ABCD SCRIPT EXECUTOR v1.0"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 11
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- ปุ่มแม่กุญแจ ล็อค/ปลดล็อค การลากหน้าจอ
local LockButton = Instance.new("ImageButton")
LockButton.Name = "LockButton"
LockButton.Size = UDim2.new(0, 16, 0, 16)
LockButton.Position = UDim2.new(1, -22, 0, 4.5) 
LockButton.BackgroundTransparency = 1
LockButton.Image = UNLOCKET_ICON -- เริ่มต้นแบบปลดล็อค ลากได้
LockButton.ImageColor3 = Color3.new(1, 1, 1)
LockButton.Parent = TitleBar

-- ==========================================
-- [[ 3. พื้นที่เขียนสคริปต์ & คอนโซล (แบ่งซ้าย-ขวา) ]]
-- ==========================================

-- ฝั่งซ้าย: ช่องพิมพ์โค้ด (Script Editor)
local ScriptInputBox = Instance.new("TextBox")
ScriptInputBox.Name = "ScriptInputBox"
ScriptInputBox.Size = UDim2.new(0.47, 0, 0.68, 0)
ScriptInputBox.Position = UDim2.new(0.02, 0, 0.15, 0)
ScriptInputBox.BackgroundColor3 = Color3.fromRGB(5, 7, 6)
ScriptInputBox.Text = ""
ScriptInputBox.PlaceholderText = "-- วางหรือพิมพ์สคริปต์ Lua ตรงนี้...\n-- ตัวอย่าง: print('ABCD Active!')"
ScriptInputBox.Font = Enum.Font.Code
ScriptInputBox.TextSize = 10
ScriptInputBox.TextColor3 = Color3.fromRGB(240, 240, 240)
ScriptInputBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptInputBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptInputBox.ClearTextOnFocus = false
ScriptInputBox.MultiLine = true -- พิมพ์ได้หลายบรรทัด
ScriptInputBox.Parent = MainFrame

local EditorStroke = Instance.new("UIStroke")
EditorStroke.Color = Color3.fromRGB(40, 50, 45)
EditorStroke.Thickness = 1
EditorStroke.Parent = ScriptInputBox

-- ฝั่งขวา: ช่องแสดงสถานะ/ผลลัพธ์ (Console Output)
local ConsoleLogFrame = Instance.new("ScrollingFrame")
ConsoleLogFrame.Name = "ConsoleLogFrame"
ConsoleLogFrame.Size = UDim2.new(0.47, 0, 0.68, 0)
ConsoleLogFrame.Position = UDim2.new(0.51, 0, 0.15, 0)
ConsoleLogFrame.BackgroundColor3 = Color3.fromRGB(5, 7, 6)
ConsoleLogFrame.CanvasSize = UDim2.new(0, 0, 5, 0) 
ConsoleLogFrame.ScrollBarThickness = 3
ConsoleLogFrame.Parent = MainFrame

local ConsoleStroke = Instance.new("UIStroke")
ConsoleStroke.Color = Color3.fromRGB(40, 50, 45)
ConsoleStroke.Thickness = 1
ConsoleStroke.Parent = ConsoleLogFrame

local ConsoleText = Instance.new("TextLabel")
ConsoleText.Size = UDim2.new(1, -6, 1, 0)
ConsoleText.Position = UDim2.new(0, 4, 0, 2)
ConsoleText.BackgroundTransparency = 1
ConsoleText.Text = "[SYSTEM] ABCD Executor Environment Ready.\n[SYSTEM] Waiting for script execution..."
ConsoleText.Font = Enum.Font.Code
ConsoleText.TextSize = 9
ConsoleText.TextColor3 = Color3.fromRGB(140, 200, 140)
ConsoleText.TextXAlignment = Enum.TextXAlignment.Left
ConsoleText.TextYAlignment = Enum.TextYAlignment.Top
ConsoleText.Parent = ConsoleLogFrame

-- ==========================================
-- [[ 4. ปุ่มกดและแถบสถานะด้านล่าง ]]
-- ==========================================

-- ปุ่มบอกอะไรสักอย่างตรงซ้ายล่าง (ปุ่มเคลียร์ Log คอนโซล)
local ClearConsoleButton = Instance.new("TextButton")
ClearConsoleButton.Name = "ClearConsoleButton"
ClearConsoleButton.Size = UDim2.new(0.2, 0, 0, 22)
ClearConsoleButton.Position = UDim2.new(0.02, 0, 0.86, 0) -- อยู่ซ้ายล่างสุด
ClearConsoleButton.BackgroundColor3 = Color3.fromRGB(25, 35, 30)
ClearConsoleButton.Text = "Clear Log"
ClearConsoleButton.Font = Enum.Font.GothamMedium
ClearConsoleButton.TextSize = 10
ClearConsoleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ClearConsoleButton.Parent = MainFrame

-- ข้อความบอกสถานะข้างๆ ปุ่มซ้ายล่าง
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.25, 0, 0, 22)
StatusLabel.Position = UDim2.new(0.24, 0, 0.86, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "● Status: Active"
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 9
StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 120)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

-- ปุ่ม RUN (ขวาล่าง ถัดเข้ามาจากมุมขยาย)
local RunButton = Instance.new("TextButton")
RunButton.Name = "RunButton"
RunButton.Size = UDim2.new(0.25, 0, 0, 22)
RunButton.Position = UDim2.new(0.70, 0, 0.86, 0) -- ขวาล่าง
RunButton.BackgroundColor3 = Color3.fromRGB(0, 120, 50)
RunButton.Text = "EXECUTE / RUN"
RunButton.Font = Enum.Font.GothamBold
RunButton.TextSize = 10
RunButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RunButton.Parent = MainFrame

local RunStroke = Instance.new("UIStroke")
RunStroke.Color = Color3.fromRGB(50, 255, 120)
RunStroke.Thickness = 1
RunStroke.Parent = RunButton

-- **ปุ่มขยับตรงมุมขวาล่างสุด (Resize Handle) ที่ทำให้ใช้ได้จริง**
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 16, 0, 16)
ResizeHandle.Position = UDim2.new(1, -16, 1, -16) -- มุมขวาล่างสุดเป๊ะๆ
ResizeHandle.BackgroundColor3 = Color3.fromRGB(50, 255, 120)
ResizeHandle.BackgroundTransparency = 0.3
ResizeHandle.Text = "⌟"
ResizeHandle.Font = Enum.Font.GothamBlack
ResizeHandle.TextSize = 12
ResizeHandle.TextColor3 = Color3.fromRGB(10, 15, 12)
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = MainFrame

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- [[ 5. ระบบควบคุมสคริปต์ (ลาก, ล็อค, ขยับมุม) ]]
-- ==========================================

local UserInputService = game:GetService("UserInputService")
local isLocked = false -- สถานะการล็อคหน้าจอ

-- ระบบเปิด-ปิด ล็อคหน้าจอ
LockButton.MouseButton1Click:Connect(function()
	isLocked = not isLocked
	if isLocked then
		LockButton.Image = LOCKET_ICON
		LockButton.ImageColor3 = Color3.fromRGB(50, 255, 120) -- กุญแจเขียวเมื่อล็อค
		ConsoleText.Text = ConsoleText.Text .. "\n[SYSTEM] Dragging Locked."
	else
		LockButton.Image = UNLOCKET_ICON
		LockButton.ImageColor3 = Color3.new(1, 1, 1) -- กุญแจขาวเมื่อปลดล็อค
		ConsoleText.Text = ConsoleText.Text .. "\n[SYSTEM] Dragging Unlocked."
	end
end)

-- ปุ่มซ้ายล่าง ทำหน้าที่เคลียร์ข้อความในหน้าต่างคอนโซล
ClearConsoleButton.MouseButton1Click:Connect(function()
	ConsoleText.Text = ""
end)

-- ปุ่ม RUN สั่งประมวลผลโค้ด Lua จริงดักจับข้อความพังด้วย pcall
RunButton.MouseButton1Click:Connect(function()
	local code = ScriptInputBox.Text
	if code == "" then
		string.format("")
		ConsoleText.Text = ConsoleText.Text .. "\n[ERROR] Textbox is empty! Type something."
		return
	end
	
	ConsoleText.Text = ConsoleText.Text .. "\n[EXECUTING] Running script code..."
	
	local success, result = pcall(function()
		local executable, err = loadstring(code)
		if executable then
			task.spawn(executable)
			return "Success"
		else
			return err or "Syntax Error"
		end
	end)
	
	if success and result == "Success" then
		string.format("")
		-- รันผ่านฉลุย
	else
		-- แสดงผลเมื่อโค้ดพังหรือทำงานผิดพลาด
		ConsoleText.Text = ConsoleText.Text .. "\n[ERR-LOG] " .. tostring(result)
	end
end)


-- ตัวแปรระบบสัมผัสและเมาส์สำหรับลากและขยายมุมหน้าจอ
local dragging, resizing = false, false
local dragStart, startPos, resizeStart, startSize

-- ดักจับการเริ่มลาก (TitleBar)
TitleBar.InputBegan:Connect(function(input)
	if isLocked then return end -- ถ้าระบบล็อคอยู่ ห้ามลากขยับ
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)

-- **ดักจับการเริ่มขยับย่อขยายมุมขวาล่าง (Resize Handle) - ใช้ได้จริงบนมือถือ**
ResizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		resizeStart = input.Position
		startSize = MainFrame.AbsoluteSize -- ดึงขนาดพิกเซลจริง ณ ตอนนั้นมาคำนวณ
		dragging = false -- กันไม่ให้ระบบลากทำงานซ้อนกัน
	end
end)

-- ดักจับการยกนิ้วขึ้น / ปล่อยเมาส์
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		resizing = false
	end
end)

-- อัปเดตตำแหน่งและการย่อขยายตามการเคลื่อนที่ของนิ้วหรือเมาส์
UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.TouchMove then
		-- ถ้ากำลังลากแผงควบคุม
		if dragging and not isLocked then
			local delta = input.Position - dragStart
			MainFrame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		-- **ถ้ากำลังขยับมุมย่อขยายหน้าจอ (คำนวณ Offset สดๆ ทำให้ขยับได้ลื่นไหลจริง)**
		elseif resizing then
			local delta = input.Position - resizeStart
			local newX = startSize.X + delta.X
			local newY = startSize.Y + delta.Y
			
			-- บังคับค่าขั้นต่ำอีกรอบในสคริปต์เพื่อความชัวร์ไม่ให้บีบจน UI หาย
			if newX < 300 then newX = 300 end
			if newY < 180 then newY = 180 end
			
			MainFrame.Size = UDim2.new(0, newX, 0, newY)
		end
	end
end)
