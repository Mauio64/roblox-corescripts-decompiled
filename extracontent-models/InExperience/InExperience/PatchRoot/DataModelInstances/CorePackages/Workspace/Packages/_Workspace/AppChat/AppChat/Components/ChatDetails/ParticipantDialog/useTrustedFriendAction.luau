local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local getTrustedFriendAction = require(script.Parent.getTrustedFriendAction)

local function useTrustedFriendAction(p: string)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(0)

	local v = useLocalization({
		addTrustedFriendText = "Feature.Friends.TrustedFriend.Label.AddTrustedFriend",
		acceptTrustedFriendText = "Feature.Friends.TrustedFriend.AcceptTrustedRequest",
		removeTrustedFriendText = "Feature.Friends.TrustedFriend.Action.RemoveTrustedFriend",
		removeTrustedFriendToastText = "Feature.Friends.TrustedFriend.Toast.TrustedFriendRemoved"
	})

	local refetch = React.useCallback(function()
		setState2(function(p2)
			return p2 + 1
		end)
	end, {})

	React.useEffect(function()
		if p == "" then
			setState(nil)
			return
		end

		local flag = true
		setState(nil)

		getTrustedFriendAction(p):andThen(function(p2)
			if flag then
				setState(p2)
			end
		end):catch(function()
			if flag then
				setState(nil)
			end
		end)

		return function()
			flag = false
		end
	end, { p, state2 })
	local actionType

	if state ~= nil then
		actionType = state.actionType
	end

	local actionText

	if actionType == "RemoveTrustedConnection" then
		actionText = v.removeTrustedFriendText
	elseif actionType == "AddIncomingTrustedConnection" then
		actionText = v.acceptTrustedFriendText
	elseif actionType == "AddTrustedConnection" then
		actionText = v.addTrustedFriendText
	end

	return {
		action = state,
		actionText = actionText,
		toastText = v.removeTrustedFriendToastText,
		refetch = refetch
	}
end

return useTrustedFriendAction
