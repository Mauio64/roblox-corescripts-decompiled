local EventIngestService = game:GetService("EventIngestService")
local SessionService = game:GetService("SessionService")

local eventIngest = require("@luauforge/bundled/bZt").AnalyticsReporters.EventIngest
local module = require("@luauforge/bundled/fIf")
local setGamePlaySession = require("@luauforge/bundled/fwa").SetGamePlaySession
local sessionType = require("@luauforge/bundled/fwa").SessionType

local function logGameDetailsDeepLinkEvent(p2, p3, p4)
	local v5 = {
		universeId = p2,
		pg = "deepLink",
		shareLinkType = p4.linkType,
		shareLinkId = p4.linkId
	}

	local v6 = eventIngest.new(EventIngestService)
	setGamePlaySession(SessionService, sessionType.StructuralIdentifier.GameDetailSource, false)

	module(v6, p3, v5)
end

local function DEPRECATED_logGameDetailsDeepLinkEvent(p2, p3)
	module(eventIngest.new(EventIngestService), p3, { universeId = p2, pg = "deepLink" })
end

if require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableShareLinksInGameDetailEvent then
	return logGameDetailsDeepLinkEvent
end

return DEPRECATED_logGameDetailsDeepLinkEvent
