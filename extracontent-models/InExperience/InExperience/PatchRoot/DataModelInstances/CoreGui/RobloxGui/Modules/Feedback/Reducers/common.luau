local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent

local IncrementFeedbackSubmissionAttempts = require(parent.Actions.IncrementFeedbackSubmissionAttempts)
local ShowHelpModal = require(parent.Actions.ShowHelpModal)
local ShowOnboardingModal = require(parent.Actions.ShowOnboardingModal)
local SetSourceLanguageName = require(parent.Actions.SetSourceLanguageName)

return Rodux.createReducer(
	{
		numFeedbackSubmissionAttempts = nil,
		showHelpModal = false,
		showOnboardingModal = true,
		sourceLanguageName = ""
	},
	{
		[IncrementFeedbackSubmissionAttempts.name] = function(p, p2)
			return Cryo.Dictionary.join(p, {
				numFeedbackSubmissionAttempts = p2.numFeedbackSubmissionAttempts
			})
		end,
		[ShowHelpModal.name] = function(p, p2)
			return Cryo.Dictionary.join(p, { showHelpModal = p2.helpModalVisible })
		end,
		[ShowOnboardingModal.name] = function(p, p2)
			return Cryo.Dictionary.join(p, { showOnboardingModal = p2.onboardingModalVisible })
		end,
		[SetSourceLanguageName.name] = function(p, p2)
			return Cryo.Dictionary.join(p, { sourceLanguageName = p2.sourceLanguageName })
		end
	}
)
