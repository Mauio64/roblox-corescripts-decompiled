local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local Foundation = require(parent.Foundation)
local RoactNavigation = require(parent.RoactNavigation)
local React = require(parent.React)

require(AvatarWorkshop.Navigation.NavigationTypes)
local WorkshopWindowContext = require(AvatarWorkshop.Contexts.WorkshopWindowContext)
local HorizontalLayout = require(AvatarWorkshop.Components.HorizontalLayout)
local VerticalLayout = require(AvatarWorkshop.Components.VerticalLayout)
local TopBar = require(AvatarWorkshop.Components.TopBar)
local AvatarPreview = require(AvatarWorkshop.Components.AvatarPreview.AvatarPreview)
local ScreenTitles = require(AvatarWorkshop.Constants.ScreenTitles)
local getActiveRoute = require(AvatarWorkshop.Navigation.getActiveRoute)

local function WorkshopNavigatorView(p)
	local v = React.useContext(WorkshopWindowContext)

	local navigation = p.navigation
	local activeRoute = getActiveRoute(navigation)
	local routeName = activeRoute.routeName
	local routeName2 = navigation.state.routes[1].routeName

	local element = React.createElement(TopBar, {
		titleKey = ScreenTitles[routeName],
		onClose = v.onClose,
		onBack = routeName ~= routeName2 and function()
			navigation.navigate(routeName2)
		end or nil
	})

	local element2 = React.createElement(RoactNavigation.RobloxSwitchView, p)
	local descriptor = p.descriptors[activeRoute.key]
	local options

	if descriptor then
		options = descriptor.options
	end

	local actionBar

	if options then
		actionBar = options.actionBar
	end

	local actionBar2

	if actionBar then
		actionBar2 = React.createElement(actionBar)
	end

	if v.verticalLayout then
		local createElement = React.createElement
		local v2 = {
			headerSlot = element,
			topItemSlot = React.createElement(AvatarPreview),
			bottomItemSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-top-xlarge"
			}, {
				Content = element2
			}),
			footerSlot = 0
		}
		local footerSlot

		if actionBar2 then
			footerSlot = React.createElement(
				Foundation.View,
				{
					tag = "size-full-0 auto-y padding-top-medium padding-x-xlarge padding-bottom-large"
				},
				{ ActionBar = actionBar2 }
			)
		end

		v2.footerSlot = footerSlot
		return createElement(VerticalLayout, v2)
	else
		local createElement = React.createElement
		local v2 = {
			headerSlot = element,
			leftItemSlot = React.createElement(Foundation.View, { tag = "size-full-full" }, {
				Content = element2
			}),
			rightItemSlot = 0
		}

		local createElement2 = React.createElement
		local view = Foundation.View

		local v3 = {
			Preview = React.createElement(Foundation.View, {
				tag = "fill size-full-0",
				LayoutOrder = 1
			}, {
				AvatarPreview = React.createElement(AvatarPreview)
			}),
			ActionBar = 0
		}
		local actionBar3

		if actionBar2 then
			actionBar3 = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y padding-medium", LayoutOrder = 2 },
				{ ActionBar = actionBar2 }
			)
		end

		v3.ActionBar = actionBar3
		v2.rightItemSlot = createElement2(view, { tag = "col size-full-full" }, v3)
		return createElement(HorizontalLayout, v2)
	end
end

return WorkshopNavigatorView
