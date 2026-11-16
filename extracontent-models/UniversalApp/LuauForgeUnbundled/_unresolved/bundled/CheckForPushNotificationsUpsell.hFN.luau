local IXPService = game:GetService("IXPService")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local module2 = require("@luauforge/bundled/fAN")
local module3 = require("@luauforge/bundled/hdh")
local appUserLayers = require("@luauforge/bundled/dMA").AppUserLayers
local module4 = require("@luauforge/bundled/dCp")
local module5 = require("@luauforge/bundled/cyM")
local useLaunchContext = module5.Hooks.useLaunchContext
local launchContext = module5.Enums.LaunchContext

local getFStringPushUpsellVariantName = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFStringPushUpsellVariantName

local getFStringPushUpsellOnFirstTimeVariantName = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFStringPushUpsellOnFirstTimeVariantName

local getFFlagLuaAppPushSystemUpsellDevOverride = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppPushSystemUpsellDevOverride

local getFFlagLuaAppEnablePushUpsellOnFirstTime = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnablePushUpsellOnFirstTime

local setupPushNotificationsUpsell = module3.setupPushNotificationsUpsell
local notificationsUpsellConstants = module3.NotificationsUpsellConstants
local pushUpsellEventConfig = module3.PushUpsellEventConfig
local modalEventConstants = module3.ModalEventConstants
local fFlagNotificationsUpsellUseRequestPushPermissionHelper = SharedFlags.FFlagPushNotificationsUpsellHomePromptsExperiment
	and SharedFlags.FFlagNotificationsUpsellUseRequestPushPermissionHelper

local v5 = { appUserLayers.PushNotificationPrompt }
local v6

if fFlagNotificationsUpsellUseRequestPushPermissionHelper then
	v6 = SharedFlags.FStringPushNotificationsUpsellHomePromptsExperimentLayer

	if v6 ~= appUserLayers.PushNotificationPrompt then
		table.insert(v5, v6)
	end
else
	v6 = ""
end

local function CheckForPushNotificationsUpsell(p2): nil
	local v7 = useDispatch()
	local v8 = useLaunchContext()
	local state, setState = React.useState(false)
	local useRef = React.useRef
	local v9 = not (v8 == nil) and (v8 == launchContext.SignUp or v8 == launchContext.Login)
	local v10 = useRef(v9)

	local v11 = useUserExperiment(v5, function(p3)
		local v12 = p3[appUserLayers.PushNotificationPrompt] or {}
		local fStringPushUpsellVariantName = getFStringPushUpsellVariantName()
		local fStringPushUpsellOnFirstTimeVariantName = getFStringPushUpsellOnFirstTimeVariantName()
		local v13 = {
			pushUpsellVariant = v12[fStringPushUpsellVariantName] or -1,
			pushUpsellOnFirstTimeVariant = v12[fStringPushUpsellOnFirstTimeVariantName] or -1
		}

		if not fFlagNotificationsUpsellUseRequestPushPermissionHelper then
			return v13
		end

		local v14 = (p3[v6] or {})[SharedFlags.FStringPushNotificationsUpsellHomePromptsExperimentParameter]
		v13.homePromptsVariant = v14
		v13.useHomePrompts = v14 ~= nil
			and v14 ~= SharedFlags.FStringPushNotificationsUpsellHomePromptsControlValue

		return v13
	end)

	local v12 = useSelector(function(p3)
		return p3.Personalization.PageSessionTimestamp[module4.Home]
	end)

	React.useEffect(function()
		if not state then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId or 0
			v7(module2(IXPService, userId)):andThen(function()
				setState(true)
			end)
		end
	end, { state })

	local v13 = fFlagNotificationsUpsellUseRequestPushPermissionHelper
		and { state, v11.homePromptsVariant, v11.useHomePrompts, v12 }
		or { state, v12 }

	React.useEffect(function()
		local v14 = true

		if fFlagNotificationsUpsellUseRequestPushPermissionHelper and v11.useHomePrompts then
			return function() end
		end

		if v12 == nil then
			return function() end
		end

		if
			state and v11.pushUpsellVariant ~= nil and v11.pushUpsellVariant > -1
			or getFFlagLuaAppPushSystemUpsellDevOverride()
		then
			if
				(not getFFlagLuaAppEnablePushUpsellOnFirstTime() or v11.pushUpsellVariant ~= 1 or v11.pushUpsellOnFirstTimeVariant ~= 1)
				and v10.current
			then
				v10.current = false
				return function() end
			end

			local v15 = not getFFlagLuaAppPushSystemUpsellDevOverride() and v11.pushUpsellVariant == 2
			setupPushNotificationsUpsell.ShouldShowUpsell(
				notificationsUpsellConstants.ModalKey.PushUpsellHome,
				v15
			):andThen(function(p3)
				if v14 and p3 then
					if
						fFlagNotificationsUpsellUseRequestPushPermissionHelper
						and v11.homePromptsVariant == SharedFlags.FStringPushNotificationsUpsellHomePromptsControlValue
						and v6 ~= appUserLayers.PushNotificationPrompt
					then
						IXPService:LogUserLayerExposure(v6)
					end

					IXPService:LogUserLayerExposure(appUserLayers.PushNotificationPrompt)

					if v11.pushUpsellVariant > 0 or getFFlagLuaAppPushSystemUpsellDevOverride() then
						local v16

						if v15 then
							v16 = modalEventConstants.ModalContextPushEduUpsell
						else
							v16 = modalEventConstants.ModalContextSysUpsell
						end

						default:logRobloxTelemetryEvent(
							pushUpsellEventConfig,
							{},
							{
								[modalEventConstants.ActionType] = modalEventConstants.ShouldRequest,
								[modalEventConstants.EntryPoint] = module4.Home
							},
							v16
						)

						setupPushNotificationsUpsell.OpenModal(
							notificationsUpsellConstants.ModalKey.PushUpsellHome,
							v15,
							module4.Home
						)
					end
				end
			end)
		end

		return function()
			v14 = false
			setupPushNotificationsUpsell.CloseModal(notificationsUpsellConstants.ModalKey.PushUpsellHome)
		end
	end, v13)

	return nil
end

return CheckForPushNotificationsUpsell
