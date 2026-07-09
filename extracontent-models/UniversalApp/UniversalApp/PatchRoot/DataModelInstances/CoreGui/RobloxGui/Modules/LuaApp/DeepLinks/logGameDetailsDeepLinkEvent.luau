local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local EventIngestService = game:GetService("EventIngestService")
local SessionService = game:GetService("SessionService")
local EventIngest = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventIngest
local gameDetailReferral = require(Modules.LuaApp.Analytics.Events.Games.gameDetailReferral)
local SetGamePlaySession = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SetGamePlaySession
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType

local function logGameDetailsDeepLinkEvent(s1: string, s2: string, t1: {[any]: any}) -- line: 26
	-- upvalues: EventIngest (copy), EventIngestService (copy), SetGamePlaySession (copy), SessionService (copy), SessionType (copy), gameDetailReferral (copy)
	local t2 = {
		pg = "deepLink",
		universeId = s1,
		shareLinkType = t1.linkType,
		shareLinkId = t1.linkId
	}
	local v15 = EventIngest.new(EventIngestService)

	SetGamePlaySession(SessionService, SessionType.StructuralIdentifier.GameDetailSource, false)
	gameDetailReferral(v15, s2, t2)
end
local function DEPRECATED_logGameDetailsDeepLinkEvent(s3: string, s4: string) -- line: 44
	-- upvalues: EventIngest (copy), EventIngestService (copy), gameDetailReferral (copy)
	local t3 = {
		pg = "deepLink",
		universeId = s3
	}
	local v19 = EventIngest.new(EventIngestService)

	gameDetailReferral(v19, s4, t3)
end

if require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableShareLinksInGameDetailEvent then
	return logGameDetailsDeepLinkEvent
end

return DEPRECATED_logGameDetailsDeepLinkEvent
