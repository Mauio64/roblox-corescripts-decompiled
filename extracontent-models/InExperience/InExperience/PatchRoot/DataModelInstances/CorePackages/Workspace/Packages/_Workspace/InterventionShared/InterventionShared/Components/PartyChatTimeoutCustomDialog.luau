local LocalizationService = game:GetService("LocalizationService")
local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local Localization = require(InterventionSharedParent.RobloxAppLocales).Localization
local Constants = require(InterventionShared.Utils.Constants)
local InterventionAnalytics = require(InterventionShared.InterventionAnalytics)
local React = require(InterventionSharedParent.React)
local Foundation = require(InterventionSharedParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local useCountdownBinding = require(InterventionShared.Hooks.useCountdownBinding)
local useLocalization = require(InterventionSharedParent.Localization).Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local LuauPolyfill = require(InterventionSharedParent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local interventionTreatmentShownSignal = require(InterventionShared.Signals.interventionTreatmentShownSignal)
local InterventionDialog = require(InterventionShared.Components.InterventionDialog)

return React.memo(function(p1) -- line: 29
	-- upvalues: useTokens (copy), useLocalization (copy), Constants (copy), Localization (copy), LocalizationService (copy), React (copy), interventionTreatmentShownSignal (copy), useCountdownBinding (copy), setTimeout (copy), clearTimeout (copy), InterventionDialog (copy), IconSize (copy), InterventionAnalytics (copy)
	local v19 = useTokens()
	local v20 = useLocalization(Constants.localizationKeys)
	local v21 = Localization.new(LocalizationService.RobloxLocaleId)

	React.useEffect(function() -- line: 33
		-- upvalues: interventionTreatmentShownSignal (copy), Constants (copy)
		interventionTreatmentShownSignal:fire(Constants.TreatmentType.PartyChatTimeoutDialog)
	end, {})

	local v22 = useCountdownBinding(p1.endTimestamp, "0:00")

	React.useEffect(function() -- line: 38
		-- upvalues: p1 (copy), setTimeout (copy), clearTimeout (copy)
		local u23 = nil

		if p1.endTimestamp ~= nil then
			u23 = setTimeout(function() -- line: 41
				-- upvalues: p1 (copy)
				p1.onDismiss()
			end, math.max(p1.endTimestamp - DateTime.now().UnixTimestamp + 1, 1) * 1000)
		end

		return function() -- line: 45
			-- upvalues: u23 (ref), clearTimeout (copy)
			if u23 then
				clearTimeout(u23)
			end
		end
	end, {
		p1.endTimestamp,
		p1.onDismiss
	})

	return React.createElement(InterventionDialog, {
		iconName = "icons/status/error_large",
		titleText = v22:map(function(p2) -- line: 53
			-- upvalues: v21 (copy), Constants (copy)
			return v21:Format(Constants.localizationKeys.PartyChatSuspendedText, {
				remainingTime = p2
			})
		end),
		bodyText = v20.CantUsePartyChatText,
		onDismiss = p1.onDismiss,
		iconSize = IconSize.Large,
		iconStyle = v19.Color.System.Alert,
		eventId = p1.eventId,
		namespaceForAnalytics = InterventionAnalytics.Constants.CounterNamespaceTypes.PartyChat,
		interventionTypeForAnalytics = InterventionAnalytics.Constants.InterventionTypes.PartyChatTimeout,
		durationForAnalytics = p1.durationForAnalytics
	})
end)
