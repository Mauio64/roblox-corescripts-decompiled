local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local useDispatch = dependencies.useDispatch
local ShareLinksNetworking = dependencies.ShareLinksNetworking
local ShareLinksRodux = dependencies.ShareLinksRodux
local TextKeys = require(ContactImporter.Common.TextKeys)
local useLocalization = dependencies.useLocalization
local RoduxContacts = dependencies.RoduxContacts
local React = dependencies.React
local Promise = dependencies.Promise
local useAnalytics = require(ContactImporter.Analytics.useAnalytics)
local EventNames = require(ContactImporter.Analytics.Enums.EventNames)

return function(t1: {[any]: any}) -- line: 32
	-- upvalues: useDispatch (copy), React (copy), useAnalytics (copy), EventNames (copy), useLocalization (copy), TextKeys (copy), ShareLinksNetworking (copy), ShareLinksRodux (copy), Promise (copy), RoduxContacts (copy)
	local v15 = useDispatch()
	local v16, v17 = React.useState(false)

	local function v18() -- line: 35
		-- upvalues: v17 (copy)
		v17(false)
	end

	local v19 = useAnalytics()
	local linkId = nil

	local function v21() -- line: 41
		-- upvalues: v19 (copy), EventNames (copy), linkId (ref), v17 (copy)
		v19.fireAnalyticsEvent(EventNames.InviteContact, {
			offNetworkFriendRequestLinkId = linkId
		})
		v17(false)
	end

	local v22 = useLocalization({
		rootMessage = TextKeys.SMS_DEFAULT_MESSAGE
	})

	return {
		sendInvite = function() -- line: 61
			-- upvalues: v17 (copy), v15 (copy), ShareLinksNetworking (copy), ShareLinksRodux (copy), v22 (copy), linkId (ref), t1 (copy), Promise (copy), RoduxContacts (copy), v21 (copy), v18 (copy)
			v17(true)

			local v25 = v15(ShareLinksNetworking.GenerateLink.API({
				linkType = ShareLinksRodux.Enums.LinkType.FriendInvite.rawValue()
			}))
			local v26 = v22
			local v27 = v25:andThen(function(t2: {[any]: any}) -- line: 52
				-- upvalues: linkId (ref), v26 (copy)
				local shortUrl = t2.responseBody.shortUrl

				linkId = t2.responseBody.linkId

				return shortUrl .. "\n\n" .. v26.rootMessage
			end)
			local v28 = t1

			return v27:andThen(function(p1) -- line: 21
				-- upvalues: v28 (copy), Promise (copy)
				return v28.smsProtocol:supportsSMS():andThen(function(p2) -- line: 22
					-- upvalues: v28 (copy), p1 (copy), Promise (copy)
					if p2 then
						return v28.smsProtocol:sendSMS({
							address = v28.address,
							message = p1
						})
					end

					return Promise.reject()
				end)
			end):andThen(v15(RoduxContacts.Actions.RequestSent({
				id = t1.deviceContactId
			}))):andThen(v21):catch(v18)
		end,
		isLoading = v16
	}
end
