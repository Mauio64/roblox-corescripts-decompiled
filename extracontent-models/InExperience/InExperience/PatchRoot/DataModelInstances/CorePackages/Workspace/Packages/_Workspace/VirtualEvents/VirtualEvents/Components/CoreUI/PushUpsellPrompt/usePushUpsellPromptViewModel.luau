local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local parent = VirtualEvents.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local NotificationsUpsell = require(parent.NotificationsUpsell)
local PermissionsProtocol = require(parent.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol
local CoreScriptsCommon = require(parent.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local CoreScriptsRoactCommon = require(parent.CoreScriptsRoactCommon)
local useScreenSize = CoreScriptsRoactCommon.useScreenSize

local fetchInGameRsvpPushUpsell = require(VirtualEvents.Common.fetchInGameRsvpPushUpsell)
require(VirtualEvents.Common.InGameRsvpPushUpsellTypes)
require(script.Parent.PushUpsellPromptView)

local ModalEventConstants = NotificationsUpsell.ModalEventConstants
local PushUpsellEventConfig = NotificationsUpsell.PushUpsellEventConfig
local requestPushNotificationPermission = NotificationsUpsell.requestPushNotificationPermission
local useLocalization = Localization.Hooks.useLocalization

local function usePushUpsellPromptViewModel(p)
	local promptData = p.promptData
	local closePrompt = p.closePrompt
	local v = promptData.path == "Settings"

	local screenSize = useScreenSize()
	local v2 = useLocalization({ notNowButton = "Feature.VirtualEvents.NotNowButton" })

	local v3 = React.useCallback(function(p2, p3: string)
		local clone = table.clone(p2)
		clone[ModalEventConstants.EntryPoint] = ModalEventConstants.EntryPointInGameRsvp
		clone[ModalEventConstants.UniverseId] = tostring(game.GameId)
		clone[ModalEventConstants.EventId] = promptData.eventId
		default:logRobloxTelemetryEvent(PushUpsellEventConfig, {}, clone, p3)
	end, { promptData.eventId })

	React.useEffect(function()
		MouseIconOverrideService.push("PushUpsellPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)
		return function()
			MouseIconOverrideService.pop("PushUpsellPromptOverride")
		end
	end, {})

	React.useEffect(function()
		fetchInGameRsvpPushUpsell.reportImpression(promptData.promptType)
		v3(
			{ [ModalEventConstants.ActionType] = ModalEventConstants.Opened },
			ModalEventConstants.ModalContextPushEduUpsell
		)
	end, {})

	local onConfirm = React.useCallback(function()
		closePrompt()
		v3(
			{
				[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
				[ModalEventConstants.Button] = ModalEventConstants.Confirm
			},
			ModalEventConstants.ModalContextPushEduUpsell
		)

		if v then
			permissionsProtocol.default:openNotificationSettings():andThen(function(p2)
				local v4

				if typeof(p2) == "table" then
					v4 = p2.status
				end

				local v5 = { [ModalEventConstants.ActionType] = ModalEventConstants.SettingsOpened }
				local settingsResult = ModalEventConstants.SettingsResult

				if typeof(v4) ~= "string" then
					v4 = permissionsProtocol.OpenSettingsStatus.FAILED
				end

				v5[settingsResult] = v4
				v3(v5, ModalEventConstants.ModalContextSettingsUpsell)
			end, function()
				v3(
					{
						[ModalEventConstants.ActionType] = ModalEventConstants.SettingsOpened,
						[ModalEventConstants.SettingsResult] = permissionsProtocol.OpenSettingsStatus.FAILED
					},
					ModalEventConstants.ModalContextSettingsUpsell
				)
			end)
			return
		end

		local function logRequestResult(p2: string, p3)
			local openSettingsStatus

			if typeof(p3) == "table" then
				openSettingsStatus = p3.openSettingsStatus
			end

			if typeof(openSettingsStatus) == "string" then
				v3(
					{
						[ModalEventConstants.ActionType] = ModalEventConstants.SettingsOpened,
						[ModalEventConstants.SettingsResult] = openSettingsStatus
					},
					ModalEventConstants.ModalContextSettingsUpsell
				)
			else
				v3({ [ModalEventConstants.ActionType] = p2 }, ModalEventConstants.ModalContextSysUpsell)
			end
		end
		v3({ [ModalEventConstants.ActionType] = ModalEventConstants.Opened }, ModalEventConstants.ModalContextSysUpsell)

		requestPushNotificationPermission({ allowOpenSettings = true }):andThen(function(p2)
			logRequestResult(ModalEventConstants.RequestSuccess, p2)
		end, function(p2)
			logRequestResult(ModalEventConstants.RequestFailed, p2)
		end)
	end, { closePrompt, v3, v })

	local onCancel = React.useCallback(function()
		closePrompt()
		fetchInGameRsvpPushUpsell.reportDismiss(promptData.promptType)
		v3(
			{
				[ModalEventConstants.ActionType] = ModalEventConstants.Clicked,
				[ModalEventConstants.Button] = ModalEventConstants.Cancel
			},
			ModalEventConstants.ModalContextPushEduUpsell
		)
	end, { closePrompt, v3, promptData.promptType })

	local translations = promptData.translations
	return {
		title = translations.title,
		bodyText = translations.body,
		confirmText = translations.confirm,
		cancelText = translations.cancel or v2.notNowButton,
		screenSize = screenSize,
		onConfirm = onConfirm,
		onCancel = onCancel
	}
end

return usePushUpsellPromptViewModel
