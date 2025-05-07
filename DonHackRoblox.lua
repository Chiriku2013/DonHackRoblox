local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function saveDon(text)
    if writefile then writefile("don_saved.txt", text) end
end

local function loadDon()
    if readfile and isfile("don_saved.txt") then
        return readfile("don_saved.txt")
    end
    return ""
end

local function obfuscateName(name)
    if #name <= 6 then return name end
    return string.sub(name, 1, 6) .. string.rep("*", #name - 6)
end

-- GUI setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DonTenUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0.5, 0, 0, 10)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 70)

-- 👤Tên
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16
nameLabel.TextXAlignment = Enum.TextXAlignment.Center
nameLabel.Text = "👤Tên: " .. obfuscateName(player.Name)
nameLabel.Size = UDim2.new(1, -40, 0, 25)
nameLabel.Position = UDim2.new(0.5, 0, 0, 5)
nameLabel.AnchorPoint = Vector2.new(0.5, 0)

-- ✏️ Nút đổi đơn
local editBtn = Instance.new("TextButton", frame)
editBtn.Text = "✏️"
editBtn.Font = Enum.Font.GothamBold
editBtn.TextSize = 14
editBtn.BackgroundTransparency = 1
editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
editBtn.Size = UDim2.new(0, 20, 0, 20)
editBtn.Position = UDim2.new(1, -25, 0, 5)

-- 📌Đơn - TextBox
local donBox = Instance.new("TextBox", frame)
donBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
donBox.TextColor3 = Color3.new(1,1,1)
donBox.Font = Enum.Font.GothamBold
donBox.TextSize = 15
donBox.TextXAlignment = Enum.TextXAlignment.Center
donBox.ClearTextOnFocus = false
donBox.Text = loadDon()
donBox.PlaceholderText = "Nhập đơn rồi nhấn Enter"
donBox.Size = UDim2.new(1, -40, 0, 25)
donBox.Position = UDim2.new(0.5, 0, 0, 38)
donBox.AnchorPoint = Vector2.new(0.5, 0)

-- 📌Đơn - Label
local donLabel = Instance.new("TextLabel", frame)
donLabel.BackgroundTransparency = 1
donLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
donLabel.Font = Enum.Font.GothamBold
donLabel.TextSize = 15
donLabel.TextXAlignment = Enum.TextXAlignment.Center
donLabel.Visible = false
donLabel.Size = donBox.Size
donLabel.Position = donBox.Position
donLabel.AnchorPoint = Vector2.new(0.5, 0)

-- Sự kiện
donBox.FocusLost:Connect(function(enter)
    if enter then
        local text = donBox.Text
        saveDon(text)
        donLabel.Text = "📌Đơn: " .. text
        donLabel.Visible = true
        donBox.Visible = false
    end
end)

editBtn.MouseButton1Click:Connect(function()
    donBox.Text = string.gsub(donLabel.Text, "📌Đơn: ", "")
    donBox.Visible = true
    donLabel.Visible = false
    donBox:CaptureFocus()
end)

-- Hiện đơn đã lưu nếu có
if donBox.Text ~= "" then
    donLabel.Text = "📌Đơn: " .. donBox.Text
    donLabel.Visible = true
    donBox.Visible = false
end
