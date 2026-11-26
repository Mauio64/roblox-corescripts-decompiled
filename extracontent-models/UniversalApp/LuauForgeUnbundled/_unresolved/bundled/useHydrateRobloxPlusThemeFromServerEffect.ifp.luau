local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module = require("@luauforge/bundled/dSY")
local module2 = require("@luauforge/bundled/ehP")
local useRealtimeNamespace = module2.useRealtimeNamespace
local useRealtimeConnectionStateChanged = module2.useRealtimeConnectionStateChanged

local module3 = require("@luauforge/bundled/fHh")

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService

local module4 = require("@luauforge/bundled/fBQ")
local module5 = require("@luauforge/bundled/fBO")
local module6 = require("@luauforge/bundled/fHj")
local module7 = require("@luauforge/bundled/fHp")
local module8 = require("@luauforge/bundled/fGL")
local systemThemeService = module8.GetSystemThemeService()

local fFlagSeedAccountThemeFromDisk = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSeedAccountThemeFromDisk
local module9 = require("@luauforge/bundled/ifq")
local module10 = require("@luauforge/bundled/fBM")
local fFlagAppIconSelectionPage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIconSelectionPage

local function selectDarkColorModeForSyncedTheme(colorThemeKey, p2)
	if p2 ~= module4.Halloween2026 or colorThemeKey == p2 or not module8.GetSystemThemeEnabled() then
		return
	end

	require("@luauforge/bundled/fHe")(require("@luauforge/bundled/fGs").DeviceLevelThemeKey.Dark, {})
end

local function getApplicableDeviceTheme(p2, p3)
	local themeKey = module6.getThemeKey()

	if themeKey == nil or module7.getThemeAccess(themeKey, p2, p3) ~= module7.ThemeAccess.Device then
		return nil
	end

	return themeKey
end

local v5 = if fFlagSeedAccountThemeFromDisk then require("@luauforge/bundled/fBR") else nil

local module11 = require("@luauforge/bundled/fHn")
local module12 = require("@luauforge/bundled/eie")
local module13 = require("@luauforge/bundled/fHg")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local v6 = if fFlagAppIconSelectionPage then require("@luauforge/bundled/ifr") else nil

local function useHydrateRobloxPlusThemeFromServerEffect()
	local userSettingsStore = module.UserSettings.getUserSettingsStore(false)
	local getHasRobloxSubscription = module3.RobloxSubscriptionSignals.get().getHasRobloxSubscription

	local v7 = module11()
	local canSeeExclusiveThemes = module13().canSeeExclusiveThemes

	if module9 and not fFlagAppIconSelectionPage then
		React.useLayoutEffect(function()
			if systemThemeService then
				systemThemeService:setAppIcon("")
			end
		end, {})
	end

	if fFlagAppIconSelectionPage then
		local v8 = useAppPolicy(function(p2)
			return p2.getShowAppIconSetting()
		end)

		v6(v7, useSignalState(getHasRobloxSubscription) == true, v8)
	end

	if fFlagSeedAccountThemeFromDisk then
		React.useLayoutEffect(function()
			if v7 <= 0 or not canSeeExclusiveThemes then
				return
			end

			local v8 = module5(false)

			if v8.getColorThemeKey(false) ~= module4.Default then
				return
			end

			local persistedAccountTheme = v5.getPersistedAccountTheme(v7)

			if persistedAccountTheme ~= nil and persistedAccountTheme ~= module4.Default then
				v8.setColorThemeKey(persistedAccountTheme)
			end
		end, { v7, canSeeExclusiveThemes })
	end

	local v9 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			if v7 <= 0 or not getHasRobloxSubscription(p2) then
				return nil
			end

			if canSeeExclusiveThemes then
				return userSettingsStore.getAndFetchAccountTheme(p2)
			end

			return nil
		end)
	end, { userSettingsStore, getHasRobloxSubscription, v7, canSeeExclusiveThemes })))

	if fFlagSeedAccountThemeFromDisk then
		local v11 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p2)
				return userSettingsStore.getAccountThemeStatus(p2)
			end)
		end, { userSettingsStore })))

		React.useEffect(function()
			if not canSeeExclusiveThemes then
				return
			end

			if v9 == nil then
				if v7 > 0 and v11 == "Ready" then
					if module10 then
						local hasRobloxSubscription = getHasRobloxSubscription(false)
						local themeKey = module6.getThemeKey()

						if
							themeKey == nil
							or module7.getThemeAccess(
								themeKey,
								hasRobloxSubscription,
								not canSeeExclusiveThemes
							) ~= module7.ThemeAccess.Device
						then
							themeKey = nil
						end

						if themeKey ~= nil then
							module5(false).setColorThemeKey(themeKey)

							v5.setPersistedAccountTheme(v7, module4.Default)
							return
						end
					end

					module5(false).setColorThemeKey(module4.Default)
					v5.setPersistedAccountTheme(v7, module4.Default)
				end
			else
				local v12 = module5(false)
				local colorThemeKey = v12.getColorThemeKey(false)
				v12.setColorThemeKey(v9)

				if module10 then
					selectDarkColorModeForSyncedTheme(colorThemeKey, v9)
				end

				if v7 > 0 then
					v5.setPersistedAccountTheme(v7, v9)
				end
			end
		end, { v9, v11, v7, canSeeExclusiveThemes, getHasRobloxSubscription })
	else
		React.useEffect(function()
			if not canSeeExclusiveThemes then
				return
			end

			if v9 ~= nil then
				local v10 = module5(false)
				local colorThemeKey = v10.getColorThemeKey(false)
				v10.setColorThemeKey(v9)

				if module10 then
					selectDarkColorModeForSyncedTheme(colorThemeKey, v9)
				end
			end
		end, { v9, v7, canSeeExclusiveThemes })
	end

	if module10 then
		local v10 = useSignalState(getHasRobloxSubscription)
		React.useEffect(function()
			if v7 <= 0 or v10 or not canSeeExclusiveThemes then
				return
			end

			local themeKey = module6.getThemeKey()

			if themeKey == nil then
				return
			end

			local v11 = module5(false)
			local colorThemeKey = v11.getColorThemeKey(false)
			local themeKey2 = module6.getThemeKey()

			if
				themeKey2 == nil
				or module7.getThemeAccess(themeKey2, false, false) ~= module7.ThemeAccess.Device
			then
				themeKey2 = nil
			end

			if themeKey2 == nil then
				if colorThemeKey == themeKey then
					v11.setColorThemeKey(module4.Default)
				end
			elseif colorThemeKey == module4.Default then
				v11.setColorThemeKey(themeKey)
			end
		end, { v7, v10, canSeeExclusiveThemes })
	end

	local v10 = React.useCallback(function()
		if v7 <= 0 then
			return
		end

		if getHasRobloxSubscription(false) and canSeeExclusiveThemes then
			userSettingsStore.fetchUserSettings()
		end
	end, { userSettingsStore, getHasRobloxSubscription, canSeeExclusiveThemes, v7 })

	useRealtimeNamespace("UserSettingsChanged", function(p2)
		local settingsChanged = p2.SettingsChanged

		if settingsChanged and table.find(settingsChanged, "AccountTheme") then
			v10()
		end
	end, { v10 })

	useRealtimeConnectionStateChanged("UserSettingsChanged", function(p2, p3)
		if p2 == Enum.ConnectionState.Connected and p3 then
			v10()
		end
	end, { v10 })

	local v11 = module12(appAppLifecycleObserverService)
	React.useEffect(function()
		if v11 == nil or v11.OnUnhide == nil then
			return
		end

		local onUnhideConnection = v11.OnUnhide:Connect(v10)

		return function()
			onUnhideConnection:Disconnect()
		end
	end, { v11, v10 })
end

return useHydrateRobloxPlusThemeFromServerEffect
