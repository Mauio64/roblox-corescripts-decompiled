local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/DataHydration")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/ReactFocusNavigation")
local useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsCommon").Hooks.useGetPresenceByUserId

local isInThisServer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/isInThisServer")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/joinFriendFromExperience")

local navigateBack = FocusNavigationUtils.FocusNavigationEventNameEnum.NavigateBack

local inGame = DataHydration.Presence.PresenceEnums.PresenceType.InGame

local v5 = { skipFetch = true }

local function getJoinTarget(userId, data)
	if
		data == nil
		or data.userPresenceType ~= inGame
		or data.universeId == ""
		or isInThisServer(data, game.JobId)
	then
		return nil
	end

	return {
		userId = userId,
		placeId = data.placeId,
		rootPlaceId = data.rootPlaceId,
		universeId = data.universeId
	}
end

local function useGameInviteLeaveServerConfirmationViewModel(data)
	local userId = data.userId
	local onJoin = data.onJoin
	local onClose = data.onClose

	local v6 = useGetPresenceByUserId(userId, v5)
	local v7 = React.useMemo(function()
		return getJoinTarget(userId, v6)
	end, { userId, v6 })

	local ref = React.useRef(false)
	local v8 = React.useCallback(function(p2): nil
		if p2 and v7 ~= nil then
			if ref.current then
				return nil
			end

			ref.current = true
			onJoin(v7)
		end

		onClose()
		return nil
	end, { v7, onJoin, onClose })

	return {
		closeCallback = v8,
		titleKey = "Notifications.ToastNotifications.Title.LeavingServer",
		bodyKey = "Notifications.ToastNotifications.Label.LeaveServerConfirmation",
		focusEventHandlers = React.useMemo(function()
			return {
				[navigateBack] = {
					handler = InputHandlers.onRelease(function(object)
						v8(false)
						object:cancel()
					end)
				}
			}
		end, { v8 })
	}
end

return useGameInviteLeaveServerConfirmationViewModel
