local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local useDispatch = dependencies.useDispatch
local shareLinksNetworking = dependencies.ShareLinksNetworking
local shareLinksRodux = dependencies.ShareLinksRodux
local TextKeys = require(ContactImporter.Common.TextKeys)
local useLocalization = dependencies.useLocalization
local roduxContacts = dependencies.RoduxContacts
local react = dependencies.React
local promise = dependencies.Promise
local useAnalytics = require(ContactImporter.Analytics.useAnalytics)
local EventNames = require(ContactImporter.Analytics.Enums.EventNames)

return function(p)
	local v = useDispatch()
	local state, setState = react.useState(false)
	local function fn()
		setState(false)
	end
	local v2 = useAnalytics()
	local linkId = nil

	local function fn2()
		v2.fireAnalyticsEvent(EventNames.InviteContact, { offNetworkFriendRequestLinkId = linkId })

		setState(false)
	end

	local v3 = useLocalization({ rootMessage = TextKeys.SMS_DEFAULT_MESSAGE })

	return {
		sendInvite = function()
			setState(true)

			local v4 = v3
			local v5 = p
			return v(shareLinksNetworking.GenerateLink.API({
				linkType = shareLinksRodux.Enums.LinkType.FriendInvite.rawValue()
			})):andThen(function(p2)
				local shortUrl = p2.responseBody.shortUrl

				linkId = p2.responseBody.linkId
				return shortUrl .. "\n\n" .. v4.rootMessage
			end):andThen(function(message)
				return v5.smsProtocol:supportsSMS():andThen(function(p2)
					if p2 then
						return v5.smsProtocol:sendSMS({ address = v5.address, message = message })
					end

					return promise.reject()
				end)
			end):andThen(v(roduxContacts.Actions.RequestSent({ id = p.deviceContactId }))):andThen(fn2):catch(fn)
		end,
		isLoading = state
	}
end
