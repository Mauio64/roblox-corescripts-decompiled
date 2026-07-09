local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local ChallengeDialogParent = ChallengeDialog.Parent
local FetchDialog = require(ChallengeDialog.Requests.FetchDialog)
local PerformFetch = require(ChallengeDialogParent.Http).PerformFetch

return function(p1) -- line: 7
	-- upvalues: PerformFetch (copy), FetchDialog (copy)
	return PerformFetch.Single("FetchDialog", function(_) -- line: 8
		-- upvalues: FetchDialog (copy), p1 (copy)
		return FetchDialog(p1):andThen(function(p3) -- line: 9
			return p3.responseBody
		end)
	end)
end
