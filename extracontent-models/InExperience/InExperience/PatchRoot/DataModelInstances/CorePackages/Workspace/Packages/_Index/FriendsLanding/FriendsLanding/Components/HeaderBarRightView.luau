local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent

local dependencies = require(FriendsLanding.dependencies)
local socialLibraries = dependencies.SocialLibraries
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local EnumScreens = require(FriendsLanding.EnumScreens)
local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)
local AddFriendsIcon = require(FriendsLanding.Components.AddFriendsIcon)
local memoize = dependencies.memoize
local iconButton = uiBlox.App.Button.IconButton
local images = uiBlox.App.ImageSet.Images
local ButtonClickEvents = require(FriendsLanding.FriendsLandingAnalytics.ButtonClickEvents)
local compose = socialLibraries.RoduxTools.compose
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Sources = SocialLuaAnalytics.Analytics.Enums.Sources

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local SharedFlags = require(parent.SharedFlags)
local FFlagConnectionManagementChips = SharedFlags.FFlagConnectionManagementChips

local function fn(p)
	return roact.createElement(iconButton, {
		size = UDim2.fromOffset(0, 0),
		icon = images["icons/common/search"],
		layoutOrder = p.layoutOrder,
		onActivated = p.goToSearchFriendsPage
	})
end

local v = { SHOW_ADDFRIENDS_ICON = 0, SHOW_SEARCHFRIENDS_ICON = 0 }
local set = { [EnumScreens.FriendsLanding] = true, [EnumScreens.SearchFriends] = true }
v.SHOW_ADDFRIENDS_ICON = set

local set2 = {
	[EnumScreens.FriendsLanding] = true,
	[EnumScreens.SearchFriends] = true,
	[EnumScreens.AddFriends] = true
}
v.SHOW_SEARCHFRIENDS_ICON = set2

local extended = roact.PureComponent:extend("HeaderBarRightView")

extended.defaultProps = { layoutOrder = 1, onActivated = nil }

function extended:init()
	self.goToFriendRequestsPage = memoize(function(_, p)
		return function()
			local addFriendsNoFriends = p == 0 and ButtonClickEvents.AddFriendsNoFriends or ButtonClickEvents.AddFriends
			self.props.analytics:buttonClick(addFriendsNoFriends)
			self.props.analytics:navigate(EnumScreens.AddFriends)

			return self.props.navigation.navigate(AppPage.AddFriendsPage)
		end
	end)

	self.goToSearchFriendsPage = memoize(function()
		return function()
			self.props.navigation.navigate(AppPage.UserSearch, {
				shouldShowUserSearchLandingPage = true,
				entryPoint = Sources.FriendsLanding
			})
		end
	end)
end

function extended.render(props)
	local navigation = props.props.navigation
	local v2 = nil
	local addFriendsIcon = nil

	if props.props.addFriendsPageSearchbarEnabled then
		v.SHOW_ADDFRIENDS_ICON[EnumScreens.SearchFriends] = false
	end

	if navigation and navigation.state then
		local routeName = navigation.state.routeName
		v2 = v.SHOW_SEARCHFRIENDS_ICON[routeName]
		addFriendsIcon = v.SHOW_ADDFRIENDS_ICON[routeName]
	end

	local createElement = roact.createElement
	local v3 = { BackgroundTransparency = 1, Size = UDim2.new(0, 72, 0, 36) }
	local v4 = {
		UIListLayout = roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SearchFriendsIcon = v2 and fn({
			goToSearchFriendsPage = props.goToSearchFriendsPage(),
			layoutOrder = 1
		}),
		Padding = roact.createElement("Frame", {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}),
		AddFriendsIcon = 0
	}

	if addFriendsIcon then
		addFriendsIcon = roact.createElement(AddFriendsIcon, {
			onActivated = props.goToFriendRequestsPage(props.props.navigateToLuaAppPages, props.props.totalFriendCount),
			layoutOrder = 3,
			friendRequestCount = props.props.friendRequestCount,
			showTooltip = not FFlagConnectionManagementChips and props.props.totalFriendCount == 0
		})
	end

	v4.AddFriendsIcon = addFriendsIcon
	return createElement("Frame", v3, v4)
end

return compose(FriendsLandingAnalytics.connect(function(analytics)
	return { analytics = analytics }
end), FriendsLandingContext.connect(function(data, _)
	return {
		navigateToLuaAppPages = data.navigateToLuaAppPages,
		friendRequestCount = data.friendRequestCount,
		totalFriendCount = data.totalFriendCount,
		luaAddFriendsPageEnabled = data.luaAddFriendsPageEnabled,
		addFriendsPageSearchbarEnabled = data.addFriendsPageSearchbarEnabled
	}
end))(extended)
