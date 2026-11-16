local Players = game:GetService("Players")

local v = { "/team ", "/t ", "% " }

function IsTeamCommand(value): boolean
	for i = 1, #v do
		local v2 = v[i]

		if string.sub(value, 1, v2:len()):lower() == v2 then
			return true
		end
	end

	return false
end

local class = {}
class.__index = class

local Util = require(script.Parent:WaitForChild("Util"))

local v2 = {}

function class:EnterTeamChat()
	self.TeamChatEntered = true
	self.MessageModeButton.Size = UDim2.new(0, 1000, 1, 0)
	self.MessageModeButton.Text = "[Team]"
	self.MessageModeButton.TextColor3 = self:GetTeamChatColor()

	local x = self.MessageModeButton.TextBounds.X
	self.MessageModeButton.Size = UDim2.new(0, x, 1, 0)
	self.TextBox.Size = UDim2.new(1, -x, 1, 0)
	self.TextBox.Position = UDim2.new(0, x, 0, 0)
	self.OriginalTeamText = self.TextBox.Text
	self.TextBox.Text = " "
end

function class:TextUpdated()
	local text = self.TextBox.Text

	if self.TeamChatEntered then
		if text == "" then
			self.MessageModeButton.Text = ""
			self.MessageModeButton.Size = UDim2.new(0, 0, 0, 0)
			self.TextBox.Size = UDim2.new(1, 0, 1, 0)
			self.TextBox.Position = UDim2.new(0, 0, 0, 0)
			self.TextBox.Text = ""

			self.TeamChatEntered = false

			self.ChatBar:ResetCustomState()
			self.ChatBar:CaptureFocus()
		end
	elseif IsTeamCommand(text) then
		self:EnterTeamChat()
	end
end

function class.GetMessage(p)
	if p.TeamChatEntered then
		return "/t " .. p.TextBox.Text
	end

	return p.TextBox.Text
end

function class.ProcessCompletedMessage(_): boolean
	return false
end

function class:Destroy()
	self.MessageModeConnection:disconnect()
	self.Destroyed = true
end

function class:GetTeamChatColor()
	local localPlayer = Players.LocalPlayer

	if localPlayer.Team then
		return localPlayer.Team.TeamColor.Color
	end

	if self.ChatSettings.DefaultChannelNameColor then
		return self.ChatSettings.DefaultChannelNameColor
	end

	return Color3.fromRGB(35, 76, 142)
end

function v2.new(chatWindow, chatBar, chatSettings)
	local object = setmetatable({}, class)
	object.Destroyed = false
	object.ChatWindow = chatWindow
	object.ChatBar = chatBar
	object.ChatSettings = chatSettings
	object.TextBox = chatBar:GetTextBox()
	object.MessageModeButton = chatBar:GetMessageModeTextButton()
	object.OriginalTeamText = ""
	object.TeamChatEntered = false

	object.MessageModeConnection = object.MessageModeButton.MouseButton1Click:connect(function()
		local text = object.TextBox.Text

		if string.sub(text, 1, 1) == " " then
			text = string.sub(text, 2)
		end

		object.ChatBar:ResetCustomState()
		object.ChatBar:SetTextBoxText(text)
		object.ChatBar:CaptureFocus()
	end)

	object:EnterTeamChat()

	return object
end

function ProcessMessage(p, p2, p3, p4)
	if p3.TargetChannel == "Team" then
		return
	end

	if IsTeamCommand(p) then
		return v2.new(p2, p3, p4)
	end

	return nil
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.IN_PROGRESS_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
