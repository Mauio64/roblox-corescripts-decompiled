local PeopleService = script:FindFirstAncestor("PeopleService")

local v = {}

local Flags = require(PeopleService.Flags)
local GetFFlagPeoplePageEnablePersonSignalStore = Flags.GetFFlagPeoplePageEnablePersonSignalStore

local function loadService(p)
	local service = nil

	if p == "PeopleUtility" then
		service = require(script.Parent.PeopleUtility)
	elseif p == "PeopleListStore" then
		if GetFFlagPeoplePageEnablePersonSignalStore() then
			local PeopleListStore = require(script.Parent.PeopleListStore)
			service = PeopleListStore()
		else
			service = require(script.Parent.PeopleListStore)
		end
	elseif p == "PeopleAnalyticsManager" then
		service = require(script.Parent.Analytics.PeopleAnalyticsManager)
	elseif p == "PerUserVoiceVolumeSessionLifecycle" then
		service = require(script.Parent.Analytics.PerUserVoiceVolumeSessionLifecycle)
	elseif p == "SettingsHubService" then
		service = require(script.Parent.Integration.SettingsHubService)
	elseif p == "PeopleVoiceChatStore" then
		service = require(script.Parent.ButtonStores.PeopleVoiceChatStore)
	elseif p == "PeopleBlockStatusStore" then
		service = require(script.Parent.ButtonStores.PeopleBlockStatusStore)
	elseif p == "FriendStatusStore" then
		service = require(script.Parent.ButtonStores.FriendStatusStore)
	elseif p == "PeopleReportAbuseMenu" then
		service = require(script.Parent.Integration.PeopleReportAbuseMenu)
	elseif p == "PeopleBlockingModalManager" then
		service = require(script.Parent.Integration.PeopleBlockingModalManager)
	elseif p == "Flags" then
		service = require(script.Parent.Flags)
	elseif p == "Constants" then
		service = require(script.Parent.Constants)
	elseif p == "FocusNavigationService" then
		service = require(script.Parent.FocusNavigationService)
	else
		error("Unknown service: " .. p)
	end

	v[p] = service
	return service
end

local ServiceLocator = {}

function ServiceLocator.register(p, p2)
	v[p] = p2
end

function ServiceLocator.get(p)
	if not v[p] then
		loadService(p)
	end

	return v[p]
end

function ServiceLocator.has(p): boolean
	return v[p] ~= nil
end

function ServiceLocator.clear()
	v = {}
end

return ServiceLocator
