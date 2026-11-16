local Players = game:GetService("Players")

local parent = script.Parent
local parent2 = parent.Parent

local UserProfiles = require(parent2.UserProfiles)

local CoreScriptsRoactCommon = require(parent2.CoreScriptsRoactCommon)
local sortTableByValue = CoreScriptsRoactCommon.Utilities.sortTableByValue

require(parent.createPersonStore)

local Flags = require(parent.Flags)
local GetFFlagPeoplePageEnablePersonSignalStore = Flags.GetFFlagPeoplePageEnablePersonSignalStore
local SharedFlags = require(parent2.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile

local _, result = pcall(function()
	return game:GetService("PlatformFriendsService")
end)

local UserProfileStore = UserProfiles.Stores.UserProfileStore

local function getInExperienceCombinedName(p)
	local getInExperienceCombinedNames = {}

	for k, v in UserProfileStore.get().fetchNamesByUserIds(p)(false).data do
		getInExperienceCombinedNames[p[k]] = v.names.getInExperienceCombinedName
	end

	return getInExperienceCombinedNames
end

local function getPlatformData(p)
	local platformData = {}

	for k, v in UserProfileStore.get().fetchNamesByUserIds(p, nil, FFlagUserProfilePlatformProfile)(false).data do
		platformData[p[k]] = {
			platformName = v.names.getPlatformName,
			platformProfileId = v.getPlatformProfileId
		}
	end

	return platformData
end

local function canShowPlatformProfile(p: string)
	return game:GetEngineFeature("PlatformFriendsService")
		and game:GetEngineFeature("PlatformFriendsProfile")
		and result
		and result:IsProfileEnabled()
		and p
		and p ~= ""
end

local function showPlatformProfile(p: string)
	if
		game:GetEngineFeature("PlatformFriendsService")
		and game:GetEngineFeature("PlatformFriendsProfile")
		and result
		and result:IsProfileEnabled()
		and p
		and p ~= ""
	then
		result:ShowProfile(p)
	end
end

local function comparePeople(p, p2): boolean -- 1 equivalent call inferred from this helper
	local localPlayer = Players.LocalPlayer

	local name = p.Name:lower()
	local name2 = p2.Name:lower()

	return (p == localPlayer and " " or name) < (p2 == localPlayer and " " or name2)
end

local function sortPeople(list)
	table.sort(list, comparePeople)
	return list
end

local fn = GetFFlagPeoplePageEnablePersonSignalStore() and function(p)
	local v = sortTableByValue(p, function(p2, p3)
		return comparePeople(p2.value.getPerson(), p3.value.getPerson()) -- inferred equivalent call
	end)

	for k, v2 in v do
		local v3 = p[v2.key]

		if v3 then
			v3.setOrder(k)
		end
	end
end or nil

local PeopleUtility = {
	getInExperienceCombinedName = getInExperienceCombinedName,
	getPlatformData = getPlatformData,
	canShowPlatformProfile = canShowPlatformProfile,
	showPlatformProfile = showPlatformProfile,
	comparePeople = comparePeople,
	sortPeople = sortPeople,
	sortPersonStores = 0,
	showPersonButtons = 0
}

if not GetFFlagPeoplePageEnablePersonSignalStore() then
	fn = nil
end

PeopleUtility.sortPersonStores = fn

function PeopleUtility.showPersonButtons(p, p2: number?): boolean
	local localPlayer = Players.LocalPlayer
	return p ~= nil and localPlayer ~= nil and p ~= localPlayer and p2 > 0 and localPlayer.UserId > 0
end
return PeopleUtility
