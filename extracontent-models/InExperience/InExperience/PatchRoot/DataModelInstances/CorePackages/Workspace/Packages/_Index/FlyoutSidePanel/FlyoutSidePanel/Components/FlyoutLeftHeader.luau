local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AppPage = require(Parent.RobloxAppEnums).AppPage
local NavigationRodux = require(Parent.NavigationRodux)
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local AppNavBar = require(Parent.AppNavBar)
local useNavBarPlacement = AppNavBar.useNavBarPlacement
local Placement = AppNavBar.Placement
local FlyoutHamburgerButton = require(script.Parent.FlyoutHamburgerButton)
local Constants = require(script.Parent.Parent.Constants)
local v13 = game:DefineFastFlag("EnableHomeBetaBadge", false)
local SharedFlags = require(Parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagEnableCoreContentBadge = SharedFlags.FFlagEnableCoreContentBadge
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local FFlagEnableConsoleRobloxLogo = SharedFlags.FFlagEnableConsoleRobloxLogo
local FFlagEnableFlyoutOnNavRail = SharedFlags.FFlagEnableFlyoutOnNavRail

local function FlyoutLeftHeader(t1: {[any]: any}) -- line: 38
	-- upvalues: useTokens (copy), FFlagEnableFlyoutOnNavRail (copy), useNavBarPlacement (copy), Placement (copy), FFlagEnableCoreContentBadge (copy), useAppPolicy (copy), AppPage (copy), FFlagAppIaHomeSubTab (copy), NavigationRodux (copy), FFlagEnableHomeRobloxLogo (copy), FFlagEnableConsoleRobloxLogo (copy), React (copy), Foundation (copy), FlyoutHamburgerButton (copy), Constants (copy), v13 (copy)
	local v22 = useTokens()
	local Size_500 = v22.Size.Size_500
	local v24 = nil

	if FFlagEnableFlyoutOnNavRail then
		v24 = useNavBarPlacement() == Placement.Bottom
	end

	local v25 = if not FFlagEnableCoreContentBadge then nil else useAppPolicy(function(p1) -- line: 50
		return p1.getCoreContentBadgeText()
	end)
	local v26 = not not FFlagEnableCoreContentBadge and (v25 and v25 ~= "")
	local v27 = t1.alwaysShowLogo or (t1.routeName == AppPage.Home or FFlagAppIaHomeSubTab and t1.routeName == NavigationRodux.Constants.HomeContainerName)
	local s1 = "auto-xy row align-x-left align-y-center"

	if FFlagEnableHomeRobloxLogo or FFlagEnableConsoleRobloxLogo or t1.isAlternateEntryPointEnabled then
		s1 ..= " gap-small"
	end

	local v29 = (not FFlagEnableHomeRobloxLogo and not FFlagEnableConsoleRobloxLogo or t1.isFlyoutEntrypointEnabled) and (not FFlagEnableFlyoutOnNavRail or v24)

	return React.createElement(Foundation.View, {
		tag = s1
	}, {
		FlyoutHamburgerButton = if not v29 then nil else React.createElement(FlyoutHamburgerButton, {
			LayoutOrder = 1,
			titleText = t1.titleText,
			isAlternateEntryPointEnabled = t1.isAlternateEntryPointEnabled
		}),
		TitleOrRobloxLogoFrame = if not FFlagEnableHomeRobloxLogo and (not FFlagEnableConsoleRobloxLogo and not t1.isRobloxLogoEnabled) or not v27 then if not t1.titleText then nil else React.createElement(Foundation.Text, {
			tag = "auto-xy text-heading-large content-emphasis",
			LayoutOrder = 2,
			Text = t1.titleText
		}) else React.createElement(Foundation.Image, {
			LayoutOrder = 2,
			tag = "size-full-full",
			Image = "icons/logo/letterform",
			imageStyle = v22.Color.Content.Emphasis,
			Size = UDim2.fromOffset(Size_500 * Constants.ROBLOX_LOGO_ASPECT_RATIO, Size_500)
		}),
		CoreContentBadge = if not FFlagEnableCoreContentBadge or (not FFlagEnableHomeRobloxLogo and (not FFlagEnableConsoleRobloxLogo and not t1.isRobloxLogoEnabled) or (not v27 or not v26)) then nil else React.createElement(Foundation.View, {
			tag = "auto-xy bg-system-contrast padding-x-xsmall padding-y-xxsmall radius-small",
			LayoutOrder = 3
		}, {
			Text = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-small",
				Text = v25,
				textStyle = v22.Color.Surface.Surface_0
			})
		}),
		BetaBadge = if not v13 or (not t1.isRobloxLogoEnabled or not v27) then nil else React.createElement(Foundation.View, {
			LayoutOrder = 4,
			tag = "auto-xy padding-xxsmall stroke-standard stroke-emphasis radius-small"
		}, {
			Text = React.createElement(Foundation.Text, {
				Text = "Beta",
				tag = "auto-xy text-body-small content-emphasis"
			})
		})
	})
end

return FlyoutLeftHeader
