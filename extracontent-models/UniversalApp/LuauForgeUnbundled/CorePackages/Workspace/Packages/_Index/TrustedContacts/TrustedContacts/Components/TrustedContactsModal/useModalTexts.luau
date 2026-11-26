local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Localization").Hooks.useLocalization

local trustedConnectionStatus = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Enums").TrustedConnectionStatus

local function useModalTexts(p2)
	local v5 = useLocalization({
		addTFHeader = "Feature.Friends.TrustedFriend.Label.AddTrustedFriend",
		addTFBody = "Feature.Friends.Description.DoMoreWithTrustedFriends",
		acceptTFHeader = "Feature.Friends.TrustedFriend.AddBack.Header",
		acceptTFBody = "Feature.Friends.Description.TrustedFriendsRequestModalBody",
		newTFHeader = "Feature.Friends.TrustedFriend.Info.Modal.Header",
		newTFBody = "Feature.Friends.Description.YouCanDoMoreWithTrustedFriends"
	})

	local v6 = React.useMemo(function()
		return {
			[trustedConnectionStatus.Friends] = {
				header = v5.addTFHeader,
				description = v5.addTFBody
			},
			[trustedConnectionStatus.RequestReceived] = {
				header = v5.acceptTFHeader,
				description = v5.acceptTFBody
			},
			[trustedConnectionStatus.TrustedFriends] = {
				header = v5.newTFHeader,
				description = v5.newTFBody
			}
		}
	end, { v5 })

	local v7 = if p2 then v6[p2] else nil

	return {
		header = not v7 and "" or v7.header,
		description = not v7 and "" or v7.description
	}
end

return useModalTexts
