local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local HttpService = game:GetService("HttpService")
local ChallengeDialogParent = ChallengeDialog.Parent
local Promise = require(ChallengeDialogParent.Promise)
local ChallengeDialogAction = require(ChallengeDialog.Enum.ChallengeDialogAction)
local ChallengeDialogError = require(ChallengeDialog.Enum.ChallengeDialogError)
local PostFinishDialog = require(ChallengeDialog.Requests.PostFinishDialog)

return function(p1, p2, p3) -- line: 11
	-- upvalues: PostFinishDialog (copy), ChallengeDialogAction (copy), Promise (copy), ChallengeDialogError (copy), HttpService (copy)
	return function(_) -- line: 12
		-- upvalues: PostFinishDialog (copy), p1 (copy), p2 (copy), ChallengeDialogAction (copy), p3 (copy), Promise (copy), ChallengeDialogError (copy), HttpService (copy)
		return PostFinishDialog(p1, p2, ChallengeDialogAction.toRawValue(p3)):andThen(function(p5) -- line: 14
			return p5.responseBody
		end):catch(function(p6) -- line: 17
			-- upvalues: Promise (copy), ChallengeDialogError (copy), HttpService (copy)
			if not p6.Body then
				return Promise.reject(ChallengeDialogError.Unknown)
			end

			local code = HttpService:JSONDecode(p6.Body).errors[1].code
			local v15 = ChallengeDialogError.fromRawValue(code)

			return Promise.reject(v15 or ChallengeDialogError.Unknown)
		end)
	end
end
