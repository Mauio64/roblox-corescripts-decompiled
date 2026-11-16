local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local headerBar = dependencies.UIBlox.App.Bar.HeaderBar

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Style").useDesignTokens

local getFFlagFixConnectTabSearchBarHeight = dependencies.GetFFlagFixConnectTabSearchBarHeight

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/React")

local fFlagAppThemeHalloween2026FriendsBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").FFlagAppThemeHalloween2026FriendsBackground
local useThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ThemeBackground").useThemeBackground
local function FriendsLandingHeaderBarPresentational(props)
	local size_2400 = useDesignTokens().Size.Size_2400

	local v5 = if fFlagAppThemeHalloween2026FriendsBackground then useThemeBackground() ~= nil else false

	local createElement = React.createElement
	local v7 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, size_2400),
		LayoutOrder = -1,
		ZIndex = 2
	}

	local createElement2 = React.createElement
	local v10 = {
		title = props.title,
		barHeight = size_2400,
		renderLeft = props.renderLeft,
		renderCenter = props.renderCenter,
		renderRight = props.renderRight,
		isSecondary = props.isSecondary,
		shouldHideSecondaryLeftItem = props.shouldHideSecondaryLeftItem,
		paddingTop = 0,
		paddingBottom = 0,
		backgroundTransparency = 0
	}
	local v11 = if getFFlagFixConnectTabSearchBarHeight() then UDim.new(0, 0) else nil
	v10.paddingTop = v11
	local v12 = if getFFlagFixConnectTabSearchBarHeight() then UDim.new(0, 0) else nil
	v10.paddingBottom = v12
	v10.backgroundTransparency = v5 and 1 or nil
	return createElement("Frame", v7, { headerBar = createElement2(headerBar, v10) })
end

return FriendsLandingHeaderBarPresentational
