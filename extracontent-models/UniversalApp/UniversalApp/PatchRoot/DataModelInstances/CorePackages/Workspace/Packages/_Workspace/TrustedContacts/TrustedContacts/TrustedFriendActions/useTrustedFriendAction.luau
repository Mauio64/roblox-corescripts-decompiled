local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local getTFAction = require(TrustedContacts.Requests.getTFAction)

require(script.Parent.TFActionsEnum)

local function useTrustedFriendAction(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), getTFAction (copy)
	local userId = t1.userId
	local tokens = t1.tokens
	local v9, v10 = React.useState({
		isLoading = true,
		enum = nil
	})

	React.useEffect(function() -- line: 30
		-- upvalues: getTFAction (copy), userId (copy), tokens (copy), v10 (copy)
		getTFAction(userId, {
			friendRequestToken = tokens
		}):andThen(function(p1) -- line: 32
			-- upvalues: v10 (copy)
			v10({
				isLoading = false,
				enum = p1
			})
		end):catch(function(_) -- line: 38
			-- upvalues: v10 (copy)
			v10({
				isLoading = false,
				enum = nil
			})
		end)
	end, {
		userId,
		tokens
	})

	return v9
end

return useTrustedFriendAction
