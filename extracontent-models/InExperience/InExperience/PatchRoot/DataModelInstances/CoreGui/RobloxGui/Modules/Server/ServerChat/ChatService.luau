local t1 = {
	0.05,
	0.1,
	0.2
}
local t2 = {}
local RunService = game:GetService("RunService")
local Chat = game:GetService("Chat")

Chat:WaitForChild("ClientChatModules")

local scriptParent = script.Parent
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local t3 = {
	ChatColor = require(ClientChatModules:WaitForChild("ChatSettings")).ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)
}
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local ChatChannel = require(scriptParent:WaitForChild("ChatChannel"))
local Speaker = require(scriptParent:WaitForChild("Speaker"))
local Util = require(scriptParent:WaitForChild("Util"))
local ChatLocalization = nil

pcall(function() -- line: 38
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)
ChatLocalization = ChatLocalization or {}

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 42
		return p3
	end
end

local function allSpaces(p4) -- line: 45
	return string.len((string.gsub(p4, " ", ""))) == 0
end

local t4 = {}

t4.__index = t4

function t4.AddChannel(p5, p6, p7) -- line: 55
	-- upvalues: ChatLocalization (ref), ChatChannel (copy), ChatConstants (copy)
	if p5.ChatChannels[p6:lower()] then
		error(string.format("Channel %q alrady exists.", p6))
	end

	local function DefaultChannelCommands(p8, p9) -- line: 60
		-- upvalues: p5 (copy), p6 (copy), ChatLocalization (ref)
		if p9:lower() == "/leave" then
			local Channel = p5:GetChannel(p6)
			local Speaker2 = p5:GetSpeaker(p8)

			if Channel and Speaker2 then
				if Channel.Leavable then
					Speaker2:LeaveChannel(p6)
					Speaker2:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatService_YouHaveLeftChannel", string.format("You have left channel '%s'", p6), "RBX_NAME", p6), "System")
				else
					Speaker2:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatService_CannotLeaveChannel", "You cannot leave this channel."), p6)
				end
			end

			return true
		end

		return false
	end

	local v27 = ChatChannel.new(p5, p6)

	p5.ChatChannels[p6:lower()] = v27
	v27:RegisterProcessCommandsFunction("default_commands", DefaultChannelCommands, ChatConstants.HighPriority)

	local ok, result = pcall(function() -- line: 89
		-- upvalues: p5 (copy), p6 (copy)
		p5.eChannelAdded:Fire(p6)
	end)

	if not ok and result then
		print("Error addding channel: " .. result)
	end

	if p7 ~= nil then
		v27.AutoJoin = p7

		if p7 then
			for _, v in pairs(p5.Speakers) do
				v:JoinChannel(p6)
			end
		end
	end

	return v27
end
function t4.RemoveChannel(p10, p11) -- line: 106
	if p10.ChatChannels[p11:lower()] then
		local Name = p10.ChatChannels[p11:lower()].Name

		p10.ChatChannels[p11:lower()]:InternalDestroy()
		p10.ChatChannels[p11:lower()] = nil

		local ok, result = pcall(function() -- line: 113
			-- upvalues: p10 (copy), Name (copy)
			p10.eChannelRemoved:Fire(Name)
		end)

		if not ok and result then
			print("Error removing channel: " .. result)

			return
		end
	else
		warn(string.format("Channel %q does not exist.", p11))
	end
end
function t4.GetChannel(p12, p13) -- line: 122
	return p12.ChatChannels[p13:lower()]
end
function t4.AddSpeaker(p14, p15) -- line: 127
	-- upvalues: Speaker (copy)
	if p14.Speakers[p15:lower()] then
		error("Speaker \"" .. p15 .. "\" already exists!")
	end

	local v41 = Speaker.new(p14, p15)

	p14.Speakers[p15:lower()] = v41

	local ok, result = pcall(function() -- line: 135
		-- upvalues: p14 (copy), p15 (copy)
		p14.eSpeakerAdded:Fire(p15)
	end)

	if not ok and result then
		print("Error adding speaker: " .. result)
	end

	return v41
end
function t4.InternalUnmuteSpeaker(p16, p17) -- line: 143
	for _, v in pairs(p16.ChatChannels) do
		if v:IsSpeakerMuted(p17) then
			v:UnmuteSpeaker(p17)
		end
	end
end
function t4.RemoveSpeaker(p18, p19) -- line: 151
	if p18.Speakers[p19:lower()] then
		local Name = p18.Speakers[p19:lower()].Name

		p18:InternalUnmuteSpeaker(Name)
		p18.Speakers[p19:lower()]:InternalDestroy()
		p18.Speakers[p19:lower()] = nil

		local ok, result = pcall(function() -- line: 160
			-- upvalues: p18 (copy), Name (copy)
			p18.eSpeakerRemoved:Fire(Name)
		end)

		if not ok and result then
			print("Error removing speaker: " .. result)

			return
		end
	else
		warn("Speaker \"" .. p19 .. "\" does not exist!")
	end
end
function t4.GetSpeaker(p20, p21) -- line: 170
	return p20.Speakers[p21:lower()]
end
function t4.GetSpeakerByUserOrDisplayName(p22, p23) -- line: 174
	local v57 = p22.Speakers[p23:lower()]

	if v57 then
		return v57
	end

	for _, v in pairs(p22.Speakers) do
		local Player = v:GetPlayer()

		if Player and Player.DisplayName:lower() == p23:lower() then
			return v
		end
	end
end
function t4.GetChannelList(p24) -- line: 190
	local t5 = {}

	for _, v in pairs(p24.ChatChannels) do
		if not v.Private then
			table.insert(t5, v.Name)
		end
	end

	return t5
end
function t4.GetAutoJoinChannelList(p25) -- line: 200
	local t6 = {}

	for _, v in pairs(p25.ChatChannels) do
		if v.AutoJoin then
			table.insert(t6, v)
		end
	end

	return t6
end
function t4.GetSpeakerList(p26) -- line: 210
	local t7 = {}

	for _, v in pairs(p26.Speakers) do
		table.insert(t7, v.Name)
	end

	return t7
end
function t4.SendGlobalSystemMessage(p27, p28) -- line: 218
	for _, v in pairs(p27.Speakers) do
		v:SendSystemMessage(p28, nil)
	end
end
function t4.RegisterFilterMessageFunction(p29, p30, p31, p32) -- line: 224
	if p29.FilterMessageFunctions:HasFunction(p30) then
		error(string.format("FilterMessageFunction '%s' already exists", p30))
	end

	p29.FilterMessageFunctions:AddFunction(p30, p31, p32)
end
function t4.FilterMessageFunctionExists(p33, p34) -- line: 231
	return p33.FilterMessageFunctions:HasFunction(p34)
end
function t4.UnregisterFilterMessageFunction(p35, p36) -- line: 235
	if not p35.FilterMessageFunctions:HasFunction(p36) then
		error(string.format("FilterMessageFunction '%s' does not exists", p36))
	end

	p35.FilterMessageFunctions:RemoveFunction(p36)
end
function t4.RegisterProcessCommandsFunction(p37, p38, p39, p40) -- line: 242
	if p37.ProcessCommandsFunctions:HasFunction(p38) then
		error(string.format("ProcessCommandsFunction '%s' already exists", p38))
	end

	p37.ProcessCommandsFunctions:AddFunction(p38, p39, p40)
end
function t4.ProcessCommandsFunctionExists(p41, p42) -- line: 249
	return p41.ProcessCommandsFunctions:HasFunction(p42)
end
function t4.UnregisterProcessCommandsFunction(p43, p44) -- line: 253
	if not p43.ProcessCommandsFunctions:HasFunction(p44) then
		error(string.format("ProcessCommandsFunction '%s' does not exist", p44))
	end

	p43.ProcessCommandsFunctions:RemoveFunction(p44)
end

local n1 = 0
local n2 = 0
local n3 = 0

function t4.InternalNotifyFilterIssue(p45) -- line: 263
	-- upvalues: n2 (ref), n3 (ref), n1 (ref), ChatLocalization (ref), t3 (copy)
	if tick() - n2 > 60 then
		n3 = 0
	end

	n3 += 1
	n2 = tick()

	if n3 >= 3 and tick() - n1 > 60 then
		n1 = tick()

		local Channel = p45:GetChannel("System")

		if Channel then
			Channel:SendSystemMessage(ChatLocalization:FormatMessageToSend("GameChat_ChatService_ChatFilterIssues", "The chat filter is currently experiencing issues and messages may be slow to appear."), t3)
		end
	end
end

local t8 = {}

function t4.InternalApplyRobloxFilter(p46, p47, p48, p49) -- line: 292
	-- upvalues: RunService (copy), Chat (copy), t1 (copy), t8 (copy)
	if RunService:IsServer() and not RunService:IsStudio() then
		local Speaker3 = p46:GetSpeaker(p47)
		local v100 = p49 and p46:GetSpeaker(p49)

		if Speaker3 == nil then
			return nil
		end

		local Player = Speaker3:GetPlayer()
		local v102 = v100 and v100:GetPlayer()

		if Player == nil then
			return p48
		end

		if string.len((string.gsub(p48, " ", ""))) == 0 then
			return p48
		end

		local timestamp = tick()
		local n4 = 0
		local result = nil

		while true do
			local ok

			ok, result = pcall(function() -- line: 315
				-- upvalues: v102 (copy), Chat (copy), p48 (copy), Player (copy)
				if v102 then
					return Chat:FilterStringAsync(p48, Player, v102)
				end

				return Chat:FilterStringForBroadcast(p48, Player)
			end)

			if ok then
				break
			end

			warn("Error filtering message:", result)
			n4 += 1

			if n4 > 3 or tick() - timestamp > 60 then
				p46:InternalNotifyFilterIssue()

				return nil
			end

			local v107 = t1[math.min(#t1, n4)]
			local v108 = v107 + (math.random() * 2 - 1) * v107

			wait(v108)
		end

		return result
	end

	if not t8[p48] then
		t8[p48] = true
		wait()
	end

	return p48
end
function t4.InternalApplyRobloxFilterAndTranslate(p50, p51, p52, p53, p54) -- line: 351
	-- upvalues: RunService (copy)
	if RunService:IsServer() and not RunService:IsStudio() then
		local Speaker4 = p50:GetSpeaker(p51)

		if Speaker4 == nil then
			return false, nil, nil
		end

		local Player = Speaker4:GetPlayer()

		if Player == nil then
			return true, false, p53
		end

		if string.len((string.gsub(p53, " ", ""))) == 0 then
			return true, false, p53
		end

		local ok, result = pcall(function() -- line: 369
			-- upvalues: p53 (copy), Player (copy), p52 (copy), p54 (copy)
			return (game:GetService("TextService"):FilterAndTranslateStringAsync(p53, Player.UserId, p52, p54))
		end)

		if ok then
			return true, true, result
		end

		warn("Error filtering and translating message", p53, result)
		p50:InternalNotifyFilterIssue()

		return false, nil, nil
	end

	wait()

	return true, false, p53
end
function t4.InternalApplyRobloxFilterNewAPI(p55, p56, p57, p58) -- line: 388
	-- upvalues: RunService (copy)
	if RunService:IsServer() and not RunService:IsStudio() then
		local Speaker5 = p55:GetSpeaker(p56)

		if Speaker5 == nil then
			return false, nil, nil
		end

		local Player = Speaker5:GetPlayer()

		if Player == nil then
			return true, false, p57
		end

		if string.len((string.gsub(p57, " ", ""))) == 0 then
			return true, false, p57
		end

		local ok, result = pcall(function() -- line: 407
			-- upvalues: p57 (copy), Player (copy), p58 (copy)
			return (game:GetService("TextService"):FilterStringAsync(p57, Player.UserId, p58))
		end)

		if ok then
			return true, true, result
		end

		warn("Error filtering message:", p57, result)
		p55:InternalNotifyFilterIssue()

		return false, nil, nil
	end

	wait()

	return true, false, p57
end
function t4.InternalDoMessageFilter(p59, p60, p61, p62) -- line: 426
	for v130, v131, _ in (p59.FilterMessageFunctions:GetIterator()) do
		local ok, result = pcall(function() -- line: 430
			-- upvalues: v131 (copy), p60 (copy), p61 (copy), p62 (copy)
			v131(p60, p61, p62)
		end)

		if not ok then
			warn(string.format("DoMessageFilter Function '%s' failed for reason: %s", v130, result))
		end
	end
end
function t4.InternalDoProcessCommands(p63, p64, p65, p66) -- line: 440
	for v139, v140, _ in (p63.ProcessCommandsFunctions:GetIterator()) do
		local ok, result = pcall(function() -- line: 444
			-- upvalues: v140 (copy), p64 (copy), p65 (copy), p66 (copy)
			local v162 = v140(p64, p65, p66)

			if type(v162) ~= "boolean" then
				error("Process command functions must return a bool")
			end

			return v162
		end)

		if ok then
			if not result then
				continue
			end

			return true
		end

		warn(string.format("DoProcessCommands Function '%s' failed for reason: %s", v139, result))
	end

	return false
end
function t4.InternalGetUniqueMessageId(p67) -- line: 462
	local MessageIdCounter = p67.MessageIdCounter

	p67.MessageIdCounter = MessageIdCounter + 1

	return MessageIdCounter
end
function t4.InternalAddSpeakerWithPlayerObject(p68, p69, p70, p71) -- line: 468
	-- upvalues: Speaker (copy)
	if p68.Speakers[p69:lower()] then
		error("Speaker \"" .. p69 .. "\" already exists!")
	end

	local v150 = Speaker.new(p68, p69)

	v150:InternalAssignPlayerObject(p70)
	p68.Speakers[p69:lower()] = v150

	if p71 then
		local ok, result = pcall(function() -- line: 478
			-- upvalues: p68 (copy), p69 (copy)
			p68.eSpeakerAdded:Fire(p69)
		end)

		if not ok and result then
			print("Error adding speaker: " .. result)
		end
	end

	return v150
end
function t4.InternalFireSpeakerAdded(p72, p73) -- line: 487
	local ok, result = pcall(function() -- line: 488
		-- upvalues: p72 (copy), p73 (copy)
		p72.eSpeakerAdded:Fire(p73)
	end)

	if not ok and result then
		print("Error firing speaker added: " .. result)
	end
end
function t2.new() -- line: 497
	-- upvalues: t4 (copy), Util (copy)
	local self = setmetatable({}, t4)

	self.MessageIdCounter = 0
	self.ChatChannels = {}
	self.Speakers = {}
	self.FilterMessageFunctions = Util:NewSortedFunctionContainer()
	self.ProcessCommandsFunctions = Util:NewSortedFunctionContainer()
	self.eChannelAdded = Instance.new("BindableEvent")
	self.eChannelRemoved = Instance.new("BindableEvent")
	self.eSpeakerAdded = Instance.new("BindableEvent")
	self.eSpeakerRemoved = Instance.new("BindableEvent")
	self.ChannelAdded = self.eChannelAdded.Event
	self.ChannelRemoved = self.eChannelRemoved.Event
	self.SpeakerAdded = self.eSpeakerAdded.Event
	self.SpeakerRemoved = self.eSpeakerRemoved.Event
	self.ChatServiceMajorVersion = 0
	self.ChatServiceMinorVersion = 5

	return self
end

return t2.new()
