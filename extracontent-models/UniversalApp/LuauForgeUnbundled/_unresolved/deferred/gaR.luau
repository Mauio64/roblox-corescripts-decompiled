local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local gridMetrics = UIBlox.App.Grid.GridMetrics
local defaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local module = require("@luauforge/bundled/cyO")

local module2 = require("@luauforge/deferred/gaS")

local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local tagBasedImpressionsDetector = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").TagBasedImpressionsDetector
local module3 = require("@luauforge/deferred/fXN")
local constants = module3.Constants
local edpUnifiedImpressionsReporter = module3.EdpUnifiedImpressionsReporter
local module4 = require("@luauforge/deferred/fXO")
local module5 = require("@luauforge/bundled/dCp")

local module6 = require("@luauforge/deferred/fXs")

local GAME_GRID_CHILD_PADDING = module.Constants.GAME_GRID_CHILD_PADDING
local GAME_GRID_TILE_FOOTER_HEIGHT = module.Constants.GAME_GRID_TILE_FOOTER_HEIGHT

local extended = Roact.PureComponent:extend("DeveloperProductsGrid")

extended.validateProps = t.strictInterface({
	universeId = t.string,
	developerProducts = t.optional(t.table),
	numRows = t.optional(t.number),
	viewWidth = t.optional(t.number),
	layoutOrder = t.optional(t.integer),
	locationType = t.optional(t.string),
	developerProductTiles = t.optional(t.table)
})

function extended:init()
	function self.renderDeveloperProduct(p3)
		return Roact.createElement(module2, p3)
	end

	function self.getDeveloperProductsGridItemHeight(p3)
		return p3 + GAME_GRID_TILE_FOOTER_HEIGHT
	end

	if module4 then
		self.ref = Roact.createRef()
		self.requestImpressionsSignal = signal.new()
	end
end

function extended.render(props)
	local developerProductTiles = props.props.developerProductTiles

	if not module4 then
		return Roact.createElement(defaultMetricsGridView, {
			renderItem = props.renderDeveloperProduct,
			getItemHeight = props.getDeveloperProductsGridItemHeight,
			getItemMetrics = gridMetrics.getSmallMetrics,
			itemPadding = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING),
			items = developerProductTiles,
			LayoutOrder = props.props.layoutOrder
		})
	end

	return Roact.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.props.layoutOrder,
		[Roact.Change.AbsolutePosition] = function()
			props.requestImpressionsSignal:fire()
		end
	}, {
		GridView = Roact.createElement(defaultMetricsGridView, {
			[Roact.Ref] = props.ref,
			renderItem = props.renderDeveloperProduct,
			getItemHeight = props.getDeveloperProductsGridItemHeight,
			getItemMetrics = gridMetrics.getSmallMetrics,
			itemPadding = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING),
			items = developerProductTiles
		}),
		UnifiedImpressionsDetector = Roact.createElement(tagBasedImpressionsDetector, {
			parentRef = props.ref,
			pageFilter = function(p2): boolean
				return props.props.locationType == constants.StoreEnums.LocationType.Store
					and p2 == module5.PassesPage
			end,
			requestImpressionsSignal = props.requestImpressionsSignal,
			extensions = { edpUnifiedImpressionsReporter(props.props.locationType) }
		})
	})
end

local v5 = memoize(function(list, p2, p3, p4, p5)
	local result = {}

	if p4 and p4 == 0 or not list then
		return result
	end

	for i, item in ipairs(list) do
		if item.priceInRobux == nil or item.storePageEnabled then
			continue
		end

		local v7 = not (p2 and p2[tostring(item.iconImageAssetId)]) and ""
			or p2[tostring(item.iconImageAssetId)].url
		local v8, v9

		if module6() and p5 and p5 > 0 then
			v8 = math.floor((i - 1) / p5) + 1
			v9 = (i - 1) % p5 + 1
		end

		table.insert(result, {
			universeId = p3,
			developerProduct = item,
			developerProductThumbnail = v7,
			gridPositionRow = v8,
			gridPositionColumn = v9
		})

		if p4 and p4 <= #result then
			break
		end
	end

	return result
end)

return (RoactRodux.connect(function(p2, data)
	local developerProducts = data.developerProducts
	local universeId = data.universeId
	local numRows = data.numRows
	local viewWidth = data.viewWidth
	local developerProductsThumbnails = p2.DeveloperProductsThumbnails

	local v6 = nil
	local itemsPerRow = nil

	if module6() then
		if viewWidth then
			itemsPerRow = gridMetrics.getSmallMetrics(viewWidth, GAME_GRID_CHILD_PADDING).itemsPerRow
		end

		if numRows and itemsPerRow then
			v6 = itemsPerRow * numRows
		end
	elseif numRows then
		v6 = gridMetrics.getSmallMetrics(viewWidth, GAME_GRID_CHILD_PADDING).itemsPerRow * numRows
	end

	if not module6() then
		itemsPerRow = nil
	end

	return {
		developerProductTiles = v5(
			developerProducts,
			developerProductsThumbnails,
			universeId,
			v6,
			itemsPerRow
		)
	}
end)(extended))
