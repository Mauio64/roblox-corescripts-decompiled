local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator(script.Name, function(numFeedbackSubmissionAttempts)
	return { numFeedbackSubmissionAttempts = numFeedbackSubmissionAttempts }
end)
