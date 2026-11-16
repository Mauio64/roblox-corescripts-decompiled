local HttpService = game:GetService("HttpService")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/TrustedContacts/Http")
local myHttpRequest = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Networking/myHttpRequest")
require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/TrustedFriendActions/TFActionsEnum")
local FFlagTFPassQRCodeSource = require("@game/CorePackages/Workspace/Packages/_Index/TrustedContacts/TrustedContacts/Flags/FFlagTFPassQRCodeSource")

return function(p2, p3)
	local v5 = string.format("%s/profile-platform-api/v1/profiles/get", Http.Url.APIS_URL)
	local v6 = nil
	local v7 = nil

	if FFlagTFPassQRCodeSource then
		local v9 = if p3 then p3.friendRequestToken or nil else nil
		local v8 = {
			friendRequestToken = v9,
			isQrCodeFlow = p3 and p3.sentFromQrCode and true or nil
		}

		if next(v8) then
			v6 = HttpService:JSONEncode(v8)
		end
	elseif p3 and p3.friendRequestToken and type(p3.friendRequestToken) == "table" then
		v7 = table.concat(p3.friendRequestToken, ",")
	end

	if FFlagTFPassQRCodeSource then
		v7 = v6
	end

	return myHttpRequest(v5, "POST", {
		postBody = {
			profileType = "User",
			profileId = p2,
			components = {
				{ component = "TrustedFriendActions", context = v7 }
			}
		}
	}):andThen(function(p4)
		return p4
			and p4.responseBody
			and p4.responseBody.components
			and p4.responseBody.components.TrustedFriendActions
			and p4.responseBody.components.TrustedFriendActions.action
			or nil
	end)
end
