local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.InGameMenuDependencies).Promise
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local ParentParent = script.Parent.Parent
local PostFeedback = require(ParentParent.Network.PostFeedback)
local IncrementFeedbackSubmissionAttempts = require(ParentParent.Actions.IncrementFeedbackSubmissionAttempts)

return function(p1, p2, p3, p4, p5, p6, p7, p8) -- line: 17
	-- upvalues: PerformFetch (copy), PostFeedback (copy), IncrementFeedbackSubmissionAttempts (copy), Promise (copy)
	return PerformFetch.Single("PostFeedbackRequest", function(p9) -- line: 28
		-- upvalues: PostFeedback (copy), p1 (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy), p7 (copy), IncrementFeedbackSubmissionAttempts (copy), p8 (copy), Promise (copy)
		return PostFeedback(p1, p2, p3, p4, p5, p6, p7):andThen(function(p10) -- line: 37
			-- upvalues: p9 (copy), IncrementFeedbackSubmissionAttempts (copy), p8 (copy), Promise (copy)
			p9:dispatch(IncrementFeedbackSubmissionAttempts(p8))

			return Promise.resolve(p10)
		end, function(p11) -- line: 40
			-- upvalues: Promise (copy)
			return Promise.reject(p11)
		end)
	end)
end
