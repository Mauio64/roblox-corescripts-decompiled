local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ChatMute/Signals").createSignal

return function()
	local signal, v5 = createSignal({})
	local signal2, v6 = createSignal({})
	local signal3, v7 = createSignal({})

	return {
		getMutedUsernames = signal,
		getMutedDisplayNames = signal2,
		getMutedUserIds = signal3,
		muteGlobalUsername = function(value)
			local v8 = string.lower(value)
			local clone = table.clone(signal(false))
			clone[v8] = true
			v5(clone)
		end,
		unmuteGlobalUsername = function(value)
			local v8 = string.lower(value)
			local clone = table.clone(signal(false))
			clone[v8] = nil
			v5(clone)
		end,
		muteGlobalDisplayName = function(value)
			local v8 = string.lower(value)
			local clone = table.clone(signal2(false))
			clone[v8] = true
			v6(clone)
		end,
		unmuteGlobalDisplayName = function(value)
			local v8 = string.lower(value)
			local clone = table.clone(signal2(false))
			clone[v8] = nil
			v6(clone)
		end,
		isUsernameMuted = function(value): boolean
			return signal(false)[string.lower(value)] == true
		end,
		isDisplayNameMuted = function(value): boolean
			return signal2(false)[string.lower(value)] == true
		end,
		muteGlobalUserId = function(p2)
			local v8 = tostring(p2)
			local clone = table.clone(signal3(false))
			clone[v8] = true
			v7(clone)
		end,
		unmuteGlobalUserId = function(p2)
			local v8 = tostring(p2)
			local clone = table.clone(signal3(false))
			clone[v8] = nil
			v7(clone)
		end,
		isUserIdMuted = function(p2): boolean
			return signal3(false)[tostring(p2)] == true
		end
	}
end
