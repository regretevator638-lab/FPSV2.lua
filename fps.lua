-- ================================================================
--   ✏️  แก้ได้ — ตั้งค่าตรงนี้
-- ================================================================
local KEY_WEB_URL  = "https://regretevator638-lab.github.io/UG-HUB-GET-KEY/"
local SCRIPT_TITLE = "UG Hub v8.3"
local SCRIPT_COLOR = Color3.fromRGB(8,0,16)

-- ================================================================
--   ⛔  แก้ไม่ได้ — ระบบทำงานอยู่ตรงนี้
-- ================================================================
local Players    = game:GetService("Players")
local TweenSvc   = game:GetService("TweenService")
local HttpSvc    = game:GetService("HttpService")
local player     = Players.LocalPlayer
local playerGui  = player:WaitForChild("PlayerGui")

-- ตรวจรูปแบบคีย์ xxxx-xxxx-xxxx-TIMESTAMP
local function isValidKey(k)
    if not k then return false end
    local parts = k:split and k:split("-") or {}
    -- แยกด้วย pattern
    local p = {}
    for part in k:gmatch("[^%-]+") do table.insert(p, part) end
    if #p ~= 4 then return false end
    return #p[1]==8 and #p[2]==8 and #p[3]==8 and tonumber(p[4]) ~= nil
end

-- อ่านเวลาหมดอายุจากคีย์ (Unix seconds)
local function getExpFromKey(k)
    local p = {}
    for part in k:gmatch("[^%-]+") do table.insert(p, part) end
    if #p ~= 4 then return nil end
    return tonumber(p[4]) -- Unix timestamp seconds
end

-- ตรวจว่าคีย์หมดอายุหรือยัง
local function isKeyExpired(k)
    local exp = getExpFromKey(k)
    if not exp then return true end
    return os.time() > exp
end

-- ดึง/บันทึกคีย์ + เวลาหมดอายุ
local function getKeyData()
    local ok,v = pcall(function() return playerGui:GetAttribute("UGHub_KeyData") end)
    if not ok or not v then return nil end
    local ok2,data = pcall(function() return HttpSvc:JSONDecode(v) end)
    return ok2 and data or nil
end

local function saveKeyData(key)
    local exp = getExpFromKey(key) -- อ่าน expiry จากคีย์โดยตรง
    local ok,enc = pcall(function()
        return HttpSvc:JSONEncode({key=key, exp=exp})
    end)
    if ok then pcall(function() playerGui:SetAttribute("UGHub_KeyData", enc) end) end
end

-- คำนวณเวลาที่เหลือ
local function getTimeLeft(expireTime)
    return expireTime - os.time()
end

local function formatTime(secs)
    if secs <= 0 then return "หมดอายุแล้ว" end
    local h = math.floor(secs/3600)
    local m = math.floor((secs%3600)/60)
    local s = secs%60
    if h > 0 then return h.."ชม. "..m.."น."
    elseif m > 0 then return m.."น. "..s.."วิ"
    else return s.."วิ" end
end

-- ===== หน้าต่างหลัก =====
local function createMainWindow(keyData)
    local old = playerGui:FindFirstChild("UGHubWindow")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name="UGHubWindow"; sg.ResetOnSpawn=false
    sg.DisplayOrder=999; sg.IgnoreGuiInset=true; sg.Parent=playerGui

    local win = Instance.new("Frame",sg)
    win.Size=UDim2.new(0,340,0,240)
    win.Position=UDim2.new(0.5,-170,0.5,-120)
    win.BackgroundColor3=SCRIPT_COLOR
    win.BorderSizePixel=0; win.Active=true
    Instance.new("UICorner",win).CornerRadius=UDim.new(0,12)
    local ws=Instance.new("UIStroke",win)
    ws.Color=Color3.fromRGB(130,0,255); ws.Thickness=1.5; ws.Transparency=0.2

    -- Header
    local header=Instance.new("Frame",win)
    header.Size=UDim2.new(1,0,0,36)
    header.BackgroundColor3=Color3.fromRGB(20,0,35)
    header.BorderSizePixel=0
    Instance.new("UICorner",header).CornerRadius=UDim.new(0,12)

    local titleL=Instance.new("TextLabel",header)
    titleL.Size=UDim2.new(1,-40,1,0); titleL.Position=UDim2.new(0,12,0,0)
    titleL.BackgroundTransparency=1; titleL.Text="🔐 "..SCRIPT_TITLE
    titleL.Font=Enum.Font.GothamBold; titleL.TextSize=13
    titleL.TextColor3=Color3.fromRGB(210,150,255)
    titleL.TextXAlignment=Enum.TextXAlignment.Left

    local closeBtn=Instance.new("TextButton",header)
    closeBtn.Size=UDim2.new(0,24,0,24); closeBtn.Position=UDim2.new(1,-30,0.5,-12)
    closeBtn.BackgroundColor3=Color3.fromRGB(180,40,40); closeBtn.BorderSizePixel=0
    closeBtn.Text="✕"; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=11
    closeBtn.TextColor3=Color3.fromRGB(255,255,255)
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6)
    closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

    -- Drag
    do
        local d,ds,sp=false,nil,nil
        header.InputBegan:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
                d=true; ds=inp.Position; sp=win.Position
            end
        end)
        header.InputEnded:Connect(function(inp)
            if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then d=false end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(inp)
            if d and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
                local delta=inp.Position-ds; local vp=sg.AbsoluteSize
                win.Position=UDim2.new(sp.X.Scale+delta.X/vp.X,0,sp.Y.Scale+delta.Y/vp.Y,0)
            end
        end)
    end

    -- Content
    local content=Instance.new("Frame",win)
    content.Size=UDim2.new(1,-20,1,-50); content.Position=UDim2.new(0,10,0,42)
    content.BackgroundTransparency=1; content.BorderSizePixel=0

    -- URL + ปุ่มคัดลอก
    local urlBg=Instance.new("Frame",content)
    urlBg.Size=UDim2.new(1,0,0,28); urlBg.Position=UDim2.new(0,0,0,0)
    urlBg.BackgroundColor3=Color3.fromRGB(0,0,0); urlBg.BackgroundTransparency=0.4
    urlBg.BorderSizePixel=0
    Instance.new("UICorner",urlBg).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",urlBg).Color=Color3.fromRGB(80,0,160)

    local urlTxt=Instance.new("TextLabel",urlBg)
    urlTxt.Size=UDim2.new(1,-44,1,0); urlTxt.Position=UDim2.new(0,8,0,0)
    urlTxt.BackgroundTransparency=1; urlTxt.Text=KEY_WEB_URL
    urlTxt.Font=Enum.Font.Code; urlTxt.TextSize=9
    urlTxt.TextColor3=Color3.fromRGB(160,100,220)
    urlTxt.TextXAlignment=Enum.TextXAlignment.Left
    urlTxt.TextTruncate=Enum.TextTruncate.AtEnd

    local cpBtn=Instance.new("TextButton",urlBg)
    cpBtn.Size=UDim2.new(0,36,1,-4); cpBtn.Position=UDim2.new(1,-38,0,2)
    cpBtn.BackgroundColor3=Color3.fromRGB(80,0,180); cpBtn.BorderSizePixel=0
    cpBtn.Text="📋"; cpBtn.TextSize=11
    Instance.new("UICorner",cpBtn).CornerRadius=UDim.new(0,5)
    local _cp=false
    cpBtn.MouseButton1Click:Connect(function()
        if _cp then return end; _cp=true
        local tb=Instance.new("TextBox",sg)
        tb.Text=KEY_WEB_URL; tb.Visible=false
        tb:CaptureFocus(); tb:ReleaseFocus(false); tb:Destroy()
        cpBtn.Text="✅"; cpBtn.BackgroundColor3=Color3.fromRGB(0,120,60)
        task.wait(1.5); cpBtn.Text="📋"; cpBtn.BackgroundColor3=Color3.fromRGB(80,0,180); _cp=false
    end)

    -- แสดงเวลาหมดอายุ
    local expLabel=Instance.new("TextLabel",content)
    expLabel.Size=UDim2.new(1,0,0,20); expLabel.Position=UDim2.new(0,0,0,34)
    expLabel.BackgroundTransparency=1
    expLabel.Font=Enum.Font.Gotham; expLabel.TextSize=11
    expLabel.TextXAlignment=Enum.TextXAlignment.Left

    -- กล่องโค้ดจำลอง
    local codeBox=Instance.new("Frame",content)
    codeBox.Size=UDim2.new(1,0,0,60); codeBox.Position=UDim2.new(0,0,0,60)
    codeBox.BackgroundColor3=Color3.fromRGB(0,0,0); codeBox.BackgroundTransparency=0.3
    codeBox.BorderSizePixel=0
    Instance.new("UICorner",codeBox).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",codeBox).Color=Color3.fromRGB(60,0,120)

    for i,clr in ipairs({Color3.fromRGB(255,95,87),Color3.fromRGB(255,189,46),Color3.fromRGB(40,200,65)}) do
        local dot=Instance.new("Frame",codeBox)
        dot.Size=UDim2.new(0,8,0,8); dot.Position=UDim2.new(0,6+(i-1)*12,0,6)
        dot.BackgroundColor3=clr; dot.BorderSizePixel=0
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    end

    local codeL=Instance.new("TextLabel",codeBox)
    codeL.Size=UDim2.new(1,-12,1,-22); codeL.Position=UDim2.new(0,6,0,20)
    codeL.BackgroundTransparency=1
    codeL.Text="-- ✅ สคริปต์โหลดสำเร็จ\n-- ยินดีต้อนรับ: "..player.Name
    codeL.Font=Enum.Font.Code; codeL.TextSize=10
    codeL.TextColor3=Color3.fromRGB(80,255,120)
    codeL.TextXAlignment=Enum.TextXAlignment.Left
    codeL.TextYAlignment=Enum.TextYAlignment.Top

    -- นับถอยหลังหมดอายุ + แจ้งเตือน
    local expiredWarned = false
    game:GetService("RunService").Heartbeat:Connect(function()
        if not keyData or not keyData.exp then return end
        local left = getTimeLeft(keyData.exp)
        if left <= 0 then
            expLabel.Text = "⚠️ คีย์หมดอายุแล้ว! กรุณารับคีย์ใหม่"
            expLabel.TextColor3 = Color3.fromRGB(255,80,80)
            if not expiredWarned then
                expiredWarned = true
                -- แจ้งเตือนแล้ว rejoin
                task.delay(3, function()
                    -- ลบคีย์เก่า
                    pcall(function() playerGui:SetAttribute("UGHub_KeyData", nil) end)
                    game:GetService("TeleportService"):Teleport(game.PlaceId, player)
                end)
            end
        elseif left <= 300 then
            expLabel.Text = "⏳ คีย์หมดอายุใน: "..formatTime(left).." (เร็วๆนี้!)"
            expLabel.TextColor3 = Color3.fromRGB(255,180,50)
        else
            expLabel.Text = "🔑 คีย์หมดอายุใน: "..formatTime(left)
            expLabel.TextColor3 = Color3.fromRGB(100,200,255)
        end
    end)

    -- Slide in
    win.Position=UDim2.new(0.5,-170,1.5,0)
    TweenSvc:Create(win,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Position=UDim2.new(0.5,-170,0.5,-120)}):Play()
end

-- ===== หน้าใส่คีย์ =====
local function showKeyUI(onPass)
    local old=playerGui:FindFirstChild("_UGKeyUI")
    if old then old:Destroy() end

    local sg=Instance.new("ScreenGui")
    sg.Name="_UGKeyUI"; sg.ResetOnSpawn=false
    sg.DisplayOrder=99999; sg.IgnoreGuiInset=true; sg.Parent=playerGui

    local dim=Instance.new("Frame",sg)
    dim.Size=UDim2.new(1,0,1,0); dim.BackgroundColor3=Color3.fromRGB(0,0,0)
    dim.BackgroundTransparency=0.4; dim.BorderSizePixel=0; dim.ZIndex=1

    local card=Instance.new("Frame",sg)
    card.Size=UDim2.new(0,320,0,260); card.Position=UDim2.new(0.5,-160,1.5,0)
    card.BackgroundColor3=Color3.fromRGB(8,0,16); card.BorderSizePixel=0; card.ZIndex=2
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local st=Instance.new("UIStroke",card)
    st.Color=Color3.fromRGB(130,0,255); st.Thickness=1.5; st.Transparency=0.2

    local function mkL(txt,size,y,color,bold)
        local l=Instance.new("TextLabel",card)
        l.Size=UDim2.new(1,-20,0,size+4); l.Position=UDim2.new(0,10,0,y)
        l.BackgroundTransparency=1; l.Text=txt
        l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
        l.TextSize=size; l.TextColor3=color; l.TextWrapped=true; l.ZIndex=3
        l.TextXAlignment=Enum.TextXAlignment.Left; return l
    end

    mkL("🔐  "..SCRIPT_TITLE.." — ใส่คีย์",15,10,Color3.fromRGB(210,150,255),true)

    -- URL box + คัดลอก
    local urlBg=Instance.new("Frame",card)
    urlBg.Size=UDim2.new(1,-20,0,26); urlBg.Position=UDim2.new(0,10,0,42)
    urlBg.BackgroundColor3=Color3.fromRGB(0,0,0); urlBg.BackgroundTransparency=0.45
    urlBg.BorderSizePixel=0; urlBg.ZIndex=3
    Instance.new("UICorner",urlBg).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",urlBg).Color=Color3.fromRGB(80,0,160)

    local urlT=Instance.new("TextLabel",urlBg)
    urlT.Size=UDim2.new(1,-36,1,0); urlT.Position=UDim2.new(0,6,0,0)
    urlT.BackgroundTransparency=1; urlT.Text=KEY_WEB_URL
    urlT.Font=Enum.Font.Code; urlT.TextSize=9
    urlT.TextColor3=Color3.fromRGB(160,100,220)
    urlT.TextXAlignment=Enum.TextXAlignment.Left
    urlT.TextTruncate=Enum.TextTruncate.AtEnd; urlT.ZIndex=4

    local cpB=Instance.new("TextButton",urlBg)
    cpB.Size=UDim2.new(0,28,1,-4); cpB.Position=UDim2.new(1,-30,0,2)
    cpB.BackgroundColor3=Color3.fromRGB(80,0,180); cpB.BorderSizePixel=0
    cpB.Text="📋"; cpB.TextSize=10; cpB.ZIndex=5
    Instance.new("UICorner",cpB).CornerRadius=UDim.new(0,5)
    local _cp2=false
    cpB.MouseButton1Click:Connect(function()
        if _cp2 then return end; _cp2=true
        local tb=Instance.new("TextBox",sg)
        tb.Text=KEY_WEB_URL; tb.Visible=false
        tb:CaptureFocus(); tb:ReleaseFocus(false); tb:Destroy()
        cpB.Text="✅"; cpB.BackgroundColor3=Color3.fromRGB(0,120,60)
        task.wait(1.5); cpB.Text="📋"; cpB.BackgroundColor3=Color3.fromRGB(80,0,180); _cp2=false
    end)

    -- input คีย์
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

    local statusL=mkL("💡 วางคีย์จากเว็บ แล้วกดยืนยัน",10,130,Color3.fromRGB(100,70,130),false)

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
        {Position=UDim2.new(0.5,-160,0.5,-130)}):Play()

    confBtn.MouseButton1Click:Connect(function()
        local key=inp.Text:gsub("%s+","")
        if key=="" then setStatus("⚠  กรุณากรอกคีย์ก่อน",255,160,60); return end
        if not isValidKey(key) then setStatus("❌  รูปแบบคีย์ไม่ถูกต้อง",255,80,80); return end
        setStatus("⏳  กำลังตรวจสอบ...",180,120,255)
        task.wait(0.6)

        -- คำนวณหมดอายุ (24 ชม. จากตอนนี้ — ตรงกับเว็บ)
        saveKeyData(key) -- expiry อ่านจากคีย์โดยตรง

        setStatus("✅  คีย์ถูกต้อง! กำลังโหลด...",80,255,130)
        task.wait(0.9)
        TweenSvc:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Position=UDim2.new(0.5,-160,-1.2,0)}):Play()
        TweenSvc:Create(dim,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.wait(0.3); sg:Destroy()
        onPass({key=key, exp=getExpFromKey(key)})
    end)
end

-- ===== เริ่มต้น =====
local keyData = getKeyData()
if keyData and isValidKey(keyData.key) and not isKeyExpired(keyData.key) then
    -- คีย์ยังใช้ได้
    createMainWindow(keyData)
elseif keyData and getTimeLeft(keyData.exp) <= 0 then
    -- คีย์หมดอายุ
    pcall(function() playerGui:SetAttribute("UGHub_KeyData", nil) end)
    showKeyUI(function(data) createMainWindow(data) end)
else
    -- ยังไม่มีคีย์
    showKeyUI(function(data) createMainWindow(data) end)
end
