local IXPService = game:GetService("IXPService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local WaitUntilIXPUserInit = require(Modules.LuaApp.Thunks.WaitUntilIXPUserInit)
local NotificationsUpsell = require(CorePackages.Workspace.Packages.NotificationsUpsell)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local AppPage = require(Modules.LuaApp.AppPage)
local AppStartup = require(CorePackages.Workspace.Packages.AppStartup)
local useLaunchContext = AppStartup.Hooks.useLaunchContext
local LaunchContext = AppStartup.Enums.LaunchContext
local GetFStringPushUpsellVariantName = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringPushUpsellVariantName
local GetFStringPushUpsellOnFirstTimeVariantName = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringPushUpsellOnFirstTimeVariantName
local GetFFlagLuaAppPushSystemUpsellDevOverride = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppPushSystemUpsellDevOverride
local GetFFlagLuaAppEnablePushUpsellOnFirstTime = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnablePushUpsellOnFirstTime
local setupPushNotificationsUpsell = NotificationsUpsell.setupPushNotificationsUpsell
local NotificationsUpsellConstants = NotificationsUpsell.NotificationsUpsellConstants
local PushUpsellEventConfig = NotificationsUpsell.PushUpsellEventConfig
local ModalEventConstants = NotificationsUpsell.ModalEventConstants

local function CheckForPushNotificationsUpsell(_) -- line: 35
	-- upvalues: useDispatch (copy), useLaunchContext (copy), React (copy), LaunchContext (copy), useUserExperiment (copy), AppUserLayers (copy), GetFStringPushUpsellVariantName (copy), GetFStringPushUpsellOnFirstTimeVariantName (copy), useSelector (copy), AppPage (copy), Players (copy), WaitUntilIXPUserInit (copy), IXPService (copy), GetFFlagLuaAppPushSystemUpsellDevOverride (copy), GetFFlagLuaAppEnablePushUpsellOnFirstTime (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy), ModalEventConstants (copy), default (copy), PushUpsellEventConfig (copy)
	local v27 = useDispatch()
	local v28 = useLaunchContext()
	local v29, v30 = React.useState(false)
	local v31 = React.useRef(v28 ~= nil and (v28 == LaunchContext.SignUp or v28 == LaunchContext.Login))
	local v32 = useUserExperiment({ AppUserLayers.PushNotificationPrompt }, function(p2) -- line: 45
		-- upvalues: AppUserLayers (copy), GetFStringPushUpsellVariantName (copy), GetFStringPushUpsellOnFirstTimeVariantName (copy)
		local v35 = p2[AppUserLayers.PushNotificationPrompt] or {}
		local v36 = GetFStringPushUpsellVariantName()
		local v37 = GetFStringPushUpsellOnFirstTimeVariantName()

		return {
			pushUpsellVariant = v35[v36] or -1,
			pushUpsellOnFirstTimeVariant = v35[v37] or -1
		}
	end)
	local v33 = useSelector(function(p3) -- line: 55
		-- upvalues: AppPage (copy)
		return p3.Personalization.PageSessionTimestamp[AppPage.Home]
	end)

	React.useEffect(function() -- line: 59
		-- upvalues: v29 (copy), Players (copy), v27 (copy), WaitUntilIXPUserInit (copy), IXPService (copy), v30 (copy)
		if not v29 then
			local v39 = Players.LocalPlayer and Players.LocalPlayer.UserId or 0

			v27(WaitUntilIXPUserInit(IXPService, v39)):andThen(function() -- line: 62
				-- upvalues: v30 (copy)
				v30(true)
			end)
		end
	end, { v29 })
	React.useEffect(function() -- line: 68
		-- upvalues: v33 (copy), v29 (copy), v32 (copy), GetFFlagLuaAppPushSystemUpsellDevOverride (copy), GetFFlagLuaAppEnablePushUpsellOnFirstTime (copy), v31 (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy), IXPService (copy), AppUserLayers (copy), ModalEventConstants (copy), default (copy), PushUpsellEventConfig (copy), AppPage (copy)
		local u40 = true

		if v33 == nil then
			return function() -- line: 72
			end
		end

		if v29 and v32.pushUpsellVariant ~= nil and v32.pushUpsellVariant > -1 or GetFFlagLuaAppPushSystemUpsellDevOverride() then
			if (not GetFFlagLuaAppEnablePushUpsellOnFirstTime() or v32.pushUpsellVariant ~= 1 or v32.pushUpsellOnFirstTimeVariant ~= 1) and v31.current then
				v31.current = false

				return function() -- line: 94
				end
			end

			local v41 = not GetFFlagLuaAppPushSystemUpsellDevOverride() and v32.pushUpsellVariant == 2

			setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellHome, v41):andThen(function(p4) -- line: 101
				-- upvalues: u40 (ref), IXPService (copy), AppUserLayers (copy), v32 (copy), GetFFlagLuaAppPushSystemUpsellDevOverride (copy), v41 (copy), ModalEventConstants (copy), default (copy), PushUpsellEventConfig (copy), AppPage (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy)
				if u40 and p4 then
					IXPService:LogUserLayerExposure(AppUserLayers.PushNotificationPrompt)

					if v32.pushUpsellVariant > 0 or GetFFlagLuaAppPushSystemUpsellDevOverride() then
						local v43 = if not v41 then ModalEventConstants.ModalContextSysUpsell else ModalEventConstants.ModalContextPushEduUpsell

						default:logRobloxTelemetryEvent(PushUpsellEventConfig, {}, {
							[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
							[ModalEventConstants.EntryPoint] = AppPage.Home
						}, v43)
						setupPushNotificationsUpsell.OpenModal(NotificationsUpsellConstants.ModalKey.PushUpsellHome, v41, AppPage.Home)
					end
				end
			end)
		end

		return function() -- line: 120
			-- upvalues: u40 (ref), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy)
			u40 = false
			setupPushNotificationsUpsell.CloseModal(NotificationsUpsellConstants.ModalKey.PushUpsellHome)
		end
	end, {
		v29,
		v33
	})

	return nil
end

return CheckForPushNotificationsUpsell
