local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local Data = {
	IsEnable = false,
	Time = {
		Minutes = 3,
		Timestamp = 3 * 60
	},
	Round = 0
}


local function secondsToTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local remainingSeconds = seconds % 60

	return hours, minutes, remainingSeconds
end

game:GetService("StarterGui").ResetPlayerGuiOnSpawn = false


local Toggle = Instance.new("ScreenGui", Player.PlayerGui)
Toggle.IgnoreGuiInset = true
Toggle.Name = "auto-suicide"

Toggle.ResetOnSpawn = false

local Container = Instance.new("Frame",Toggle)
Container.Name = "Container"

Container.Position = UDim2.new(0.1,0,0.25,0)
Container.Size = UDim2.new(0,190,0,30)

Container.BackgroundColor3 = Color3.new(0.172549, 0.172549, 0.172549)

Instance.new("UICorner",Container)

local Button = Instance.new("TextButton",Container)
Button.Size = UDim2.new(0.35,0,1,0)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Font = Enum.Font.FredokaOne
Button.FontSize = Enum.FontSize.Size24
Button.BorderSizePixel = 0


local TextBox = Instance.new("TextBox",Container)
TextBox.Size = UDim2.new(0.3,0,1,0)
TextBox.Position = UDim2.new(0.35,0,1,0)
TextBox.AnchorPoint = Vector2.new(0.0,1)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.Text = Data.Time.Minutes
TextBox.BorderSizePixel = 0
TextBox.BackgroundTransparency = 0.8
TextBox.Font = Enum.Font.FredokaOne
TextBox.FontSize = Enum.FontSize.Size24

local TextTimeOut = Instance.new("TextLabel",Container)
TextTimeOut.Size = UDim2.new(0.35,0,1.3,0)
TextTimeOut.Position = UDim2.new(0.65,0,1,0)
TextTimeOut.AnchorPoint = Vector2.new(0.0,1)
TextTimeOut.BorderSizePixel = 0
TextTimeOut.BackgroundTransparency = 1
TextTimeOut.Font = Enum.Font.FredokaOne
TextTimeOut.FontSize = Enum.FontSize.Size12
TextTimeOut.TextColor3 = Color3.new(1, 1, 1)
local hours, minutes, seconds = secondsToTime(Data.Time.Timestamp)
TextTimeOut.Text = string.format("%d:%d:%d", hours, minutes, seconds)

local TextRound = Instance.new("TextLabel",Container)
TextRound.Size = UDim2.new(0.35,0,0.45,0)
TextRound.Position = UDim2.new(0.65,0,1,0)
TextRound.AnchorPoint = Vector2.new(0.0,1)
TextRound.BorderSizePixel = 0
TextRound.BackgroundTransparency = 1
TextRound.Font = Enum.Font.FredokaOne
TextRound.FontSize = Enum.FontSize.Size12
TextRound.TextColor3 = Color3.new(0.0313725, 0.87451, 0.458824)
TextRound.Text = Data.Round

Button.MouseButton1Click:Connect(function()
	Data.IsEnable = not Data.IsEnable
end)


local TimeC = Data.Time.Minutes 

local start = tick()

game:GetService("RunService").RenderStepped:Connect(function()
	
	if (tick() - start) >= 1 and Data.IsEnable and Data.Time.Timestamp > 0 then
		start = tick()
		
		Data.Time.Timestamp -= 1 
		
		local hours, minutes, seconds = secondsToTime(Data.Time.Timestamp)
		TextTimeOut.Text = string.format("%d:%d:%d", hours, minutes, seconds)
	end
	
	if TimeC ~= TextBox.Text and tonumber(TextBox.Text) ~= nil and tonumber(TextBox.Text) ~= 0 then
		TimeC = TextBox.Text
		Data.Time.Timestamp = TextBox.Text * 60
	end
	
	
	if Data.Time.Timestamp <= 0 and Data.IsEnable then
		Data.Time.Timestamp = TimeC * 60
		
		if Player.Character ~= nil then
			local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
			if Humanoid ~= nil then
				Data.Round += 1
				TextRound.Text = Data.Round
				Humanoid.Health = 0
			end
		end
	end
	
	if Data.IsEnable then
		Button.Text = "ON"
		Button.BackgroundColor3 = Color3.new(0.0313725, 0.87451, 0.458824)
	else
		Button.Text = "OFF"
		Button.BackgroundColor3 = Color3.new(0.866667, 0.231373, 0.294118)
	end
	
end)

Player.CharacterAdded:Connect(function()
	
	if Data.IsEnable then
		Button.Text = "ON"
		Button.BackgroundColor3 = Color3.new(0.0313725, 0.87451, 0.458824)
	else
		Button.Text = "OFF"
		Button.BackgroundColor3 = Color3.new(0.866667, 0.231373, 0.294118)
	end
end)
