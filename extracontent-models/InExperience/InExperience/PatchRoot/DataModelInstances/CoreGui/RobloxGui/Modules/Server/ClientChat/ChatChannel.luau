local ok, result = pcall(function() -- line: 7
	return UserSettings():IsUserFeatureEnabled("UserFlagRemoveMessageFromMessageLog")
end)
local u3 = ok and result
local ok2, result2 = pcall(function() -- line: 15
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)
local u6 = ok2 and result2
local t1 = {}
local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local scriptParent = script.Parent
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local ChatTranslationEnabled = nil

if u6 then
	ChatTranslationEnabled = scriptParent:FindFirstChild("ChatTranslationEnabled")

	if ChatTranslationEnabled == nil then
		local connection = nil

		connection = scriptParent.ChildAdded:Connect(function(child) -- line: 35
			-- upvalues: ChatTranslationEnabled (ref), connection (ref)
			if child.Name == "ChatTranslationEnabled" then
				ChatTranslationEnabled = child
				connection:Disconnect()
			end
		end)
	end
end

local t2 = {}

t2.__index = t2

function t2.Destroy(p1) -- line: 50
	p1.Destroyed = true
end
function t2.SetActive(p2, p3) -- line: 54
	if p3 == p2.Active then
		return
	end

	if p3 == false then
		p2.MessageLogDisplay:Clear()
	else
		p2.MessageLogDisplay:SetCurrentChannelName(p2.Name)

		for i = 1, #p2.MessageLog do
			p2.MessageLogDisplay:AddMessage(p2.MessageLog[i])
		end
	end

	p2.Active = p3
end
function t2.UpdateMessageFiltered(p4, p5) -- line: 69
	-- upvalues: u6 (ref), ChatTranslationEnabled (ref), u3 (ref)
	local n1 = 1
	local MessageLog = p4.MessageLog
	local v23 = nil

	while n1 <= #MessageLog do
		local v24 = MessageLog[n1]

		if v24.ID == p5.ID then
			v23 = v24

			break
		end

		n1 += 1
	end

	if v23 then
		v23.Message = p5.Message
		v23.IsFiltered = true

		if u6 and ChatTranslationEnabled ~= nil and ChatTranslationEnabled.Value then
			v23.TranslatedMessage = p5.TranslatedMessage
			v23.ShowTranslated = true
		end

		if p4.Active then
			if u3 and v23.Message == "" then
				table.remove(p4.MessageLog, n1)
			end

			p4.MessageLogDisplay:UpdateMessageFiltered(v23)

			return
		end
	else
		p4:AddMessageToChannelByTimeStamp(p5)
	end
end
function t2.AddMessageToChannel(p6, p7) -- line: 105
	-- upvalues: ChatSettings (copy)
	table.insert(p6.MessageLog, p7)

	if p6.Active then
		p6.MessageLogDisplay:AddMessage(p7)
	end

	if #p6.MessageLog > ChatSettings.MessageHistoryLengthPerChannel then
		p6:RemoveLastMessageFromChannel()
	end
end
function t2.InternalAddMessageAtTimeStamp(p8, p9) -- line: 115
	for i = 1, #p8.MessageLog do
		if p9.Time < p8.MessageLog[i].Time then
			table.insert(p8.MessageLog, i, p9)

			return
		end
	end

	table.insert(p8.MessageLog, p9)
end
function t2.AddMessagesToChannelByTimeStamp(p10, p11, p12) -- line: 125
	-- upvalues: ChatSettings (copy)
	for i = p12, #p11 do
		p10:InternalAddMessageAtTimeStamp(p11[i])
	end

	while #p10.MessageLog > ChatSettings.MessageHistoryLengthPerChannel do
		table.remove(p10.MessageLog, 1)
	end

	if p10.Active then
		p10.MessageLogDisplay:Clear()

		for i = 1, #p10.MessageLog do
			p10.MessageLogDisplay:AddMessage(p10.MessageLog[i])
		end
	end
end
function t2.AddMessageToChannelByTimeStamp(p13, p14) -- line: 140
	-- upvalues: ChatSettings (copy)
	if #p13.MessageLog >= 1 then
		if p13.MessageLog[1].Time > p14.Time then
			return
		end

		if p14.Time >= p13.MessageLog[#p13.MessageLog].Time then
			p13:AddMessageToChannel(p14)

			return
		end

		for i = 1, #p13.MessageLog do
			if p14.Time < p13.MessageLog[i].Time then
				table.insert(p13.MessageLog, i, p14)

				if #p13.MessageLog > ChatSettings.MessageHistoryLengthPerChannel then
					p13:RemoveLastMessageFromChannel()
				end

				if p13.Active then
					p13.MessageLogDisplay:AddMessageAtIndex(p14, i)
				end

				return
			end
		end

		return
	end

	p13:AddMessageToChannel(p14)
end
function t2.RemoveLastMessageFromChannel(p15) -- line: 170
	table.remove(p15.MessageLog, 1)

	if p15.Active then
		p15.MessageLogDisplay:RemoveLastMessage()
	end
end
function t2.ClearMessageLog(p16) -- line: 178
	p16.MessageLog = {}

	if p16.Active then
		p16.MessageLogDisplay:Clear()
	end
end
function t2.RegisterChannelTab(p17, p18) -- line: 186
	p17.ChannelTab = p18
end
function t1.new(p19, p20) -- line: 193
	-- upvalues: t2 (copy)
	local self = setmetatable({}, t2)

	self.Destroyed = false
	self.Active = false
	self.MessageLog = {}
	self.MessageLogDisplay = p20
	self.ChannelTab = nil
	self.Name = p19

	return self
end

return t1
