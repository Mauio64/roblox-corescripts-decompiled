local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")

local Screens = require(AvatarWorkshop.Navigation.Screens)
local InventoryPagesData = require(AvatarWorkshop.Constants.InventoryPagesData)
local WorkshopNavigatorView = require(AvatarWorkshop.Navigation.NavigatorViews.WorkshopNavigatorView)
local InventoryGridContainer = require(AvatarWorkshop.Components.Inventory.InventoryGrid.InventoryGridContainer)
local CustomizeActionBar = require(AvatarWorkshop.Components.ActionBars.CustomizeActionBar)
local YourAvatarsActionBar = require(AvatarWorkshop.Components.ActionBars.YourAvatarsActionBar)
local createPagesNavigator = require(script.Parent.createPagesNavigator)
local InventoryNavigator = require(script.Parent.InventoryNavigator)

return createPagesNavigator(WorkshopNavigatorView, {
	{
		[Screens.Workshop.YourAvatars] = {
			screen = InventoryGridContainer,
			params = { pageData = InventoryPagesData[Screens.Inventory.Avatars] },
			navigationOptions = { actionBar = YourAvatarsActionBar }
		}
	},
	{
		[Screens.Workshop.Customize] = {
			screen = InventoryNavigator,
			navigationOptions = { actionBar = CustomizeActionBar }
		}
	}
})
