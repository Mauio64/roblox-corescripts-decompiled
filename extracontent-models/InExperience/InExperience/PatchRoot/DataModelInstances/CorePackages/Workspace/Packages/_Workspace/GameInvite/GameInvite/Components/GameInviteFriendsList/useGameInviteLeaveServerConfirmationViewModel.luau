local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent

local React = require(parent.React)
local DataHydration = require(parent.DataHydration)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
require(parent.ReactFocusNavigation)
local FriendsCommon = require(parent.FriendsCommon)
local useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId

local isInThisServer = require(GameInvite.utils.isInThisServer)
require(script.Parent.joinFriendFromExperience)

local NavigateBack = FocusNavigationUtils.FocusNavigationEventNameEnum.NavigateBack

local InGame = DataHydration.Presence.PresenceEnums.PresenceType.InGame

local v = { skipFetch = true }

local function getJoinTarget(userId: string, data)
	if data == nil or data.userPresenceType ~= InGame or data.universeId == "" or isInThisServer(data, game.JobId) then
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

	local v2 = useGetPresenceByUserId(userId, v)
	local v3 = React.useMemo(function()
		return getJoinTarget(userId, v2)
	end, { userId, v2 })

	local ref = React.useRef(false)
	local closeCallback = React.useCallback(function(flag: boolean): nil
		if flag and v3 ~= nil then
			if ref.current then
				return nil
			end

			ref.current = true
			onJoin(v3)
		end

		onClose()
		return nil
	end, { v3, onJoin, onClose })

	return {
		closeCallback = closeCallback,
		titleKey = "Notifications.ToastNotifications.Title.LeavingServer",
		bodyKey = "Notifications.ToastNotifications.Label.LeaveServerConfirmation",
		focusEventHandlers = React.useMemo(function()
			return {
				[NavigateBack] = {
					handler = InputHandlers.onRelease(function(object)
						closeCallback(false)
						object:cancel()
					end)
				}
			}
		end, { closeCallback })
	}
end

return useGameInviteLeaveServerConfirmationViewModel
