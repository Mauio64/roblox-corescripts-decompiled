local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local useLocalization = require(TrustedContactsParent.Localization).Hooks.useLocalization
local TrustedConnectionStatus = require(TrustedContacts.Enums).TrustedConnectionStatus

local function useModalTexts(s1: string?) -- line: 14
	-- upvalues: useLocalization (copy), React (copy), TrustedConnectionStatus (copy)
	local v8 = useLocalization({
		addTFHeader = "Feature.Friends.TrustedFriend.Label.AddTrustedFriend",
		addTFBody = "Feature.Friends.Description.DoMoreWithTrustedFriends",
		acceptTFHeader = "Feature.Friends.TrustedFriend.AddBack.Header",
		acceptTFBody = "Feature.Friends.Description.TrustedFriendsRequestModalBody",
		newTFHeader = "Feature.Friends.TrustedFriend.Info.Modal.Header",
		newTFBody = "Feature.Friends.Description.YouCanDoMoreWithTrustedFriends"
	})
	local v9 = React.useMemo(function() -- line: 24
		-- upvalues: TrustedConnectionStatus (copy), v8 (copy)
		return {
			[TrustedConnectionStatus.Friends] = {
				header = v8.addTFHeader,
				description = v8.addTFBody
			},
			[TrustedConnectionStatus.RequestReceived] = {
				header = v8.acceptTFHeader,
				description = v8.acceptTFBody
			},
			[TrustedConnectionStatus.TrustedFriends] = {
				header = v8.newTFHeader,
				description = v8.newTFBody
			}
		}
	end, { v8 })
	local v10 = if not s1 then nil else v9[s1]

	return {
		header = not v10 and "" or v10.header,
		description = not v10 and "" or v10.description
	}
end

return useModalTexts
