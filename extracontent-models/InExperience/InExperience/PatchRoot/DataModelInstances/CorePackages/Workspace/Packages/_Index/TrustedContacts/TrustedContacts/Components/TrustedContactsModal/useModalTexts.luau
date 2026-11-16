local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Enums = require(TrustedContacts.Enums)
local TrustedConnectionStatus = Enums.TrustedConnectionStatus

local function useModalTexts(p: string?)
	local v = useLocalization({
		addTFHeader = "Feature.Friends.TrustedFriend.Label.AddTrustedFriend",
		addTFBody = "Feature.Friends.Description.DoMoreWithTrustedFriends",
		acceptTFHeader = "Feature.Friends.TrustedFriend.AddBack.Header",
		acceptTFBody = "Feature.Friends.Description.TrustedFriendsRequestModalBody",
		newTFHeader = "Feature.Friends.TrustedFriend.Info.Modal.Header",
		newTFBody = "Feature.Friends.Description.YouCanDoMoreWithTrustedFriends"
	})

	local v2 = React.useMemo(function()
		return {
			[TrustedConnectionStatus.Friends] = {
				header = v.addTFHeader,
				description = v.addTFBody
			},
			[TrustedConnectionStatus.RequestReceived] = {
				header = v.acceptTFHeader,
				description = v.acceptTFBody
			},
			[TrustedConnectionStatus.TrustedFriends] = {
				header = v.newTFHeader,
				description = v.newTFBody
			}
		}
	end, { v })
	local v3

	if p then
		v3 = v2[p]
	end

	return {
		header = not v3 and "" or v3.header,
		description = not v3 and "" or v3.description
	}
end

return useModalTexts
