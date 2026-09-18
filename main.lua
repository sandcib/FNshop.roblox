-- โหลดไลบรารี Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- สร้างเมนูหลัก
local Window = Library.CreateLib("FN SHOP", "BloodTheme")
local Tab = Window:NewTab("ความเร็ว")
local Section = Tab:NewSection("⚡ การตั้งค่าความเร็ว")

-- ฟังก์ชันความเร็ว
Section:NewToggle("ความเร็วสูง", "เปลี่ยนความเร็วตัวละคร", function(state)
    local plr = game.Players.LocalPlayer
    if not plr.Character then return end
    local Hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
    if not Hum then return end
    Hum.WalkSpeed = state and 100 or 20
end)

-- 🔧 ส่วนสำคัญ: ปลดล็อกการลากเมนู + รองรับมือถือ
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer.PlayerGui
UIS.TouchEnabled = true

-- รอเมนูโหลดเสร็จ แล้วบังคับเปิดการลาก
task.wait(0.3)
pcall(function()
    for _, gui in pairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Name ~= "MenuToggleBtn" then
            gui.IgnoreGuiInset = true
            -- หาเฟรมหลักของเมนู แล้วเปิด Drag
            local MainFrame = gui:FindFirstChild("Main", true)
            if MainFrame then
                -- เปิดการลากให้ชัดเจน
                Library:EnableDrag(MainFrame) -- สั่ง Kavo เปิดลาก
                -- ปรับตำแหน่งเริ่มให้อยู่กลางจอ
                MainFrame.Position = UDim2.new(0.5, -170, 0.5, -200)
            end
        end
    end
end)

-- 🟢 ปุ่มลอยเปิด-ปิด (ติดจอ ไม่หาย ลากได้ด้วย)
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "MenuToggleBtn"
ToggleGui.IgnoreGuiInset = true
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.DisplayOrder = 999 -- อยู่บนสุดเสมอ
ToggleGui.Parent = PlayerGui

local Btn = Instance.new("TextButton")
Btn.Name = "FloatingToggle"
Btn.Size = UDim2.new(0, 55, 0, 55)
Btn.Position = UDim2.new(0.02, 0, 0.35, 0)
Btn.BackgroundColor3 = Color3.fromRGB(210, 30, 30)
Btn.Text = "☰"
Btn.Font = Enum.Font.GothamBold
Btn.TextColor3 = Color3.new(1,1,1)
Btn.TextScaled = true
Btn.ZIndex = 1000
Btn.Parent = ToggleGui

-- มุมกลม+ขอบสวย
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = Btn
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 120, 120)
Stroke.Thickness = 2
Stroke.Parent = Btn

-- ✅ ลากปุ่มได้ (ไม่ขวางเมนูหลัก)
local DragState = false
local DragStart, BtnStartPos
Btn.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseButton1 then
        DragState = true
        DragStart = Input.Position
        BtnStartPos = Btn.Position
    end
end)
UIS.InputChanged:Connect(function(Input)
    if DragState and (Input.UserInputType == Enum.UserInputType.Touch or Input.UserInputType == Enum.UserInputType.MouseMovement) then
        local Delta = Input.Position - DragStart
        Btn.Position = UDim2.new(
            BtnStartPos.X.Scale, BtnStartPos.X.Offset + Delta.X,
            BtnStartPos.Y.Scale, BtnStartPos.Y.Offset + Delta.Y
        )
    end
end)
UIS.InputEnded:Connect(function() DragState = false end)

-- ✅ กดปุ่มแล้วเปิด/ปิดเมนูได้จริง
local MenuShown = true
Btn.MouseButton1Click:Connect(function()
    MenuShown = not MenuShown
    pcall(function()
        for _, gui in pairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= ToggleGui.Name then
                gui.Enabled = MenuShown
            end
        end
    end)
    Btn.BackgroundColor3 = MenuShown and Color3.fromRGB(210,30,30) or Color3.fromRGB(65,65,65)
end)

print("✅ เสร็จสิ้น! เมนูลากได้+ปุ่ม☰ลอยซ้าย ติดจอแน่นอน")
