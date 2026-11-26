require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local getFFlagEdpPlayerFeedbackEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").GetFFlagEdpPlayerFeedbackEnabled

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Votes/UserVoteFeedbackMetadataStoreTypes")

return {
	calculateDerivedField = function(p2, p3, p4): nil | boolean
		if p2 ~= "isHidden" then
			return nil
		end

		if getFFlagEdpPlayerFeedbackEnabled() and p3 and p3.canSubmitReview then
			return false
		end

		return true
	end
}
