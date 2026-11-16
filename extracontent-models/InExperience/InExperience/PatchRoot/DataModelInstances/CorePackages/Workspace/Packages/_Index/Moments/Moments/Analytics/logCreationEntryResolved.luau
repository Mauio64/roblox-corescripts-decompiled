local parent = script:FindFirstAncestor("Moments").Parent

local MomentsCommon = require(parent.MomentsCommon)
local Analytics = MomentsCommon.Analytics

local outcome = {
	GalleryOpened = "gallery_opened",
	EducationShown = "education_shown",
	PermissionDenied = "permission_denied",
	ReadError = "read_error",
	GalleryUnavailable = "gallery_unavailable",
	RequestInFlight = "request_in_flight"
}

local function logCreationEntryResolved(entryOutcome: string, creationSessionId: string?)
	local v = { entryOutcome = entryOutcome }

	if creationSessionId ~= nil then
		v.creationSessionId = creationSessionId
	end

	Analytics.fireAnalyticsEvent(Analytics.EventNames.MomentCreationEntryResolved, v)
end

return {
	Outcome = outcome,
	resolveGalleryOutcome = function(flag: boolean, p: number, p2: string?)
		if flag then
			if p == 0 then
				return outcome.EducationShown
			end

			return outcome.GalleryOpened
		elseif p2 == outcome.PermissionDenied then
			return outcome.PermissionDenied
		else
			return outcome.ReadError
		end
	end,
	log = logCreationEntryResolved
}
