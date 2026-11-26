local CorePackages = game:GetService("CorePackages")

local Players = game:GetService("Players")

local Signals = require(CorePackages.Packages.Signals)
local module = require("@luauforge/bundled/fBQ")

local fFlagSeedAccountThemeFromDisk = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSeedAccountThemeFromDisk

local v5 = if fFlagSeedAccountThemeFromDisk then require("@luauforge/bundled/fBR") else nil

local function defaultGetLocalPlayerUserId()
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		return localPlayer.UserId
	end

	return 0
end

local function resolveInitialColorThemeKey(callback, p2)
	if not fFlagSeedAccountThemeFromDisk then
		return module.Default
	end

	local v6 = callback()

	if v6 <= 0 then
		return module.Default
	end

	local persistedAccountTheme = p2.getPersistedAccountTheme(v6)

	if persistedAccountTheme == nil or persistedAccountTheme == module.Default then
		return module.Default
	end

	return persistedAccountTheme
end

local function createRobloxPlusThemeStore(p2, p3, p4)
	local v6 = p3 or defaultGetLocalPlayerUserId
	local v7 = p4 or v5
	local createSignal = Signals.createSignal
	local v8

	if fFlagSeedAccountThemeFromDisk then
		local v9 = v6()

		if v9 <= 0 then
			v8 = module.Default
		else
			v8 = v7.getPersistedAccountTheme(v9)

			if v8 == nil or v8 == module.Default then
				v8 = module.Default
			end
		end
	else
		v8 = module.Default
	end

	local signal, v9 = createSignal(v8)

	local signal2, v10 = Signals.createSignal(nil)

	local signal3, v11 = Signals.createSignal("Idle")

	local signal4, v12 = Signals.createSignal(false)

	return {
		getColorThemeKey = signal,
		setColorThemeKey = v9,
		getPreviewColorThemeKey = signal2,
		setPreviewColorThemeKey = v10,
		getWriteStatus = signal3,
		setWriteStatus = v11,
		getSuppressAccountTheme = signal4,
		setSuppressAccountTheme = v12
	}
end

return createRobloxPlusThemeStore
