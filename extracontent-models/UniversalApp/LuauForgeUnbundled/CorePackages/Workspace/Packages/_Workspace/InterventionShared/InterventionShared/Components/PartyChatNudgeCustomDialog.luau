local IXPService = game:GetService("IXPService")

local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/ExperimentLayers").AppUserLayers
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Constants")
local InterventionAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/InterventionAnalytics")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation")
local iconSize = Foundation.Enums.IconSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Localization").Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local interventionTreatmentShownSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Signals/interventionTreatmentShownSignal")

local InterventionDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Components/InterventionDialog")

local FFlagUFRFriendsChatIXPExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRFriendsChatIXPExposure")

return React.memo(function(p2)
	local v5 = useTokens()
	local v6 = useLocalization(Constants.localizationKeys)
	React.useEffect(function()
		if FFlagUFRFriendsChatIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(appUserLayers.FriendsChatRestrictionUserIDLayer)
		end

		interventionTreatmentShownSignal:fire(Constants.TreatmentType.PartyChatNudgeDialog)
	end, {})

	return React.createElement(InterventionDialog, {
		titleText = v6.DontSharePersonalInformationText,
		bodyText = v6.PartyChatMayBeSuspendedText,
		onDismiss = p2.onDismiss,
		iconName = "icons/status/error_large",
		iconSize = iconSize.Large,
		iconStyle = v5.Color.System.Warning,
		eventId = p2.eventId,
		namespaceForAnalytics = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.PartyChatNudge
	})
end)
