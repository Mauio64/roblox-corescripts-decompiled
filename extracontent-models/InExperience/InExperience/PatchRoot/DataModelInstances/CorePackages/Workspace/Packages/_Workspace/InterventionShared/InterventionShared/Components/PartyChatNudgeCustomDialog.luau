local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local IXPService = game:GetService("IXPService")

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local Constants = require(InterventionShared.Utils.Constants)
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local interventionTreatmentShownSignal = require(InterventionShared.Signals.interventionTreatmentShownSignal)

local InterventionDialog = require(InterventionShared.Components.InterventionDialog)

local FFlagUFRFriendsChatIXPExposure = require(InterventionShared.Flags.FFlagUFRFriendsChatIXPExposure)

return React.memo(function(p)
	local v = useTokens()
	local v2 = useLocalization(Constants.localizationKeys)
	React.useEffect(function()
		if FFlagUFRFriendsChatIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.FriendsChatRestrictionUserIDLayer)
		end

		interventionTreatmentShownSignal:fire(Constants.TreatmentType.PartyChatNudgeDialog)
	end, {})

	return React.createElement(InterventionDialog, {
		titleText = v2.DontSharePersonalInformationText,
		bodyText = v2.PartyChatMayBeSuspendedText,
		onDismiss = p.onDismiss,
		iconName = "icons/status/error_large",
		iconSize = IconSize.Large,
		iconStyle = v.Color.System.Warning,
		eventId = p.eventId,
		namespaceForAnalytics = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.PartyChatNudge
	})
end)
