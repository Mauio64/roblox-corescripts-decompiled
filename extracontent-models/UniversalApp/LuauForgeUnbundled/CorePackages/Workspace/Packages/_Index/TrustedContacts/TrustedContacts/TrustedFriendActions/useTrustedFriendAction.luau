local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/React")

local getTFAction = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Requests/getTFAction")
require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/TrustedFriendActions/TFActionsEnum")
local FFlagTFPassQRCodeSource = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTFPassQRCodeSource")

local function useTrustedFriendAction(data)
	local userId = data.userId
	local tokens = data.tokens
	local sentFromQrCode = if FFlagTFPassQRCodeSource then data.sentFromQrCode else nil

	local state, setState = React.useState({ isLoading = true, enum = nil })

	local function fn()
		getTFAction(userId, {
			friendRequestToken = tokens,
			sentFromQrCode = if FFlagTFPassQRCodeSource then sentFromQrCode else nil
		}):andThen(function(p2)
			setState({ isLoading = false, enum = p2 })
		end):catch(function(p2)
			setState({ isLoading = false, enum = nil })
		end)
	end

	React.useEffect(fn, { userId, tokens, if FFlagTFPassQRCodeSource then sentFromQrCode else nil })

	return state
end

return useTrustedFriendAction
