local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.InGameMenuDependencies).Promise
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local PostFeedback = require(ParentParent.Network.PostFeedback)
local IncrementFeedbackSubmissionAttempts = require(ParentParent.Actions.IncrementFeedbackSubmissionAttempts)

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 17
	-- upvalues: PerformFetch (copy), PostFeedback (copy), IncrementFeedbackSubmissionAttempts (copy), Promise (copy)
	return PerformFetch.Single("PostFeedbackRequest", function(p8) -- line: 27
		-- upvalues: PostFeedback (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy), IncrementFeedbackSubmissionAttempts (copy), p7 (copy), Promise (copy)
		return PostFeedback(p1, p2, p3, p4, p5, p6):andThen(function(p9) -- line: 35
			-- upvalues: p8 (copy), IncrementFeedbackSubmissionAttempts (copy), p7 (copy), Promise (copy)
			p8:dispatch(IncrementFeedbackSubmissionAttempts(p7))

			return Promise.resolve(p9)
		end, function(p10) -- line: 38
			-- upvalues: Promise (copy)
			return Promise.reject(p10)
		end)
	end)
end
