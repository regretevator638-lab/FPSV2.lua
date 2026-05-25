-- === ส่วนที่ 1: ตั้งค่าคีย์ ===
local validKeys = {
    ["GEN-KEY-001"] = true,
    ["GEN-KEY-002"] = true,
    ["GEN-KEY-003"] = true
}

-- === ส่วนที่ 2: ระบบ UI ===
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.new(0, 0, 0)

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1, 0, 0.5, 0)
input.PlaceholderText = "ใส่คีย์ที่นี่"
input.Parent = frame

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, 0, 0.5, 0)
btn.Position = UDim2.new(0, 0, 0.5, 0)
btn.Text = "เริ่มทำงาน"
btn.Parent = frame

-- === ส่วนที่ 3: ระบบเช็คและรัน ===
btn.MouseButton1Click:Connect(function()
    if validKeys[input.Text] then
        print("คีย์ถูกต้อง กำลังสั่งรันสคริปต์...")
        gui:Destroy() -- ลบ UI ทิ้งก่อน
        
        -- บังคับรันแบบดึงจากภายนอก
        local success, err = pcall(function()
            -- !!! ก๊อปปี้โค้ดสคริปต์หลักของคุณมาวางตรงนี้ !!!
            -- เช่น loadstring(game:HttpGet("..."))()
        end)
        
        if not success then
            warn("สคริปต์หลักติดปัญหา: " .. tostring(err))
        end
    else
        input.Text = "คีย์ผิด!"
    end
end)
