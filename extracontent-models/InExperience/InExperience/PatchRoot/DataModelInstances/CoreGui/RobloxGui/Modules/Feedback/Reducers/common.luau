local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local IncrementFeedbackSubmissionAttempts = require(ParentParent.Actions.IncrementFeedbackSubmissionAttempts)
local ShowHelpModal = require(ParentParent.Actions.ShowHelpModal)
local ShowOnboardingModal = require(ParentParent.Actions.ShowOnboardingModal)

return Rodux.createReducer({
	numFeedbackSubmissionAttempts = nil,
	showHelpModal = false,
	showOnboardingModal = true
}, {
	[IncrementFeedbackSubmissionAttempts.name] = function(p1, t1: {[any]: any}) -- line: 20
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			numFeedbackSubmissionAttempts = t1.numFeedbackSubmissionAttempts
		})
	end,
	[ShowHelpModal.name] = function(p2, t2: {[any]: any}) -- line: 25
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p2, {
			showHelpModal = t2.helpModalVisible
		})
	end,
	[ShowOnboardingModal.name] = function(p3, t3: {[any]: any}) -- line: 30
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			showOnboardingModal = t3.onboardingModalVisible
		})
	end
})
