local parent = script.Parent.Parent.Parent

local Signals = require(parent.Signals)

local signal, v = Signals.createSignal(true)

local v2 = false

local function setShouldPersistVisibility(flag: boolean)
	v2 = flag
end

local function setVisible(playerListVisible: boolean)
	v(playerListVisible)

	if v2 then
		local userSettings = UserSettings()
		userSettings.GameSettings.PlayerListVisible = playerListVisible
	end
end

local signal2, v3 = Signals.createSignal({})

local getEffectiveVisible = Signals.createComputed(function(p)
	return signal(p) and next(signal2(p)) == nil
end)

local v4 = nil

local function setTempHide(p: string, flag: boolean?)
	local v5 = next(signal2(false)) == nil
	v3(function(p2)
		local clone = table.clone(p2)
		clone[p] = flag and true or nil
		return clone
	end)

	local v6 = next(signal2(false)) == nil

	if v5 and not v6 then
		v4 = signal(false)
	elseif not v5 and v6 and v4 ~= nil then
		local v7 = v4
		v4 = nil

		if signal(false) ~= v7 then
			v(v7)
		end
	end
end

local function setTempHideSnapshot(flag: boolean)
	if v4 ~= nil then
		v4 = flag
	end
end

local function reset()
	v2 = false
	v4 = nil
	v3({})
	v(true)
end

return {
	getVisible = signal,
	setVisible = setVisible,
	setShouldPersistVisibility = setShouldPersistVisibility,
	getEffectiveVisible = getEffectiveVisible,
	setTempHide = setTempHide,
	setTempHideSnapshot = setTempHideSnapshot,
	reset = reset
}
