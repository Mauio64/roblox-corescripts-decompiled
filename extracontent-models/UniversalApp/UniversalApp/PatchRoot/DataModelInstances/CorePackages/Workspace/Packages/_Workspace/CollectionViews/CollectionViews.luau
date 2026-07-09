local CollectionViewTypes = require(script.CollectionViewTypes)
local CollectionGrid = require(script.Grid.CollectionGrid)
local calculateSpanAwareGrids = require(script.calculateSpanAwareGrids)
local calculateSpanAwareGrids2 = calculateSpanAwareGrids.calculateSpanAwareGrids
local processOneGrid = calculateSpanAwareGrids.processOneGrid
local FFlagLuaAppLayoutParamsInContext = require(script.Parent.SharedFlags).FFlagLuaAppLayoutParamsInContext

return {
	["jest.config"] = script["jest.config"],
	CollectionCarousel = require(script.Carousel.CollectionCarousel),
	CollectionGrid = CollectionGrid,
	CollectionViewTypes = CollectionViewTypes,
	CollectionLayoutCalculators = require(script.CollectionLayoutCalculators),
	calculateItemWidth = require(script.calculateItemWidth),
	calculateNumColumns = require(script.calculateNumColumns),
	useCollectionLayoutParams = require(script.useCollectionLayoutParams),
	useCollectionLayoutConfig = if not FFlagLuaAppLayoutParamsInContext then nil else require(script.useCollectionLayoutConfig),
	useCollectionImpressionsSignal = require(script.useCollectionImpressionsSignal),
	usePageSideMargin = require(script.usePageSideMargin),
	useCollectionSizeBindings = require(script.useCollectionSizeBindings),
	maybeForceDarkTheme = require(script.maybeForceDarkTheme),
	CarouselScrollButtons = require(script.Carousel.CarouselScrollButtons),
	CollectionHeader = require(script.CollectionHeader),
	checkAndFormatPossibleLink = require(script.checkAndFormatPossibleLink),
	CollectionItemSize = CollectionViewTypes.CollectionItemSize,
	useCollectionLayout = require(script.CollectionLayoutStore.useCollectionLayout),
	CollectionLayoutStoreProvider = require(script.CollectionLayoutStore.CollectionLayoutStoreProvider),
	CollectionLayoutStoreContext = require(script.CollectionLayoutStore.CollectionLayoutStoreContext),
	getItemsPerRow = require(script.CollectionLayoutStore.CollectionBreakpointConfig).getItemsPerRow,
	getMainCollectionLayoutStore = require(script.CollectionLayoutStore.getMainCollectionLayoutStore),
	calculateSpanAwareGrids = calculateSpanAwareGrids2,
	processOneGrid = processOneGrid
}
