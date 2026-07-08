local t1 = {}
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.PlayerAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local Chat = game:GetService("Chat")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local scriptParent = script.Parent
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local CurveUtil = require(scriptParent:WaitForChild("CurveUtil"))
local CommandModules = ClientChatModules:WaitForChild("CommandModules")
local Whisper = require(CommandModules:WaitForChild("Whisper"))

require(scriptParent:WaitForChild("MessageSender"))

local ChatLocalization = nil

pcall(function() -- line: 35
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

if ChatLocalization == nil then
	ChatLocalization = {
		Get = function(_, _, p3) -- line: 36
			return p3
		end
	}
end

local t2 = {}

t2.__index = t2

function t2.CreateGuiObjects(p4, p5) -- line: 43
	-- upvalues: ChatSettings (copy)
	p4.ChatBarParentFrame = p5

	local Frame = Instance.new("Frame")

	Frame.Selectable = false
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 0.6
	Frame.BorderSizePixel = 0
	Frame.BackgroundColor3 = ChatSettings.ChatBarBackGroundColor
	Frame.Parent = p5

	local Frame2 = Instance.new("Frame")

	Frame2.Selectable = false
	Frame2.Name = "BoxFrame"
	Frame2.BackgroundTransparency = 0.6
	Frame2.BorderSizePixel = 0
	Frame2.BackgroundColor3 = ChatSettings.ChatBarBoxColor
	Frame2.Size = UDim2.new(1, -14, 1, -14)
	Frame2.Position = UDim2.new(0, 7, 0, 7)
	Frame2.Parent = Frame

	local Frame3 = Instance.new("Frame")

	Frame3.BackgroundTransparency = 1
	Frame3.Size = UDim2.new(1, -10, 1, -10)
	Frame3.Position = UDim2.new(0, 5, 0, 5)
	Frame3.Parent = Frame2

	local TextBox = Instance.new("TextBox")

	TextBox.Selectable = ChatSettings.GamepadNavigationEnabled
	TextBox.Name = "ChatBar"
	TextBox.BackgroundTransparency = 1
	TextBox.Size = UDim2.new(1, 0, 1, 0)
	TextBox.Position = UDim2.new(0, 0, 0, 0)
	TextBox.TextSize = ChatSettings.ChatBarTextSize
	TextBox.Font = ChatSettings.ChatBarFont
	TextBox.TextColor3 = ChatSettings.ChatBarTextColor
	TextBox.TextTransparency = 0.4
	TextBox.TextStrokeTransparency = 1
	TextBox.ClearTextOnFocus = false
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.TextYAlignment = Enum.TextYAlignment.Top
	TextBox.TextWrapped = true
	TextBox.Text = ""
	TextBox.Parent = Frame3

	local TextButton = Instance.new("TextButton")

	TextButton.Selectable = false
	TextButton.Name = "MessageMode"
	TextButton.BackgroundTransparency = 1
	TextButton.Position = UDim2.new(0, 0, 0, 0)
	TextButton.TextSize = ChatSettings.ChatBarTextSize
	TextButton.Font = ChatSettings.ChatBarFont
	TextButton.TextXAlignment = Enum.TextXAlignment.Left
	TextButton.TextWrapped = true
	TextButton.Text = ""
	TextButton.Size = UDim2.new(0, 0, 0, 0)
	TextButton.TextYAlignment = Enum.TextYAlignment.Center
	TextButton.TextColor3 = p4:GetDefaultChannelNameColor()
	TextButton.Visible = true
	TextButton.Parent = Frame3

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Selectable = false
	TextLabel.TextWrapped = true
	TextLabel.BackgroundTransparency = 1
	TextLabel.Size = TextBox.Size
	TextLabel.Position = TextBox.Position
	TextLabel.TextSize = TextBox.TextSize
	TextLabel.Font = TextBox.Font
	TextLabel.TextColor3 = TextBox.TextColor3
	TextLabel.TextTransparency = TextBox.TextTransparency
	TextLabel.TextStrokeTransparency = TextBox.TextStrokeTransparency
	TextLabel.TextXAlignment = TextBox.TextXAlignment
	TextLabel.TextYAlignment = TextBox.TextYAlignment
	TextLabel.Text = "..."
	TextLabel.Parent = Frame3
	p4.GuiObject = Frame
	p4.TextBox = TextBox
	p4.TextLabel = TextLabel
	p4.GuiObjects.BaseFrame = Frame
	p4.GuiObjects.TextBoxFrame = Frame2
	p4.GuiObjects.TextBox = TextBox
	p4.GuiObjects.TextLabel = TextLabel
	p4.GuiObjects.MessageModeTextButton = TextButton
	p4:AnimGuiObjects()
	p4:SetUpTextBoxEvents(TextBox, TextLabel, TextButton)

	if p4.UserHasChatOff then
		p4:DoLockChatBar()
	end

	p4.eGuiObjectsChanged:Fire()
end
function t2.DoLockChatBar(p6) -- line: 142
	-- upvalues: LocalPlayer (ref), ChatLocalization (ref)
	if p6.TextLabel then
		if LocalPlayer.UserId > 0 then
			p6.TextLabel.Text = ChatLocalization:Get("GameChat_ChatMessageValidator_SettingsError", "To chat in game, turn on chat in your Privacy Settings.")
		else
			p6.TextLabel.Text = ChatLocalization:Get("GameChat_SwallowGuestChat_Message", "Sign up to chat in game.")
		end

		p6:CalculateSize()
	end

	if p6.TextBox then
		p6.TextBox.Active = false
		p6.TextBox.Focused:connect(function() -- line: 159
			-- upvalues: p6 (copy)
			p6.TextBox:ReleaseFocus()
		end)
	end
end
function t2.SetUpTextBoxEvents(p7, p8, p9, p10) -- line: 165
	-- upvalues: UserInputService (copy), ChatSettings (copy)
	for k, v in pairs(p7.TextBoxConnections) do
		v:disconnect()
		p7.TextBoxConnections[k] = nil
	end

	p7.TextBoxConnections.UserInputBegan = UserInputService.InputBegan:connect(function(p11, _) -- line: 173
		-- upvalues: p7 (copy), p8 (copy), ChatSettings (copy)
		if p11.KeyCode == Enum.KeyCode.Backspace and (p7:IsFocused() and p8.Text == "") then
			p7:SetChannelTarget(ChatSettings.GeneralChannelName)
		end
	end)
	p7.TextBoxConnections.TextBoxChanged = p8.Changed:connect(function(p13) -- line: 181
		-- upvalues: p7 (copy), p8 (copy), ChatSettings (copy)
		if p13 == "AbsoluteSize" then
			p7:CalculateSize()

			return
		end

		if p13 ~= "Text" then
			return
		end

		p7:CalculateSize()

		if utf8.len(utf8.nfcnormalize(p8.Text)) > ChatSettings.MaximumMessageLength then
			p8.Text = p7.PreviousText
		else
			p7.PreviousText = p8.Text
		end

		if not p7.InCustomState then
			local v110 = p7.CommandProcessor:ProcessInProgressChatMessage(p8.Text, p7.ChatWindow, p7)

			if v110 then
				p7.InCustomState = true
				p7.CustomState = v110

				return
			end
		else
			p7.CustomState:TextUpdated()
		end
	end)

	local function UpdateOnFocusStatusChanged(p14) -- line: 210
		-- upvalues: p8 (copy), p9 (copy)
		if p14 or p8.Text ~= "" then
			p9.Visible = false

			return
		end

		p9.Visible = true
	end

	p7.TextBoxConnections.MessageModeClick = p10.MouseButton1Click:connect(function() -- line: 218
		-- upvalues: p10 (copy), p7 (copy), ChatSettings (copy)
		if p10.Text ~= "" then
			p7:SetChannelTarget(ChatSettings.GeneralChannelName)
		end
	end)
	p7.TextBoxConnections.TextBoxFocused = p8.Focused:connect(function() -- line: 224
		-- upvalues: p7 (copy), p9 (copy)
		if not p7.UserHasChatOff then
			p7:CalculateSize()
			p9.Visible = false
		end
	end)
	p7.TextBoxConnections.TextBoxFocusLost = p8.FocusLost:connect(function(_, p16) -- line: 231
		-- upvalues: p7 (copy), p8 (copy), p9 (copy)
		p7:CalculateSize()

		if p16 and p16.KeyCode == Enum.KeyCode.Escape then
			p8.Text = ""
		end

		if p8.Text ~= "" then
			p9.Visible = false

			return
		end

		p9.Visible = true
	end)
end
function t2.GetTextBox(p17) -- line: 240
	return p17.TextBox
end
function t2.GetMessageModeTextButton(p18) -- line: 244
	return p18.GuiObjects.MessageModeTextButton
end
function t2.GetMessageModeTextLabel(p19) -- line: 250
	return p19:GetMessageModeTextButton()
end
function t2.IsFocused(p20) -- line: 254
	if p20.UserHasChatOff then
		return false
	end

	return p20:GetTextBox():IsFocused()
end
function t2.GetVisible(p21) -- line: 262
	return p21.GuiObject.Visible
end
function t2.CaptureFocus(p22) -- line: 266
	if not p22.UserHasChatOff then
		p22:GetTextBox():CaptureFocus()
	end
end
function t2.ReleaseFocus(p23, p24) -- line: 272
	p23:GetTextBox():ReleaseFocus(p24)
end
function t2.ResetText(p25) -- line: 276
	p25:GetTextBox().Text = ""
end
function t2.SetText(p26, p27) -- line: 280
	p26:GetTextBox().Text = p27
end
function t2.GetEnabled(p28) -- line: 284
	return p28.GuiObject.Visible
end
function t2.SetEnabled(p29, p30) -- line: 288
	if p29.UserHasChatOff then
		p29.GuiObject.Visible = true

		return
	end

	p29.GuiObject.Visible = p30
end
function t2.SetTextLabelText(p31, p32) -- line: 298
	if not p31.UserHasChatOff then
		p31.TextLabel.Text = p32
	end
end
function t2.SetTextBoxText(p33, p34) -- line: 304
	p33.TextBox.Text = p34
end
function t2.GetTextBoxText(p35) -- line: 308
	return p35.TextBox.Text
end
function t2.ResetSize(p36) -- line: 312
	p36.TargetYSize = 0
	p36:TweenToTargetYSize()
end

local function measureSize(p37) -- line: 317
	-- upvalues: TextService (copy)
	return TextService:GetTextSize(p37.Text, p37.TextSize, p37.Font, Vector2.new(p37.AbsoluteSize.X, 10000))
end

function t2.CalculateSize(p38) -- line: 326
	-- upvalues: TextService (copy)
	if p38.CalculatingSizeLock then
		return
	end

	p38.CalculatingSizeLock = true

	local TextBoxTextSize, Y

	if p38:IsFocused() or p38.TextBox.Text ~= "" then
		TextBoxTextSize = p38.TextBox.TextSize

		local TextBox = p38.TextBox

		Y = TextService:GetTextSize(TextBox.Text, TextBox.TextSize, TextBox.Font, Vector2.new(TextBox.AbsoluteSize.X, 10000)).Y
	else
		TextBoxTextSize = p38.TextLabel.TextSize

		local TextLabel = p38.TextLabel

		Y = TextService:GetTextSize(TextLabel.Text, TextLabel.TextSize, TextLabel.Font, Vector2.new(TextLabel.AbsoluteSize.X, 10000)).Y
	end

	local v62 = Y - TextBoxTextSize

	if v62 ~= p38.TargetYSize then
		p38.TargetYSize = v62
		p38:TweenToTargetYSize()
	end

	p38.CalculatingSizeLock = false
end
function t2.TweenToTargetYSize(p39) -- line: 352
	local uDim2 = UDim2.new(1, 0, 1, p39.TargetYSize)
	local GuiObjectSize = p39.GuiObject.Size
	local AbsoluteSizeY = p39.GuiObject.AbsoluteSize.Y

	p39.GuiObject.Size = uDim2

	local AbsoluteSizeY2 = p39.GuiObject.AbsoluteSize.Y

	p39.GuiObject.Size = GuiObjectSize

	local v68 = math.min(1, math.abs(AbsoluteSizeY2 - AbsoluteSizeY) * (1 / p39.TweenPixelsPerSecond))

	if not pcall(function() -- line: 364
		-- upvalues: p39 (copy), uDim2 (copy), v68 (copy)
		p39.GuiObject:TweenSize(uDim2, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, v68, true)
	end) then
		p39.GuiObject.Size = uDim2
	end
end
function t2.SetTextSize(p40, p41) -- line: 372
	if not p40:IsInCustomState() then
		if p40.TextBox then
			p40.TextBox.TextSize = p41
		end

		if p40.TextLabel then
			p40.TextLabel.TextSize = p41
		end
	end
end
function t2.GetDefaultChannelNameColor(_) -- line: 383
	-- upvalues: ChatSettings (copy)
	if ChatSettings.DefaultChannelNameColor then
		return ChatSettings.DefaultChannelNameColor
	end

	return Color3.fromRGB(35, 76, 142)
end
function t2.SetChannelTarget(p43, p44) -- line: 390
	-- upvalues: ChatSettings (copy), ChatLocalization (ref)
	local MessageModeTextButton = p43.GuiObjects.MessageModeTextButton
	local TextBox = p43.TextBox
	local TextLabel = p43.TextLabel

	p43.TargetChannel = p44

	if not p43:IsInCustomState() then
		if p44 ~= ChatSettings.GeneralChannelName then
			MessageModeTextButton.Size = UDim2.new(0, 1000, 1, 0)

			local v77 = p44

			if ChatLocalization.tryLocalize then
				v77 = ChatLocalization:tryLocalize(p44)
			end

			MessageModeTextButton.Text = string.format("[%s] ", v77)

			local ChannelNameColor = p43:GetChannelNameColor(p44)

			if ChannelNameColor then
				MessageModeTextButton.TextColor3 = ChannelNameColor
			else
				MessageModeTextButton.TextColor3 = p43:GetDefaultChannelNameColor()
			end

			local TextBoundsX = MessageModeTextButton.TextBounds.X

			MessageModeTextButton.Size = UDim2.new(0, TextBoundsX, 1, 0)
			TextBox.Size = UDim2.new(1, -TextBoundsX, 1, 0)
			TextBox.Position = UDim2.new(0, TextBoundsX, 0, 0)
			TextLabel.Size = UDim2.new(1, -TextBoundsX, 1, 0)
			TextLabel.Position = UDim2.new(0, TextBoundsX, 0, 0)

			return
		end

		MessageModeTextButton.Text = ""
		MessageModeTextButton.Size = UDim2.new(0, 0, 0, 0)
		TextBox.Size = UDim2.new(1, 0, 1, 0)
		TextBox.Position = UDim2.new(0, 0, 0, 0)
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.Position = UDim2.new(0, 0, 0, 0)
	end
end
function t2.IsInCustomState(p45) -- line: 430
	return p45.InCustomState
end
function t2.ResetCustomState(p46) -- line: 434
	-- upvalues: ChatLocalization (ref)
	if p46.InCustomState then
		p46.CustomState:Destroy()
		p46.CustomState = nil
		p46.InCustomState = false
		p46.ChatBarParentFrame:ClearAllChildren()
		p46:CreateGuiObjects(p46.ChatBarParentFrame)
		p46:SetTextLabelText(ChatLocalization:Get("GameChat_ChatMain_ChatBarText", "To chat click here or press \"/\" key"))
	end
end
function t2.EnterWhisperState(p47, p48) -- line: 451
	-- upvalues: Whisper (copy), ChatSettings (copy)
	p47:ResetCustomState()

	if Whisper.CustomStateCreator then
		p47.CustomState = Whisper.CustomStateCreator(p48, p47.ChatWindow, p47, ChatSettings)
		p47.InCustomState = true
	else
		p47:SetText("/w " .. if not ChatSettings.PlayerDisplayNamesEnabled then p48.Name else p48.DisplayName)
	end

	p47:CaptureFocus()
end
function t2.GetCustomMessage(p49) -- line: 475
	if p49.InCustomState then
		return p49.CustomState:GetMessage()
	end

	return nil
end
function t2.CustomStateProcessCompletedMessage(p50, _) -- line: 482
	if p50.InCustomState then
		return p50.CustomState:ProcessCompletedMessage()
	end

	return false
end
function t2.FadeOutBackground(p52, p53) -- line: 489
	-- upvalues: CurveUtil (copy)
	p52.AnimParams.Background_TargetTransparency = 1
	p52.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p53)
	p52:FadeOutText(p53)
end
function t2.FadeInBackground(p54, p55) -- line: 495
	-- upvalues: CurveUtil (copy)
	p54.AnimParams.Background_TargetTransparency = 0.6
	p54.AnimParams.Background_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p55)
	p54:FadeInText(p55)
end
function t2.FadeOutText(p56, p57) -- line: 501
	-- upvalues: CurveUtil (copy)
	p56.AnimParams.Text_TargetTransparency = 1
	p56.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p57)
end
function t2.FadeInText(p58, p59) -- line: 506
	-- upvalues: CurveUtil (copy)
	p58.AnimParams.Text_TargetTransparency = 0.4
	p58.AnimParams.Text_NormalizedExptValue = CurveUtil:NormalizedDefaultExptValueInSeconds(p59)
end
function t2.AnimGuiObjects(p60) -- line: 511
	p60.GuiObject.BackgroundTransparency = p60.AnimParams.Background_CurrentTransparency
	p60.GuiObjects.TextBoxFrame.BackgroundTransparency = p60.AnimParams.Background_CurrentTransparency
	p60.GuiObjects.TextLabel.TextTransparency = p60.AnimParams.Text_CurrentTransparency
	p60.GuiObjects.TextBox.TextTransparency = p60.AnimParams.Text_CurrentTransparency
	p60.GuiObjects.MessageModeTextButton.TextTransparency = p60.AnimParams.Text_CurrentTransparency
end
function t2.InitializeAnimParams(p61) -- line: 520
	p61.AnimParams.Text_TargetTransparency = 0.4
	p61.AnimParams.Text_CurrentTransparency = 0.4
	p61.AnimParams.Text_NormalizedExptValue = 1
	p61.AnimParams.Background_TargetTransparency = 0.6
	p61.AnimParams.Background_CurrentTransparency = 0.6
	p61.AnimParams.Background_NormalizedExptValue = 1
end
function t2.Update(p62, p63) -- line: 530
	-- upvalues: CurveUtil (copy)
	p62.AnimParams.Text_CurrentTransparency = CurveUtil:Expt(p62.AnimParams.Text_CurrentTransparency, p62.AnimParams.Text_TargetTransparency, p62.AnimParams.Text_NormalizedExptValue, p63)
	p62.AnimParams.Background_CurrentTransparency = CurveUtil:Expt(p62.AnimParams.Background_CurrentTransparency, p62.AnimParams.Background_TargetTransparency, p62.AnimParams.Background_NormalizedExptValue, p63)
	p62:AnimGuiObjects()
end
function t2.SetChannelNameColor(p64, p65, p66) -- line: 547
	p64.ChannelNameColors[p65] = p66

	if p65 == p64.GuiObjects.MessageModeTextButton.Text then
		p64.GuiObjects.MessageModeTextButton.TextColor3 = p66
	end
end
function t2.GetChannelNameColor(p67, p68) -- line: 554
	return p67.ChannelNameColors[p68]
end
function t1.new(p69, p70) -- line: 561
	-- upvalues: t2 (copy), ChatSettings (copy), Chat (copy), LocalPlayer (ref), RunService (copy)
	local self = setmetatable({}, t2)

	self.GuiObject = nil
	self.ChatBarParentFrame = nil
	self.TextBox = nil
	self.TextLabel = nil
	self.GuiObjects = {}
	self.eGuiObjectsChanged = Instance.new("BindableEvent")
	self.GuiObjectsChanged = self.eGuiObjectsChanged.Event
	self.TextBoxConnections = {}
	self.PreviousText = ""
	self.InCustomState = false
	self.CustomState = nil
	self.TargetChannel = nil
	self.CommandProcessor = p69
	self.ChatWindow = p70
	self.TweenPixelsPerSecond = 500
	self.TargetYSize = 0
	self.AnimParams = {}
	self.CalculatingSizeLock = false
	self.ChannelNameColors = {}
	self.UserHasChatOff = false
	self:InitializeAnimParams()
	ChatSettings.SettingsChanged:connect(function(p71, p72) -- line: 593
		-- upvalues: self (copy)
		if p71 == "ChatBarTextSize" then
			self:SetTextSize(p72)
		end
	end)
	coroutine.wrap(function() -- line: 599
		-- upvalues: Chat (copy), LocalPlayer (ref), RunService (copy), self (copy)
		local ok, result = pcall(function() -- line: 600
			-- upvalues: Chat (copy), LocalPlayer (ref)
			return Chat:CanUserChatAsync(LocalPlayer.UserId)
		end)

		if (ok and (RunService:IsStudio() or result)) == false then
			self.UserHasChatOff = true
			self:DoLockChatBar()
		end
	end)()

	return self
end

return t1
