local Parent = script:FindFirstAncestor("DataHydration").Parent

require(Parent.Signals)

local GetFFlagEdpPlayerFeedbackEnabled = require(Parent.SharedFlags).GetFFlagEdpPlayerFeedbackEnabled

require(script.Parent.UserVoteFeedbackMetadataStoreTypes)

return {
	calculateDerivedField = function(s1: string, p1, _) -- line: 13
		-- upvalues: GetFFlagEdpPlayerFeedbackEnabled (copy)
		if s1 == "isHidden" then
			if GetFFlagEdpPlayerFeedbackEnabled() and p1 and p1.canSubmitReview then
				return false
			end

			return true
		end

		return nil
	end
}
