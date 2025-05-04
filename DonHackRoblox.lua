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

-- Làm mờ tên nếu dài hơn 6 ký tự
local function obfuscateName(name)
    if #name <= 6 then
        return name
    else
        local visible = string.sub(name, 1, 6)
        local hidden = string.rep("*", #name - 6)
        return visible .. hidden
    end
end

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "DonTenUI"

local frame = Instance.new("Frame", gui)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0, 10)
frame.Size = UDim2.new(0, 300, 0, 80)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Name = "MainFrame"

-- Label tên
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.Position = UDim2.new(0, 10, 0, 5)
nameLabel.Size = UDim2.new(1, -20, 0, 30)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Text = "👤Tên: " .. obfuscateName(player.Name)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Đơn
local donBox = Instance.new("TextBox", frame)
donBox.Position = UDim2.new(0, 10, 0, 40)
donBox.Size = UDim2.new(1, -20, 0, 30)
donBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
donBox.TextColor3 = Color3.new(1,1,1)
donBox.Font = Enum.Font.Gotham
donBox.TextSize = 15
donBox.TextXAlignment = Enum.TextXAlignment.Left
donBox.PlaceholderText = "📌Đơn: Nhập đơn và nhấn Enter"
donBox.Text = loadDon()
donBox.ClearTextOnFocus = false

-- Lưu khi Enter
donBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        saveDon(donBox.Text)
    end
end)
