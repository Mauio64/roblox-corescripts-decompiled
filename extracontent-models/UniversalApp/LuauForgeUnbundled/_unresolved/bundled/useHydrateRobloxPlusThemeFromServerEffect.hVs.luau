local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module = require("@luauforge/bundled/dPI")
local module2 = require("@luauforge/bundled/ees")
local useRealtimeNamespace = module2.useRealtimeNamespace
local useRealtimeConnectionStateChanged = module2.useRealtimeConnectionStateChanged

local module3 = require("@luauforge/bundled/fzr")

local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppAppLifecycleObserverService

local module4 = require("@luauforge/bundled/fup")
local module5 = require("@luauforge/bundled/fun")
local module6 = require("@luauforge/bundled/fzt")
local module7 = require("@luauforge/bundled/fzB")
local module8 = require("@luauforge/bundled/fyV")

local fFlagSeedAccountThemeFromDisk = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSeedAccountThemeFromDisk
local module9 = require("@luauforge/bundled/hVt")
local module10 = require("@luauforge/bundled/fzx")
local module11 = require("@luauforge/bundled/ful")
local module12 = require("@luauforge/bundled/fzy")

local function selectDarkColorModeForSyncedTheme(colorThemeKey, p2)
	if p2 ~= module4.Halloween2026 or colorThemeKey == p2 or not module8.GetSystemThemeEnabled() then
		return
	end

	require("@luauforge/bundled/fzo")(require("@luauforge/bundled/fyB").DeviceLevelThemeKey.Dark, {})
end

local function getApplicableDeviceTheme(p2, p3)
	local themeKey = module6.getThemeKey()

	if themeKey == nil or module7.getThemeAccess(themeKey, p2, p3) ~= module7.ThemeAccess.Device then
		return nil
	end

	return themeKey
end

local v5 = if fFlagSeedAccountThemeFromDisk then require("@luauforge/bundled/fuq") else nil

local module13 = require("@luauforge/bundled/fzz")
local module14 = require("@luauforge/bundled/eeH")
local module15 = require("@luauforge/bundled/fzq")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local v6 = if module12 then require("@luauforge/bundled/hVu") else nil

local function useHydrateRobloxPlusThemeFromServerEffect()
	local userSettingsStore = module.UserSettings.getUserSettingsStore(false)
	local getHasRobloxSubscription = module3.RobloxSubscriptionSignals.get().getHasRobloxSubscription

	local v7 = module13()
	local v8 = module15()
	local canSeeExclusiveThemes = v8.canSeeExclusiveThemes

	if module9 and not (module10 or module12) then
		React.useLayoutEffect(function()
			local systemThemeService = module8.GetSystemThemeService()

			if systemThemeService then
				systemThemeService:setAppIcon("")
			end
		end, {})
	end

	if module12 then
		local v9 = useAppPolicy(function(p2)
			return p2.getShowAppIconSetting()
		end)

		v6(v7, v8.hasRobloxPlusSubscription, v9)
	end

	if fFlagSeedAccountThemeFromDisk then
		React.useLayoutEffect(function()
			if v7 <= 0 or not canSeeExclusiveThemes then
				return
			end

			local v9 = module5(false)

			if v9.getColorThemeKey(false) ~= module4.Default then
				return
			end

			local persistedAccountTheme = v5.getPersistedAccountTheme(v7)

			if persistedAccountTheme ~= nil and persistedAccountTheme ~= module4.Default then
				v9.setColorThemeKey(persistedAccountTheme)
			end
		end, { v7, canSeeExclusiveThemes })
	end

	local v10 = useSignalState((React.useMemo(function()
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
		local v12 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p2)
				return userSettingsStore.getAccountThemeStatus(p2)
			end)
		end, { userSettingsStore })))

		React.useEffect(function()
			if not canSeeExclusiveThemes then
				return
			end

			if v10 == nil then
				if v7 > 0 and v12 == "Ready" then
					if module11 then
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
				local v13 = module5(false)
				local colorThemeKey = v13.getColorThemeKey(false)
				v13.setColorThemeKey(v10)

				if module11 then
					selectDarkColorModeForSyncedTheme(colorThemeKey, v10)
				end

				if v7 > 0 then
					v5.setPersistedAccountTheme(v7, v10)
				end
			end
		end, { v10, v12, v7, canSeeExclusiveThemes, getHasRobloxSubscription })
	else
		React.useEffect(function()
			if not canSeeExclusiveThemes then
				return
			end

			if v10 ~= nil then
				local v11 = module5(false)
				local colorThemeKey = v11.getColorThemeKey(false)
				v11.setColorThemeKey(v10)

				if module11 then
					selectDarkColorModeForSyncedTheme(colorThemeKey, v10)
				end
			end
		end, { v10, v7, canSeeExclusiveThemes })
	end

	if module11 then
		local v11 = useSignalState(getHasRobloxSubscription)
		React.useEffect(function()
			if v7 <= 0 or v11 or not canSeeExclusiveThemes then
				return
			end

			local themeKey = module6.getThemeKey()

			if themeKey == nil then
				return
			end

			local v12 = module5(false)
			local colorThemeKey = v12.getColorThemeKey(false)
			local themeKey2 = module6.getThemeKey()

			if
				themeKey2 == nil
				or module7.getThemeAccess(themeKey2, false, false) ~= module7.ThemeAccess.Device
			then
				themeKey2 = nil
			end

			if themeKey2 == nil then
				if colorThemeKey == themeKey then
					v12.setColorThemeKey(module4.Default)
				end
			elseif colorThemeKey == module4.Default then
				v12.setColorThemeKey(themeKey)
			end
		end, { v7, v11, canSeeExclusiveThemes })
	end

	local v11 = React.useCallback(function()
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
			v11()
		end
	end, { v11 })

	useRealtimeConnectionStateChanged("UserSettingsChanged", function(p2, p3)
		if p2 == Enum.ConnectionState.Connected and p3 then
			v11()
		end
	end, { v11 })

	local v12 = module14(appAppLifecycleObserverService)
	React.useEffect(function()
		if v12 == nil or v12.OnUnhide == nil then
			return
		end

		local onUnhideConnection = v12.OnUnhide:Connect(v11)

		return function()
			onUnhideConnection:Disconnect()
		end
	end, { v12, v11 })
end

return useHydrateRobloxPlusThemeFromServerEffect
