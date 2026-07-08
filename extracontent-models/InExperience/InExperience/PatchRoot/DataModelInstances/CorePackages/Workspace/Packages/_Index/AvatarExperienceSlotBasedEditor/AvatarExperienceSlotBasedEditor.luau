require(script.Types)

local AvatarEditorCategories = require(script.Enums.AvatarEditorCategories)
local AvatarEditorSubcategories = require(script.Enums.AvatarEditorSubcategories)
local Categories = require(script.Enums.Categories)
local ScreenLayout = require(script.Enums.ScreenLayout)
local ItemView = require(script.Enums.ItemView)
local NavigationParams = require(script.Enums.NavigationParams)

require(script.Hooks.useSlotItemCardBreakpoints)

local InventoryItemType = require(script.Enums.InventoryItemType)
local InventorySorts = require(script.Enums.InventorySorts)
local InventoryFilters = require(script.Enums.InventoryFilters)
local InventoryItemAvailability = require(script.Enums.InventoryItemAvailability)
local SlotType = require(script.Enums.SlotType)
local createCategoryInventoryStore = require(script.Stores.createCategoryInventoryStore)
local createSortAndFiltersStore = require(script.Stores.createSortAndFiltersStore)
local createAvatarEditorStores = require(script.Stores.createAvatarEditorStores)
local createSlotBasedEditorStore = require(script.Stores.createSlotBasedEditorStore)
local createStaleInventoryGrantStore = require(script.Stores.createStaleInventoryGrantStore)
local SlotBasedEditorContext = require(script.Context.SlotBasedEditorContext)
local AvatarEditorStores = require(script.Context.AvatarEditorStores)

return {
	Components = {
		SlotItemCard = require(script.Components.SlotItemCard),
		SlotItemCardFooter = require(script.Components.SlotItemCardFooter),
		SlotCircularGradientFrame = require(script.Components.SlotCircularGradientFrame),
		SlotItemCardThumbnail = require(script.Components.SlotItemCardThumbnail),
		ClearAllButton = require(script.Components.ClearAllButton),
		CloseableHeader = require(script.Components.CloseableHeader),
		AXPartialPageModal = require(script.Components.AXPartialPageModal)
	},
	Hooks = {
		useSlotItemCardBreakpoints = require(script.Hooks.useSlotItemCardBreakpoints),
		useSlotCustomizeFtux = require(script.Hooks.useSlotCustomizeFtux)
	},
	Context = {
		SlotBasedEditorContext = SlotBasedEditorContext,
		useSlotBasedEditorContext = require(script.Context.useSlotBasedEditorContext),
		AvatarEditorStores = AvatarEditorStores,
		useAvatarEditorStores = require(script.Context.useAvatarEditorStores)
	},
	Stores = {
		createCategoryInventoryStore = createCategoryInventoryStore,
		createSortAndFiltersStore = createSortAndFiltersStore,
		createAvatarEditorStores = createAvatarEditorStores,
		createSlotBasedEditorStore = createSlotBasedEditorStore,
		createStaleInventoryGrantStore = createStaleInventoryGrantStore,
		getStaleInventoryGrantStore = require(script.Stores.getStaleInventoryGrantStore)
	},
	Enums = {
		ScreenLayout = ScreenLayout,
		AvatarEditorCategories = AvatarEditorCategories,
		AvatarEditorSubcategories = AvatarEditorSubcategories,
		Categories = Categories,
		ItemView = ItemView,
		NavigationParams = NavigationParams,
		InventoryItemType = InventoryItemType,
		InventorySorts = InventorySorts,
		InventoryFilters = InventoryFilters,
		InventoryItemAvailability = InventoryItemAvailability,
		SlotType = SlotType
	},
	Constants = require(script.Constants),
	Utils = {
		buildStringsToLocalize = require(script.Utils.buildStringsToLocalize),
		buildSlots = require(script.Utils.buildSlots),
		getAssetTypesByCategory = require(script.Utils.getAssetTypesByCategory),
		buildBodySlotViewportProps = require(script.Utils.buildBodySlotViewportProps),
		getRemainingTimeFromExpiration = require(script.Utils.getRemainingTimeFromExpiration)
	},
	["jest.config"] = script["jest.config"]
}
