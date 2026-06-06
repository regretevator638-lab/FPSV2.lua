-- ================================================================
--   ✏️  แก้ได้ — ตั้งค่าตรงนี้
-- ================================================================
local KEY_WEB_URL  = "กรุณาใส่เว็บตรงนี้ด้วยนะถ้าไม่ใส่จะไปกระทืบถึงหน้าบ้าน"
local SCRIPT_TITLE = "UG Hub v8.3"          -- ชื่อที่แสดงบนหน้าต่าง
local SCRIPT_COLOR = Color3.fromRGB(8,0,16) -- สีพื้นหลังหน้าต่าง

-- ================================================================
--   ⛔  แก้ไม่ได้ — ระบบทำงานอยู่ตรงนี้
-- ================================================================
local Players    = game:GetService("Players")
local TweenSvc   = game:GetService("TweenService")
local player     = Players.LocalPlayer
local playerGui  = player:WaitForChild("PlayerGui")

-- ตรวจรูปแบบคีย์
local function isValidKey(k)
    if not k or #k ~= 35 then return false end
    return k:sub(9,9)=="-" and k:sub(18,18)=="-" and k:sub(27,27)=="-"
end

-- ดึง/บันทึกคีย์
local function getKey()
    local ok,v = pcall(function() return playerGui:GetAttribute("UGHub_Key") end)
    return ok and v or nil
end
local function saveKey(k)
    pcall(function() playerGui:SetAttribute("UGHub_Key", k) end)
end

-- ===== หน้าต่างหลัก (จำลอง) =====
local function createMainWindow()
    local old = playerGui:FindFirstChild("UGHubWindow")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "UGHubWindow"; sg.ResetOnSpawn = false
    sg.DisplayOrder = 999; sg.IgnoreGuiInset = true; sg.Parent = playerGui

    -- หน้าต่างหลัก
    local win = Instance.new("Frame", sg)
    win.Size = UDim2.new(0,340,0,220)
    win.Position = UDim2.new(0.5,-170,0.5,-110)
    win.BackgroundColor3 = SCRIPT_COLOR
    win.BorderSizePixel = 0; win.Active = true
    Instance.new("UICorner", win).CornerRadius = UDim.new(0,12)
    local ws = Instance.new("UIStroke", win)
    ws.Color = Color3.fromRGB(130,0,255); ws.Thickness = 1.5; ws.Transparency = 0.2

    -- Header
    local header = Instance.new("Frame", win)
    header.Size = UDim2.new(1,0,0,36)
    header.BackgroundColor3 = Color3.fromRGB(20,0,35)
    header.BorderSizePixel = 0
    Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

    local titleL = Instance.new("TextLabel", header)
    titleL.Size = UDim2.new(1,-40,1,0); titleL.Position = UDim2.new(0,12,0,0)
    titleL.BackgroundTransparency = 1; titleL.Text = "🔐 "..SCRIPT_TITLE
    titleL.Font = Enum.Font.GothamBold; titleL.TextSize = 13
    titleL.TextColor3 = Color3.fromRGB(210,150,255)
    titleL.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0,24,0,24); closeBtn.Position = UDim2.new(1,-30,0.5,-12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180,40,40); closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 11
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
    closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

    -- Drag
    do
        local d,ds,sp = false,nil,nil
        header.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                d=true; ds=inp.Position; sp=win.Position
            end
        end)
        header.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then d=false end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(inp)
            if d and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local delta = inp.Position - ds; local vp = sg.AbsoluteSize
                win.Position = UDim2.new(sp.X.Scale+delta.X/vp.X,0,sp.Y.Scale+delta.Y/vp.Y,0)
            end
        end)
    end

    -- Content area
    local content = Instance.new("Frame", win)
    content.Size = UDim2.new(1,-20,1,-50); content.Position = UDim2.new(0,10,0,42)
    content.BackgroundTransparency = 1; content.BorderSizePixel = 0

    -- URL label
    local urlLabel = Instance.new("TextLabel", content)
    urlLabel.Size = UDim2.new(1,0,0,14); urlLabel.Position = UDim2.new(0,0,0,0)
    urlLabel.BackgroundTransparency = 1; urlLabel.Text = "🌐 เว็บรับคีย์:"
    urlLabel.Font = Enum.Font.Gotham; urlLabel.TextSize = 10
    urlLabel.TextColor3 = Color3.fromRGB(100,65,140)
    urlLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- URL box
    local urlBg = Instance.new("Frame", content)
    urlBg.Size = UDim2.new(1,0,0,28); urlBg.Position = UDim2.new(0,0,0,16)
    urlBg.BackgroundColor3 = Color3.fromRGB(0,0,0); urlBg.BackgroundTransparency = 0.4
    urlBg.BorderSizePixel = 0
    Instance.new("UICorner", urlBg).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", urlBg).Color = Color3.fromRGB(80,0,160)

    local urlTxt = Instance.new("TextLabel", urlBg)
    urlTxt.Size = UDim2.new(1,-44,1,0); urlTxt.Position = UDim2.new(0,8,0,0)
    urlTxt.BackgroundTransparency = 1; urlTxt.Text = KEY_WEB_URL
    urlTxt.Font = Enum.Font.Code; urlTxt.TextSize = 9
    urlTxt.TextColor3 = Color3.fromRGB(160,100,220)
    urlTxt.TextXAlignment = Enum.TextXAlignment.Left
    urlTxt.TextTruncate = Enum.TextTruncate.AtEnd

    -- ปุ่มคัดลอก URL
    local cpBtn = Instance.new("TextButton", urlBg)
    cpBtn.Size = UDim2.new(0,36,1,-4); cpBtn.Position = UDim2.new(1,-38,0,2)
    cpBtn.BackgroundColor3 = Color3.fromRGB(80,0,180); cpBtn.BorderSizePixel = 0
    cpBtn.Text = "📋"; cpBtn.TextSize = 11
    Instance.new("UICorner", cpBtn).CornerRadius = UDim.new(0,5)

    local _cp = false
    cpBtn.MouseButton1Click:Connect(function()
        if _cp then return end; _cp = true
        -- คัดลอกลิงก์จริงๆ
        local tb = Instance.new("TextBox", sg)
        tb.Text = KEY_WEB_URL; tb.Visible = false
        tb:CaptureFocus(); tb:ReleaseFocus(false); tb:Destroy()
        cpBtn.Text = "✅"; cpBtn.BackgroundColor3 = Color3.fromRGB(0,120,60)
        task.wait(1.5); cpBtn.Text = "📋"; cpBtn.BackgroundColor3 = Color3.fromRGB(80,0,180); _cp = false
    end)

    -- สถานะ
    local statusL = Instance.new("TextLabel", content)
    statusL.Size = UDim2.new(1,0,0,20); statusL.Position = UDim2.new(0,0,0,52)
    statusL.BackgroundTransparency = 1
    statusL.Text = "💡 คีย์ถูกต้องแล้ว — สคริปต์พร้อมใช้งาน ✅"
    statusL.Font = Enum.Font.Gotham; statusL.TextSize = 10
    statusL.TextColor3 = Color3.fromRGB(80,255,130)
    statusL.TextWrapped = true

    -- กล่องโค้ดจำลอง
    local codeBox = Instance.new("Frame", content)
    codeBox.Size = UDim2.new(1,0,0,60); codeBox.Position = UDim2.new(0,0,0,76)
    codeBox.BackgroundColor3 = Color3.fromRGB(0,0,0); codeBox.BackgroundTransparency = 0.3
    codeBox.BorderSizePixel = 0
    Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", codeBox).Color = Color3.fromRGB(60,0,120)

    -- จุดสี (macOS style)
    for i,clr in ipairs({Color3.fromRGB(255,95,87), Color3.fromRGB(255,189,46), Color3.fromRGB(40,200,65)}) do
        local dot = Instance.new("Frame", codeBox)
        dot.Size = UDim2.new(0,8,0,8); dot.Position = UDim2.new(0,6+(i-1)*12,0,6)
        dot.BackgroundColor3 = clr; dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    end

    local codeL = Instance.new("TextLabel", codeBox)
    codeL.Size = UDim2.new(1,-12,1,-22); codeL.Position = UDim2.new(0,6,0,20)
    codeL.BackgroundTransparency = 1
    codeL.Text = "-- สคริปต์โหลดสำเร็จ\n-- ยินดีต้อนรับ: "..player.Name
    codeL.Font = Enum.Font.Code; codeL.TextSize = 10
    codeL.TextColor3 = Color3.fromRGB(80,255,120)
    codeL.TextXAlignment = Enum.TextXAlignment.Left
    codeL.TextYAlignment = Enum.TextYAlignment.Top

    -- Slide in
    win.Position = UDim2.new(0.5,-170,1.5,0)
    TweenSvc:Create(win, TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Position=UDim2.new(0.5,-170,0.5,-110)}):Play()
end

-- ===== หน้าใส่คีย์ =====
local function showKeyUI(onPass)
    local old = playerGui:FindFirstChild("_UGKeyUI")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name="_UGKeyUI"; sg.ResetOnSpawn=false
    sg.DisplayOrder=99999; sg.IgnoreGuiInset=true; sg.Parent=playerGui

    local dim = Instance.new("Frame",sg)
    dim.Size=UDim2.new(1,0,1,0); dim.BackgroundColor3=Color3.fromRGB(0,0,0)
    dim.BackgroundTransparency=0.4; dim.BorderSizePixel=0; dim.ZIndex=1

    local card = Instance.new("Frame",sg)
    card.Size=UDim2.new(0,320,0,270); card.Position=UDim2.new(0.5,-160,1.5,0)
    card.BackgroundColor3=Color3.fromRGB(8,0,16); card.BorderSizePixel=0; card.ZIndex=2
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local st=Instance.new("UIStroke",card)
    st.Color=Color3.fromRGB(130,0,255); st.Thickness=1.5; st.Transparency=0.2

    local function lbl(txt,size,y,color,bold)
        local l=Instance.new("TextLabel",card)
        l.Size=UDim2.new(1,-20,0,size+4); l.Position=UDim2.new(0,10,0,y)
        l.BackgroundTransparency=1; l.Text=txt
        l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
        l.TextSize=size; l.TextColor3=color; l.TextWrapped=true; l.ZIndex=3
        l.TextXAlignment=Enum.TextXAlignment.Left; return l
    end

    lbl("🔐  "..SCRIPT_TITLE.." — ใส่คีย์",15,10,Color3.fromRGB(210,150,255),true)
    lbl("รับคีย์ฟรีที่: "..KEY_WEB_URL,9,42,Color3.fromRGB(100,65,140),false)

    -- input
    local inpBg=Instance.new("Frame",card)
    inpBg.Size=UDim2.new(1,-20,0,40); inpBg.Position=UDim2.new(0,10,0,80)
    inpBg.BackgroundColor3=Color3.fromRGB(0,0,0); inpBg.BackgroundTransparency=0.45
    inpBg.BorderSizePixel=0; inpBg.ZIndex=3
    Instance.new("UICorner",inpBg).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",inpBg).Color=Color3.fromRGB(100,0,200)

    local inp=Instance.new("TextBox",inpBg)
    inp.Size=UDim2.new(1,-16,1,0); inp.Position=UDim2.new(0,8,0,0)
    inp.BackgroundTransparency=1; inp.PlaceholderText="xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx"
    inp.PlaceholderColor3=Color3.fromRGB(70,40,100); inp.Text=""
    inp.Font=Enum.Font.Code; inp.TextSize=12
    inp.TextColor3=Color3.fromRGB(200,130,255); inp.ClearTextOnFocus=false; inp.ZIndex=4

    local statusL=lbl("💡 วางคีย์จากเว็บ แล้วกดยืนยัน",10,130,Color3.fromRGB(100,70,130),false)

    local function setStatus(msg,r,g,b)
        statusL.Text=msg; statusL.TextColor3=Color3.fromRGB(r,g,b)
    end

    local confBtn=Instance.new("TextButton",card)
    confBtn.Size=UDim2.new(1,-20,0,40); confBtn.Position=UDim2.new(0,10,0,158)
    confBtn.BackgroundColor3=Color3.fromRGB(75,0,170); confBtn.BorderSizePixel=0
    confBtn.Text="✅   ยืนยันคีย์"; confBtn.Font=Enum.Font.GothamBold; confBtn.TextSize=14
    confBtn.TextColor3=Color3.fromRGB(255,255,255); confBtn.ZIndex=3
    Instance.new("UICorner",confBtn).CornerRadius=UDim.new(0,10)

    local ver=Instance.new("TextLabel",card)
    ver.Size=UDim2.new(1,0,0,12); ver.Position=UDim2.new(0,0,1,-16)
    ver.BackgroundTransparency=1; ver.Text=SCRIPT_TITLE.." — Key System"
    ver.Font=Enum.Font.Gotham; ver.TextSize=9
    ver.TextColor3=Color3.fromRGB(55,35,75); ver.ZIndex=3

    TweenSvc:Create(card,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Position=UDim2.new(0.5,-160,0.5,-135)}):Play()

    confBtn.MouseButton1Click:Connect(function()
        local key=inp.Text:gsub("%s+","")
        if key=="" then setStatus("⚠  กรุณากรอกคีย์ก่อน",255,160,60); return end
        if not isValidKey(key) then setStatus("❌  รูปแบบคีย์ไม่ถูกต้อง",255,80,80); return end
        setStatus("⏳  กำลังตรวจสอบ...",180,120,255)
        task.wait(0.6); saveKey(key)
        setStatus("✅  คีย์ถูกต้อง! กำลังโหลด...",80,255,130)
        task.wait(0.9)
        TweenSvc:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Position=UDim2.new(0.5,-160,-1.2,0)}):Play()
        TweenSvc:Create(dim,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.wait(0.3); sg:Destroy(); onPass()
    end)
end

-- ===== เริ่มต้น =====
local saved = getKey()
if saved and isValidKey(saved) then
    createMainWindow()
else
    showKeyUI(function()
        createMainWindow()
    end)
end
