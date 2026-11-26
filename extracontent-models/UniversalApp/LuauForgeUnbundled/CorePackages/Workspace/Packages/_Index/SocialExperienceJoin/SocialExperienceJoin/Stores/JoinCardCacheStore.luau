local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperienceJoin/Signals")

local createSignal = Signals.createSignal
local computed = Signals.createComputed(function(p2)
	local signal, v5 = createSignal({})
	local signal2, v6 = createSignal(nil)

	local function setPlayabilityEntry(p3, p4)
		if not p3 or p3 == "" then
			return
		end

		local v7 = signal(false)
		v5(Cryo.Dictionary.join(v7, { [p3] = p4 }))
	end

	local function setUserSettingsAction(p3)
		v6(p3)
	end

	local function clearPlayabilityEntry(p3)
		if not p3 or p3 == "" then
			return
		end

		local v7 = signal(false)

		if v7[p3] == nil then
			return
		end

		v5(Cryo.Dictionary.join(v7, { [p3] = Cryo.None }))
	end

	local function clearCache(p3)
		if p3 and p3 ~= "" then
			local v7 = signal(false)
			v5(Cryo.Dictionary.join(v7, { [p3] = Cryo.None }))
		else
			v5({})
		end

		v6(nil)
	end

	return {
		getPlayabilityEntries = signal,
		getUserSettings = signal2,
		setPlayabilityEntry = setPlayabilityEntry,
		setUserSettings = setUserSettingsAction,
		clearPlayabilityEntry = clearPlayabilityEntry,
		clearCache = clearCache
	}
end)

return {
	get = function()
		return computed(false)
	end
}
