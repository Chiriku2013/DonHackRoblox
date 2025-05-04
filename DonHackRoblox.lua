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

-- Tạo UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "DonTenUI"

local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0.5, 0, 0, 10)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Name = "MainFrame"

-- Tên Label
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Text = "👤Tên: " .. obfuscateName(player.Name)

-- Đơn Label
local donText = loadDon()
local donLabel = Instance.new("TextLabel", frame)
donLabel.BackgroundTransparency = 1
donLabel.TextColor3 = Color3.new(1, 1, 1)
donLabel.Font = Enum.Font.Gotham
donLabel.TextSize = 15
donLabel.TextXAlignment = Enum.TextXAlignment.Left
donLabel.Text = "📌Đơn: " .. donText

-- Tính toán size lớn nhất và apply
local function updateUISize()
    nameLabel.Size = UDim2.new(0, nameLabel.TextBounds.X + 20, 0, 30)
    donLabel.Size = UDim2.new(0, donLabel.TextBounds.X + 20, 0, 30)

    local maxWidth = math.max(nameLabel.AbsoluteSize.X, donLabel.AbsoluteSize.X)
    frame.Size = UDim2.new(0, maxWidth + 20, 0, 80)

    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    donLabel.Position = UDim2.new(0, 10, 0, 40)
    frame.Position = UDim2.new(0.5, 0, 0, 10)
end

updateUISize()

-- Cho phép sửa đơn khi double click
donLabel.MouseButton1Click:Connect(function()
    -- Thay label bằng textbox để chỉnh
    donLabel.Visible = false
    local editBox = Instance.new("TextBox", frame)
    editBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    editBox.TextColor3 = Color3.new(1,1,1)
    editBox.Font = Enum.Font.Gotham
    editBox.TextSize = 15
    editBox.TextXAlignment = Enum.TextXAlignment.Left
    editBox.Text = donText
    editBox.Position = donLabel.Position
    editBox.Size = donLabel.Size
    editBox.ClearTextOnFocus = false
    editBox:CaptureFocus()

    editBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            donText = editBox.Text
            saveDon(donText)
            donLabel.Text = "📌Đơn: " .. donText
            editBox:Destroy()
            donLabel.Visible = true
            updateUISize()
        else
            editBox:Destroy()
            donLabel.Visible = true
        end
    end)
end)
