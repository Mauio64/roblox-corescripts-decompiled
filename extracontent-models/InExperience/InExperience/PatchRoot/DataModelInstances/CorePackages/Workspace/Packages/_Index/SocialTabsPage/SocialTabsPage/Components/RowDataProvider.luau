local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local SocialExperienceJoin = require(parent.SocialExperienceJoin)
local useJoinUserInExperience = SocialExperienceJoin.useJoinUserInExperience

local DataHydration = require(parent.DataHydration)

local useCTAForRow = require(SocialTabsPage.Hooks.useCTAForRow)
require(SocialTabsPage.Common.Types)

local FriendsCommon = require(parent.FriendsCommon)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId

local v = {
	userPresenceType = DataHydration.Presence.PresenceEnums.PresenceType.Offline,
	lastLocation = ""
}

local function RowDataProvider(data)
	local presence = useGetPresenceByUserId(data.entity.id) or v

	local userPresenceType = presence.userPresenceType

	local v2 = useJoinUserInExperience(data.entity.id, { presence = presence })

	local primaryCta = useCTAForRow(data.ctaResult, data.actionHandlers, data.entity.id, v2)

	return data.createRow({ presence = userPresenceType, primaryCta = primaryCta })
end

return React.memo(RowDataProvider)
