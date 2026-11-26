local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Localization")
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/LoggingProtocol").default
local NotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/NotificationsUpsell")
local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/PermissionsProtocol").PermissionsProtocol
local mouseIconOverrideService = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/CoreScriptsCommon").MouseIconOverrideService
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/CoreScriptsRoactCommon").useScreenSize

local fetchInGameRsvpPushUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/fetchInGameRsvpPushUpsell")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Common/InGameRsvpPushUpsellTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/CoreUI/PushUpsellPrompt/PushUpsellPromptView")

local modalEventConstants = NotificationsUpsell.ModalEventConstants
local pushUpsellEventConfig = NotificationsUpsell.PushUpsellEventConfig
local requestPushNotificationPermission = NotificationsUpsell.requestPushNotificationPermission
local useLocalization = Localization.Hooks.useLocalization

local function usePushUpsellPromptViewModel(p2)
	local promptData = p2.promptData
	local closePrompt = p2.closePrompt
	local v5 = promptData.path == "Settings"

	local v6 = useScreenSize()
	local v7 = useLocalization({ notNowButton = "Feature.VirtualEvents.NotNowButton" })

	local v8 = React.useCallback(function(p3, p4)
		local clone = table.clone(p3)
		clone[modalEventConstants.EntryPoint] = modalEventConstants.EntryPointInGameRsvp
		clone[modalEventConstants.UniverseId] = tostring(game.GameId)
		clone[modalEventConstants.EventId] = promptData.eventId
		default:logRobloxTelemetryEvent(pushUpsellEventConfig, {}, clone, p4)
	end, { promptData.eventId })

	React.useEffect(function()
		mouseIconOverrideService.push("PushUpsellPromptOverride", Enum.OverrideMouseIconBehavior.ForceShow)
		return function()
			mouseIconOverrideService.pop("PushUpsellPromptOverride")
		end
	end, {})

	React.useEffect(function()
		fetchInGameRsvpPushUpsell.reportImpression(promptData.promptType)
		v8(
			{ [modalEventConstants.ActionType] = modalEventConstants.Opened },
			modalEventConstants.ModalContextPushEduUpsell
		)
	end, {})

	local v9 = React.useCallback(function()
		closePrompt()
		v8(
			{
				[modalEventConstants.ActionType] = modalEventConstants.Clicked,
				[modalEventConstants.Button] = modalEventConstants.Confirm
			},
			modalEventConstants.ModalContextPushEduUpsell
		)

		if v5 then
			permissionsProtocol.default:openNotificationSettings():andThen(function(p3)
				local v12 = if typeof(p3) == "table" then p3.status else nil
				local v14 = {
					[modalEventConstants.ActionType] = modalEventConstants.SettingsOpened
				}
				local settingsResult = modalEventConstants.SettingsResult

				if typeof(v12) ~= "string" then
					v12 = permissionsProtocol.OpenSettingsStatus.FAILED
				end

				v14[settingsResult] = v12
				v8(v14, modalEventConstants.ModalContextSettingsUpsell)
			end, function()
				v8(
					{
						[modalEventConstants.ActionType] = modalEventConstants.SettingsOpened,
						[modalEventConstants.SettingsResult] = permissionsProtocol.OpenSettingsStatus.FAILED
					},
					modalEventConstants.ModalContextSettingsUpsell
				)
			end)
			return
		end

		local function logRequestResult(p3, p4)
			local openSettingsStatus = if typeof(p4) == "table" then p4.openSettingsStatus else nil

			if typeof(openSettingsStatus) == "string" then
				v8(
					{
						[modalEventConstants.ActionType] = modalEventConstants.SettingsOpened,
						[modalEventConstants.SettingsResult] = openSettingsStatus
					},
					modalEventConstants.ModalContextSettingsUpsell
				)
			else
				v8({ [modalEventConstants.ActionType] = p3 }, modalEventConstants.ModalContextSysUpsell)
			end
		end
		v8(
			{ [modalEventConstants.ActionType] = modalEventConstants.Opened },
			modalEventConstants.ModalContextSysUpsell
		)

		requestPushNotificationPermission({ allowOpenSettings = true }):andThen(function(p3)
			logRequestResult(modalEventConstants.RequestSuccess, p3)
		end, function(p3)
			logRequestResult(modalEventConstants.RequestFailed, p3)
		end)
	end, { closePrompt, v8, v5 })

	local v10 = React.useCallback(function()
		closePrompt()
		fetchInGameRsvpPushUpsell.reportDismiss(promptData.promptType)
		v8(
			{
				[modalEventConstants.ActionType] = modalEventConstants.Clicked,
				[modalEventConstants.Button] = modalEventConstants.Cancel
			},
			modalEventConstants.ModalContextPushEduUpsell
		)
	end, { closePrompt, v8, promptData.promptType })

	local translations = promptData.translations
	return {
		title = translations.title,
		bodyText = translations.body,
		confirmText = translations.confirm,
		cancelText = translations.cancel or v7.notNowButton,
		screenSize = v6,
		onConfirm = v9,
		onCancel = v10
	}
end

return usePushUpsellPromptViewModel
