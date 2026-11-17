local CollectionViewTypes = require(script.CollectionViewTypes)

local CollectionGrid = require(script.Grid.CollectionGrid)

local calculateSpanAwareGrids = require(script.calculateSpanAwareGrids)
local calculateSpanAwareGrids2 = calculateSpanAwareGrids.calculateSpanAwareGrids
local processOneGrid = calculateSpanAwareGrids.processOneGrid

local SharedFlags = require(script.Parent.SharedFlags)
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext

local CollectionViews = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	["jest.bench.config"] = script["jest.bench.config"],
	CollectionCarousel = require(script.Carousel.CollectionCarousel),
	CollectionGrid = CollectionGrid,
	CollectionViewTypes = CollectionViewTypes,
	CollectionLayoutCalculators = require(script.CollectionLayoutCalculators),
	calculateItemWidth = require(script.calculateItemWidth),
	calculateNumColumns = require(script.calculateNumColumns),
	useCollectionLayoutParams = require(script.useCollectionLayoutParams)
}
local useCollectionLayoutConfig

if FFlagLuaAppLayoutParamsInContext then
	useCollectionLayoutConfig = require(script.useCollectionLayoutConfig)
end

CollectionViews.useCollectionLayoutConfig = useCollectionLayoutConfig

CollectionViews.useCollectionImpressionsSignal = require(script.useCollectionImpressionsSignal)
CollectionViews.usePageSideMargin = require(script.usePageSideMargin)
CollectionViews.useCollectionSizeBindings = require(script.useCollectionSizeBindings)

CollectionViews.maybeForceDarkTheme = require(script.maybeForceDarkTheme)
CollectionViews.CarouselScrollButtons = require(script.Carousel.CarouselScrollButtons)
CollectionViews.CollectionHeader = require(script.CollectionHeader)
CollectionViews.checkAndFormatPossibleLink = require(script.checkAndFormatPossibleLink)

CollectionViews.CollectionItemSize = CollectionViewTypes.CollectionItemSize
CollectionViews.useCollectionLayout = require(script.CollectionLayoutStore.useCollectionLayout)
CollectionViews.CollectionLayoutStoreProvider = require(script.CollectionLayoutStore.CollectionLayoutStoreProvider)
CollectionViews.CollectionLayoutStoreContext = require(script.CollectionLayoutStore.CollectionLayoutStoreContext)
CollectionViews.createColumnSpanCollectionLayoutStore = require(script.CollectionLayoutStore.createColumnSpanCollectionLayoutStore)
local CollectionBreakpointConfig = require(script.CollectionLayoutStore.CollectionBreakpointConfig)
CollectionViews.getItemsPerRow = CollectionBreakpointConfig.getItemsPerRow
CollectionViews.getMainCollectionLayoutStore = require(script.CollectionLayoutStore.getMainCollectionLayoutStore)

CollectionViews.calculateSpanAwareGrids = calculateSpanAwareGrids2
CollectionViews.processOneGrid = processOneGrid
return CollectionViews
