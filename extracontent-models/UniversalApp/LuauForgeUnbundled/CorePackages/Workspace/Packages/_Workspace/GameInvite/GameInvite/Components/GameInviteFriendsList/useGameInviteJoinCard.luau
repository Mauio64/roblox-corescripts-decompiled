local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/DataHydration")

local GameInviteLeaveServerConfirmation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/GameInviteLeaveServerConfirmation")
local joinFriendFromExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/joinFriendFromExperience")
local isInOtherServerOfThisExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/isInOtherServerOfThisExperience")

local v5 = { skipFetch = true }

local function getInExperienceGameJoinCard()
	return require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameJoinCard").getInExperienceGameJoinCard()
end

local function useGameInviteJoinCard(p2, p3)
	local state, setState = React.useState(nil)

	local v6 = React.useCallback(function(p4)
		setState({
			userId = p4,
			isLeavingServer = isInOtherServerOfThisExperience(
				DataHydration.Presence.PresenceStore.get().GetPresenceByUserId(p4, v5).data(false),
				p2,
				p3
			)
		})
	end, { p2, p3 })

	local v7 = React.useCallback(function()
		setState(nil)
	end, {})
	local v8

	if state ~= nil then
		if state.isLeavingServer then
			v8 = GameInviteLeaveServerConfirmation
		else
			v8 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameJoinCard").getInExperienceGameJoinCard()
		end
	end

	local v10 = if state then state.userId else nil
	return {
		userId = v10,
		open = v6,
		close = v7,
		join = joinFriendFromExperience,
		cardComponent = v8
	}
end

return useGameInviteJoinCard
