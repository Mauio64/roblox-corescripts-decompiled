local t1 = {}
local RunService = game:GetService("RunService")
local ClientChatModules = game:GetService("Chat"):WaitForChild("ClientChatModules")
local ChatSettings = require(ClientChatModules:WaitForChild("ChatSettings"))
local _ = script.Parent
local ok, result = pcall(function() -- line: 16
	return UserSettings():IsUserFeatureEnabled("UserRemoveMessageOnTextFilterFailures")
end)
local u8 = ok and result
local ok2, result2 = pcall(function() -- line: 24
	return UserSettings():IsUserFeatureEnabled("UserIsChatTranslationEnabled2")
end)
local _ = ok2 and result2

local function ShallowCopy(p1) -- line: 32
	local t2 = {}

	for k, v in pairs(p1) do
		t2[k] = v
	end

	return t2
end

local t3 = {}
local t4 = {
	eDestroyed = true,
	eSaidMessage = true,
	eReceivedMessage = true,
	eReceivedUnfilteredMessage = true,
	eMessageDoneFiltering = true,
	eReceivedSystemMessage = true,
	eChannelJoined = true,
	eChannelLeft = true,
	eMuted = true,
	eUnmuted = true,
	eExtraDataUpdated = true,
	eMainChannelSet = true,
	eChannelNameColorUpdated = true
}
local t5 = {
	Destroyed = "eDestroyed",
	SaidMessage = "eSaidMessage",
	ReceivedMessage = "eReceivedMessage",
	ReceivedUnfilteredMessage = "eReceivedUnfilteredMessage",
	RecievedUnfilteredMessage = "eReceivedUnfilteredMessage",
	MessageDoneFiltering = "eMessageDoneFiltering",
	ReceivedSystemMessage = "eReceivedSystemMessage",
	ChannelJoined = "eChannelJoined",
	ChannelLeft = "eChannelLeft",
	Muted = "eMuted",
	Unmuted = "eUnmuted",
	ExtraDataUpdated = "eExtraDataUpdated",
	MainChannelSet = "eMainChannelSet",
	ChannelNameColorUpdated = "eChannelNameColorUpdated"
}

function t3.__index(p2, p3) -- line: 76
	-- upvalues: t3 (copy), t4 (copy), t5 (copy)
	local v22 = rawget(t3, p3)

	if v22 then
		return v22
	end

	if t4[p3] and not rawget(p2, p3) then
		rawset(p2, p3, Instance.new("BindableEvent"))
	end

	local v23 = t5[p3]

	if v23 and not rawget(p2, p3) then
		local v24 = rawget(p2, v23)

		if not v24 then
			v24 = Instance.new("BindableEvent")
			rawset(p2, v23, v24)
		end

		rawset(p2, p3, v24.Event)
	end

	return (rawget(p2, p3))
end
function t3.LazyFire(p4, p5, ...) -- line: 95
	local v27 = rawget(p4, p5)

	if v27 then
		v27:Fire(...)
	end
end
function t3.SayMessage(p6, p7, p8, p9) -- line: 102
	if p6.ChatService:InternalDoProcessCommands(p6.Name, p7, p8) then
		return
	end

	if not p8 then
		return
	end

	local v32 = p6.Channels[p8:lower()]

	if not v32 then
		return
	end

	local v33 = v32:InternalPostMessage(p6, p7, p9)

	if v33 then
		pcall(function() -- line: 117
			-- upvalues: p6 (copy), v33 (copy), p8 (copy)
			p6:LazyFire("eSaidMessage", v33, p8)
		end)
	end

	return v33
end
function t3.JoinChannel(p10, p11) -- line: 125
	if p10.Channels[p11:lower()] then
		warn("Speaker is already in channel \"" .. p11 .. "\"")

		return
	end

	local Channel = p10.ChatService:GetChannel(p11)

	if not Channel then
		error("Channel \"" .. p11 .. "\" does not exist!")
	end

	p10.Channels[p11:lower()] = Channel
	Channel:InternalAddSpeaker(p10)

	local ok3, result3 = pcall(function() -- line: 138
		-- upvalues: p10 (copy), Channel (copy)
		p10.eChannelJoined:Fire(Channel.Name, Channel:GetWelcomeMessageForSpeaker(p10))
	end)

	if not ok3 and result3 then
		print("Error joining channel: " .. result3)
	end
end
function t3.LeaveChannel(p12, p13) -- line: 146
	if not p12.Channels[p13:lower()] then
		warn("Speaker is not in channel \"" .. p13 .. "\"")

		return
	end

	local v41 = p12.Channels[p13:lower()]

	p12.Channels[p13:lower()] = nil
	v41:InternalRemoveSpeaker(p12)

	local ok4, result4 = pcall(function() -- line: 156
		-- upvalues: p12 (copy), v41 (copy)
		p12:LazyFire("eChannelLeft", v41.Name)

		if p12.PlayerObj then
			p12.EventFolder.OnChannelLeft:FireClient(p12.PlayerObj, v41.Name)
		end
	end)

	if not ok4 and result4 then
		print("Error leaving channel: " .. result4)
	end
end
function t3.IsInChannel(p14, p15) -- line: 167
	return p14.Channels[p15:lower()] ~= nil
end
function t3.GetChannelList(p16) -- line: 171
	local t6 = {}

	for _, v in pairs(p16.Channels) do
		table.insert(t6, v.Name)
	end

	return t6
end
function t3.SendMessage(p17, p18, p19, p20, p21) -- line: 179
	-- upvalues: RunService (copy)
	local v55 = p17.Channels[p19:lower()]

	if v55 then
		v55:SendMessageToSpeaker(p18, p17.Name, p20, p21)

		return
	end

	if RunService:IsStudio() then
		warn(string.format("Speaker '%s' is not in channel '%s' and cannot receive a message in it.", p17.Name, p19))
	end
end
function t3.SendSystemMessage(p22, p23, p24, p25) -- line: 190
	-- upvalues: RunService (copy)
	local v60 = p22.Channels[p24:lower()]

	if v60 then
		v60:SendSystemMessageToSpeaker(p23, p22.Name, p25)

		return
	end

	if RunService:IsStudio() then
		warn(string.format("Speaker '%s' is not in channel '%s' and cannot receive a system message in it.", p22.Name, p24))
	end
end
function t3.GetPlayer(p26) -- line: 201
	return p26.PlayerObj
end
function t3.GetNameForDisplay(p27) -- line: 205
	-- upvalues: ChatSettings (copy)
	if ChatSettings.PlayerDisplayNamesEnabled then
		local Player = p27:GetPlayer()

		if Player then
			return Player.DisplayName
		end

		return p27.Name
	end

	return p27.Name
end
function t3.SetExtraData(p28, p29, p30) -- line: 219
	p28.ExtraData[p29] = p30
	p28:LazyFire("eExtraDataUpdated", p29, p30)
end
function t3.GetExtraData(p31, p32) -- line: 224
	return p31.ExtraData[p32]
end
function t3.SetMainChannel(p33, p34) -- line: 228
	local ok5, result5 = pcall(function() -- line: 229
		-- upvalues: p33 (copy), p34 (copy)
		p33:LazyFire("eMainChannelSet", p34)

		if p33.PlayerObj then
			p33.EventFolder.OnMainChannelSet:FireClient(p33.PlayerObj, p34)
		end
	end)

	if not ok5 and result5 then
		print("Error setting main channel: " .. result5)
	end
end
function t3.AddMutedSpeaker(p35, p36) -- line: 241
	p35.MutedSpeakers[p36:lower()] = true
end
function t3.RemoveMutedSpeaker(p37, p38) -- line: 245
	p37.MutedSpeakers[p38:lower()] = false
end
function t3.IsSpeakerMuted(p39, p40) -- line: 249
	return p39.MutedSpeakers[p40:lower()]
end
function t3.InternalDestroy(p41) -- line: 255
	for _, v in pairs(p41.Channels) do
		v:InternalRemoveSpeaker(p41)
	end

	p41.eDestroyed:Fire()
	p41.EventFolder = nil
	p41.eDestroyed:Destroy()
	p41.eSaidMessage:Destroy()
	p41.eReceivedMessage:Destroy()
	p41.eReceivedUnfilteredMessage:Destroy()
	p41.eMessageDoneFiltering:Destroy()
	p41.eReceivedSystemMessage:Destroy()
	p41.eChannelJoined:Destroy()
	p41.eChannelLeft:Destroy()
	p41.eMuted:Destroy()
	p41.eUnmuted:Destroy()
	p41.eExtraDataUpdated:Destroy()
	p41.eMainChannelSet:Destroy()
	p41.eChannelNameColorUpdated:Destroy()
end
function t3.InternalAssignPlayerObject(p42, p43) -- line: 278
	p42.PlayerObj = p43
end
function t3.InternalAssignEventFolder(p44, p45) -- line: 282
	p44.EventFolder = p45
end
function t3.InternalSendMessage(p46, p47, p48) -- line: 286
	local ok6, result6 = pcall(function() -- line: 287
		-- upvalues: p46 (copy), p47 (copy), p48 (copy)
		p46:LazyFire("eReceivedUnfilteredMessage", p47, p48)

		if p46.PlayerObj then
			p46.EventFolder.OnNewMessage:FireClient(p46.PlayerObj, p47, p48)
		end
	end)

	if not ok6 and result6 then
		print("Error sending internal message: " .. result6)
	end
end
function t3.InternalSendFilteredMessage(p49, p50, p51) -- line: 298
	local ok7, result7 = pcall(function() -- line: 299
		-- upvalues: p49 (copy), p50 (copy), p51 (copy)
		p49:LazyFire("eReceivedMessage", p50, p51)
		p49:LazyFire("eMessageDoneFiltering", p50, p51)

		if p49.PlayerObj then
			p49.EventFolder.OnMessageDoneFiltering:FireClient(p49.PlayerObj, p50, p51)
		end
	end)

	if not ok7 and result7 then
		print("Error sending internal filtered message: " .. result7)
	end
end
function t3.InternalSendFilteredMessageWithTranslatedFilterResult(p52, p53, p54, p55) -- line: 314
	-- upvalues: u8 (ref)
	local t7 = {}

	for k, v in pairs(p53) do
		t7[k] = v
	end

	local v103 = t7
	local FilterResult = v103.FilterResult
	local Player = p52:GetPlayer()
	local v106 = if Player == nil then nil else p55:GetTranslationForLocale(Player.LocaleId)
	local s1 = ""
	local ChatForUserAsync = nil

	pcall(function() -- line: 324
		-- upvalues: v103 (copy), Player (copy), s1 (ref), FilterResult (copy), v106 (copy), ChatForUserAsync (ref)
		if v103.IsFilterResult then
			if Player then
				s1 = FilterResult:GetChatForUserAsync(Player.UserId)

				if v106 then
					ChatForUserAsync = v106:GetChatForUserAsync(Player.UserId)

					return
				end
			else
				s1 = FilterResult:GetNonChatStringForBroadcastAsync()

				if v106 then
					ChatForUserAsync = v106:GetNonChatStringForBroadcastAsync()

					return
				end
			end
		else
			s1 = FilterResult
		end
	end)

	if u8 then
		v103.Message = s1

		if ChatForUserAsync then
			v103.TranslatedMessage = ChatForUserAsync
		end

		v103.FilterResult = nil
		p52:InternalSendFilteredMessage(v103, p54)
	elseif #s1 > 0 then
		v103.Message = s1

		if ChatForUserAsync then
			v103.TranslatedMessage = ChatForUserAsync
		end

		v103.FilterResult = nil
		p52:InternalSendFilteredMessage(v103, p54)
	end
end
function t3.InternalSendFilteredMessageWithFilterResult(p56, p57, p58) -- line: 360
	-- upvalues: u8 (ref)
	local t8 = {}

	for k, v in pairs(p57) do
		t8[k] = v
	end

	local v115 = t8
	local FilterResult = v115.FilterResult
	local Player = p56:GetPlayer()
	local s2 = ""

	pcall(function() -- line: 367
		-- upvalues: v115 (copy), Player (copy), s2 (ref), FilterResult (copy)
		if v115.IsFilterResult then
			if Player then
				s2 = FilterResult:GetChatForUserAsync(Player.UserId)

				return
			end

			s2 = FilterResult:GetNonChatStringForBroadcastAsync()

			return
		end

		s2 = FilterResult
	end)

	if u8 then
		v115.Message = s2
		v115.FilterResult = nil
		p56:InternalSendFilteredMessage(v115, p58)
	elseif #s2 > 0 then
		v115.Message = s2
		v115.FilterResult = nil
		p56:InternalSendFilteredMessage(v115, p58)
	end
end
function t3.InternalSendSystemMessage(p59, p60, p61) -- line: 396
	local ok8, result8 = pcall(function() -- line: 397
		-- upvalues: p59 (copy), p60 (copy), p61 (copy)
		p59:LazyFire("eReceivedSystemMessage", p60, p61)

		if p59.PlayerObj then
			p59.EventFolder.OnNewSystemMessage:FireClient(p59.PlayerObj, p60, p61)
		end
	end)

	if not ok8 and result8 then
		print("Error sending internal system message: " .. result8)
	end
end
function t3.UpdateChannelNameColor(p62, p63, p64) -- line: 408
	p62:LazyFire("eChannelNameColorUpdated", p63, p64)

	if p62.PlayerObj then
		p62.EventFolder.ChannelNameColorUpdated:FireClient(p62.PlayerObj, p63, p64)
	end
end
function t1.new(p65, p66) -- line: 418
	-- upvalues: t3 (copy)
	local self = setmetatable({}, t3)

	self.ChatService = p65
	self.PlayerObj = nil
	self.Name = p66
	self.ExtraData = {}
	self.Channels = {}
	self.MutedSpeakers = {}
	self.EventFolder = nil

	return self
end

return t1
