local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/React")
local useJoinUserInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SocialExperienceJoin").useJoinUserInExperience

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/DataHydration")

local useCTAForRow = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Hooks/useCTAForRow")
require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/Types")

local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/FriendsCommon").Hooks.useGetPresenceByUserId

local v5 = {
	userPresenceType = DataHydration.Presence.PresenceEnums.PresenceType.Offline,
	lastLocation = ""
}

local function RowDataProvider(data)
	local v6 = useGetPresenceByUserId(data.entity.id) or v5

	local userPresenceType = v6.userPresenceType

	local v7 = useJoinUserInExperience(data.entity.id, { presence = v6 })

	local v8 = useCTAForRow(data.ctaResult, data.actionHandlers, data.entity.id, v7)

	return data.createRow({ presence = userPresenceType, primaryCta = v8 })
end

return React.memo(RowDataProvider)
