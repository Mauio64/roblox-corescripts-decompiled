local parent = script:FindFirstAncestor("DataHydration").Parent

require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEdpPlayerFeedbackEnabled = SharedFlags.GetFFlagEdpPlayerFeedbackEnabled

require(script.Parent.UserVoteFeedbackMetadataStoreTypes)

return {
	calculateDerivedField = function(p: string, p2, _): nil | boolean
		if p ~= "isHidden" then
			return nil
		end

		return not (GetFFlagEdpPlayerFeedbackEnabled() and p2 and p2.canSubmitReview)
	end
}
