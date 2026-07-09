local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useCrossPlaySettings = require(CorePackages.Workspace.Packages.CrossPlay).Hooks.useCrossPlaySettings
local CrossPlayCapabilities = require(CorePackages.Workspace.Packages.UniversalAppPolicy).Enum.CrossPlayCapabilities
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local useEffectOnMount = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useEffectOnMount
local MoreSection = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreSection)
local MoreStatusButton = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreStatusButton)
local BodyText = require(Modules.LuaApp.TenFootUI.MoreComponents.MoreText).BodyText
local FFlagDontUseCrossPlayGlobalEffect = require(CorePackages.Workspace.Packages.SharedFlags).FFlagDontUseCrossPlayGlobalEffect

require(script.Parent.Types)

local function getCrossPlayStatusText(p1, t1: {[any]: any}) -- line: 34
	local v23 = not p1.isEnabled and "" or "(" .. t1.recommended .. ") "

	if p1.isLoading then
		return v23 .. t1.loading
	end

	if p1.hasError then
		return v23 .. t1.error
	end

	if p1.isEnabled then
		return v23 .. t1.enabled
	end

	return v23 .. t1.disabled
end
local function isCapabilityEnabled(p2) -- line: 49
	return p2 and (p2.Success and (p2.CanJoinGame and p2.PrivilegeCheckResult == "NoIssue"))
end
local function getPrivilegeStatuses(t2: {[any]: any}, p3, t3: {[any]: any}, b1: boolean) -- line: 53
	-- upvalues: CrossPlayCapabilities (copy), Dash (copy)
	local t4 = {
		[CrossPlayCapabilities.CrossPlatform] = t3.crossPlatform,
		[CrossPlayCapabilities.Multiplayer] = t3.multiplayer,
		[CrossPlayCapabilities.SharedContent] = t3.sharedContent
	}

	return Dash.map(t2, function(p4) -- line: 65
		-- upvalues: p3 (copy), b1 (copy), t3 (copy), t4 (copy)
		local v51 = p3[p4]
		local v52 = v51 and (v51.Success and (v51.CanJoinGame and v51.PrivilegeCheckResult == "NoIssue"))
		local v53 = p3[p4] and p3[p4].PrivilegeCheckResult == "Error"
		local v54 = if not b1 then if not v53 then if not v52 then t3.disallowed else t3.allowed else t3.error else t3.loading

		return {
			label = t4[p4],
			status = v54
		}
	end)
end
local function useCrossPlayStatus(t5: {[any]: any}) -- line: 87
	-- upvalues: useCrossPlaySettings (copy), useLocalization (copy), React (copy), getPrivilegeStatuses (copy), useEffectOnMount (copy)
	local v31 = useCrossPlaySettings()
	local v32 = useLocalization({
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
	local v33 = not v31.isEnabled and "" or "(" .. v32.recommended .. ") "
	local v34 = if not v31.isLoading then if not v31.hasError then if not v31.isEnabled then v33 .. v32.disabled else v33 .. v32.enabled else v33 .. v32.error else v33 .. v32.loading
	local v35 = React.useMemo(function() -- line: 103
		-- upvalues: getPrivilegeStatuses (copy), t5 (copy), v31 (copy), v32 (copy)
		return getPrivilegeStatuses(t5, v31.systemPrivileges, v32, v31.isLoading)
	end, {
		v31,
		t5,
		v32
	})

	useEffectOnMount(function() -- line: 112
		-- upvalues: v31 (copy)
		v31.reload()
	end)

	return (React.useMemo(function() -- line: 117
		-- upvalues: v31 (copy), v34 (copy), v35 (copy)
		return {
			crossPlaySettings = v31,
			crossPlayStatusText = v34,
			privilegeStatuses = v35
		}
	end, {
		v31,
		v34,
		v35
	}))
end
local function getAccountSettingsSuccess(p5, p6, p7) -- line: 134
	-- upvalues: Dash (copy)
	return Dash.reduce(p6, function(p8, p9) -- line: 135
		-- upvalues: p7 (copy)
		if p8 then
			local v57 = p7[p9]

			p8 = v57 and (v57.Success and (v57.CanJoinGame and v57.PrivilegeCheckResult == "NoIssue"))
		end

		return p8
	end, p5.isEnabled)
end
local function DeviceSettingsSection(p10) -- line: 140
	-- upvalues: useAppPolicy (copy), useLocalization (copy), useCrossPlayStatus (copy), FFlagDontUseCrossPlayGlobalEffect (copy), React (copy), AppLifecycleObserverService (copy), Dash (copy), MoreStatusButton (copy), BodyText (copy), MoreSection (copy)
	local v40 = useAppPolicy(function(p11) -- line: 141
		return p11.getPlatformAccountName()
	end)
	local v41 = useLocalization({
		crossPlatform = "Feature.Settings.Label.CrossPlatform",
		crossPlatformDescription = "Feature.Settings.Description.CrossPlatform",
		platformAccountSettingsSuccess = {
			"Feature.Settings.Description.PlatformAccountSettingsSuccess",
			platform = v40
		},
		platformAccountSettings = {
			"Feature.Settings.Heading.PlatformAccountSettings",
			platform = v40
		}
	})
	local v42 = useAppPolicy(function(p12) -- line: 155
		return (p12.getCrossPlayCapabilities())
	end)
	local v43 = useCrossPlayStatus(v42)
	local crossPlaySettings = v43.crossPlaySettings
	local crossPlayStatusText = v43.crossPlayStatusText
	local privilegeStatuses = v43.privilegeStatuses

	if FFlagDontUseCrossPlayGlobalEffect then
		React.useEffect(function() -- line: 165
			-- upvalues: AppLifecycleObserverService (copy), crossPlaySettings (copy)
			local connection = AppLifecycleObserverService.OnBecomeActive:Connect(function() -- line: 166
				-- upvalues: crossPlaySettings (copy)
				crossPlaySettings.reload()
			end)

			return function() -- line: 170
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, { crossPlaySettings })
	end

	local v47 = Dash.map(privilegeStatuses, function(p13, n1: number) -- line: 176
		-- upvalues: React (copy), MoreStatusButton (copy), crossPlaySettings (copy)
		return React.createElement(MoreStatusButton, {
			layoutOrder = n1 + 2,
			title = p13.label,
			status = p13.status,
			onActivated = crossPlaySettings.invokeSystemUi
		})
	end)
	local systemPrivileges = crossPlaySettings.systemPrivileges
	local v49 = if not Dash.reduce(v42, function(p14, p15) -- line: 135
		-- upvalues: systemPrivileges (copy)
		if p14 then
			local v65 = systemPrivileges[p15]

			p14 = v65 and (v65.Success and (v65.CanJoinGame and v65.PrivilegeCheckResult == "NoIssue"))
		end

		return p14
	end, crossPlaySettings.isEnabled) then nil else React.createElement(BodyText, {
		layoutOrder = 10,
		text = v41.platformAccountSettingsSuccess
	})

	return React.createElement(MoreSection, {
		layoutOrder = p10.layoutOrder,
		withDivider = p10.withDivider,
		title = v41.platformAccountSettings
	}, Dash.append({
		React.createElement(MoreStatusButton, {
			layoutOrder = 1,
			title = v41.crossPlatform,
			status = crossPlayStatusText,
			isDisabled = crossPlaySettings.isLoading,
			onActivated = crossPlaySettings.toggle
		}),
		React.createElement(BodyText, {
			layoutOrder = 2,
			text = v41.crossPlatformDescription
		})
	}, v47, { v49 }))
end

return DeviceSettingsSection
