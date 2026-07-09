local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local SocialLibraries = dependencies.SocialLibraries
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local EnumScreens = require(FriendsLanding.EnumScreens)
local FriendsLandingAnalytics = require(FriendsLanding.FriendsLandingAnalytics)
local AddFriendsIcon = require(FriendsLanding.Components.AddFriendsIcon)
local memoize = dependencies.memoize
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local ButtonClickEvents = require(FriendsLanding.FriendsLandingAnalytics.ButtonClickEvents)
local compose = SocialLibraries.RoduxTools.compose
local Sources = require(FriendsLandingParent.SocialLuaAnalytics).Analytics.Enums.Sources
local AppPage = require(FriendsLandingParent.RobloxAppEnums).AppPage
local FFlagConnectionManagementChips = require(FriendsLandingParent.SharedFlags).FFlagConnectionManagementChips

local function v19(p1) -- line: 27
	-- upvalues: Roact (copy), IconButton (copy), Images (copy)
	return Roact.createElement(IconButton, {
		size = UDim2.fromOffset(0, 0),
		icon = Images["icons/common/search"],
		layoutOrder = p1.layoutOrder,
		onActivated = p1.goToSearchFriendsPage
	})
end

local t1 = {
	SHOW_ADDFRIENDS_ICON = {
		[EnumScreens.FriendsLanding] = true,
		[EnumScreens.SearchFriends] = true
	},
	SHOW_SEARCHFRIENDS_ICON = {
		[EnumScreens.FriendsLanding] = true,
		[EnumScreens.SearchFriends] = true,
		[EnumScreens.AddFriends] = true
	}
}
local v21 = Roact.PureComponent:extend("HeaderBarRightView")

v21.defaultProps = {
	layoutOrder = 1,
	onActivated = nil
}

function v21.init(p2) -- line: 55
	-- upvalues: memoize (copy), ButtonClickEvents (copy), EnumScreens (copy), AppPage (copy), Sources (copy)
	p2.goToFriendRequestsPage = memoize(function(_, p4) -- line: 57
		-- upvalues: ButtonClickEvents (copy), p2 (copy), EnumScreens (copy), AppPage (copy)
		return function() -- line: 58
			-- upvalues: p4 (copy), ButtonClickEvents (copy), p2 (copy), EnumScreens (copy), AppPage (copy)
			local v34 = p4 == 0 and ButtonClickEvents.AddFriendsNoFriends or ButtonClickEvents.AddFriends

			p2.props.analytics:buttonClick(v34)
			p2.props.analytics:navigate(EnumScreens.AddFriends)

			return p2.props.navigation.navigate(AppPage.AddFriendsPage)
		end
	end)
	p2.goToSearchFriendsPage = memoize(function() -- line: 68
		-- upvalues: p2 (copy), AppPage (copy), Sources (copy)
		return function() -- line: 69
			-- upvalues: p2 (copy), AppPage (copy), Sources (copy)
			p2.props.navigation.navigate(AppPage.UserSearch, {
				shouldShowUserSearchLandingPage = true,
				entryPoint = Sources.FriendsLanding
			})
		end
	end)
end
function v21.render(p5) -- line: 78
	-- upvalues: t1 (copy), EnumScreens (copy), Roact (copy), v19 (copy), AddFriendsIcon (copy), FFlagConnectionManagementChips (copy)
	local navigation = p5.props.navigation
	local v26 = nil
	local v27 = nil

	if p5.props.addFriendsPageSearchbarEnabled then
		t1.SHOW_ADDFRIENDS_ICON[EnumScreens.SearchFriends] = false
	end

	if navigation and navigation.state then
		local routeName = navigation.state.routeName

		v26 = t1.SHOW_SEARCHFRIENDS_ICON[routeName]
		v27 = t1.SHOW_ADDFRIENDS_ICON[routeName]
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 72, 0, 36)
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		SearchFriendsIcon = v26 and v19({
			layoutOrder = 1,
			goToSearchFriendsPage = p5.goToSearchFriendsPage()
		}),
		Padding = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, 0)
		}),
		AddFriendsIcon = v27 and Roact.createElement(AddFriendsIcon, {
			layoutOrder = 3,
			onActivated = p5.goToFriendRequestsPage(p5.props.navigateToLuaAppPages, p5.props.totalFriendCount),
			friendRequestCount = p5.props.friendRequestCount,
			showTooltip = not FFlagConnectionManagementChips and p5.props.totalFriendCount == 0
		})
	})
end

return compose(FriendsLandingAnalytics.connect(function(p6) -- line: 121
	return {
		analytics = p6
	}
end), FriendsLandingContext.connect(function(p7, _) -- line: 126
	return {
		navigateToLuaAppPages = p7.navigateToLuaAppPages,
		friendRequestCount = p7.friendRequestCount,
		totalFriendCount = p7.totalFriendCount,
		luaAddFriendsPageEnabled = p7.luaAddFriendsPageEnabled,
		addFriendsPageSearchbarEnabled = p7.addFriendsPageSearchbarEnabled
	}
end))(v21)
