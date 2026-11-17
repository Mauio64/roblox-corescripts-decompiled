local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local RoactNavigation = require(parent.RoactNavigation)

local WorkshopWindowContext = require(AvatarWorkshop.Contexts.WorkshopWindowContext)
local WorkshopNavigator = require(AvatarWorkshop.Navigation.Navigators.WorkshopNavigator)

local appContainer = RoactNavigation.createAppContainer(WorkshopNavigator)

local function AvatarWorkshopWindow(p)
	local v = useTokens()

	local v2 = React.useMemo(function()
		return { verticalLayout = p.verticalLayout, onClose = p.onClose }
	end, { p.verticalLayout, p.onClose })

	return React.createElement(
		"Frame",
		{
			Active = true,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v.Color.Surface.Surface_100.Color3,
			BackgroundTransparency = v.Color.Surface.Surface_100.Transparency
		},
		{
			Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v.Radius.Medium) }),
			Navigation = React.createElement(
				WorkshopWindowContext.Provider,
				{ value = v2 },
				React.createElement(appContainer)
			)
		}
	)
end

return AvatarWorkshopWindow
