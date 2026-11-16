local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")

local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/ExperimentLayers").AppUserLayers
local localization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/RobloxAppLocales").Localization
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Constants")
local InterventionAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/InterventionAnalytics")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation")
local iconSize = Foundation.Enums.IconSize
local useCountdownBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Hooks/useCountdownBinding")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Localization").Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/LuauPolyfill")
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local interventionTreatmentShownSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Signals/interventionTreatmentShownSignal")

local InterventionDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Components/InterventionDialog")

local FFlagUFRFriendsChatIXPExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRFriendsChatIXPExposure")

return React.memo(function(props)
	local v5 = useTokens()
	local v6 = useLocalization(Constants.localizationKeys)
	local v7 = localization.new(LocalizationService.RobloxLocaleId)
	React.useEffect(function()
		if FFlagUFRFriendsChatIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(appUserLayers.FriendsChatRestrictionUserIDLayer)
		end

		interventionTreatmentShownSignal:fire(Constants.TreatmentType.PartyChatTimeoutDialog)
	end, {})

	local v8 = useCountdownBinding(props.endTimestamp, "0:00")
	React.useEffect(function()
		local v9

		if props.endTimestamp == nil then
			v9 = nil
		else
			v9 = setTimeout(function()
				props.onDismiss()
			end, math.max(props.endTimestamp - DateTime.now().UnixTimestamp + 1, 1) * 1000)
		end

		return function()
			if v9 then
				clearTimeout(v9)
			end
		end
	end, { props.endTimestamp, props.onDismiss })

	return React.createElement(InterventionDialog, {
		titleText = v8:map(function(p2)
			return v7:Format(Constants.localizationKeys.PartyChatSuspendedText, {
				remainingTime = p2
			})
		end),
		bodyText = v6.CantUsePartyChatText,
		onDismiss = props.onDismiss,
		iconName = "icons/status/error_large",
		iconSize = iconSize.Large,
		iconStyle = v5.Color.System.Alert,
		eventId = props.eventId,
		namespaceForAnalytics = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.PartyChatTimeout,
		durationForAnalytics = props.durationForAnalytics
	})
end)
