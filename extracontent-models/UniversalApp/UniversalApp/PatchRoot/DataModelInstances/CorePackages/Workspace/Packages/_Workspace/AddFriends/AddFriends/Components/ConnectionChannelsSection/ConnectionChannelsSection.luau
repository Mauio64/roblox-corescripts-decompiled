local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local Roact = require(AddFriendsParent.Roact)
local Images = require(AddFriendsParent.UIBlox).App.ImageSet.Images
local AddFriendsGenericBanner = require(AddFriends.Components.AddFriendsGenericBanner)
local useFireAnalyticsEvent = require(AddFriends.Analytics.useFireAnalyticsEvent)
local ConnectionChannelsCarousel = require(script.Parent.ConnectionChannelsCarousel)
local ConnectionChannelsHeader = require(script.Parent.ConnectionChannelsHeader)
local ConnectionChannelsTile = require(script.Parent.ConnectionChannelsTile)
local ContactImporterChannel = require(script.Parent.ContactImporterChannel)
local QRCodeChannel = require(script.Parent.QRCodeChannel)
local SchoolChannel = require(script.Parent.SchoolChannel)
local FFlagAddFriendsBannersNewUI_IXP = require(AddFriendsParent.SharedFlags).FFlagAddFriendsBannersNewUI_IXP
local FFlagAFPConnectionsChannelsHeader = require(AddFriendsParent.SharedFlags).FFlagAFPConnectionsChannelsHeader
local FFlagEnableSchoolEntry = require(AddFriendsParent.SharedFlags).FFlagEnableSchoolEntry
local useAppPolicy = require(AddFriendsParent.UniversalAppPolicy).useAppPolicy

require(script.Parent.Types)

local t1 = {
	{
		component = ContactImporterChannel
	},
	{
		component = QRCodeChannel
	}
}

if FFlagEnableSchoolEntry then
	table.insert(t1, {
		component = SchoolChannel
	})
end

local function ConnectionChannelsSection(t2: {[any]: any}) -- line: 58
	-- upvalues: useFireAnalyticsEvent (copy), useAppPolicy (copy), FFlagAddFriendsBannersNewUI_IXP (copy), React (copy), ConnectionChannelsTile (copy), ConnectionChannelsCarousel (copy), t1 (copy), FFlagAFPConnectionsChannelsHeader (copy), ConnectionChannelsHeader (copy), AddFriendsGenericBanner (copy), Images (copy), Roact (copy), ContactImporterChannel (copy), QRCodeChannel (copy)
	local v21 = useFireAnalyticsEvent()
	local v22 = useAppPolicy(function(p1) -- line: 61
		return p1.getEnableProfileQrCode()
	end)

	if FFlagAddFriendsBannersNewUI_IXP then
		local layoutOrder = t2.layoutOrder
		local navigateToLuaAppPages = t2.navigateToLuaAppPages
		local v25 = React.useCallback(function(t3: {[any]: any}, n1: number, uDim2: UDim2) -- line: 70
			-- upvalues: React (copy), ConnectionChannelsTile (copy), v21 (copy), t2 (copy)
			return React.createElement(t3.component, {
				component = ConnectionChannelsTile,
				componentUIProps = {
					layoutOrder = n1,
					itemSize = uDim2
				},
				fireAnalyticsEvent = v21,
				navigateToLuaAppPages = t2.navigateToLuaAppPages
			}), "Item"
		end, {
			v21,
			navigateToLuaAppPages
		})

		return React.createElement(ConnectionChannelsCarousel, {
			contextualInfoHeight = 25,
			layoutOrder = layoutOrder,
			items = t1,
			renderItem = v25,
			headerComponent = if not FFlagAFPConnectionsChannelsHeader or not v22 then nil else React.createElement(ConnectionChannelsHeader)
		})
	end

	local v26 = t2.layoutOrder or 1
	local v27 = React.useCallback(function(p2) -- line: 98
		-- upvalues: React (copy), AddFriendsGenericBanner (copy), Images (copy)
		return React.createElement(AddFriendsGenericBanner, {
			maxWidth = 640,
			bannerIcon = Images[p2.icon],
			bannerTitle = p2.title,
			bannerText = p2.text,
			onActivated = p2.onActivated,
			onBannerMounted = p2.onMounted,
			layoutOrder = p2.componentUIProps.layoutOrder
		})
	end, {})

	return Roact.createFragment({
		ContactImporterBanner = React.createElement(ContactImporterChannel, {
			component = v27,
			componentUIProps = {
				layoutOrder = v26
			},
			fireAnalyticsEvent = v21
		}),
		QRCodeBanner = React.createElement(QRCodeChannel, {
			component = v27,
			componentUIProps = {
				layoutOrder = v26 + 1
			},
			fireAnalyticsEvent = v21,
			navigateToLuaAppPages = t2.navigateToLuaAppPages
		})
	})
end

return ConnectionChannelsSection
