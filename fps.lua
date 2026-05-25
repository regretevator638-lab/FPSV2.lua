local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AccessSystem"

-- ใส่คีย์ 3 ชุดที่นี่
local validKeys = {
    ["GEN-KEY-001"] = true,
    ["GEN-KEY-002"] = true,
    ["GEN-KEY-003"] = true
}

-- สร้าง UI
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.8, 0, 0.3, 0)
input.Position = UDim2.new(0.1, 0, 0.2, 0)
input.PlaceholderText = "Enter Access Key"
input.TextColor3 = Color3.fromRGB(0, 255, 0)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.8, 0, 0.3, 0)
btn.Position = UDim2.new(0.1, 0, 0.6, 0)
btn.Text = "ACTIVATE"
btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)

-- หน้าจอเวลาถอยหลัง
local timerLabel = Instance.new("TextLabel", gui)
timerLabel.Size = UDim2.new(0, 200, 0, 50)
timerLabel.Position = UDim2.new(0, 20, 0, 20)
timerLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
timerLabel.Visible = false

btn.MouseButton1Click:Connect(function()
    if validKeys[input.Text] then
        frame.Visible = false
        timerLabel.Visible = true
        
        -- เริ่มนับเวลา 10 นาที (600 วินาที)
        local timeRemaining = 600
        while timeRemaining > 0 do
            local mins = math.floor(timeRemaining / 60)
            local secs = timeRemaining % 60
            timerLabel.Text = string.format("Time Left: %02d:%02d", mins, secs)
            task.wait(1)
            timeRemaining = timeRemaining - 1
        end
        gui:Destroy() -- ปิดระบบเมื่อหมดเวลา
    else
        input.Text = "INVALID KEY"
    end
end)
