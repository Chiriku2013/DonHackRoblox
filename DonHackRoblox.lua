local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Save/load đơn
local function saveDon(text)
    if writefile then
        writefile("don_saved.txt", text)
    end
end

local function loadDon()
    if readfile and isfile("don_saved.txt") then
        return readfile("don_saved.txt")
    end
    return ""
end

-- Làm mờ tên (sau 6 ký tự)
local function obfuscateName(name)
    if #name <= 6 then
        return name
    else
        return string.sub(name, 1, 6) .. string.rep("*", #name - 6)
    end
end

-- UI khởi tạo
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
local nameText = "👤Tên: " .. obfuscateName(player.Name)
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Text = nameText

-- Nút chỉnh đơn (bên phải dòng tên)
local editBtn = Instance.new("TextButton", frame)
editBtn.Text = "✏️"
editBtn.Font = Enum.Font.Gotham
editBtn.TextSize = 14
editBtn.BackgroundTransparency = 1
editBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
editBtn.Size = UDim2.new(0, 20, 0, 20)

-- TextBox đơn khởi đầu
local donBox = Instance.new("TextBox", frame)
donBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
donBox.TextColor3 = Color3.new(1,1,1)
donBox.Font = Enum.Font.Gotham
donBox.TextSize = 15
donBox.TextXAlignment = Enum.TextXAlignment.Left
donBox.ClearTextOnFocus = false
donBox.Text = loadDon() ~= "" and loadDon() or ""
donBox.PlaceholderText = "Nhập đơn rồi nhấn Enter"

-- Đơn Label (ẩn ban đầu)
local donLabel = Instance.new("TextLabel", frame)
donLabel.BackgroundTransparency = 1
donLabel.TextColor3 = Color3.new(1, 1, 1)
donLabel.Font = Enum.Font.Gotham
donLabel.TextSize = 15
donLabel.TextXAlignment = Enum.TextXAlignment.Left
donLabel.Visible = false

-- Hàm resize & căn giữa UI
local function updateUI()
    nameLabel.Size = UDim2.new(0, nameLabel.TextBounds.X + 10, 0, 25)
    donBox.Size = UDim2.new(0, math.max(100, donBox.TextBounds.X + 20), 0, 25)
    donLabel.Size = donBox.Size

    local width = math.max(nameLabel.Size.X.Offset + 25, donBox.Size.X.Offset + 20)
    frame.Size = UDim2.new(0, width, 0, 70)

    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    editBtn.Position = UDim2.new(0, nameLabel.Position.X.Offset + nameLabel.Size.X.Offset + 5, 0, 7)

    donBox.Position = UDim2.new(0, 10, 0, 35)
    donLabel.Position = donBox.Position

    frame.Position = UDim2.new(0.5, 0, 0, 10)
end

updateUI()

-- Enter xong thì chuyển textbox thành label
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

-- Nhấn nút ✏️ để sửa đơn
editBtn.MouseButton1Click:Connect(function()
    donBox.Visible = true
    donBox.Text = string.gsub(donLabel.Text or "", "📌Đơn: ", "")
    donLabel.Visible = false
    donBox:CaptureFocus()
    updateUI()
end)

-- Nếu đã có đơn -> hiện label, ẩn textbox
if donBox.Text ~= "" then
    donLabel.Text = "📌Đơn: " .. donBox.Text
    donLabel.Visible = true
    donBox.Visible = false
    updateUI()
end
