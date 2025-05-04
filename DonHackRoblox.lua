local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- Hàm lưu và đọc đơn
local function saveDon(text)
    if isfile and writefile then
        writefile("don_saved.txt", text)
    end
end

local function loadDon()
    if isfile and readfile and isfile("don_saved.txt") then
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

-- Tạo Billboard GUI trên đầu
local function createBillboard(nameText, donText)
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")

    if head:FindFirstChild("PlayerInfoDisplay") then
        head:FindFirstChild("PlayerInfoDisplay"):Destroy()
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
    nameLabel.Text = "👤Tên: " .. obfuscateName(nameText)
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

-- UI nhập đơn
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 80)
frame.Position = UDim2.new(0.5, -125, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Name = "DonUI"

local donBox = Instance.new("TextBox", frame)
donBox.PlaceholderText = "Nhập đơn và nhấn Enter"
donBox.Size = UDim2.new(1, -20, 0, 50)
donBox.Position = UDim2.new(0, 10, 0, 15)
donBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
donBox.TextColor3 = Color3.new(1,1,1)
donBox.Font = Enum.Font.Gotham
donBox.TextSize = 14
donBox.Text = loadDon()

-- Khi nhấn Enter để lưu đơn và hiện lên đầu
donBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        saveDon(donBox.Text)
        createBillboard(player.Name, donBox.Text)
    end
end)

-- Tự hiện khi đã có đơn trước đó
if donBox.Text ~= "" then
    createBillboard(player.Name, donBox.Text)
end
