local ShareGameAnalytics = {}
ShareGameAnalytics.__index = ShareGameAnalytics

ShareGameAnalytics.ButtonName = {
	LuaChatInputBar = "luaChatInputBar",
	LuaGameDetails = "luaGameDetails"
}

ShareGameAnalytics.EventName = {
	InviteSent = "inputShareGameInviteSent",
	EntryPoint = "inputShareGameEntryPoint"
}

ShareGameAnalytics.DiagCounters = {
	EntryPoint = {
		[ShareGameAnalytics.ButtonName.LuaChatInputBar] = game:DefineFastString(
			"LuaShareGameLuaChatInputBarEntryCounter",
			"LuaShareGameLuaChatInputBarEntryCounter"
		),
		[ShareGameAnalytics.ButtonName.LuaGameDetails] = game:DefineFastString(
			"LuaShareGameLuaGameDetailsEntryCounter",
			"LuaShareGameLuaGameDetailsEntryCounter"
		)
	},
	InviteSent = {
		[ShareGameAnalytics.ButtonName.LuaChatInputBar] = game:DefineFastString(
			"LuaShareGameLuaChatInputBarInviteCounter",
			"LuaShareGameLuaChatInputBarInviteCounter"
		),
		[ShareGameAnalytics.ButtonName.LuaGameDetails] = game:DefineFastString(
			"LuaShareGameLuaGameDetailsInviteCounter",
			"LuaShareGameLuaGameDetailsInviteCounter"
		)
	}
}

function ShareGameAnalytics.new(eventStreamImpl, diagImpl, buttonName)
	assert(eventStreamImpl, "EventStream implementation not found.")
	assert(diagImpl, "Diag implementation not found.")
	assert(buttonName, "ButtonName not found.")

	return (setmetatable(
		{ _eventStreamImpl = eventStreamImpl, _diagImpl = diagImpl, _buttonName = buttonName },
		ShareGameAnalytics
	))
end

function ShareGameAnalytics:onActivatedInviteSent(p, p2, senderId, p3, list)
	local buttonName = self:_getButtonName()

	local inviteSent = ShareGameAnalytics.EventName.InviteSent
	local joined = table.concat(list, ",")
	local v = {
		btn = buttonName,
		placeId = tostring(p),
		gameId = tostring(p2),
		senderId = senderId,
		conversationId = tostring(p3),
		participants = joined
	}

	self:_getEventStream():setRBXEventStream("touch", inviteSent, v)

	local v2 = ShareGameAnalytics.DiagCounters.InviteSent[self:_getButtonName()]

	if v2 then
		self:_getDiag():reportCounter(v2, 1)
	end
end

function ShareGameAnalytics:inputShareGameEntryPoint(p, p2)
	local buttonName = self:_getButtonName()

	local entryPoint = ShareGameAnalytics.EventName.EntryPoint
	local v = {
		btn = buttonName,
		placeId = p and tostring(p),
		gameId = p2 and tostring(p2)
	}

	self:_getEventStream():setRBXEventStream("touch", entryPoint, v)

	local v2 = ShareGameAnalytics.DiagCounters.EntryPoint[self:_getButtonName()]

	if v2 then
		self:_getDiag():reportCounter(v2, 1)
	end
end

function ShareGameAnalytics:_getEventStream()
	return self._eventStreamImpl
end

function ShareGameAnalytics:_getDiag()
	return self._diagImpl
end

function ShareGameAnalytics:_getButtonName()
	return self._buttonName
end

return ShareGameAnalytics
