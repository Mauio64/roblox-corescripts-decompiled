local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local HttpService = game:GetService("HttpService")
local Http = require(parent.Http)
local myHttpRequest = require(TrustedContacts.Networking.myHttpRequest)
require(TrustedContacts.TrustedFriendActions.TFActionsEnum)
local FFlagTFPassQRCodeSource = require(TrustedContacts.Flags.FFlagTFPassQRCodeSource)

return function(profileId, p)
	local v = string.format("%s/profile-platform-api/v1/profiles/get", Http.Url.APIS_URL)
	local v2 = nil
	local context = nil

	if FFlagTFPassQRCodeSource then
		local friendRequestToken

		if p then
			friendRequestToken = p.friendRequestToken or nil
		end

		local v3 = {
			friendRequestToken = friendRequestToken,
			isQrCodeFlow = p and p.sentFromQrCode and true or nil
		}

		if next(v3) then
			v2 = HttpService:JSONEncode(v3)
		end
	elseif p and p.friendRequestToken and type(p.friendRequestToken) == "table" then
		context = table.concat(p.friendRequestToken, ",")
	end

	if FFlagTFPassQRCodeSource then
		context = v2
	end

	return myHttpRequest(v, "POST", {
		postBody = {
			profileType = "User",
			profileId = profileId,
			components = {
				{ component = "TrustedFriendActions", context = context }
			}
		}
	}):andThen(function(p2)
		return p2
			and p2.responseBody
			and p2.responseBody.components
			and p2.responseBody.components.TrustedFriendActions
			and p2.responseBody.components.TrustedFriendActions.action
			or nil
	end)
end
