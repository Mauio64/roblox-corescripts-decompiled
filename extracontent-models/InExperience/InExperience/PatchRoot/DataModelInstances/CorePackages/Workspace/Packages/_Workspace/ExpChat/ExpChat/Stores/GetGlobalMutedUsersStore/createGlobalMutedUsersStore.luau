local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createSignal = Signals.createSignal

return function()
	local signal, v = createSignal({})
	local signal2, v2 = createSignal({})
	local signal3, v3 = createSignal({})

	return {
		getMutedGlobalUsernames = signal,
		getMutedGlobalDisplayNames = signal2,
		getMutedGlobalUserIds = signal3,
		muteGlobalUsername = function(value: string)
			local v4 = string.lower(value)
			local clone = table.clone(signal(false))
			clone[v4] = true
			v(clone)
		end,
		unmuteGlobalUsername = function(value: string)
			local v4 = string.lower(value)
			local clone = table.clone(signal(false))
			clone[v4] = nil
			v(clone)
		end,
		muteGlobalDisplayName = function(value: string)
			local v4 = string.lower(value)
			local clone = table.clone(signal2(false))
			clone[v4] = true
			v2(clone)
		end,
		unmuteGlobalDisplayName = function(value: string)
			local v4 = string.lower(value)
			local clone = table.clone(signal2(false))
			clone[v4] = nil
			v2(clone)
		end,
		isUsernameMuted = function(value: string): boolean
			return signal(false)[string.lower(value)] == true
		end,
		isDisplayNameMuted = function(value: string): boolean
			return signal2(false)[string.lower(value)] == true
		end,
		muteGlobalUserId = function(p)
			local v4 = tostring(p)
			local clone = table.clone(signal3(false))
			clone[v4] = true
			v3(clone)
		end,
		unmuteGlobalUserId = function(p)
			local v4 = tostring(p)
			local clone = table.clone(signal3(false))
			clone[v4] = nil
			v3(clone)
		end,
		isUserIdMuted = function(p): boolean
			return signal3(false)[tostring(p)] == true
		end
	}
end
