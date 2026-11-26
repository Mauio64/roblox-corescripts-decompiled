require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")
local module = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/Categories")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/ScreenLayout")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/ItemView")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/NavigationParams")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Hooks/useSlotItemCardBreakpoints")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventorySorts")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventoryFilters")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventoryItemAvailability")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventoryItemType")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventorySearchSortOption")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/SlotType")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createCategoryInventoryStore")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createSortAndFiltersStore")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createInventorySearchStore")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createAvatarEditorStores")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createSlotBasedEditorStore")
local module15 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createStaleInventoryGrantStore")
local module16 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createThumbnailLatencyStore")
local module17 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Context/SlotBasedEditorContext")
local module18 = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Context/AvatarEditorStores")

return {
	Components = {
		SlotItemCard = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/SlotItemCard"),
		SlotItemCardFooter = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/SlotItemCardFooter"),
		SlotCircularGradientFrame = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/SlotCircularGradientFrame"),
		SlotItemCardThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/SlotItemCardThumbnail"),
		ClearAllButton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/ClearAllButton"),
		CloseableHeader = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/CloseableHeader"),
		AXPartialPageModal = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/AXPartialPageModal"),
		OutfitDetailsActionBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/OutfitDetails/ActionBar/OutfitDetailsActionBarContainer"),
		OutfitDetailsTopBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Components/OutfitDetails/TopBar/OutfitDetailsTopBarContainer")
	},
	Hooks = {
		useSlotItemCardBreakpoints = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Hooks/useSlotItemCardBreakpoints"),
		useSlotCustomizeFtux = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Hooks/useSlotCustomizeFtux")
	},
	Context = {
		SlotBasedEditorContext = module17,
		useSlotBasedEditorContext = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Context/useSlotBasedEditorContext"),
		AvatarEditorStores = module18,
		useAvatarEditorStores = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Context/useAvatarEditorStores")
	},
	Stores = {
		createCategoryInventoryStore = module10,
		createSortAndFiltersStore = module11,
		createInventorySearchStore = module12,
		createAvatarEditorStores = module13,
		createSlotBasedEditorStore = module14,
		createStaleInventoryGrantStore = module15,
		createThumbnailLatencyStore = module16,
		getStaleInventoryGrantStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/getStaleInventoryGrantStore")
	},
	Enums = {
		ScreenLayout = module2,
		Categories = module,
		ItemView = module3,
		NavigationParams = module4,
		InventorySorts = module5,
		InventoryFilters = module6,
		InventoryItemAvailability = module7,
		InventoryItemType = module8,
		SlotType = module9
	},
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Constants"),
	InventorySearchConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/InventorySearchConstants"),
	Utils = {
		buildStringsToLocalize = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/buildStringsToLocalize"),
		buildSlots = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/buildSlots"),
		getAssetTypesByCategory = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/getAssetTypesByCategory"),
		buildBodySlotViewportProps = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/buildBodySlotViewportProps"),
		getRemainingTimeFromExpiration = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/getRemainingTimeFromExpiration"),
		buildSlotCategoryTabItems = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/buildSlotCategoryTabItems"),
		buildSlotCategoryLocalizationKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/buildSlotCategoryLocalizationKeys"),
		buildSearchAvatarInventoryQuery = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/buildSearchAvatarInventoryQuery"),
		toSearchableItemCategories = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/toSearchableItemCategories"),
		getInventorySearchKey = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Utils/getInventorySearchKey")
	}
}
