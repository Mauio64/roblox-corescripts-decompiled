local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")

local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local Constants = require(InterventionShared.Utils.Constants)
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local useCountdownBinding = require(InterventionShared.Hooks.useCountdownBinding)
local Localization2 = require(parent.Localization)
local useLocalization = Localization2.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local LuauPolyfill = require(parent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local interventionTreatmentShownSignal = require(InterventionShared.Signals.interventionTreatmentShownSignal)

local InterventionDialog = require(InterventionShared.Components.InterventionDialog)

local FFlagUFRFriendsChatIXPExposure = require(InterventionShared.Flags.FFlagUFRFriendsChatIXPExposure)

return React.memo(function(props)
	local v = useTokens()
	local v2 = useLocalization(Constants.localizationKeys)
	local v3 = Localization.new(LocalizationService.RobloxLocaleId)
	React.useEffect(function()
		if FFlagUFRFriendsChatIXPExposure and game:GetEngineFeature("EnableLogFlagLinkedUserLayerExposure") then
			IXPService:LogFlagLinkedUserLayerExposure(AppUserLayers.FriendsChatRestrictionUserIDLayer)
		end

		interventionTreatmentShownSignal:fire(Constants.TreatmentType.PartyChatTimeoutDialog)
	end, {})

	local v4 = useCountdownBinding(props.endTimestamp, "0:00")
	React.useEffect(function()
		local v5

		if props.endTimestamp == nil then
			v5 = nil
		else
			v5 = setTimeout(function()
				props.onDismiss()
			end, math.max(props.endTimestamp - DateTime.now().UnixTimestamp + 1, 1) * 1000)
		end

		return function()
			if v5 then
				clearTimeout(v5)
			end
		end
	end, { props.endTimestamp, props.onDismiss })

	return React.createElement(InterventionDialog, {
		titleText = v4:map(function(remainingTime)
			return v3:Format(Constants.localizationKeys.PartyChatSuspendedText, {
				remainingTime = remainingTime
			})
		end),
		bodyText = v2.CantUsePartyChatText,
		onDismiss = props.onDismiss,
		iconName = "icons/status/error_large",
		iconSize = IconSize.Large,
		iconStyle = v.Color.System.Alert,
		eventId = props.eventId,
		namespaceForAnalytics = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.PartyChatTimeout,
		durationForAnalytics = props.durationForAnalytics
	})
end)
