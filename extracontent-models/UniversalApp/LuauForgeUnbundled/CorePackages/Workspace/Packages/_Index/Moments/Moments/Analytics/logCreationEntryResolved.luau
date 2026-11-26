local analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon").Analytics

local v5 = {
	GalleryOpened = "gallery_opened",
	EducationShown = "education_shown",
	PermissionDenied = "permission_denied",
	ReadError = "read_error",
	GalleryUnavailable = "gallery_unavailable",
	RequestInFlight = "request_in_flight"
}

local function logCreationEntryResolved(p2, creationSessionId)
	local v6 = { entryOutcome = p2 }

	if creationSessionId ~= nil then
		v6.creationSessionId = creationSessionId
	end

	analytics.fireAnalyticsEvent(analytics.EventNames.MomentCreationEntryResolved, v6)
end

return {
	Outcome = v5,
	resolveGalleryOutcome = function(p2, p3, p4)
		if p2 then
			if p3 == 0 then
				return v5.EducationShown
			end

			return v5.GalleryOpened
		elseif p4 == v5.PermissionDenied then
			return v5.PermissionDenied
		else
			return v5.ReadError
		end
	end,
	log = logCreationEntryResolved
}
