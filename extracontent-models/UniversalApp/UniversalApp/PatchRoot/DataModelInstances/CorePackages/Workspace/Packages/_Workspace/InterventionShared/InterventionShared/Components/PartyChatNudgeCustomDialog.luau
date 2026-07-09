local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local Constants = require(InterventionShared.Utils.Constants)
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)
local React = require(InterventionSharedParent.React)
local Foundation = require(InterventionSharedParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local useLocalization = require(InterventionSharedParent.Localization).Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local interventionTreatmentShownSignal = require(InterventionShared.Signals.interventionTreatmentShownSignal)
local InterventionDialog = require(InterventionShared.Components.InterventionDialog)

return React.memo(function(p1) -- line: 21
	-- upvalues: useTokens (copy), useLocalization (copy), Constants (copy), React (copy), interventionTreatmentShownSignal (copy), InterventionDialog (copy), IconSize (copy), InterventionAnalytics (copy)
	local v13 = useTokens()
	local v14 = useLocalization(Constants.localizationKeys)

	React.useEffect(function() -- line: 24
		-- upvalues: interventionTreatmentShownSignal (copy), Constants (copy)
		interventionTreatmentShownSignal:fire(Constants.TreatmentType.PartyChatNudgeDialog)
	end, {})

	return React.createElement(InterventionDialog, {
		iconName = "icons/status/error_large",
		titleText = v14.DontSharePersonalInformationText,
		bodyText = v14.PartyChatMayBeSuspendedText,
		onDismiss = p1.onDismiss,
		iconSize = IconSize.Large,
		iconStyle = v13.Color.System.Warning,
		eventId = p1.eventId,
		namespaceForAnalytics = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.PartyChatNudge
	})
end)
