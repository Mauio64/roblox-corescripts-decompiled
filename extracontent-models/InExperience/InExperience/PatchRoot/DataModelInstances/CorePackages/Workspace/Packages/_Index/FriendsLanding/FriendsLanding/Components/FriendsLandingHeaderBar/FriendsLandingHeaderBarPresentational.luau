local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local HeaderBar = dependencies.UIBlox.App.Bar.HeaderBar
local useUiModeInfo = require(FriendsLandingParent.RobloxAppHooks).useUiModeInfo
local UiMode = require(FriendsLandingParent.RobloxAppEnums).UiMode
local useDesignTokens = require(FriendsLandingParent.Style).useDesignTokens
local Constants = require(FriendsLanding.Common.Constants)
local GetFFlagFixConnectTabSearchBarHeight = dependencies.GetFFlagFixConnectTabSearchBarHeight
local FFlagEnableLeftNavOnConsole = require(FriendsLandingParent.SharedFlags).FFlagEnableLeftNavOnConsole
local React = require(FriendsLandingParent.React)

local function FriendsLandingHeaderBarPresentational(p1) -- line: 18
	-- upvalues: useUiModeInfo (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy), Constants (copy), useDesignTokens (copy), React (copy), HeaderBar (copy), GetFFlagFixConnectTabSearchBarHeight (copy)
	if useUiModeInfo().uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole then
		return nil
	end

	local TOP_BAR_HEIGHT = Constants.TOP_BAR_HEIGHT

	if FFlagEnableLeftNavOnConsole then
		TOP_BAR_HEIGHT = useDesignTokens().Size.Size_2400
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = -1,
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, TOP_BAR_HEIGHT)
	}, {
		headerBar = React.createElement(HeaderBar, {
			title = p1.title,
			barHeight = TOP_BAR_HEIGHT,
			renderLeft = p1.renderLeft,
			renderCenter = p1.renderCenter,
			renderRight = p1.renderRight,
			isSecondary = p1.isSecondary,
			shouldHideSecondaryLeftItem = p1.shouldHideSecondaryLeftItem,
			paddingTop = if not GetFFlagFixConnectTabSearchBarHeight() then nil else UDim.new(0, 0),
			paddingBottom = if not GetFFlagFixConnectTabSearchBarHeight() then nil else UDim.new(0, 0)
		})
	})
end

return FriendsLandingHeaderBarPresentational
