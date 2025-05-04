local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Lưu và đọc đơn
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

-- Làm mờ tên nếu dài
local function obfuscateName(name)
    if #name <= 6 then
        return name
    end
    return string.sub(name, 1, 4) .. string.rep("*", 6)
end

-- Hiển thị trên đầu
local function updateBillboard(donText)
    local char = player.Character or player.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    if head:FindFirstChild("PlayerInfoDisplay") then
        head.PlayerInfoDisplay:Destroy()
    end

    local gui = Instance.new("BillboardGui", head)
    gui.Name = "PlayerInfoDisplay"
    gui.Adornee = head
    gui.Size = UDim2.new(0, 250, 0, 60)
    gui.StudsOffset = Vector3.new(0, 2.5, 0)
    gui.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel", gui)
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Text = "👤Tên: " .. obfuscateName(player.Name)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14

    local donLabel = Instance.new("TextLabel", gui)
    donLabel.Position = UDim2.new(0, 0, 0.5, 0)
    donLabel.Size = UDim2.new(1, 0, 0.5, 0)
    donLabel.BackgroundTransparency = 1
    donLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
    donLabel.TextStrokeTransparency = 0.5
    donLabel.Text = "📌Đơn: " .. donText
    donLabel.Font = Enum.Font.GothamBold
    donLabel.TextSize = 14
end

-- UI cố định trên màn hình
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "DonInfoUI"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.Size = UDim2.new(0, 280, 0, 90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Name = "InfoFrame"

local nameLabel = Instance.new("TextLabel", frame)
nameLabel.Position = UDim2.new(0, 10, 0, 10)
nameLabel.Size = UDim2.new(1, -20, 0, 25)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Text = "👤Tên: " .. obfuscateName(player.Name)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

local donBox = Instance.new("TextBox", frame)
donBox.Position = UDim2.new(0, 10, 0, 45)
donBox.Size = UDim2.new(1, -20, 0, 30)
donBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
donBox.TextColor3 = Color3.new(1,1,1)
donBox.Font = Enum.Font.Gotham
donBox.TextSize = 14
donBox.TextXAlignment = Enum.TextXAlignment.Left
donBox.Text = loadDon()
donBox.PlaceholderText = "📌Đơn: Nhập đơn của bạn..."

-- Cập nhật khi Enter
donBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        saveDon(donBox.Text)
        updateBillboard(donBox.Text)
    end
end)

-- Tự cập nhật nếu đã có sẵn đơn
if donBox.Text ~= "" then
    updateBillboard(donBox.Text)
end
