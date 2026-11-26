local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local useTokens = Foundation.Hooks.useTokens
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/NavigationRodux")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UniversalAppPolicy").useAppPolicy
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/AppNavBar")
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local placement = AppNavBar.Placement
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/FlyoutHamburgerButton")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Constants")

local defineFastFlag = game:DefineFastFlag("EnableHomeBetaBadge", false)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagEnableCoreContentBadge = SharedFlags.FFlagEnableCoreContentBadge
local fFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local fFlagEnableConsoleRobloxLogo = SharedFlags.FFlagEnableConsoleRobloxLogo
local fFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail
local fFlagFlyoutHeaderFixPadding = SharedFlags.FFlagFlyoutHeaderFixPadding

local function FlyoutLeftHeader(props)
	local v5 = useTokens()
	local size_500 = v5.Size.Size_500
	local vector2 = Vector2.new(size_500 * Constants.ROBLOX_LOGO_ASPECT_RATIO, size_500)

	local v6 = if fFlagEnableFlyoutOnNavRail then useNavBarPlacement() == placement.Bottom else nil
	local v7

	if fFlagEnableCoreContentBadge then
		v7 = useAppPolicy(function(p2)
			return p2.getCoreContentBadgeText()
		end)
	end

	local v8 = if fFlagEnableCoreContentBadge then v7 and v7 ~= "" else false
	local alwaysShowLogo = props.alwaysShowLogo
		or props.routeName == appPage.Home
		or fFlagAppIaHomeSubTab and props.routeName == NavigationRodux.Constants.HomeContainerName
	local v9 = "auto-xy row align-x-left align-y-center"

	if
		not fFlagFlyoutHeaderFixPadding
		and (fFlagEnableHomeRobloxLogo or fFlagEnableConsoleRobloxLogo or props.isAlternateEntryPointEnabled)
	then
		v9 ..= " gap-small"
	end

	local v10 = (not (fFlagEnableHomeRobloxLogo or fFlagEnableConsoleRobloxLogo) or props.isFlyoutEntrypointEnabled)
		and (not fFlagEnableFlyoutOnNavRail or v6)
	local v11

	if
		fFlagEnableCoreContentBadge
		and (fFlagEnableHomeRobloxLogo or fFlagEnableConsoleRobloxLogo or props.isRobloxLogoEnabled)
		and alwaysShowLogo
		and v8
	then
		v11 = React.createElement(
			Foundation.View,
			{
				tag = "auto-xy padding-x-xsmall padding-y-xxsmall radius-small bg-system-contrast",
				LayoutOrder = 3
			},
			{
				Text = React.createElement(Foundation.Text, {
					Text = v7,
					tag = "auto-xy text-title-small",
					textStyle = v5.Color.Surface.Surface_0
				})
			}
		)
	end

	local v12

	if defineFastFlag and props.isRobloxLogoEnabled and alwaysShowLogo then
		v12 = React.createElement(
			Foundation.View,
			{
				LayoutOrder = 4,
				tag = "auto-xy padding-xxsmall stroke-standard stroke-emphasis radius-small"
			},
			{
				Text = React.createElement(Foundation.Text, {
					Text = "Beta",
					tag = "auto-xy text-body-small content-emphasis"
				})
			}
		)
	end

	local createElement = React.createElement
	local view = Foundation.View

	local v15 = if v10 then React.createElement(module5, {
		titleText = props.titleText,
		LayoutOrder = 1,
		isAlternateEntryPointEnabled = props.isAlternateEntryPointEnabled
	}) else nil
	local v16

	if
		(fFlagEnableHomeRobloxLogo or fFlagEnableConsoleRobloxLogo or props.isRobloxLogoEnabled)
		and alwaysShowLogo
	then
		if props.useHeaderLogo then
			v16 = React.createElement(require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/HeaderLogo"))
		else
			v16 = React.createElement(Foundation.Image, {
				LayoutOrder = 2,
				tag = "size-full-full",
				Image = "icons/logo/letterform",
				imageStyle = v5.Color.Content.Emphasis,
				Size = UDim2.fromOffset(vector2.X, vector2.Y)
			})
		end
	elseif props.titleText then
		v16 = React.createElement(Foundation.Text, {
			tag = "auto-xy text-heading-large content-emphasis",
			LayoutOrder = 2,
			Text = props.titleText
		})
	end

	local v17 = if fFlagFlyoutHeaderFixPadding then React.createElement(
		Foundation.View,
		{
			tag = "row gap-xsmall auto-xy align-y-center padding-left-xsmall",
			LayoutOrder = 3
		},
		{ CoreContentBadge = v11, BetaBadge = v12 }
	) else nil

	if fFlagFlyoutHeaderFixPadding then
		v11 = nil
	end

	if fFlagFlyoutHeaderFixPadding then
		v12 = nil
	end

	return createElement(view, { tag = v9 }, {
		FlyoutHamburgerButton = v15,
		TitleOrRobloxLogoFrame = v16,
		Badges = v17,
		CoreContentBadge = v11,
		BetaBadge = v12
	})
end

return FlyoutLeftHeader
