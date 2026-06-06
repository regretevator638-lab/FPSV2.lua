-- ================================================================
--   ✏️  แก้ได้ — ระบบคีย์
-- ================================================================
local KEY_WEB_URL = "https://regretevator638-lab.github.io/UG-HUB-GET-KEY/"
-- ☝️ เปลี่ยนเป็น URL เว็บจริงของคุณ

-- ================================================================
--   ⛔  แก้ไม่ได้ — ระบบคีย์ทำงานอยู่ตรงนี้
-- ================================================================
local _P   = game:GetService("Players")
local _TS  = game:GetService("TweenService")
local _pl  = _P.LocalPlayer
local _pg  = _pl:WaitForChild("PlayerGui")

local function _validKey(k)
    if not k or #k ~= 35 then return false end
    return k:sub(9,9)=="-" and k:sub(18,18)=="-" and k:sub(27,27)=="-"
end
local function _getKey()
    local ok,v = pcall(function() return _pg:GetAttribute("UGHub_Key") end)
    return ok and v or nil
end
local function _setKey(k)
    pcall(function() _pg:SetAttribute("UGHub_Key", k) end)
end

local function _showKeyUI(onPass)
    local old = _pg:FindFirstChild("_UGKeyUI")
    if old then old:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name="_UGKeyUI"; sg.ResetOnSpawn=false
    sg.DisplayOrder=99999; sg.IgnoreGuiInset=true; sg.Parent=_pg

    local dim = Instance.new("Frame",sg)
    dim.Size=UDim2.new(1,0,1,0)
    dim.BackgroundColor3=Color3.fromRGB(0,0,0)
    dim.BackgroundTransparency=0.4
    dim.BorderSizePixel=0; dim.ZIndex=1

    local card = Instance.new("Frame",sg)
    card.Size=UDim2.new(0,340,0,295)
    card.Position=UDim2.new(0.5,-170,1.5,0)
    card.BackgroundColor3=Color3.fromRGB(8,0,16)
    card.BorderSizePixel=0; card.ZIndex=2
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local st=Instance.new("UIStroke",card)
    st.Color=Color3.fromRGB(130,0,255); st.Thickness=1.5; st.Transparency=0.2

    -- หัวข้อ
    local title=Instance.new("TextLabel",card)
    title.Size=UDim2.new(1,0,0,36); title.Position=UDim2.new(0,0,0,10)
    title.BackgroundTransparency=1; title.Text="🔐  UG Hub — ใส่คีย์"
    title.Font=Enum.Font.GothamBold; title.TextSize=15
    title.TextColor3=Color3.fromRGB(210,150,255); title.ZIndex=3

    -- ป้าย URL
    local urlL=Instance.new("TextLabel",card)
    urlL.Size=UDim2.new(1,-20,0,16); urlL.Position=UDim2.new(0,10,0,46)
    urlL.BackgroundTransparency=1; urlL.Text="รับคีย์ฟรีที่:"
    urlL.Font=Enum.Font.Gotham; urlL.TextSize=10
    urlL.TextColor3=Color3.fromRGB(100,65,140)
    urlL.TextXAlignment=Enum.TextXAlignment.Left; urlL.ZIndex=3

    -- กล่อง URL + ปุ่มคัดลอก
    local urlBg=Instance.new("Frame",card)
    urlBg.Size=UDim2.new(1,-20,0,26); urlBg.Position=UDim2.new(0,10,0,62)
    urlBg.BackgroundColor3=Color3.fromRGB(0,0,0); urlBg.BackgroundTransparency=0.5
    urlBg.BorderSizePixel=0; urlBg.ZIndex=3
    Instance.new("UICorner",urlBg).CornerRadius=UDim.new(0,6)
    Instance.new("UIStroke",urlBg).Color=Color3.fromRGB(80,0,160)

    local urlTxt=Instance.new("TextLabel",urlBg)
    urlTxt.Size=UDim2.new(1,-36,1,0); urlTxt.Position=UDim2.new(0,6,0,0)
    urlTxt.BackgroundTransparency=1; urlTxt.Text=KEY_WEB_URL
    urlTxt.Font=Enum.Font.Code; urlTxt.TextSize=9
    urlTxt.TextColor3=Color3.fromRGB(160,100,220)
    urlTxt.TextXAlignment=Enum.TextXAlignment.Left
    urlTxt.TextTruncate=Enum.TextTruncate.AtEnd; urlTxt.ZIndex=4

    local cpyBtn=Instance.new("TextButton",urlBg)
    cpyBtn.Size=UDim2.new(0,28,1,-4); cpyBtn.Position=UDim2.new(1,-30,0,2)
    cpyBtn.BackgroundColor3=Color3.fromRGB(80,0,180); cpyBtn.BorderSizePixel=0
    cpyBtn.Text="📋"; cpyBtn.TextSize=11; cpyBtn.ZIndex=5
    Instance.new("UICorner",cpyBtn).CornerRadius=UDim.new(0,5)
    local _cp=false
    cpyBtn.MouseButton1Click:Connect(function()
        if _cp then return end; _cp=true
        pcall(function()
            local g=Instance.new("ScreenGui",_pg)
            local tb=Instance.new("TextBox",g)
            tb.Text=KEY_WEB_URL; tb:CaptureFocus(); tb:ReleaseFocus(false); g:Destroy()
        end)
        cpyBtn.Text="✅"; cpyBtn.BackgroundColor3=Color3.fromRGB(0,120,60)
        task.wait(1.5); cpyBtn.Text="📋"; cpyBtn.BackgroundColor3=Color3.fromRGB(80,0,180); _cp=false
    end)

    -- เส้นแบ่ง
    local div=Instance.new("Frame",card)
    div.Size=UDim2.new(1,-20,0,1); div.Position=UDim2.new(0,10,0,92)
    div.BackgroundColor3=Color3.fromRGB(100,0,200); div.BackgroundTransparency=0.6
    div.BorderSizePixel=0; div.ZIndex=3

    -- กล่องกรอกคีย์
    local inpBg=Instance.new("Frame",card)
    inpBg.Size=UDim2.new(1,-20,0,42); inpBg.Position=UDim2.new(0,10,0,102)
    inpBg.BackgroundColor3=Color3.fromRGB(0,0,0); inpBg.BackgroundTransparency=0.45
    inpBg.BorderSizePixel=0; inpBg.ZIndex=3
    Instance.new("UICorner",inpBg).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",inpBg).Color=Color3.fromRGB(100,0,200)

    local inp=Instance.new("TextBox",inpBg)
    inp.Size=UDim2.new(1,-16,1,0); inp.Position=UDim2.new(0,8,0,0)
    inp.BackgroundTransparency=1
    inp.PlaceholderText="xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx"
    inp.PlaceholderColor3=Color3.fromRGB(70,40,100)
    inp.Text=""; inp.Font=Enum.Font.Code; inp.TextSize=12
    inp.TextColor3=Color3.fromRGB(200,130,255)
    inp.ClearTextOnFocus=false; inp.ZIndex=4

    -- สถานะ
    local statusL=Instance.new("TextLabel",card)
    statusL.Size=UDim2.new(1,-20,0,20); statusL.Position=UDim2.new(0,10,0,152)
    statusL.BackgroundTransparency=1
    statusL.Text="💡 วางคีย์แล้วกดยืนยัน — คีย์หมดอายุตามที่ตั้งไว้"
    statusL.Font=Enum.Font.Gotham; statusL.TextSize=10
    statusL.TextColor3=Color3.fromRGB(100,70,130)
    statusL.TextWrapped=true; statusL.ZIndex=3

    local function setStatus(msg,r,g,b)
        statusL.Text=msg; statusL.TextColor3=Color3.fromRGB(r,g,b)
    end

    -- ปุ่มยืนยัน
    local confBtn=Instance.new("TextButton",card)
    confBtn.Size=UDim2.new(1,-20,0,42); confBtn.Position=UDim2.new(0,10,0,178)
    confBtn.BackgroundColor3=Color3.fromRGB(75,0,170); confBtn.BorderSizePixel=0
    confBtn.Text="✅   ยืนยันคีย์"
    confBtn.Font=Enum.Font.GothamBold; confBtn.TextSize=14
    confBtn.TextColor3=Color3.fromRGB(255,255,255); confBtn.ZIndex=3
    Instance.new("UICorner",confBtn).CornerRadius=UDim.new(0,10)
    confBtn.MouseEnter:Connect(function()
        _TS:Create(confBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(110,0,230)}):Play()
    end)
    confBtn.MouseLeave:Connect(function()
        _TS:Create(confBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(75,0,170)}):Play()
    end)

    -- เวอร์ชัน
    local ver=Instance.new("TextLabel",card)
    ver.Size=UDim2.new(1,0,0,14); ver.Position=UDim2.new(0,0,1,-18)
    ver.BackgroundTransparency=1; ver.Text="UG Hub v8.3 — Key System"
    ver.Font=Enum.Font.Gotham; ver.TextSize=9
    ver.TextColor3=Color3.fromRGB(55,35,75); ver.ZIndex=3

    -- Slide in
    _TS:Create(card,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Position=UDim2.new(0.5,-170,0.5,-147)}):Play()

    -- กดยืนยัน
    confBtn.MouseButton1Click:Connect(function()
        local key=inp.Text:gsub("%s+","")
        if key=="" then setStatus("⚠  กรุณากรอกคีย์ก่อน",255,160,60); return end
        if not _validKey(key) then setStatus("❌  รูปแบบคีย์ไม่ถูกต้อง",255,80,80); return end
        setStatus("⏳  กำลังตรวจสอบ...",180,120,255)
        task.wait(0.6)
        _setKey(key)
        setStatus("✅  คีย์ถูกต้อง! กำลังโหลด...",80,255,130)
        task.wait(0.9)
        _TS:Create(card,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
            {Position=UDim2.new(0.5,-170,-1.2,0)}):Play()
        _TS:Create(dim,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play()
        task.wait(0.3); sg:Destroy(); onPass()
    end)
end

-- ตรวจคีย์ — ถ้ามีแล้วข้ามเลย ถ้าไม่มีแสดง popup
local _saved = _getKey()
if _saved and _validKey(_saved) then
    -- ผ่าน โหลดฮับเลย
else
    local _wait = true
    _showKeyUI(function() _wait=false end)
    while _wait do task.wait(0.1) end
end

-- ================================================================
-- ================================================================
--   ⛔  โค้ดหลัก UG Hub ด้านล่างนี้ — ห้ามแตะ!
-- ================================================================
-- ================================================================

