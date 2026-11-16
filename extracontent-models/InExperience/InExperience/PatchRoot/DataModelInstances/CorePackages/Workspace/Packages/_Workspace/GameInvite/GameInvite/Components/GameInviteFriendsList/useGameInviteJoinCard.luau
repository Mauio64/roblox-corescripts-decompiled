local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent
local React = require(parent.React)
local DataHydration = require(parent.DataHydration)

local GameInviteLeaveServerConfirmation = require(script.Parent.GameInviteLeaveServerConfirmation)
local joinFriendFromExperience = require(script.Parent.joinFriendFromExperience)
local isInOtherServerOfThisExperience = require(GameInvite.utils.isInOtherServerOfThisExperience)

local v = { skipFetch = true }

local function getInExperienceGameJoinCard() -- 1 equivalent call inferred from this helper
	local GameJoinCard = require(parent.GameJoinCard)
	return GameJoinCard.getInExperienceGameJoinCard()
end

local function useGameInviteJoinCard(p: string, p2: string)
	local state, setState = React.useState(nil)

	local open = React.useCallback(function(userId: string)
		setState({
			userId = userId,
			isLeavingServer = isInOtherServerOfThisExperience(
				DataHydration.Presence.PresenceStore.get().GetPresenceByUserId(userId, v).data(false),
				p,
				p2
			)
		})
	end, { p, p2 })

	local close = React.useCallback(function()
		setState(nil)
	end, {})
	local cardComponent

	if state ~= nil then
		if state.isLeavingServer then
			cardComponent = GameInviteLeaveServerConfirmation
		else
			cardComponent = getInExperienceGameJoinCard() -- inferred equivalent call
		end
	end

	local userId

	if state then
		userId = state.userId
	end

	return {
		userId = userId,
		open = open,
		close = close,
		join = joinFriendFromExperience,
		cardComponent = cardComponent
	}
end

return useGameInviteJoinCard
