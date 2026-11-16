local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Promise = InGameMenuDependencies.Promise
local Http = require(CorePackages.Workspace.Packages.Http)
local PerformFetch = Http.PerformFetch

local parent = script.Parent.Parent

local PostFeedback = require(parent.Network.PostFeedback)

local IncrementFeedbackSubmissionAttempts = require(parent.Actions.IncrementFeedbackSubmissionAttempts)

return function(p, p2, p3, p4, p5, p6, p7, p8)
	return PerformFetch.Single("PostFeedbackRequest", function(object)
		return PostFeedback(p, p2, p3, p4, p5, p6, p7):andThen(function(p9)
			object:dispatch(IncrementFeedbackSubmissionAttempts(p8))
			return Promise.resolve(p9)
		end, function(p9)
			return Promise.reject(p9)
		end)
	end)
end
