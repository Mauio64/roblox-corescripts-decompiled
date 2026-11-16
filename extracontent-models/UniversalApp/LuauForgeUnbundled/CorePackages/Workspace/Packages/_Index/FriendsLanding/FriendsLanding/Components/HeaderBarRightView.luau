local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local socialLibraries = dependencies.SocialLibraries
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/EnumScreens")
local FriendsLandingAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/AddFriendsIcon")
local memoize = dependencies.memoize
local iconButton = uiBlox.App.Button.IconButton
local images = uiBlox.App.ImageSet.Images
local ButtonClickEvents = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/ButtonClickEvents")
local compose = socialLibraries.RoduxTools.compose
local sources = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SocialLuaAnalytics").Analytics.Enums.Sources

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppEnums").AppPage

local fFlagConnectionManagementChips = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagConnectionManagementChips

local function fn(p2)
	return roact.createElement(iconButton, {
		size = UDim2.fromOffset(0, 0),
		icon = images["icons/common/search"],
		layoutOrder = p2.layoutOrder,
		onActivated = p2.goToSearchFriendsPage
	})
end

local v5 = { SHOW_ADDFRIENDS_ICON = 0, SHOW_SEARCHFRIENDS_ICON = 0 }
local set = { [EnumScreens.FriendsLanding] = true, [EnumScreens.SearchFriends] = true }
v5.SHOW_ADDFRIENDS_ICON = set

local set2 = {
	[EnumScreens.FriendsLanding] = true,
	[EnumScreens.SearchFriends] = true,
	[EnumScreens.AddFriends] = true
}
v5.SHOW_SEARCHFRIENDS_ICON = set2

local extended = roact.PureComponent:extend("HeaderBarRightView")

extended.defaultProps = { layoutOrder = 1, onActivated = nil }

function extended:init()
	self.goToFriendRequestsPage = memoize(function(p3, p4)
		return function()
			local addFriendsNoFriends = p4 == 0 and ButtonClickEvents.AddFriendsNoFriends or ButtonClickEvents.AddFriends
			self.props.analytics:buttonClick(addFriendsNoFriends)
			self.props.analytics:navigate(EnumScreens.AddFriends)

			return self.props.navigation.navigate(appPage.AddFriendsPage)
		end
	end)

	self.goToSearchFriendsPage = memoize(function()
		return function()
			self.props.navigation.navigate(appPage.UserSearch, {
				shouldShowUserSearchLandingPage = true,
				entryPoint = sources.FriendsLanding
			})
		end
	end)
end

function extended.render(props)
	local navigation = props.props.navigation
	local v6 = nil
	local v7 = nil

	if props.props.addFriendsPageSearchbarEnabled then
		v5.SHOW_ADDFRIENDS_ICON[EnumScreens.SearchFriends] = false
	end

	if navigation and navigation.state then
		local routeName = navigation.state.routeName
		v6 = v5.SHOW_SEARCHFRIENDS_ICON[routeName]
		v7 = v5.SHOW_ADDFRIENDS_ICON[routeName]
	end

	local createElement = roact.createElement
	local v9 = { BackgroundTransparency = 1, Size = UDim2.new(0, 72, 0, 36) }
	local v10 = {
		UIListLayout = roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SearchFriendsIcon = v6 and fn({
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

	if v7 then
		v7 = roact.createElement(module5, {
			onActivated = props.goToFriendRequestsPage(
				props.props.navigateToLuaAppPages,
				props.props.totalFriendCount
			),
			layoutOrder = 3,
			friendRequestCount = props.props.friendRequestCount,
			showTooltip = not fFlagConnectionManagementChips and props.props.totalFriendCount == 0
		})
	end

	v10.AddFriendsIcon = v7
	return createElement("Frame", v9, v10)
end

return compose(FriendsLandingAnalytics.connect(function(p2)
	return { analytics = p2 }
end), FriendsLandingContext.connect(function(data, p2)
	return {
		navigateToLuaAppPages = data.navigateToLuaAppPages,
		friendRequestCount = data.friendRequestCount,
		totalFriendCount = data.totalFriendCount,
		luaAddFriendsPageEnabled = data.luaAddFriendsPageEnabled,
		addFriendsPageSearchbarEnabled = data.addFriendsPageSearchbarEnabled
	}
end))(extended)
