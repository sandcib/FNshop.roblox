-- เรียกไลบรารี Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- ✅ เพิ่มส่วนรองรับสัมผัส/เลื่อนมือถือ
local UIS = game:GetService("UserInputService")
UIS.TouchEnabled = true

-- สร้างหน้าต่าง + ธีมสีแดงเข้ม
local Window = Library.CreateLib("FN SHOP", "BloodTheme")

-- แท็บความเร็ว
local Tab = Window:NewTab("ความเร็ว")
local Section = Tab:NewSection("⚡ การตั้งค่าความเร็ว")

-- ปุ่มเปิด/ปิดความเร็ว
Section:NewToggle("ความเร็วสูง", "เปลี่ยนความเร็วตัวละคร", function(state)
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        if state then
            plr.Character.Humanoid.WalkSpeed = 100
        else
            plr.Character.Humanoid.WalkSpeed = 20
        end
    end
end)

-- ✅ เพิ่มส่วนอื่นๆ ให้มีเนื้อที่เลื่อนได้
local Tab2 = Window:NewTab("🎮 ฟังก์ชันอื่น")
local Sec2 = Tab2:NewSection("ฟังก์ชันเสริม")

for i=1,15 do -- สร้างรายการเยอะๆ เพื่อทดสอบเลื่อน
    Sec2:NewButton("ปุ่มทดสอบ "..i, "ทดสอบการเลื่อน", function()
        print("กดปุ่ม "..i)
    end)
end

-- ✅ โค้ดสำคัญ: เปิดการเลื่อนด้วยนิ้ว + ปรับขนาดให้พอดีจอมือถือ
coroutine.wrap(function()
    while task.wait(0.1) do
        -- ค้นหาเฟรมเนื้อหาในเมนู
        for _, gui in pairs(game.CoreGui:GetChildren()) do
            if gui.Name == "MobileMenu" or gui:FindFirstChild("pages") then
                local pages = gui:FindFirstChild("pages")
                if pages then
                    -- เปิดการเลื่อนด้วยนิ้ว
                    pcall(function()
                        pages.ScrollingEnabled = true
                        pages.ScrollBarThickness = 6 -- ขนาดแถบเลื่อนมองเห็นง่าย
                        pages.CanvasSize = UDim2.new(0, 0, 2, 0) -- ขยายพื้นที่เลื่อน
                    end)
                end
                -- ปรับขนาดเมนูให้พอดีจอมือถือ
                local main = gui:FindFirstChild("Main")
                if main then
                    pcall(function()
                        main.Size = UDim2.new(0, 340, 0, 450) -- ขนาดพอดีมือถือ
                        main.Position = UDim2.new(0.5, -170, 0.5, -225) -- กึ่งกลางจอ
                    end)
                end
            end
        end
    end
end)()

print("✅ เมนูมือถือพร้อมใช้ (เลื่อนได้แล้ว!)")
