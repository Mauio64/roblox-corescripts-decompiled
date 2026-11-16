local parent = script:FindFirstAncestor("FriendsChat").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, v = createSignal(false)
	local signal2, v2 = createSignal(nil)

	local signal3, v3 = createSignal({})

	return {
		getHasEnteredFriendsTab = signal,
		getActiveConversationId = signal2,
		getLocalUnreadConversationIds = signal3,
		markFriendsTabEntered = function()
			v(true)
		end,
		setActiveConversationId = function(p: string?)
			v2(p)
		end,
		addLocalUnread = function(p: string)
			v3(function(p2)
				if p2[p] then
					return p2
				end

				local clone = table.clone(p2)
				clone[p] = true
				return clone
			end)
		end,
		clearLocalUnread = function()
			v3(function(items)
				if next(items) == nil then
					return items
				end

				return {}
			end)
		end
	}
end
