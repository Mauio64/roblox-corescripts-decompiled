local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")

local Screens = require(AvatarWorkshop.Navigation.Screens)
local TabsNavigatorView = require(AvatarWorkshop.Navigation.NavigatorViews.TabsNavigatorView)
local InventoryGridContainer = require(AvatarWorkshop.Components.Inventory.InventoryGrid.InventoryGridContainer)
local createPagesNavigator = require(script.Parent.createPagesNavigator)
local createInventoryPageRoute = require(script.Parent.createInventoryPageRoute)
local createPageGroupRoute = require(script.Parent.createPageGroupRoute)

local Inventory = Screens.Inventory

return createPagesNavigator(TabsNavigatorView, {
	createInventoryPageRoute(Inventory.Avatars, InventoryGridContainer),
	createPageGroupRoute(Inventory.Body.Root, TabsNavigatorView, {
		createInventoryPageRoute(Inventory.Body.FullBody, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Body.Head, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Body.Hair, InventoryGridContainer)
	}),
	createPageGroupRoute(Inventory.Clothing.Root, TabsNavigatorView, {
		createInventoryPageRoute(Inventory.Clothing.Top, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Clothing.Outterwear, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Clothing.Bottom, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Clothing.Shoes, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Clothing.ClassicShirt, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Clothing.ClassicPants, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Clothing.ClassicTShirt, InventoryGridContainer)
	}),
	createPageGroupRoute(Inventory.Accessories.Root, TabsNavigatorView, {
		createInventoryPageRoute(Inventory.Accessories.Hat, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Accessories.Face, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Accessories.Neck, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Accessories.Back, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Accessories.Waist, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Accessories.Shoulder, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Accessories.Front, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Accessories.Gear, InventoryGridContainer)
	}),
	createPageGroupRoute(Inventory.Animations.Root, TabsNavigatorView, {
		createInventoryPageRoute(Inventory.Animations.FullSet, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Animations.Idle, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Animations.Walk, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Animations.Run, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Animations.Jump, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Animations.Fall, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Animations.Climb, InventoryGridContainer),
		createInventoryPageRoute(Inventory.Animations.Swim, InventoryGridContainer)
	}),
	createInventoryPageRoute(Inventory.Emotes, InventoryGridContainer)
}, { initialRouteName = Inventory.Body.Root })
