local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local getTrustedFriendAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/getTrustedFriendAction")

local function useTrustedFriendAction(p2)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(0)

	local v5 = useLocalization({
		addTrustedFriendText = "Feature.Friends.TrustedFriend.Label.AddTrustedFriend",
		acceptTrustedFriendText = "Feature.Friends.TrustedFriend.AcceptTrustedRequest",
		removeTrustedFriendText = "Feature.Friends.TrustedFriend.Action.RemoveTrustedFriend",
		removeTrustedFriendToastText = "Feature.Friends.TrustedFriend.Toast.TrustedFriendRemoved"
	})

	local v6 = React.useCallback(function()
		setState2(function(p3)
			return p3 + 1
		end)
	end, {})

	React.useEffect(function()
		if p2 == "" then
			setState(nil)
			return
		end

		local flag = true
		setState(nil)

		getTrustedFriendAction(p2):andThen(function(p3)
			if flag then
				setState(p3)
			end
		end):catch(function()
			if flag then
				setState(nil)
			end
		end)

		return function()
			flag = false
		end
	end, { p2, state2 })

	local actionType = if state ~= nil then state.actionType else nil
	local v7

	if actionType == "RemoveTrustedConnection" then
		v7 = v5.removeTrustedFriendText
	elseif actionType == "AddIncomingTrustedConnection" then
		v7 = v5.acceptTrustedFriendText
	elseif actionType == "AddTrustedConnection" then
		v7 = v5.addTrustedFriendText
	end

	return {
		action = state,
		actionText = v7,
		toastText = v5.removeTrustedFriendToastText,
		refetch = v6
	}
end

return useTrustedFriendAction
