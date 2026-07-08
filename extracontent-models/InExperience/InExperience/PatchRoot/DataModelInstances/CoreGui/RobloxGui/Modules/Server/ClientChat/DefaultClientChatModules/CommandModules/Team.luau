local Players = game:GetService("Players")
local t1 = {
	"/team ",
	"/t ",
	"% "
}

function IsTeamCommand(p1) -- line: 10
	-- upvalues: t1 (copy)
	for i = 1, #t1 do
		local v8 = t1[i]

		if v8 == string.sub(p1, 1, v8:len()):lower() then
			return true
		end
	end

	return false
end

local t2 = {}

t2.__index = t2

local Util = require(script.Parent:WaitForChild("Util"))
local t3 = {}

function t2.EnterTeamChat(p2) -- line: 27
	p2.TeamChatEntered = true
	p2.MessageModeButton.Size = UDim2.new(0, 1000, 1, 0)
	p2.MessageModeButton.Text = "[Team]"
	p2.MessageModeButton.TextColor3 = p2:GetTeamChatColor()

	local TextBoundsX = p2.MessageModeButton.TextBounds.X

	p2.MessageModeButton.Size = UDim2.new(0, TextBoundsX, 1, 0)
	p2.TextBox.Size = UDim2.new(1, -TextBoundsX, 1, 0)
	p2.TextBox.Position = UDim2.new(0, TextBoundsX, 0, 0)
	p2.OriginalTeamText = p2.TextBox.Text
	p2.TextBox.Text = " "
end
function t2.TextUpdated(p3) -- line: 41
	local TextBoxText = p3.TextBox.Text

	if not p3.TeamChatEntered then
		if IsTeamCommand(TextBoxText) then
			p3:EnterTeamChat()

			return
		end
	elseif TextBoxText == "" then
		p3.MessageModeButton.Text = ""
		p3.MessageModeButton.Size = UDim2.new(0, 0, 0, 0)
		p3.TextBox.Size = UDim2.new(1, 0, 1, 0)
		p3.TextBox.Position = UDim2.new(0, 0, 0, 0)
		p3.TextBox.Text = ""
		p3.TeamChatEntered = false
		p3.ChatBar:ResetCustomState()
		p3.ChatBar:CaptureFocus()
	end
end
function t2.GetMessage(p4) -- line: 64
	if p4.TeamChatEntered then
		return "/t " .. p4.TextBox.Text
	end

	return p4.TextBox.Text
end
function t2.ProcessCompletedMessage(_) -- line: 71
	return false
end
function t2.Destroy(p6) -- line: 75
	p6.MessageModeConnection:disconnect()
	p6.Destroyed = true
end
function t2.GetTeamChatColor(p7) -- line: 80
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer.Team then
		return LocalPlayer.Team.TeamColor.Color
	end

	if p7.ChatSettings.DefaultChannelNameColor then
		return p7.ChatSettings.DefaultChannelNameColor
	end

	return Color3.fromRGB(35, 76, 142)
end
function t3.new(p8, p9, p10) -- line: 91
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.Destroyed = false
	self.ChatWindow = p8
	self.ChatBar = p9
	self.ChatSettings = p10
	self.TextBox = p9:GetTextBox()
	self.MessageModeButton = p9:GetMessageModeTextButton()
	self.OriginalTeamText = ""
	self.TeamChatEntered = false
	self.MessageModeConnection = self.MessageModeButton.MouseButton1Click:connect(function() -- line: 102
		-- upvalues: self (copy)
		local TextBoxText = self.TextBox.Text

		if string.sub(TextBoxText, 1, 1) == " " then
			TextBoxText = string.sub(TextBoxText, 2)
		end

		self.ChatBar:ResetCustomState()
		self.ChatBar:SetTextBoxText(TextBoxText)
		self.ChatBar:CaptureFocus()
	end)
	self:EnterTeamChat()

	return self
end
function ProcessMessage(p11, p12, p13, p14) -- line: 117
	-- upvalues: t3 (copy)
	if p13.TargetChannel == "Team" then
		return
	end

	if IsTeamCommand(p11) then
		return t3.new(p12, p13, p14)
	end

	return nil
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.IN_PROGRESS_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
