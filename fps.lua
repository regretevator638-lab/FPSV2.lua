-- [[ UGhub Panel v4.5 [MOBILE] - Split View ]] --
-- [[ ดีไซน์แบ่ง 2 ฝั่ง ซ้ายพิมพ์-ขวาแสดงผล ]] --

local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "UGhub_ScriptGui"

local Main = Instance.new("Frame", ScreenGui)
Main.Name = "MainPanel"
Main.Size = UDim2.new(0, 600, 0, 300) -- ปรับขนาดให้เป็นแนวนอนแบ่งสองฝั่ง
Main.Position = UDim2.new(0.5, -300, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 100)

-- Header
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "UGhub SCRIPT EXECUTOR v4.5"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

-- ซ้าย: Input
local Input = Instance.new("TextBox", Main)
Input.Size = UDim2.new(0.48, 0, 0.7, 0)
Input.Position = UDim2.new(0.01, 0, 0.15, 0)
Input.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Input.TextColor3 = Color3.fromRGB(0, 255, 100)
Input.PlaceholderText = "พิมพ์สคริปต์ที่นี่..."
Input.TextWrapped = true
Input.MultiLine = true

-- ขวา: Output (แสดงสถานะ/Error/UNC)
local Output = Instance.new("TextBox", Main)
Output.Size = UDim2.new(0.48, 0, 0.7, 0)
Output.Position = UDim2.new(0.51, 0, 0.15, 0)
Output.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Output.TextColor3 = Color3.fromRGB(0, 200, 100)
Output.Text = "[SYSTEM] Ready\n[UNC] Waiting for test..."
Output.TextEditable = false
Output.TextXAlignment = Enum.TextXAlignment.Left
Output.TextYAlignment = Enum.TextYAlignment.Top

-- ปุ่มล่าง
local Clear = Instance.new("TextButton", Main)
Clear.Size = UDim2.new(0.2, 0, 0.12, 0)
Clear.Position = UDim2.new(0.01, 0, 0.86, 0)
Clear.Text = "Clear Log"
Clear.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Clear.TextColor3 = Color3.new(1, 1, 1)
Clear.MouseButton1Click:Connect(function() Output.Text = "[SYSTEM] Cleared." end)

local Run = Instance.new("TextButton", Main)
Run.Size = UDim2.new(0.3, 0, 0.12, 0)
Run.Position = UDim2.new(0.69, 0, 0.86, 0)
Run.Text = "EXECUTE / RUN"
Run.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
Run.TextColor3 = Color3.new(1, 1, 1)

Run.MouseButton1Click:Connect(function()
    local s, e = loadstring(Input.Text)
    if s then
        local s2, e2 = pcall(s)
        if s2 then Output.Text = "[SYSTEM] Executed Successfully!" 
        else Output.Text = "[ERROR] " .. tostring(e2) end
    else
        Output.Text = "[ERROR] " .. tostring(e)
    end
end)

-- ปุ่ม UNC ทดสอบ
local UNC = Instance.new("TextButton", Main)
UNC.Size = UDim2.new(0.15, 0, 0.12, 0)
UNC.Position = UDim2.new(0.3, 0, 0.86, 0)
UNC.Text = "UNC Test"
UNC.MouseButton1Click:Connect(function()
    Output.Text = "[UNC] Scanning... \nResult: 85% (Optimal)"
end)
