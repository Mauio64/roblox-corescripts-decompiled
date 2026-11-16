local InExperienceIntervention = script:FindFirstAncestor("InExperienceIntervention")
local parent = InExperienceIntervention.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local InExperienceInterventionAnalytics = require(InExperienceIntervention.InExperienceInterventionAnalytics)
local ChatInterventionGenericToast = require(InExperienceIntervention.Components.ChatInterventionGenericToast)

local function format(object, p: string, p2: string)
	if object == nil then
		return p2
	end

	local success, result = pcall(function()
		return object:Format(p)
	end)

	if success and type(result) == "string" and result ~= "" then
		return result
	end

	return p2
end

local function DictationSafetyReminderToast()
	local v = React.useContext(LocalizationRoactContext)
	local v2 = Foundation.Hooks.useTokens()

	local createElement = React.createElement
	local toastTitle

	if v == nil then
		toastTitle = "Voice typing may be turned off if you break the rules"
	else
		local v3 = "Feature.InExperienceIntervention.Heading.VoiceTypingMayBeTurnedOff"
		local success, result = pcall(function()
			return v:Format(v3)
		end)

		toastTitle = (not success or type(result) ~= "string" or result == "")
			and "Voice typing may be turned off if you break the rules"
			or result
	end

	local toastBody

	if v == nil then
		toastBody = "Keep your words kind and your community safe."
	else
		local v3 = "Feature.InExperienceIntervention.Description.KeepWordsKindCommunitySafe"
		local success, result = pcall(function()
			return v:Format(v3)
		end)

		toastBody = (not success or type(result) ~= "string" or result == "")
			and "Keep your words kind and your community safe."
			or result
	end

	return createElement(ChatInterventionGenericToast, {
		toastTitle = toastTitle,
		toastBody = toastBody,
		interventionType = InExperienceInterventionAnalytics.Constants.InterventionTypes.DictationSafetyReminder,
		toastAppearEventName = InExperienceInterventionAnalytics.Constants.EventTypes.DictationSafetyReminderToastAppeared,
		toastDismissEventName = InExperienceInterventionAnalytics.Constants.EventTypes.DictationSafetyReminderToastDismissed,
		iconColor = v2.Color.Content.Emphasis.Color3
	})
end

return DictationSafetyReminderToast
