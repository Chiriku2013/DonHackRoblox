local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Lưu/đọc đơn
local function saveDon(text)
    if writefile then writefile("don_saved.txt", text) end
end

local function loadDon()
    if readfile and isfile("don_saved.txt") then
        return readfile("don_saved.txt")
    end
    return ""
end

-- Ẩn tên sau 6 ký tự
local function obfuscateName(name)
    if #name <= 6 then return name end
    return string.sub(name, 1, 6) .. string.rep("*", #name - 6)
end

-- Tạo GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DonTenUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0.5, 0, 0, 10)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Name = "MainFrame"

-- Tên người chơi
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Text = "👤Tên: " .. obfuscateName(player.Name)

-- Nút chỉnh đơn
local editBtn = Instance.new("TextButton", frame)
editBtn.Text = "✏️"
editBtn.Font = Enum.Font.Gotham
editBtn.TextSize = 14
editBtn.BackgroundTransparency = 1
editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
editBtn.Size = UDim2.new(0, 20, 0, 20)

-- Đơn - TextBox
local donBox = Instance.new("TextBox", frame)
donBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
donBox.TextColor3 = Color3.new(1,1,1)
donBox.Font = Enum.Font.Gotham
donBox.TextSize = 15
donBox.TextXAlignment = Enum.TextXAlignment.Left
donBox.ClearTextOnFocus = false
donBox.Text = loadDon()
donBox.PlaceholderText = "Nhập đơn rồi nhấn Enter"

-- Đơn - Label
local donLabel = Instance.new("TextLabel", frame)
donLabel.BackgroundTransparency = 1
donLabel.TextColor3 = Color3.new(1, 1, 1)
donLabel.Font = Enum.Font.Gotham
donLabel.TextSize = 15
donLabel.TextXAlignment = Enum.TextXAlignment.Left
donLabel.Visible = false

-- Cập nhật giao diện và căn chỉnh
local function updateUI()
    nameLabel.Size = UDim2.new(0, nameLabel.TextBounds.X + 10, 0, 25)
    editBtn.Position = UDim2.new(0, nameLabel.Position.X.Offset + nameLabel.TextBounds.X + 15, 0, 2)

    local donText = donBox.Visible and donBox.Text or donLabel.Text
    local donWidth = donText and (#donText > 0 and math.max(100, donBox.TextBounds.X + 30) or 120) or 120
    donBox.Size = UDim2.new(0, donWidth, 0, 25)
    donLabel.Size = donBox.Size

    local frameWidth = math.max(nameLabel.Size.X.Offset + 40, donWidth + 20)
    frame.Size = UDim2.new(0, frameWidth, 0, 70)

    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    donBox.Position = UDim2.new(0, 10, 0, 35)
    donLabel.Position = donBox.Position
    frame.Position = UDim2.new(0.5, 0, 0, 10)
end

-- Enter -> lưu đơn, chuyển về label
donBox.FocusLost:Connect(function(enter)
    if enter then
        local text = donBox.Text
        saveDon(text)
        donLabel.Text = "📌Đơn: " .. text
        donLabel.Visible = true
        donBox.Visible = false
        updateUI()
    end
end)

-- Nhấn nút ✏️ để sửa
editBtn.MouseButton1Click:Connect(function()
    donBox.Text = string.gsub(donLabel.Text, "📌Đơn: ", "")
    donBox.Visible = true
    donLabel.Visible = false
    donBox:CaptureFocus()
    updateUI()
end)

-- Hiện đơn nếu đã có
if donBox.Text ~= "" then
    donLabel.Text = "📌Đơn: " .. donBox.Text
    donLabel.Visible = true
    donBox.Visible = false
end

-- Gọi lần đầu
updateUI()
