local PeopleService = script:FindFirstAncestor("PeopleService")
local t1 = {}
local t2 = {}
local GetFFlagPeoplePageEnablePersonSignalStore = require(PeopleService.Flags).GetFFlagPeoplePageEnablePersonSignalStore

local function loadService(p1) -- line: 19
	-- upvalues: GetFFlagPeoplePageEnablePersonSignalStore (copy), t2 (ref)
	local PeopleUtility = nil

	if p1 == "PeopleUtility" then
		PeopleUtility = require(script.Parent.PeopleUtility)
	elseif p1 == "PeopleListStore" then
		PeopleUtility = if not GetFFlagPeoplePageEnablePersonSignalStore() then require(script.Parent.PeopleListStore) else require(script.Parent.PeopleListStore)()
	elseif p1 == "PeopleAnalyticsManager" then
		PeopleUtility = require(script.Parent.Analytics.PeopleAnalyticsManager)
	elseif p1 == "PerUserVoiceVolumeSessionLifecycle" then
		PeopleUtility = require(script.Parent.Analytics.PerUserVoiceVolumeSessionLifecycle)
	elseif p1 == "SettingsHubService" then
		PeopleUtility = require(script.Parent.Integration.SettingsHubService)
	elseif p1 == "PeopleVoiceChatStore" then
		PeopleUtility = require(script.Parent.ButtonStores.PeopleVoiceChatStore)
	elseif p1 == "PeopleBlockStatusStore" then
		PeopleUtility = require(script.Parent.ButtonStores.PeopleBlockStatusStore)
	elseif p1 == "FriendStatusStore" then
		PeopleUtility = require(script.Parent.ButtonStores.FriendStatusStore)
	elseif p1 == "PeopleReportAbuseMenu" then
		PeopleUtility = require(script.Parent.Integration.PeopleReportAbuseMenu)
	elseif p1 == "PeopleBlockingModalManager" then
		PeopleUtility = require(script.Parent.Integration.PeopleBlockingModalManager)
	elseif p1 == "Flags" then
		PeopleUtility = require(script.Parent.Flags)
	elseif p1 == "Constants" then
		PeopleUtility = require(script.Parent.Constants)
	elseif p1 == "FocusNavigationService" then
		PeopleUtility = require(script.Parent.FocusNavigationService)
	else
		error("Unknown service: " .. p1)
	end

	t2[p1] = PeopleUtility

	return PeopleUtility
end

function t1.register(p2, p3) -- line: 60
	-- upvalues: t2 (ref)
	t2[p2] = p3
end
function t1.get(p4) -- line: 64
	-- upvalues: t2 (ref), loadService (copy)
	if not t2[p4] then
		loadService(p4)
	end

	return t2[p4]
end
function t1.has(p5) -- line: 71
	-- upvalues: t2 (ref)
	return t2[p5] ~= nil
end
function t1.clear() -- line: 75
	-- upvalues: t2 (ref)
	t2 = {}
end

return t1
