local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local HttpService = game:GetService("HttpService")
local Http = require(TrustedContactsParent.Http)
local myHttpRequest = require(TrustedContacts.Networking.myHttpRequest)

require(TrustedContacts.TrustedFriendActions.TFActionsEnum)

local FFlagTFPassQRCodeSource = require(TrustedContacts.Flags.FFlagTFPassQRCodeSource)

return function(p1, t1: {[any]: any}) -- line: 17
	-- upvalues: Http (copy), FFlagTFPassQRCodeSource (copy), HttpService (copy), myHttpRequest (copy)
	local v9 = string.format("%s/profile-platform-api/v1/profiles/get", Http.Url.APIS_URL)
	local json = nil
	local v11 = nil

	if FFlagTFPassQRCodeSource then
		local t2 = {
			friendRequestToken = t1 and t1.friendRequestToken or nil,
			isQrCodeFlow = t1 and not not t1.sentFromQrCode or nil
		}

		if next(t2) then
			json = HttpService:JSONEncode(t2)
		end
	else
		v11 = if not t1 or (not t1.friendRequestToken or type(t1.friendRequestToken) ~= "table") then nil else table.concat(t1.friendRequestToken, ",")
	end

	local t3 = {
		postBody = {
			profileType = "User",
			profileId = p1,
			components = {{
				component = "TrustedFriendActions",
				context = if not FFlagTFPassQRCodeSource then v11 else json
			}}
		}
	}

	return myHttpRequest(v9, "POST", t3):andThen(function(p2) -- line: 50
		return p2 and (not not p2.responseBody and (not not p2.responseBody.components and (not not p2.responseBody.components.TrustedFriendActions and p2.responseBody.components.TrustedFriendActions.action))) or nil
	end)
end
