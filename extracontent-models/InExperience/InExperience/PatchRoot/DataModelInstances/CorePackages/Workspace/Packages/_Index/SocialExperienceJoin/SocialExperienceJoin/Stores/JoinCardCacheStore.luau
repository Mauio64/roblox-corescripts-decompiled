local parent = script:FindFirstAncestor("SocialExperienceJoin").Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local createSignal = Signals.createSignal
local computed = Signals.createComputed(function(_)
	local signal, v = createSignal({})
	local signal2, v2 = createSignal(nil)

	local function setPlayabilityEntry(p: string, p2)
		if not p or p == "" then
			return
		end

		local v3 = signal(false)
		v(Cryo.Dictionary.join(v3, { [p] = p2 }))
	end

	local function setUserSettingsAction(p)
		v2(p)
	end

	local function clearPlayabilityEntry(p: string)
		if not p or p == "" then
			return
		end

		local v3 = signal(false)

		if v3[p] == nil then
			return
		end

		v(Cryo.Dictionary.join(v3, { [p] = Cryo.None }))
	end

	local function clearCache(p: string?)
		if p and p ~= "" then
			local v3 = signal(false)
			v(Cryo.Dictionary.join(v3, { [p] = Cryo.None }))
		else
			v({})
		end

		v2(nil)
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
