local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local dictationSafetyReminderSignal = require(parent.InterventionShared.dictationSafetyReminderSignal)

local FFlagExpChatDictationGrafanaMetrics = require(ExpChat.Flags.FFlagExpChatDictationGrafanaMetrics)
local DictationAnalytics = require(script.Parent.DictationAnalytics)
local createDictationSafetyReminder = require(script.Parent.createDictationSafetyReminder)

return createDictationSafetyReminder({
	onTriggered = function()
		DictationAnalytics.fire(DictationAnalytics.Events.SafetyReminderTriggered, {
			[DictationAnalytics.Properties.SttMode] = DictationAnalytics.Modes.Continuous
		})

		if FFlagExpChatDictationGrafanaMetrics then
			DictationAnalytics.reportSafetyReminderCounter()
		end

		dictationSafetyReminderSignal:fire()
	end
})
