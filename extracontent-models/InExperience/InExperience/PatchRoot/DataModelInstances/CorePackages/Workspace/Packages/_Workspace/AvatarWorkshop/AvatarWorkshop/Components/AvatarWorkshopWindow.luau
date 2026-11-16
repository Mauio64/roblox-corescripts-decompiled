local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local RoactNavigation = require(parent.RoactNavigation)

local HorizontalLayout = require(AvatarWorkshop.Components.HorizontalLayout)
local VerticalLayout = require(AvatarWorkshop.Components.VerticalLayout)
local TopBar = require(AvatarWorkshop.Components.TopBar)
local InventoryNavigator = require(AvatarWorkshop.Navigation.Navigators.InventoryNavigator)

local appContainer = RoactNavigation.createAppContainer(InventoryNavigator)

local function AvatarWorkshopWindow(p)
	local v = useTokens()
	local element = React.createElement(TopBar, { onClose = p.onClose })

	local element2 = React.createElement(appContainer)

	local createElement = React.createElement
	local v2 = {
		Active = true,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v.Color.Surface.Surface_100.Color3,
		BackgroundTransparency = v.Color.Surface.Surface_100.Transparency
	}
	local v3 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Medium) }),
		Layout = 0
	}
	local layout

	if p.verticalLayout then
		layout = React.createElement(VerticalLayout, {
			headerSlot = element,
			bottomItemSlot = React.createElement(Foundation.View, {
				tag = "size-full-full padding-top-xlarge"
			}, {
				Inventory = element2
			})
		})
	else
		layout = React.createElement(HorizontalLayout, {
			headerSlot = element,
			leftItemSlot = React.createElement(Foundation.View, { tag = "size-full-full" }, {
				Inventory = element2
			})
		})
	end

	v3.Layout = layout
	return createElement("Frame", v2, v3)
end

return AvatarWorkshopWindow
