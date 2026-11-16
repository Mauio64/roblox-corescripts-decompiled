local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)

local headerBar = dependencies.UIBlox.App.Bar.HeaderBar

local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local getFFlagFixConnectTabSearchBarHeight = dependencies.GetFFlagFixConnectTabSearchBarHeight

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026FriendsBackground = SharedFlags.FFlagAppThemeHalloween2026FriendsBackground
local ThemeBackground = require(parent.ThemeBackground)
local useThemeBackground = ThemeBackground.useThemeBackground
local function FriendsLandingHeaderBarPresentational(props)
	local size_2400 = useDesignTokens().Size.Size_2400
	local v

	if FFlagAppThemeHalloween2026FriendsBackground then
		v = useThemeBackground() ~= nil
	else
		v = false
	end

	local createElement = React.createElement
	local v2 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, size_2400),
		LayoutOrder = -1,
		ZIndex = 2
	}

	local createElement2 = React.createElement
	local v3 = {
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
	local paddingTop

	if getFFlagFixConnectTabSearchBarHeight() then
		paddingTop = UDim.new(0, 0)
	end

	v3.paddingTop = paddingTop
	local paddingBottom

	if getFFlagFixConnectTabSearchBarHeight() then
		paddingBottom = UDim.new(0, 0)
	end

	v3.paddingBottom = paddingBottom
	v3.backgroundTransparency = v and 1 or nil
	return createElement("Frame", v2, { headerBar = createElement2(headerBar, v3) })
end

return FriendsLandingHeaderBarPresentational
