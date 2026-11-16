local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent

local Constants = require(parent.Resources.Constants)

local SetFeedbackFlowState = require(parent.Actions.SetFeedbackFlowState)
local SetFeedbackReason = require(parent.Actions.SetFeedbackReason)

return Rodux.createReducer({ feedbackFlowState = Constants.State.Default, feedbackReason = 0 }, {
	[SetFeedbackFlowState.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { feedbackFlowState = p2.feedbackFlowState })
	end,
	[SetFeedbackReason.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { feedbackReason = p2.feedbackReason })
	end
})
