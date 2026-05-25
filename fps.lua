-- รันใน Executor
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MatrixKeySystem"

-- คีย์ 10 ชุด (สุ่ม)
local keys = {}
local usedKeys = {}
local keyExpiry = {} -- เก็บเวลาหมดอายุ

local function generateKeys()
    local charset = "ABCDEF0123456789"
    for i = 1, 10 do
        local key = ""
        for j = 1, 6 do key = key .. charset:sub(math.random(1, #charset), math.random(1, #charset)) end
        table.insert(keys, key)
    end
end
generateKeys()

-- สร้าง UI
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 255, 0)

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.8, 0, 0.15, 0)
input.Position = UDim2.new(0.1, 0, 0.1, 0)
input.PlaceholderText = "Enter Key"
input.TextColor3 = Color3.fromRGB(0, 255, 0)
input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.8, 0, 0.15, 0)
btn.Position = UDim2.new(0.1, 0, 0.3, 0)
btn.Text = "VALIDATE"

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0.1, 0)
status.Position = UDim2.new(0, 0, 0.5, 0)
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Text = "Keys: (Check Output/Console)"

-- พิมพ์คีย์ออกมาใน Console (กด F9 ดูได้)
for i, k in pairs(keys) do
    print("KEY " .. i .. ": " .. k)
end

-- Logic เช็คคีย์
btn.MouseButton1Click:Connect(function()
    local entered = input.Text
    local found = false
    
    for _, k in pairs(keys) do
        if entered == k then
            if usedKeys[k] then
                status.Text = "Key already used!"
                return
            end
            
            -- คีย์ถูกต้อง เริ่มนับเวลา 10 นาที
            usedKeys[k] = true
            keyExpiry[k] = tick() + 600 -- 600 วินาที = 10 นาที
            status.Text = "Access Granted! Time: 10:00"
            found = true
            break
        end
    end
    
    if not found then status.Text = "Invalid Key" end
end)

-- ระบบนับถอยหลัง
RunService.RenderStepped:Connect(function()
    for k, expiry in pairs(keyExpiry) do
        local remaining = expiry - tick()
        if remaining > 0 then
            local mins = math.floor(remaining / 60)
            local secs = math.floor(remaining % 60)
            status.Text = string.format("Time Left: %02d:%02d", mins, secs)
        else
            status.Text = "Key Expired!"
            keyExpiry[k] = nil
        end
    end
end)
