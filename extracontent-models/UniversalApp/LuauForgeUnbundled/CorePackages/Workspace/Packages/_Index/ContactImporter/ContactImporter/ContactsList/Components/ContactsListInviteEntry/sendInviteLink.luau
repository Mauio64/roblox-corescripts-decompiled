local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local useDispatch = dependencies.useDispatch
local shareLinksNetworking = dependencies.ShareLinksNetworking
local shareLinksRodux = dependencies.ShareLinksRodux
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys")
local useLocalization = dependencies.useLocalization
local roduxContacts = dependencies.RoduxContacts
local react = dependencies.React
local promise = dependencies.Promise
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/useAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Analytics/Enums/EventNames")

return function(p2)
	local v5 = useDispatch()
	local state, setState = react.useState(false)
	local function fn()
		setState(false)
	end
	local v6 = useAnalytics()
	local linkId = nil

	local function fn2()
		v6.fireAnalyticsEvent(EventNames.InviteContact, {
			offNetworkFriendRequestLinkId = linkId
		})

		setState(false)
	end

	local v7 = useLocalization({ rootMessage = TextKeys.SMS_DEFAULT_MESSAGE })

	return {
		sendInvite = function()
			setState(true)

			local v9 = v7
			local v11 = p2
			return v5(shareLinksNetworking.GenerateLink.API({
				linkType = shareLinksRodux.Enums.LinkType.FriendInvite.rawValue()
			})):andThen(function(p3)
				local shortUrl = p3.responseBody.shortUrl

				linkId = p3.responseBody.linkId
				return shortUrl .. "\n\n" .. v9.rootMessage
			end):andThen(function(p3)
				return v11.smsProtocol:supportsSMS():andThen(function(p4)
					if p4 then
						return v11.smsProtocol:sendSMS({
							address = v11.address,
							message = p3
						})
					end

					return promise.reject()
				end)
			end):andThen(v5(roduxContacts.Actions.RequestSent({
				id = p2.deviceContactId
			}))):andThen(fn2):catch(fn)
		end,
		isLoading = state
	}
end
