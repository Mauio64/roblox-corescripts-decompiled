local t1 = {}
local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local scriptParent = script.Parent
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local CurveUtil = require(scriptParent:WaitForChild("CurveUtil"))
local t2 = {}

t2.__index = t2

local function CreateGuiObjects() -- line: 21
	-- upvalues: ChatSettings (copy)
	local Frame = Instance.new("Frame")

	Frame.Selectable = false
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1

	local Frame2 = Instance.new("Frame")

	Frame2.Selectable = false
	Frame2.Name = "BackgroundFrame"
	Frame2.Size = UDim2.new(1, -2, 1, -2)
	Frame2.Position = UDim2.new(0, 1, 0, 1)
	Frame2.BackgroundTransparency = 1
	Frame2.Parent = Frame

	local Frame3 = Instance.new("Frame")

	Frame3.Selectable = false
	Frame3.Name = "UnselectedFrame"
	Frame3.Size = UDim2.new(1, 0, 1, 0)
	Frame3.Position = UDim2.new(0, 0, 0, 0)
	Frame3.BorderSizePixel = 0
	Frame3.BackgroundColor3 = ChatSettings.ChannelsTabUnselectedColor
	Frame3.BackgroundTransparency = 0.6
	Frame3.Parent = Frame2

	local Frame4 = Instance.new("Frame")

	Frame4.Selectable = false
	Frame4.Name = "SelectedFrame"
	Frame4.Size = UDim2.new(1, 0, 1, 0)
	Frame4.Position = UDim2.new(0, 0, 0, 0)
	Frame4.BorderSizePixel = 0
	Frame4.BackgroundColor3 = ChatSettings.ChannelsTabSelectedColor
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = Frame2

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Selectable = false
	ImageLabel.Name = "BackgroundImage"
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel.Position = UDim2.new(0, 0, 0, 0)
	ImageLabel.ScaleType = Enum.ScaleType.Slice
	ImageLabel.Parent = Frame4
	ImageLabel.BackgroundTransparency = -0.4
	ImageLabel.BackgroundColor3 = Color3.fromRGB(93.6, 100.8, 115.19999999999999)

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Selectable = false
	ImageLabel2.Size = UDim2.new(0.5, -2, 0, 4)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.ScaleType = Enum.ScaleType.Slice
	ImageLabel2.SliceCenter = Rect.new(3, 3, 32, 21)
	ImageLabel2.Parent = Frame4

	local clone = ImageLabel2:Clone()

	clone.Parent = Frame4
	ImageLabel2.Position = UDim2.new(0, 2, 1, -4)
	clone.Position = UDim2.new(0.5, 0, 1, -4)
	ImageLabel2.Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarLeft.png"
	clone.Image = "rbxasset://textures/ui/Settings/Slider/SelectedBarRight.png"
	ImageLabel2.Name = "BlueBarLeft"
	clone.Name = "BlueBarRight"

	local TextButton = Instance.new("TextButton")

	TextButton.Selectable = ChatSettings.GamepadNavigationEnabled
	TextButton.Size = UDim2.new(1, 0, 1, 0)
	TextButton.Position = UDim2.new(0, 0, 0, 0)
	TextButton.BackgroundTransparency = 1
	TextButton.Font = ChatSettings.DefaultFont
	TextButton.TextSize = ChatSettings.ChatChannelsTabTextSize
	TextButton.TextColor3 = Color3.new(1, 1, 1)
	TextButton.TextStrokeTransparency = 0.75
	TextButton.Parent = Frame2

	local clone2 = TextButton:Clone()
	local clone3 = TextButton:Clone()

	clone2.Parent = Frame3
	clone3.Parent = Frame4
	clone2.Font = Enum.Font.SourceSans
	clone2.Active = false
	clone3.Active = false

	local Frame5 = Instance.new("Frame")

	Frame5.Selectable = false
	Frame5.Size = UDim2.new(0, 18, 0, 18)
	Frame5.Position = UDim2.new(0.8, -9, 0.5, -9)
	Frame5.BackgroundTransparency = 1
	Frame5.Parent = Frame2

	local ImageLabel3 = Instance.new("ImageLabel")

	ImageLabel3.Selectable = false
	ImageLabel3.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel3.BackgroundTransparency = 1
	ImageLabel3.Image = "rbxasset://textures/ui/Chat/MessageCounter.png"
	ImageLabel3.Visible = false
	ImageLabel3.Parent = Frame5

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Selectable = false
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = UDim2.new(0, 13, 0, 9)
	TextLabel.Position = UDim2.new(0.5, -7, 0.5, -7)
	TextLabel.Font = ChatSettings.DefaultFont
	TextLabel.TextSize = 14
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.Text = ""
	TextLabel.Parent = ImageLabel3

	return Frame, TextButton, clone2, clone3, ImageLabel3, Frame3, Frame4
end

function t2.Destroy(p1) -- line: 141
	p1.GuiObject:Destroy()
end
function t2.UpdateMessagePostedInChannel(p2, p3) -- line: 145
	if p2.Active and p3 ~= true then
		return
	end

	local v24 = p2.UnreadMessageCount + 1

	p2.UnreadMessageCount = v24

	local NewMessageIcon = p2.NewMessageIcon

	NewMessageIcon.Visible = true
	NewMessageIcon.TextLabel.Text = v24 < 100 and tostring(v24) or "!"

	local uDim2 = UDim2.new(0, 0, -0.1, 0)
	local _ = NewMessageIcon.Position + uDim2
	local Out = Enum.EasingDirection.Out
	local Quad = Enum.EasingStyle.Quad

	NewMessageIcon.Position = UDim2.new(0, 0, -0.15, 0)
	NewMessageIcon:TweenPosition(UDim2.new(0, 0, 0, 0), Out, Quad, 0.15, true)
end
function t2.SetActive(p4, p5) -- line: 168
	p4.Active = p5
	p4.UnselectedFrame.Visible = not p5
	p4.SelectedFrame.Visible = p5

	if p5 then
		p4.UnreadMessageCount = 0
		p4.NewMessageIcon.Visible = false
		p4.NameTag.Font = Enum.Font.SourceSansBold

		return
	end

	p4.NameTag.Font = Enum.Font.SourceSans
end
function t2.SetTextSize(p6, p7) -- line: 184
	p6.NameTag.TextSize = p7
end
function t2.FadeOutBackground(p8, p9) -- line: 188
	-- upvalues: CurveUtil (copy)
	p8.AnimParams.Background_TargetTransparency = 1
	p8.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p9)
end
function t2.FadeInBackground(p10, p11) -- line: 193
	-- upvalues: CurveUtil (copy)
	p10.AnimParams.Background_TargetTransparency = 0.6
	p10.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p11)
end
function t2.FadeOutText(p12, p13) -- line: 198
	-- upvalues: CurveUtil (copy)
	p12.AnimParams.Text_TargetTransparency = 1
	p12.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p13)
	p12.AnimParams.TextStroke_TargetTransparency = 1
	p12.AnimParams.TextStroke_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p13)
end
function t2.FadeInText(p14, p15) -- line: 205
	-- upvalues: CurveUtil (copy)
	p14.AnimParams.Text_TargetTransparency = 0
	p14.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p15)
	p14.AnimParams.TextStroke_TargetTransparency = 0.75
	p14.AnimParams.TextStroke_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p15)
end
function t2.AnimGuiObjects(p16) -- line: 212
	p16.UnselectedFrame.BackgroundTransparency = p16.AnimParams.Background_CurrentTransparency
	p16.SelectedFrame.BackgroundImage.BackgroundTransparency = p16.AnimParams.Background_CurrentTransparency
	p16.SelectedFrame.BlueBarLeft.ImageTransparency = p16.AnimParams.Background_CurrentTransparency
	p16.SelectedFrame.BlueBarRight.ImageTransparency = p16.AnimParams.Background_CurrentTransparency
	p16.NameTagNonSelect.TextTransparency = p16.AnimParams.Background_CurrentTransparency
	p16.NameTagNonSelect.TextStrokeTransparency = p16.AnimParams.Background_CurrentTransparency
	p16.NameTag.TextTransparency = p16.AnimParams.Text_CurrentTransparency
	p16.NewMessageIcon.ImageTransparency = p16.AnimParams.Text_CurrentTransparency
	p16.WhiteTextNewMessageNotification.TextTransparency = p16.AnimParams.Text_CurrentTransparency
	p16.NameTagSelect.TextTransparency = p16.AnimParams.Text_CurrentTransparency
	p16.NameTag.TextStrokeTransparency = p16.AnimParams.TextStroke_CurrentTransparency
	p16.WhiteTextNewMessageNotification.TextStrokeTransparency = p16.AnimParams.TextStroke_CurrentTransparency
	p16.NameTagSelect.TextStrokeTransparency = p16.AnimParams.TextStroke_CurrentTransparency
end
function t2.InitializeAnimParams(p17) -- line: 230
	-- upvalues: CurveUtil (copy)
	p17.AnimParams.Text_TargetTransparency = 0
	p17.AnimParams.Text_CurrentTransparency = 0
	p17.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)
	p17.AnimParams.TextStroke_TargetTransparency = 0.75
	p17.AnimParams.TextStroke_CurrentTransparency = 0.75
	p17.AnimParams.TextStroke_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)
	p17.AnimParams.Background_TargetTransparency = 0.6
	p17.AnimParams.Background_CurrentTransparency = 0.6
	p17.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(0)
end
function t2.Update(p18, p19) -- line: 244
	-- upvalues: CurveUtil (copy)
	p18.AnimParams.Background_CurrentTransparency = CurveUtil:Expt(p18.AnimParams.Background_CurrentTransparency, p18.AnimParams.Background_TargetTransparency, p18.AnimParams.Background_NormalizedExptValue, p19)
	p18.AnimParams.Text_CurrentTransparency = CurveUtil:Expt(p18.AnimParams.Text_CurrentTransparency, p18.AnimParams.Text_TargetTransparency, p18.AnimParams.Text_NormalizedExptValue, p19)
	p18.AnimParams.TextStroke_CurrentTransparency = CurveUtil:Expt(p18.AnimParams.TextStroke_CurrentTransparency, p18.AnimParams.TextStroke_TargetTransparency, p18.AnimParams.TextStroke_NormalizedExptValue, p19)
	p18:AnimGuiObjects()
end
function t1.new(p20) -- line: 270
	-- upvalues: t2 (copy), CreateGuiObjects (copy), ChatSettings (copy)
	local self = setmetatable({}, t2)
	local v48, v49, v50, v51, v52, v53, v54 = CreateGuiObjects()

	self.GuiObject = v48
	self.NameTag = v49
	self.NameTagNonSelect = v50
	self.NameTagSelect = v51
	self.NewMessageIcon = v52
	self.UnselectedFrame = v53
	self.SelectedFrame = v54
	self.BlueBarLeft = v54.BlueBarLeft
	self.BlueBarRight = v54.BlueBarRight
	self.BackgroundImage = v54.BackgroundImage
	self.WhiteTextNewMessageNotification = self.NewMessageIcon.TextLabel
	self.ChannelName = p20
	self.UnreadMessageCount = 0
	self.Active = false
	self.GuiObject.Name = "Frame_" .. self.ChannelName

	if string.len(p20) > ChatSettings.MaxChannelNameLength then
		p20 = string.sub(p20, 1, ChatSettings.MaxChannelNameLength - 3) .. "..."
	end

	self.NameTag.Text = ""
	self.NameTagNonSelect.Text = p20
	self.NameTagSelect.Text = p20
	self.AnimParams = {}
	self:InitializeAnimParams()
	self:AnimGuiObjects()
	self:SetActive(false)

	return self
end

return t1
