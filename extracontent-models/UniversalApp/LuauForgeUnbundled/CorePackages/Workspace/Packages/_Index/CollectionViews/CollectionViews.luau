local module = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionViewTypes")

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Grid/CollectionGrid")

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/calculateSpanAwareGrids")
local calculateSpanAwareGrids = module3.calculateSpanAwareGrids
local processOneGrid = module3.processOneGrid

local fFlagLuaAppLayoutParamsInContext = require("@game/CorePackages/Workspace/Packages/_Workspace/CollectionViews/SharedFlags").FFlagLuaAppLayoutParamsInContext

local v5 = {
	CollectionCarousel = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/CollectionCarousel"),
	CollectionGrid = module2,
	CollectionViewTypes = module,
	CollectionLayoutCalculators = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutCalculators"),
	calculateItemWidth = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/calculateItemWidth"),
	calculateNumColumns = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/calculateNumColumns"),
	useCollectionLayoutParams = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/useCollectionLayoutParams"),
	useCollectionLayoutConfig = 0,
	useCollectionImpressionsSignal = 0,
	usePageSideMargin = 0,
	useCollectionSizeBindings = 0,
	maybeForceDarkTheme = 0,
	CarouselScrollButtons = 0,
	CollectionHeader = 0,
	checkAndFormatPossibleLink = 0,
	CollectionItemSize = 0,
	useCollectionLayout = 0,
	CollectionLayoutStoreProvider = 0,
	CollectionLayoutStoreContext = 0,
	createColumnSpanCollectionLayoutStore = 0,
	getItemsPerRow = 0,
	getMainCollectionLayoutStore = 0,
	calculateSpanAwareGrids = 0,
	processOneGrid = 0
}

local v6 = if fFlagLuaAppLayoutParamsInContext then require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/useCollectionLayoutConfig") else nil
v5.useCollectionLayoutConfig = v6

v5.useCollectionImpressionsSignal = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/useCollectionImpressionsSignal")
v5.usePageSideMargin = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/usePageSideMargin")
v5.useCollectionSizeBindings = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/useCollectionSizeBindings")

v5.maybeForceDarkTheme = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/maybeForceDarkTheme")
v5.CarouselScrollButtons = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/Carousel/CarouselScrollButtons")
v5.CollectionHeader = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionHeader")
v5.checkAndFormatPossibleLink = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/checkAndFormatPossibleLink")

v5.CollectionItemSize = module.CollectionItemSize
v5.useCollectionLayout = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/useCollectionLayout")
v5.CollectionLayoutStoreProvider = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/CollectionLayoutStoreProvider")
v5.CollectionLayoutStoreContext = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/CollectionLayoutStoreContext")
v5.createColumnSpanCollectionLayoutStore = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/createColumnSpanCollectionLayoutStore")
v5.getItemsPerRow = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/CollectionBreakpointConfig").getItemsPerRow
v5.getMainCollectionLayoutStore = require("@game/CorePackages/Workspace/Packages/_Index/CollectionViews/CollectionViews/CollectionLayoutStore/getMainCollectionLayoutStore")

v5.calculateSpanAwareGrids = calculateSpanAwareGrids
v5.processOneGrid = processOneGrid
return v5
