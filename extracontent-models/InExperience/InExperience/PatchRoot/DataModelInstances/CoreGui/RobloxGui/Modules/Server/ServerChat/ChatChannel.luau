local ok, result = pcall(function() -- line: 8
	return UserSettings():IsUserFeatureEnabled("UserShouldMuteUnfilteredMessage")
end)
local u3 = ok and result
local ok2, result2 = pcall(function() -- line: 13
	return UserSettings():IsUserFeatureEnabled("UserRemoveMessageOnTextFilterFailures")
end)
local u6 = ok2 and result2
local ok3, result3 = pcall(function() -- line: 21
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)
local u9 = ok3 and result3
local t1 = {}
local scriptParent = script.Parent
local Chat = game:GetService("Chat")
local RunService = game:GetService("RunService")
local ClientChatModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local ChatConstants = require(ClientChatModules:WaitForChild("ChatConstants"))
local Util = require(scriptParent:WaitForChild("Util"))
local ChatLocalization = nil

pcall(function() -- line: 42
	-- upvalues: ChatLocalization (ref)
	ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization)
end)
ChatLocalization = ChatLocalization or {}

if not ChatLocalization.FormatMessageToSend or not ChatLocalization.LocalizeFormattedMessage then
	function ChatLocalization.FormatMessageToSend(_, _, p3) -- line: 46
		return p3
	end
end

local t2 = {}

t2.__index = t2

function t2.SendSystemMessage(p4, p5, p6) -- line: 55
	local v27 = p4:InternalCreateMessageObject(p5, nil, true, p6)
	local ok4, result4 = pcall(function() -- line: 58
		-- upvalues: p4 (copy), v27 (copy)
		p4.eMessagePosted:Fire(v27)
	end)

	if not ok4 and result4 then
		print("Error posting message: " .. result4)
	end

	p4:InternalAddMessageToHistoryLog(v27)

	for _, v in pairs(p4.Speakers) do
		v:InternalSendSystemMessage(v27, p4.Name)
	end

	return v27
end
function t2.SendSystemMessageToSpeaker(p7, p8, p9, p10) -- line: 72
	-- upvalues: RunService (copy)
	local v36 = p7.Speakers[p9]

	if v36 then
		v36:InternalSendSystemMessage(p7:InternalCreateMessageObject(p8, nil, true, p10), p7.Name)

		return
	end

	if RunService:IsStudio() then
		warn(string.format("Speaker '%s' is not in channel '%s' and cannot be sent a system message", p9, p7.Name))
	end
end
function t2.SendMessageObjToFilters(p11, p12, p13, p14) -- line: 82
	local p13Message = p13.Message

	p13.Message = p12
	p11:InternalDoMessageFilter(p14.Name, p13, p11.Name)
	p11.ChatService:InternalDoMessageFilter(p14.Name, p13, p11.Name)

	local p13Message2 = p13.Message

	p13.Message = p13Message

	return p13Message2
end
function t2.CanCommunicateByUserId(_, p16, p17) -- line: 92
	-- upvalues: RunService (copy), Chat (copy)
	if RunService:IsStudio() then
		return true
	end

	if p16 == 0 or p17 == 0 then
		return true
	end

	local ok5, result5 = pcall(function() -- line: 100
		-- upvalues: Chat (copy), p16 (copy), p17 (copy)
		return Chat:CanUsersChatAsync(p16, p17)
	end)

	return ok5 and result5
end
function t2.CanCommunicate(p18, p19, p20) -- line: 106
	local Player = p19:GetPlayer()
	local Player2 = p20:GetPlayer()

	if Player and Player2 then
		return p18:CanCommunicateByUserId(Player.UserId, Player2.UserId)
	end

	return true
end
function t2.SendMessageToSpeaker(p21, p22, p23, p24, p25) -- line: 115
	-- upvalues: RunService (copy)
	local v58 = p21.Speakers[p23]
	local Speaker = p21.ChatService:GetSpeaker(p24)

	if v58 and Speaker then
		if v58:IsSpeakerMuted(p24) then
			return
		end

		if not p21:CanCommunicate(v58, Speaker) then
			return
		end

		local v60 = p21:InternalCreateMessageObject(p22, p24, p23 == p24, p25)
		local v61 = p21:SendMessageObjToFilters(p22, v60, p24)

		v58:InternalSendMessage(v60, p21.Name)

		local v62 = p21.Private and Enum.TextFilterContext.PrivateChat or Enum.TextFilterContext.PublicChat
		local v63, v64, v65 = p21.ChatService:InternalApplyRobloxFilterNewAPI(v60.FromSpeaker, v61, v62)

		if v63 then
			v60.FilterResult = v65
			v60.IsFilterResult = v64
			v60.IsFiltered = true
			v58:InternalSendFilteredMessageWithFilterResult(v60, p21.Name)

			return
		end
	elseif RunService:IsStudio() then
		warn(string.format("Speaker '%s' is not in channel '%s' and cannot be sent a message", p23, p21.Name))
	end
end
function t2.KickSpeaker(p26, p27, p28) -- line: 151
	local Speaker = p26.ChatService:GetSpeaker(p27)

	if not Speaker then
		error("Speaker \"" .. p27 .. "\" does not exist!")
	end

	local NameForDisplay = Speaker:GetNameForDisplay()
	local v71, v72

	if p28 then
		v71 = string.format("You were kicked from '%s' for the following reason(s): %s", p26.Name, p28)
		v72 = string.format("%s was kicked for the following reason(s): %s", NameForDisplay, p28)
	else
		v71 = string.format("You were kicked from '%s'", p26.Name)
		v72 = string.format("%s was kicked", NameForDisplay)
	end

	p26:SendSystemMessageToSpeaker(v71, p27)
	Speaker:LeaveChannel(p26.Name)
	p26:SendSystemMessage(v72)
end
function t2.MuteSpeaker(p29, p30, p31, p32) -- line: 174
	local Speaker = p29.ChatService:GetSpeaker(p30)

	if not Speaker then
		error("Speaker \"" .. p30 .. "\" does not exist!")
	end

	p29.Mutes[p30:lower()] = if p32 ~= 0 and p32 ~= nil then os.time() + p32 else 0

	if p31 then
		local NameForDisplay = Speaker:GetNameForDisplay()

		p29:SendSystemMessage(string.format("%s was muted for the following reason(s): %s", NameForDisplay, p31))
	end

	local ok6, result6 = pcall(function() -- line: 188
		-- upvalues: p29 (copy), p30 (copy), p31 (copy), p32 (copy)
		p29.eSpeakerMuted:Fire(p30, p31, p32)
	end)

	if not ok6 and result6 then
		print("Error mutting speaker: " .. result6)
	end

	local Speaker2 = p29.ChatService:GetSpeaker(p30)

	if Speaker2 then
		local ok7, result7 = pcall(function() -- line: 195
			-- upvalues: Speaker2 (copy), p29 (copy), p31 (copy), p32 (copy)
			Speaker2.eMuted:Fire(p29.Name, p31, p32)
		end)

		if not ok7 and result7 then
			print("Error mutting speaker: " .. result7)
		end
	end
end
function t2.UnmuteSpeaker(p33, p34) -- line: 203
	if not p33.ChatService:GetSpeaker(p34) then
		error("Speaker \"" .. p34 .. "\" does not exist!")
	end

	p33.Mutes[p34:lower()] = nil

	local ok8, result8 = pcall(function() -- line: 211
		-- upvalues: p33 (copy), p34 (copy)
		p33.eSpeakerUnmuted:Fire(p34)
	end)

	if not ok8 and result8 then
		print("Error unmuting speaker: " .. result8)
	end

	local Speaker = p33.ChatService:GetSpeaker(p34)

	if Speaker then
		local ok9, result9 = pcall(function() -- line: 218
			-- upvalues: Speaker (copy), p33 (copy)
			Speaker.eUnmuted:Fire(p33.Name)
		end)

		if not ok9 and result9 then
			print("Error unmuting speaker: " .. result9)
		end
	end
end
function t2.IsSpeakerMuted(p35, p36) -- line: 225
	return p35.Mutes[p36:lower()] ~= nil
end
function t2.GetSpeakerList(p37) -- line: 229
	local t3 = {}

	for _, v in pairs(p37.Speakers) do
		table.insert(t3, v.Name)
	end

	return t3
end
function t2.RegisterFilterMessageFunction(p38, p39, p40, p41) -- line: 237
	if p38.FilterMessageFunctions:HasFunction(p39) then
		error(string.format("FilterMessageFunction '%s' already exists", p39))
	end

	p38.FilterMessageFunctions:AddFunction(p39, p40, p41)
end
function t2.FilterMessageFunctionExists(p42, p43) -- line: 244
	return p42.FilterMessageFunctions:HasFunction(p43)
end
function t2.UnregisterFilterMessageFunction(p44, p45) -- line: 248
	if not p44.FilterMessageFunctions:HasFunction(p45) then
		error(string.format("FilterMessageFunction '%s' does not exists", p45))
	end

	p44.FilterMessageFunctions:RemoveFunction(p45)
end
function t2.RegisterProcessCommandsFunction(p46, p47, p48, p49) -- line: 255
	if p46.ProcessCommandsFunctions:HasFunction(p47) then
		error(string.format("ProcessCommandsFunction '%s' already exists", p47))
	end

	p46.ProcessCommandsFunctions:AddFunction(p47, p48, p49)
end
function t2.ProcessCommandsFunctionExists(p50, p51) -- line: 262
	return p50.ProcessCommandsFunctions:HasFunction(p51)
end
function t2.UnregisterProcessCommandsFunction(p52, p53) -- line: 266
	if not p52.ProcessCommandsFunctions:HasFunction(p53) then
		error(string.format("ProcessCommandsFunction '%s' does not exist", p53))
	end

	p52.ProcessCommandsFunctions:RemoveFunction(p53)
end

local function ShallowCopy(p54) -- line: 273
	local t4 = {}

	for k, v in pairs(p54) do
		t4[k] = v
	end

	return t4
end

function t2.GetHistoryLog(p55) -- line: 281
	local ChatHistory = p55.ChatHistory
	local t5 = {}

	for k, v in pairs(ChatHistory) do
		t5[k] = v
	end

	return t5
end
function t2.GetHistoryLogForSpeaker(p56, p57) -- line: 285
	-- upvalues: ChatConstants (copy)
	local n1 = -1
	local Player = p57:GetPlayer()

	if Player then
		n1 = Player.UserId
	end

	local t6 = {}

	for i = 1, #p56.ChatHistory do
		if p56:CanCommunicateByUserId(n1, p56.ChatHistory[i].SpeakerUserId) then
			local v128 = p56.ChatHistory[i]
			local t7 = {}

			for k, v in pairs(v128) do
				t7[k] = v
			end

			if t7.MessageType == ChatConstants.MessageTypeDefault or t7.MessageType == ChatConstants.MessageTypeMeCommand then
				local FilterResult = t7.FilterResult

				if t7.IsFilterResult then
					if Player then
						t7.Message = FilterResult:GetChatForUserAsync(Player.UserId)
					else
						t7.Message = FilterResult:GetNonChatStringForBroadcastAsync()
					end
				else
					t7.Message = FilterResult
				end
			end

			table.insert(t6, t7)
		end
	end

	return t6
end
function t2.InternalDestroy(p58) -- line: 323
	for _, v in pairs(p58.Speakers) do
		v:LeaveChannel(p58.Name)
	end

	p58.eDestroyed:Fire()
	p58.eDestroyed:Destroy()
	p58.eMessagePosted:Destroy()
	p58.eSpeakerJoined:Destroy()
	p58.eSpeakerLeft:Destroy()
	p58.eSpeakerMuted:Destroy()
	p58.eSpeakerUnmuted:Destroy()
end
function t2.InternalDoMessageFilter(p59, p60, p61, p62) -- line: 338
	for v140, v141, _ in (p59.FilterMessageFunctions:GetIterator()) do
		local ok10, result10 = pcall(function() -- line: 341
			-- upvalues: v141 (copy), p60 (copy), p61 (copy), p62 (copy)
			v141(p60, p61, p62)
		end)

		if not ok10 then
			warn(string.format("DoMessageFilter Function '%s' failed for reason: %s", v140, result10))
		end
	end
end
function t2.InternalDoProcessCommands(p63, p64, p65, p66) -- line: 351
	for v149, v150, _ in (p63.ProcessCommandsFunctions:GetIterator()) do
		local ok11, result11 = pcall(function() -- line: 354
			-- upvalues: v150 (copy), p64 (copy), p65 (copy), p66 (copy)
			local v246 = v150(p64, p65, p66)

			if type(v246) ~= "boolean" then
				error("Process command functions must return a bool")
			end

			return v246
		end)

		if ok11 then
			if not result11 then
				continue
			end

			return true
		end

		warn(string.format("DoProcessCommands Function '%s' failed for reason: %s", v149, result11))
	end

	return false
end
function getLanguageCodeFromLocale(p67) -- line: 372
	local v155 = string.gmatch(p67, "[^-]+")()

	if v155 then
		return v155
	end

	return "en"
end
function t2.InternalPostMessage(p68, p69, p70, p71) -- line: 382
	-- upvalues: ChatLocalization (ref), Chat (copy), u3 (ref), u9 (ref), u6 (ref)
	if p68:InternalDoProcessCommands(p69.Name, p70, p68.Name) then
		return false
	end

	if p68.Mutes[p69.Name:lower()] ~= nil then
		local v160 = p68.Mutes[p69.Name:lower()]

		if not (v160 > 0) or not (v160 < os.time()) then
			p68:SendSystemMessageToSpeaker(ChatLocalization:FormatMessageToSend("GameChat_ChatChannel_MutedInChannel", "You are muted and cannot talk in this channel"), p69.Name)

			return false
		end

		p68:UnmuteSpeaker(p69.Name)
	end

	local u161 = p68:InternalCreateMessageObject(p70, p69.Name, false, p71)

	u161.Message = p70

	local u162 = nil

	pcall(function() -- line: 400
		-- upvalues: u162 (ref), Chat (copy), u161 (ref)
		u162 = Chat:InvokeChatCallback(Enum.ChatCallbackType.OnServerReceivingMessage, u161)
	end)
	u161.Message = nil

	if u162 then
		if u162.ShouldDeliver == false then
			return false
		end

		u161 = u162
	end

	local v163 = p68:SendMessageObjToFilters(p70, u161, p69)
	local t8 = {}

	for _, v in pairs(p68.Speakers) do
		if not v:IsSpeakerMuted(p69.Name) and p68:CanCommunicate(p69, v) then
			table.insert(t8, v.Name)

			if v.Name == p69.Name then
				local v167 = u161
				local t9 = {}

				for k, v2 in pairs(v167) do
					t9[k] = v2
				end

				if u3 then
					local v171 = u161.MessageLengthUtf8 or u161.MessageLength

					t9.Message = string.rep("_", v171)
				else
					t9.Message = v163
				end

				t9.IsFiltered = true
				v:InternalSendMessage(t9, p68.Name)
			else
				v:InternalSendMessage(u161, p68.Name)
			end
		end
	end

	local ok12, result12 = pcall(function() -- line: 439
		-- upvalues: p68 (copy), u161 (ref)
		p68.eMessagePosted:Fire(u161)
	end)

	if not ok12 and result12 then
		print("Error posting message: " .. result12)
	end

	local v174 = p68.Private and Enum.TextFilterContext.PrivateChat or Enum.TextFilterContext.PublicChat
	local v175 = nil

	if u9 then
		local t10 = {}
		local t11 = {}

		for _, v in pairs(p68.Speakers) do
			local Player = v:GetPlayer()

			if Player ~= nil and Player.LocaleId ~= nil then
				t11[getLanguageCodeFromLocale(Player.LocaleId)] = true
			end
		end

		for v181, _ in t11 do
			table.insert(t10, v181)
		end

		local v183, v184, v185 = p68.ChatService:InternalApplyRobloxFilterAndTranslate(u161.FromSpeaker, t10, v163, v174)

		if v183 then
			if v184 then
				u161.FilterResult = v185.SourceText
			else
				u161.FilterResult = v185
			end

			u161.IsFilterResult = v184

			if v184 then
				v175 = v185
			end
		else
			if not u6 then
				return false
			end

			u161.IsFilterResult = false
			u161.FilterResult = ""
			u161.MessageLength = 0
		end
	else
		local v186, v187, v188 = p68.ChatService:InternalApplyRobloxFilterNewAPI(u161.FromSpeaker, v163, v174)

		if v186 then
			u161.FilterResult = v188
			u161.IsFilterResult = v187
		else
			if not u6 then
				return false
			end

			u161.IsFilterResult = false
			u161.FilterResult = ""
			u161.MessageLength = 0
		end
	end

	u161.IsFiltered = true
	p68:InternalAddMessageToHistoryLog(u161)

	for _, v in pairs(t8) do
		local v191 = p68.Speakers[v]

		if v191 then
			if u9 and (v175 and (p69:GetPlayer() ~= nil and (v191:GetPlayer() ~= nil and p69:GetPlayer().LocaleId ~= v191:GetPlayer().LocaleId))) then
				v191:InternalSendFilteredMessageWithTranslatedFilterResult(u161, p68.Name, v175)
			else
				v191:InternalSendFilteredMessageWithFilterResult(u161, p68.Name)
			end
		end
	end

	local t12 = {}

	for _, v in pairs(p68.Speakers) do
		if not v:IsSpeakerMuted(p69.Name) and p68:CanCommunicate(p69, v) then
			local v195 = false

			for _, v3 in pairs(t8) do
				if v3 == v.Name then
					v195 = true

					break
				end
			end

			if not v195 then
				table.insert(t12, v.Name)
			end
		end
	end

	for _, v in pairs(t12) do
		local v200 = p68.Speakers[v]

		if v200 then
			v200:InternalSendFilteredMessageWithFilterResult(u161, p68.Name)
		end
	end

	return u161
end
function t2.InternalAddSpeaker(p72, p73) -- line: 551
	if p72.Speakers[p73.Name] then
		warn("Speaker \"" .. p73.name .. "\" is already in the channel!")

		return
	end

	p72.Speakers[p73.Name] = p73

	local ok13, result13 = pcall(function() -- line: 558
		-- upvalues: p72 (copy), p73 (copy)
		p72.eSpeakerJoined:Fire(p73.Name)
	end)

	if not ok13 and result13 then
		print("Error removing channel: " .. result13)
	end
end
function t2.InternalRemoveSpeaker(p74, p75) -- line: 564
	if not p74.Speakers[p75.Name] then
		warn("Speaker \"" .. p75.name .. "\" is not in the channel!")

		return
	end

	p74.Speakers[p75.Name] = nil

	local ok14, result14 = pcall(function() -- line: 571
		-- upvalues: p74 (copy), p75 (copy)
		p74.eSpeakerLeft:Fire(p75.Name)
	end)

	if not ok14 and result14 then
		print("Error removing speaker: " .. result14)
	end
end
function t2.InternalRemoveExcessMessagesFromLog(p76) -- line: 577
	local remove = table.remove

	while #p76.ChatHistory > p76.MaxHistory do
		remove(p76.ChatHistory, 1)
	end
end
function t2.InternalAddMessageToHistoryLog(p77, p78) -- line: 584
	table.insert(p77.ChatHistory, p78)
	p77:InternalRemoveExcessMessagesFromLog()
end
function t2.GetMessageType(_, _, p81) -- line: 590
	-- upvalues: ChatConstants (copy)
	if p81 == nil then
		return ChatConstants.MessageTypeSystem
	end

	return ChatConstants.MessageTypeDefault
end
function t2.InternalCreateMessageObject(p82, p83, p84, p85, p86) -- line: 597
	-- upvalues: ChatSettings (copy)
	local MessageType = p82:GetMessageType(p83, p84)
	local n2 = -1
	local NameForDisplay = nil
	local Speaker = nil

	if p84 then
		Speaker = p82.ChatService:GetSpeaker(p84)

		if Speaker then
			local Player = Speaker:GetPlayer()

			if Player then
				n2 = Player.UserId

				if ChatSettings.PlayerDisplayNamesEnabled then
					NameForDisplay = Speaker:GetNameForDisplay()
				end
			else
				n2 = 0
			end
		end
	end

	local t13 = {
		ID = p82.ChatService:InternalGetUniqueMessageId(),
		FromSpeaker = p84,
		SpeakerDisplayName = NameForDisplay,
		SpeakerUserId = n2,
		OriginalChannel = p82.Name,
		MessageLength = string.len(p83),
		MessageLengthUtf8 = utf8.len(utf8.nfcnormalize(p83)),
		MessageType = MessageType,
		IsFiltered = p85,
		Message = p85 and p83 or nil,
		Time = os.time(),
		ExtraData = {}
	}

	if Speaker then
		for k, v in pairs(Speaker.ExtraData) do
			t13.ExtraData[k] = v
		end
	end

	if p86 then
		for k, v in pairs(p86) do
			t13.ExtraData[k] = v
		end
	end

	return t13
end
function t2.SetChannelNameColor(p87, p88) -- line: 657
	p87.ChannelNameColor = p88

	for _, v in pairs(p87.Speakers) do
		v:UpdateChannelNameColor(p87.Name, p88)
	end
end
function t2.GetWelcomeMessageForSpeaker(p89, p90) -- line: 664
	if p89.GetWelcomeMessageFunction then
		local v237 = p89.GetWelcomeMessageFunction(p90)

		if v237 then
			return v237
		end
	end

	return p89.WelcomeMessage
end
function t2.RegisterGetWelcomeMessageFunction(p91, p92) -- line: 674
	if type(p92) ~= "function" then
		error("RegisterGetWelcomeMessageFunction must be called with a function.")
	end

	p91.GetWelcomeMessageFunction = p92
end
function t2.UnRegisterGetWelcomeMessageFunction(p93) -- line: 681
	p93.GetWelcomeMessageFunction = nil
end
function t1.new(p94, p95, p96, p97) -- line: 688
	-- upvalues: t2 (copy), Util (copy)
	local self = setmetatable({}, t2)

	self.ChatService = p94
	self.Name = p95
	self.WelcomeMessage = p96 or ""
	self.GetWelcomeMessageFunction = nil
	self.ChannelNameColor = p97
	self.Joinable = true
	self.Leavable = true
	self.AutoJoin = false
	self.Private = false
	self.Speakers = {}
	self.Mutes = {}
	self.MaxHistory = 200
	self.HistoryIndex = 0
	self.ChatHistory = {}
	self.FilterMessageFunctions = Util:NewSortedFunctionContainer()
	self.ProcessCommandsFunctions = Util:NewSortedFunctionContainer()
	self.eDestroyed = Instance.new("BindableEvent")
	self.eMessagePosted = Instance.new("BindableEvent")
	self.eSpeakerJoined = Instance.new("BindableEvent")
	self.eSpeakerLeft = Instance.new("BindableEvent")
	self.eSpeakerMuted = Instance.new("BindableEvent")
	self.eSpeakerUnmuted = Instance.new("BindableEvent")
	self.MessagePosted = self.eMessagePosted.Event
	self.SpeakerJoined = self.eSpeakerJoined.Event
	self.SpeakerLeft = self.eSpeakerLeft.Event
	self.SpeakerMuted = self.eSpeakerMuted.Event
	self.SpeakerUnmuted = self.eSpeakerUnmuted.Event
	self.Destroyed = self.eDestroyed.Event

	return self
end

return t1
