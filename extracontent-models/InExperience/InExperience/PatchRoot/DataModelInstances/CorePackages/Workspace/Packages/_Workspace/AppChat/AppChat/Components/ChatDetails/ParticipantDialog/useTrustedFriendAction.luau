local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local getTrustedFriendAction = require(script.Parent.getTrustedFriendAction)

local function useTrustedFriendAction(s1: string) -- line: 23
	-- upvalues: React (copy), useLocalization (copy), getTrustedFriendAction (copy)
	local v7, v8 = React.useState(nil)
	local v9, v10 = React.useState(0)
	local v11 = useLocalization({
		addTrustedFriendText = "Feature.Friends.TrustedFriend.Label.AddTrustedFriend",
		acceptTrustedFriendText = "Feature.Friends.TrustedFriend.AcceptTrustedRequest",
		removeTrustedFriendText = "Feature.Friends.TrustedFriend.Action.RemoveTrustedFriend",
		removeTrustedFriendToastText = "Feature.Friends.TrustedFriend.Toast.TrustedFriendRemoved"
	})
	local v12 = React.useCallback(function() -- line: 35
		-- upvalues: v10 (copy)
		v10(function(p1) -- line: 36
			return p1 + 1
		end)
	end, {})

	React.useEffect(function() -- line: 41
		-- upvalues: s1 (copy), v8 (copy), getTrustedFriendAction (copy)
		if s1 == "" then
			v8(nil)

			return
		end

		local u15 = true

		v8(nil)
		getTrustedFriendAction(s1):andThen(function(p2) -- line: 54
			-- upvalues: u15 (ref), v8 (copy)
			if u15 then
				v8(p2)
			end
		end):catch(function() -- line: 59
			-- upvalues: u15 (ref), v8 (copy)
			if u15 then
				v8(nil)
			end
		end)

		return function() -- line: 65
			-- upvalues: u15 (ref)
			u15 = false
		end
	end, {
		s1,
		v9
	})

	local v13 = if v7 == nil then nil else v7.actionType
	local v14 = if v13 ~= "RemoveTrustedConnection" then if v13 ~= "AddIncomingTrustedConnection" then if v13 ~= "AddTrustedConnection" then nil else v11.addTrustedFriendText else v11.acceptTrustedFriendText else v11.removeTrustedFriendText

	return {
		action = v7,
		actionText = v14,
		toastText = v11.removeTrustedFriendToastText,
		refetch = v12
	}
end

return useTrustedFriendAction
