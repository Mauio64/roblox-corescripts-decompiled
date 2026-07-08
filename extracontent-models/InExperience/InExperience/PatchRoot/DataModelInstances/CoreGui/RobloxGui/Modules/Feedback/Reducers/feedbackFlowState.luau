local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local SetFeedbackFlowState = require(ParentParent.Actions.SetFeedbackFlowState)
local SetFeedbackReason = require(ParentParent.Actions.SetFeedbackReason)

return Rodux.createReducer({
	feedbackReason = 0,
	feedbackFlowState = Constants.State.Default
}, {
	[SetFeedbackFlowState.name] = function(p1, t1: {[any]: any}) -- line: 21
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			feedbackFlowState = t1.feedbackFlowState
		})
	end,
	[SetFeedbackReason.name] = function(p2, t2: {[any]: any}) -- line: 26
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p2, {
			feedbackReason = t2.feedbackReason
		})
	end
})
