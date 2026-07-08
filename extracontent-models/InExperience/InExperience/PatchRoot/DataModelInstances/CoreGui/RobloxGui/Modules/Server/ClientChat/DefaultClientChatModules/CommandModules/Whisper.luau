local Util = require(script.Parent:WaitForChild("Util"))
local ChatSettings = require(script.Parent.Parent:WaitForChild("ChatSettings"))
local Players = game:GetService("Players")
local ChatLocalization = nil

pcall(function() -- line: 13
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)

local LocalPlayer = Players.LocalPlayer

while LocalPlayer == nil do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local t1 = {}

t1.__index = t1

local t2 = {}

function t1.TrimWhisperCommand(_, p2) -- line: 26
	if string.sub(p2, 1, 3):lower() == "/w " then
		return (string.sub(p2, 4))
	end

	if string.sub(p2, 1, 9):lower() == "/whisper " then
		return (string.sub(p2, 10))
	end

	return nil
end
function t1.TrimWhiteSpace(_, p4) -- line: 35
	return string.gsub(p4, "%s+", ""), p4[#p4] == " "
end
function t1.ShouldAutoCompleteNames(_) -- line: 41
	-- upvalues: ChatSettings (copy)
	if ChatSettings.WhisperCommandAutoCompletePlayerNames ~= nil then
		return ChatSettings.WhisperCommandAutoCompletePlayerNames
	end

	return true
end
function t1.GetWhisperingPlayer(p6, p7) -- line: 48
	-- upvalues: Players (copy), LocalPlayer (ref), ChatSettings (copy)
	local v15 = p6:TrimWhisperCommand((p7:lower()))

	if v15 then
		local v16, v17 = p6:TrimWhiteSpace(v15)
		local t3 = {}
		local t4 = {}
		local players = Players:GetPlayers()

		for i = 1, #players do
			if players[i] ~= LocalPlayer then
				if v16 == string.sub(players[i].Name:lower(), 1, (string.len(v16))) then
					t3[players[i]] = players[i].Name:lower()
				end

				if ChatSettings.WhisperByDisplayName then
					local v22 = players[i].DisplayName:lower()

					if v16 == string.sub(v22, 1, (string.len(v16))) then
						t4[players[i]] = v22
					end
				end
			end
		end

		local n1 = 0
		local v24 = nil
		local v25 = nil

		for k, v in pairs(t3) do
			n1 += 1
			v24 = k
			v25 = v

			if v == v16 and v17 then
				return k
			end
		end

		if ChatSettings.WhisperByDisplayName then
			for k, v in pairs(t4) do
				if v24 ~= k then
					n1 += 1
					v24 = k
					v25 = v
				end
			end
		end

		if n1 == 1 then
			if p6:ShouldAutoCompleteNames() then
				return v24
			end

			if v25 == v16 then
				return v24
			end
		end
	end

	return nil
end
function t1.GetWhisperChanneNameColor(p8) -- line: 106
	if p8.ChatSettings.WhisperChannelNameColor then
		return p8.ChatSettings.WhisperChannelNameColor
	end

	return Color3.fromRGB(102, 14, 102)
end
function t1.EnterWhisperState(p9, p10) -- line: 113
	-- upvalues: ChatSettings (copy), ChatLocalization (ref)
	p9.PlayerNameEntered = true
	p9.PlayerName = p10.Name
	p9.PlayerDisplayName = p10.DisplayName
	p9.MessageModeButton.Size = UDim2.new(0, 1000, 1, 0)

	local v33 = if not ChatSettings.PlayerDisplayNamesEnabled or not ChatSettings.WhisperByDisplayName then string.format("[To %s]", p10.Name) else string.format("[To %s]", p10.DisplayName)

	if ChatLocalization.tryLocalize then
		v33 = ChatLocalization:tryLocalize(v33)
	end

	p9.MessageModeButton.Text = v33
	p9.MessageModeButton.TextColor3 = p9:GetWhisperChanneNameColor()

	local v34 = math.ceil(p9.MessageModeButton.TextBounds.X)

	p9.MessageModeButton.Size = UDim2.new(0, v34, 1, 0)
	p9.TextBox.Size = UDim2.new(1, -v34, 1, 0)
	p9.TextBox.Position = UDim2.new(0, v34, 0, 0)
	p9.TextBox.Text = " "
end
function t1.TextUpdated(p11) -- line: 142
	local TextBoxText = p11.TextBox.Text

	if not p11.PlayerNameEntered then
		local WhisperingPlayer = p11:GetWhisperingPlayer(TextBoxText)

		if WhisperingPlayer then
			p11:EnterWhisperState(WhisperingPlayer)

			return
		end
	elseif TextBoxText == "" then
		p11.MessageModeButton.Text = ""
		p11.MessageModeButton.Size = UDim2.new(0, 0, 0, 0)
		p11.TextBox.Size = UDim2.new(1, 0, 1, 0)
		p11.TextBox.Position = UDim2.new(0, 0, 0, 0)
		p11.TextBox.Text = ""
		p11.PlayerNameEntered = false
		p11.ChatBar:ResetCustomState()
		p11.ChatBar:CaptureFocus()
	end
end
function t1.GetMessage(p12) -- line: 166
	if p12.PlayerNameEntered then
		return "/w " .. p12.PlayerName .. " " .. p12.TextBox.Text
	end

	return p12.TextBox.Text
end
function t1.ProcessCompletedMessage(_) -- line: 173
	return false
end
function t1.Destroy(p14) -- line: 177
	p14.MessageModeConnection:disconnect()
	p14.Destroyed = true
end
function t2.new(p15, p16, p17, p18) -- line: 182
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.Destroyed = false
	self.ChatWindow = p15
	self.ChatBar = p16
	self.ChatSettings = p17
	self.TextBox = p16:GetTextBox()
	self.MessageModeButton = p16:GetMessageModeTextButton()
	self.OriginalWhisperText = ""
	self.PlayerNameEntered = false
	self.MessageModeConnection = self.MessageModeButton.MouseButton1Click:connect(function() -- line: 193
		-- upvalues: self (copy)
		local TextBoxText = self.TextBox.Text

		if string.sub(TextBoxText, 1, 1) == " " then
			TextBoxText = string.sub(TextBoxText, 2)
		end

		self.ChatBar:ResetCustomState()
		self.ChatBar:SetTextBoxText(TextBoxText)
		self.ChatBar:CaptureFocus()
	end)

	if p18 then
		self:EnterWhisperState(p18)

		return self
	end

	self:TextUpdated()

	return self
end
function ProcessMessage(p19, p20, p21, p22) -- line: 212
	-- upvalues: t2 (copy)
	if string.sub(p19, 1, 3):lower() == "/w " or string.sub(p19, 1, 9):lower() == "/whisper " then
		return t2.new(p20, p21, p22)
	end

	return nil
end
function CreateCustomState(p23, p24, p25, p26) -- line: 219
	-- upvalues: t2 (copy)
	return t2.new(p24, p25, p26, p23)
end

return {
	[Util.KEY_COMMAND_PROCESSOR_TYPE] = Util.IN_PROGRESS_MESSAGE_PROCESSOR,
	[Util.KEY_PROCESSOR_FUNCTION] = ProcessMessage,
	CustomStateCreator = CreateCustomState
}
