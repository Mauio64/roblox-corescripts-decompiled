local signal, v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals").createSignal(nil)

local function updateOpenChat(p2, p3, p4)
	local v6 = signal(false)

	if v6 ~= nil and v6.chatOpenId == p2 and (v6.universeId ~= p3 or v6.sessionId ~= p4) then
		v5(table.freeze({ chatOpenId = p2, universeId = p3, sessionId = p4 }))
	end
end

return {
	open = function(p2, p3)
		local v6 = signal(false)

		if v6 == nil or v6.chatOpenId ~= p2 then
			v5(table.freeze({ chatOpenId = p2, universeId = p3 }))
		end
	end,
	close = function(p2)
		local v6 = signal(false)

		if v6 ~= nil and v6.chatOpenId == p2 then
			v5(nil)
		end
	end,
	setUniverseId = function(p2, p3)
		local v6 = signal(false)
		local v8 = if v6 ~= nil then v6.sessionId else nil
		updateOpenChat(p2, p3, v8)
	end,
	setSessionId = function(p2, p3)
		local v6 = signal(false)
		local v8 = if v6 ~= nil then v6.universeId else nil
		updateOpenChat(p2, v8, p3)
	end,
	getChatOpenId = function()
		local v6 = signal(false)

		if v6 == nil then
			return nil
		end

		return v6.chatOpenId
	end,
	getSessionId = function()
		local v6 = signal(false)

		if v6 == nil then
			return nil
		end

		return v6.sessionId
	end,
	getChatOpenIdForUniverse = function(p2)
		local v6 = signal(false)

		if v6 == nil or v6.universeId ~= p2 then
			return nil
		end

		return v6.chatOpenId
	end,
	resolveEventIds = function(p2, p3, p4)
		local v6 = signal(false)

		if v6 == nil then
			return p2, nil
		end

		local v7

		if p2 == nil then
			if p3 == nil then
				v7 = if p4 == nil then v6.universeId == nil else p4 == v6.universeId
			else
				v7 = p3 == v6.sessionId
			end
		else
			v7 = p2 == v6.chatOpenId
		end

		if v7 then
			return v6.chatOpenId, v6.sessionId
		end

		return p2, nil
	end
}
