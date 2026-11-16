local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local AppNavBar = require(parent.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local Placement = AppNavBar.Placement
local FlyoutHamburgerButton = require(script.Parent.FlyoutHamburgerButton)
local Constants = require(script.Parent.Parent.Constants)

local defineFastFlag = game:DefineFastFlag("EnableHomeBetaBadge", false)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagEnableCoreContentBadge = SharedFlags.FFlagEnableCoreContentBadge
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local FFlagEnableConsoleRobloxLogo = SharedFlags.FFlagEnableConsoleRobloxLogo
local FFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail
local FFlagFlyoutHeaderFixPadding = SharedFlags.FFlagFlyoutHeaderFixPadding

local function FlyoutLeftHeader(props)
	local v = useTokens()
	local size_500 = v.Size.Size_500
	local vector2 = Vector2.new(size_500 * Constants.ROBLOX_LOGO_ASPECT_RATIO, size_500)
	local v2

	if FFlagEnableFlyoutOnNavRail then
		v2 = useNavBarPlacement() == Placement.Bottom
	end

	local text

	if FFlagEnableCoreContentBadge then
		text = useAppPolicy(function(p)
			return p.getCoreContentBadgeText()
		end)
	end

	local v3

	if FFlagEnableCoreContentBadge then
		v3 = text and text ~= ""
	else
		v3 = false
	end

	local alwaysShowLogo = props.alwaysShowLogo
		or props.routeName == AppPage.Home
		or FFlagAppIaHomeSubTab and props.routeName == NavigationRodux.Constants.HomeContainerName
	local tag = "auto-xy row align-x-left align-y-center"

	if
		not FFlagFlyoutHeaderFixPadding
		and (FFlagEnableHomeRobloxLogo or FFlagEnableConsoleRobloxLogo or props.isAlternateEntryPointEnabled)
	then
		tag ..= " gap-small"
	end

	local v4 = (not (FFlagEnableHomeRobloxLogo or FFlagEnableConsoleRobloxLogo) or props.isFlyoutEntrypointEnabled)
		and (not FFlagEnableFlyoutOnNavRail or v2)
	local coreContentBadge

	if
		FFlagEnableCoreContentBadge
		and (FFlagEnableHomeRobloxLogo or FFlagEnableConsoleRobloxLogo or props.isRobloxLogoEnabled)
		and alwaysShowLogo
		and v3
	then
		coreContentBadge = React.createElement(
			Foundation.View,
			{
				tag = "auto-xy padding-x-xsmall padding-y-xxsmall radius-small bg-system-contrast",
				LayoutOrder = 3
			},
			{
				Text = React.createElement(Foundation.Text, {
					Text = text,
					tag = "auto-xy text-title-small",
					textStyle = v.Color.Surface.Surface_0
				})
			}
		)
	end

	local betaBadge

	if defineFastFlag and props.isRobloxLogoEnabled and alwaysShowLogo then
		betaBadge = React.createElement(
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
	local flyoutHamburgerButton

	if v4 then
		flyoutHamburgerButton = React.createElement(FlyoutHamburgerButton, {
			titleText = props.titleText,
			LayoutOrder = 1,
			isAlternateEntryPointEnabled = props.isAlternateEntryPointEnabled
		})
	end

	local titleOrRobloxLogoFrame

	if (FFlagEnableHomeRobloxLogo or FFlagEnableConsoleRobloxLogo or props.isRobloxLogoEnabled) and alwaysShowLogo then
		if props.useHeaderLogo then
			titleOrRobloxLogoFrame = React.createElement(require(script.Parent.HeaderLogo))
		else
			titleOrRobloxLogoFrame = React.createElement(Foundation.Image, {
				LayoutOrder = 2,
				tag = "size-full-full",
				Image = "icons/logo/letterform",
				imageStyle = v.Color.Content.Emphasis,
				Size = UDim2.fromOffset(vector2.X, vector2.Y)
			})
		end
	elseif props.titleText then
		titleOrRobloxLogoFrame = React.createElement(Foundation.Text, {
			tag = "auto-xy text-heading-large content-emphasis",
			LayoutOrder = 2,
			Text = props.titleText
		})
	end

	local badges

	if FFlagFlyoutHeaderFixPadding then
		badges = React.createElement(
			Foundation.View,
			{ tag = "row gap-xsmall auto-xy align-y-center padding-left-xsmall", LayoutOrder = 3 },
			{ CoreContentBadge = coreContentBadge, BetaBadge = betaBadge }
		)
	end

	if FFlagFlyoutHeaderFixPadding then
		coreContentBadge = nil
	end

	if FFlagFlyoutHeaderFixPadding then
		betaBadge = nil
	end

	return createElement(view, { tag = tag }, {
		FlyoutHamburgerButton = flyoutHamburgerButton,
		TitleOrRobloxLogoFrame = titleOrRobloxLogoFrame,
		Badges = badges,
		CoreContentBadge = coreContentBadge,
		BetaBadge = betaBadge
	})
end

return FlyoutLeftHeader
