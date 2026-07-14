local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local TrustedContactsParent = TrustedContacts.Parent
local React = require(TrustedContactsParent.React)
local getTFAction = require(TrustedContacts.Requests.getTFAction)

require(script.Parent.TFActionsEnum)

local FFlagTFPassQRCodeSource = require(TrustedContacts.Flags.FFlagTFPassQRCodeSource)

local function useTrustedFriendAction(t1: {[any]: any}) -- line: 23
	-- upvalues: FFlagTFPassQRCodeSource (copy), React (copy), getTFAction (copy)
	local userId = t1.userId
	local tokens = t1.tokens
	local v10 = if not FFlagTFPassQRCodeSource then nil else t1.sentFromQrCode
	local v11, v12 = React.useState({
		isLoading = true,
		enum = nil
	})

	React.useEffect(function() -- line: 33
		-- upvalues: getTFAction (copy), userId (copy), tokens (copy), FFlagTFPassQRCodeSource (copy), v10 (copy), v12 (copy)
		getTFAction(userId, {
			friendRequestToken = tokens,
			sentFromQrCode = if not FFlagTFPassQRCodeSource then nil else v10
		}):andThen(function(p1) -- line: 38
			-- upvalues: v12 (copy)
			v12({
				isLoading = false,
				enum = p1
			})
		end):catch(function(_) -- line: 44
			-- upvalues: v12 (copy)
			v12({
				isLoading = false,
				enum = nil
			})
		end)
	end, {
		userId,
		tokens,
		if not FFlagTFPassQRCodeSource then nil else v10
	})

	return v11
end

return useTrustedFriendAction
