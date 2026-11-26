local CorePackages = game:GetService("CorePackages")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useCrossPlaySettings = require("@luauforge/bundled/hSB").Hooks.useCrossPlaySettings
local crossPlayCapabilities = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").Enum.CrossPlayCapabilities
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local useEffectOnMount = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useEffectOnMount

local module2 = require("@luauforge/bundled/hSu")
local module3 = require("@luauforge/bundled/hSz")
local bodyText = require("@luauforge/bundled/hSv").BodyText

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagUnifyConsoleSettingsPage = SharedFlags.FFlagUnifyConsoleSettingsPage
local fFlagEnableSettingsTelemetry = SharedFlags.FFlagEnableSettingsTelemetry

require("@luauforge/bundled/hSx")
local module5 = require("@luauforge/bundled/fGw")

local function getCrossPlayStatusText(data, data2)
	local v5 = not data.isEnabled and "" or "(" .. data2.recommended .. ") "

	if data.isLoading then
		return v5 .. data2.loading
	end

	if data.hasError then
		return v5 .. data2.error
	end

	if data.isEnabled then
		return v5 .. data2.enabled
	end

	return v5 .. data2.disabled
end

local function isCapabilityEnabled(data)
	return data and data.Success and data.CanJoinGame and data.PrivilegeCheckResult == "NoIssue"
end

local function getPrivilegeStatuses(p2, systemPrivileges, data, isLoading)
	local v5 = {
		[crossPlayCapabilities.CrossPlatform] = data.crossPlatform,
		[crossPlayCapabilities.Multiplayer] = data.multiplayer,
		[crossPlayCapabilities.SharedContent] = data.sharedContent
	}

	return Dash.map(p2, function(p3)
		local v6 = systemPrivileges[p3]
		local v7 = v6 and v6.Success and v6.CanJoinGame and v6.PrivilegeCheckResult == "NoIssue"

		local v8 = systemPrivileges[p3] and systemPrivileges[p3].PrivilegeCheckResult == "Error"
		local v9

		if isLoading then
			v9 = data.loading
		else
			v9 = if v8 then data.error elseif v7 then data.allowed else data.disallowed
		end

		return { label = v5[p3], status = v9 }
	end)
end

local function useCrossPlayStatus(p2)
	local v5 = useCrossPlaySettings()
	local v6 = useLocalization({
		multiplayer = "Feature.Settings.Label.Multiplayer",
		sharedContent = "Feature.Settings.Label.SharedContent",
		recommended = "Feature.Settings.Label.Recommended",
		enabled = "Feature.Settings.Label.Enabled",
		disabled = "Feature.Settings.Label.Disabled",
		loading = "Feature.Settings.Label.Loading",
		error = "Feature.Settings.Label.Error",
		allowed = "Feature.Settings.Label.Allowed",
		disallowed = "Feature.Settings.Label.Disallowed"
	})
	local v7 = not v5.isEnabled and "" or "(" .. v6.recommended .. ") "
	local v8

	if v5.isLoading then
		v8 = v7 .. v6.loading
	elseif v5.hasError then
		v8 = v7 .. v6.error
	else
		v8 = if v5.isEnabled then v7 .. v6.enabled else v7 .. v6.disabled
	end

	local v9 = React.useMemo(function()
		return getPrivilegeStatuses(p2, v5.systemPrivileges, v6, v5.isLoading)
	end, { v5, p2, v6 })

	useEffectOnMount(function()
		v5.reload()
	end)

	return (React.useMemo(function()
		return {
			crossPlaySettings = v5,
			crossPlayStatusText = v8,
			privilegeStatuses = v9
		}
	end, { v5, v8, v9 }))
end

local function getAccountSettingsSuccess(p2, p3, p4)
	return Dash.reduce(p3, function(p5, p6)
		local v5 = p5 and p4[p6]
		return v5 and v5.Success and v5.CanJoinGame and v5.PrivilegeCheckResult == "NoIssue"
	end, p2.isEnabled)
end

local function PlatformSettingsSection(p2)
	local v5 = useAppPolicy(function(p3)
		return p3.getPlatformAccountName()
	end)

	local v6 = useLocalization({
		platformAccountSettingsSuccess = {
			"Feature.Settings.Description.PlatformAccountSettingsSuccess",
			platform = v5
		},
		platformAccountSettings = {
			"Feature.Settings.Heading.PlatformAccountSettings",
			platform = v5
		},
		crossPlatform = "Feature.Settings.Label.CrossPlatform",
		crossPlatformDescription = "Feature.Settings.Description.CrossPlatform"
	})

	local v7 = useAppPolicy(function(p3)
		return p3.getCrossPlayCapabilities()
	end)

	local v8 = useCrossPlayStatus(v7)
	local crossPlaySettings = v8.crossPlaySettings
	local crossPlayStatusText = v8.crossPlayStatusText
	local privilegeStatuses = v8.privilegeStatuses
	local v9

	if fFlagEnableSettingsTelemetry then
		v9 = React.useCallback(function()
			module5.reportSettingToggle(
				"CrossPlatformPlay",
				crossPlaySettings.isEnabled,
				not crossPlaySettings.isEnabled
			)

			crossPlaySettings.toggle()
		end, { crossPlaySettings })
	end

	React.useEffect(function()
		local onBecomeActiveConnection = AppLifecycleObserverService.OnBecomeActive:Connect(function()
			crossPlaySettings.reload()
		end)

		return function()
			onBecomeActiveConnection:Disconnect()
		end
	end, { crossPlaySettings })

	local mapped = Dash.map(privilegeStatuses, function(p3, p4)
		return React.createElement(module3, {
			layoutOrder = p4 + 2,
			title = p3.label,
			status = p3.status,
			onActivated = crossPlaySettings.invokeSystemUi
		})
	end)

	local systemPrivileges = crossPlaySettings.systemPrivileges
	local v10

	if Dash.reduce(v7, function(p3, p4)
		local v11 = p3 and systemPrivileges[p4]
		return v11 and v11.Success and v11.CanJoinGame and v11.PrivilegeCheckResult == "NoIssue"
	end, crossPlaySettings.isEnabled) then
		v10 = React.createElement(bodyText, {
			layoutOrder = 10,
			text = v6.platformAccountSettingsSuccess
		})
	end

	local createElement = React.createElement

	local v12 = {
		layoutOrder = p2.layoutOrder,
		withDivider = p2.withDivider,
		title = fFlagUnifyConsoleSettingsPage and "" or v6.platformAccountSettings
	}

	local append = Dash.append

	local createElement2 = React.createElement
	local v15 = {
		layoutOrder = 1,
		title = v6.crossPlatform,
		status = crossPlayStatusText,
		isDisabled = crossPlaySettings.isLoading,
		onActivated = 0
	}

	if not fFlagEnableSettingsTelemetry then
		v9 = crossPlaySettings.toggle
	end

	v15.onActivated = v9
	local element = createElement(
		module2,
		v12,
		append(
			{
				createElement2(module3, v15),
				React.createElement(bodyText, {
					layoutOrder = 2,
					text = v6.crossPlatformDescription
				})
			},
			mapped,
			{ v10 }
		)
	)

	if not fFlagUnifyConsoleSettingsPage then
		return element
	end

	local v16 = useDesignTokens()

	return React.createElement(
		"Frame",
		{
			LayoutOrder = p2.layoutOrder,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v16.Size.Size_400)
			}),
			Section = element
		}
	)
end

return PlatformSettingsSection
