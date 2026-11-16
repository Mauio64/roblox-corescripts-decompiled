local TrustedContacts = script:FindFirstAncestor("TrustedContacts")
local parent = TrustedContacts.Parent

local React = require(parent.React)

local getTFAction = require(TrustedContacts.Requests.getTFAction)
require(script.Parent.TFActionsEnum)
local FFlagTFPassQRCodeSource = require(TrustedContacts.Flags.FFlagTFPassQRCodeSource)

local function useTrustedFriendAction(data)
	local userId = data.userId
	local tokens = data.tokens
	local sentFromQrCode

	if FFlagTFPassQRCodeSource then
		sentFromQrCode = data.sentFromQrCode
	else
		sentFromQrCode = nil
	end

	local state, setState = React.useState({ isLoading = true, enum = nil })

	local useEffect = React.useEffect
	local function fn()
		local v = { friendRequestToken = tokens, sentFromQrCode = nil }
		local sentFromQrCode2

		if FFlagTFPassQRCodeSource then
			sentFromQrCode2 = sentFromQrCode
		end

		v.sentFromQrCode = sentFromQrCode2
		getTFAction(userId, v):andThen(function(enum)
			setState({ isLoading = false, enum = enum })
		end):catch(function(_)
			setState({ isLoading = false, enum = nil })
		end)
	end

	local v

	if FFlagTFPassQRCodeSource then
		v = sentFromQrCode
	end

	useEffect(fn, { userId, tokens, v })

	return state
end

return useTrustedFriendAction
