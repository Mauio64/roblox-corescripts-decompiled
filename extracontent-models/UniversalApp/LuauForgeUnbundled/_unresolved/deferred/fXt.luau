local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local gridMetrics = UIBlox.App.Grid.GridMetrics
local defaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local module = require("@luauforge/bundled/cyO")

local module2 = require("@luauforge/deferred/fXu")

local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local tagBasedImpressionsDetector = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").TagBasedImpressionsDetector
local module3 = require("@luauforge/deferred/fXN")
local constants = module3.Constants
local edpUnifiedImpressionsReporter = module3.EdpUnifiedImpressionsReporter
local module4 = require("@luauforge/deferred/fXO")
local module5 = require("@luauforge/bundled/dCp")

local module6 = require("@luauforge/deferred/fXQ")

local module7 = require("@luauforge/deferred/fXs")

local fFlagLuaAppGamePassesDataHydrationMigrationEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGamePassesDataHydrationMigrationEnabled

local GAME_GRID_CHILD_PADDING = module.Constants.GAME_GRID_CHILD_PADDING
local GAME_GRID_TILE_FOOTER_HEIGHT = module.Constants.GAME_GRID_TILE_FOOTER_HEIGHT

local extended = Roact.PureComponent:extend("PassesGrid")

local strictInterface = t.strictInterface
local v5 = {
	universeId = t.string,
	passes = t.optional(t.table),
	numRows = t.optional(t.number),
	viewWidth = t.optional(t.number),
	layoutOrder = t.optional(t.integer),
	textSizeOffset = t.number,
	locationType = 0,
	passTiles = 0
}
local v6 = if module6() then t.optional(t.string) else nil
v5.locationType = v6

v5.passTiles = t.optional(t.table)
extended.validateProps = strictInterface(v5)

function extended:init()
	function self.renderPass(p3)
		return Roact.createElement(module2, p3)
	end

	function self.getPassesGridItemHeight(p3)
		return p3 + GAME_GRID_TILE_FOOTER_HEIGHT + self.props.textSizeOffset
	end

	if module4 then
		self.ref = Roact.createRef()
		self.requestImpressionsSignal = signal.new()
	end
end

function extended.render(props)
	local passTiles = props.props.passTiles

	if not module4 then
		return Roact.createElement(defaultMetricsGridView, {
			renderItem = props.renderPass,
			getItemHeight = props.getPassesGridItemHeight,
			getItemMetrics = gridMetrics.getSmallMetrics,
			itemPadding = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING),
			items = passTiles,
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
			renderItem = props.renderPass,
			getItemHeight = props.getPassesGridItemHeight,
			getItemMetrics = gridMetrics.getSmallMetrics,
			itemPadding = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING),
			items = passTiles
		}),
		UnifiedImpressionsDetector = Roact.createElement(tagBasedImpressionsDetector, {
			parentRef = props.ref,
			pageFilter = function(p2): boolean
				if p2 == module5.GameDetail then
					return props.props.locationType == constants.StoreEnums.LocationType.Edp
				end

				if p2 == module5.PassesPage then
					return props.props.locationType == constants.StoreEnums.LocationType.Store
				end

				logging.warn("Skip Impression Logging for page: " .. p2)
				return false
			end,
			requestImpressionsSignal = props.requestImpressionsSignal,
			extensions = { edpUnifiedImpressionsReporter(props.props.locationType) }
		})
	})
end

local v7 = memoize(function(list, p2, p3, p4, p5, p6)
	local result = {}

	if p4 and p4 == 0 or not list then
		return result
	end

	for i, item in ipairs(list) do
		if item.price == nil then
			continue
		end

		local v9 = ""

		if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			if item.displayIconImageAssetId then
				v9 = string.format(
					"rbxthumb://type=Asset&id=%s&w=150&h=150",
					(tostring(item.displayIconImageAssetId))
				)
			end
		elseif p2 and p2[tostring(item.id)] then
			v9 = p2[tostring(item.id)].url
		end

		local v10, v11

		if module7() and p6 and p6 > 0 then
			v10 = math.floor((i - 1) / p6) + 1
			v11 = (i - 1) % p6 + 1
		end

		local v13 = if module6() then p5 else nil
		table.insert(result, {
			universeId = p3,
			pass = item,
			passThumbnail = v9,
			locationType = v13,
			gridPositionRow = v10,
			gridPositionColumn = v11
		})

		if p4 and p4 <= #result then
			break
		end
	end

	return result
end)

return (RoactRodux.connect(function(p2, data)
	local passes = data.passes
	local universeId = data.universeId
	local numRows = data.numRows
	local viewWidth = data.viewWidth
	local passesThumbnails

	if not fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		passesThumbnails = p2.PassesThumbnails
	end

	local locationType = if module6() then data.locationType else nil

	local v8 = nil
	local itemsPerRow = nil

	if module7() then
		if viewWidth then
			itemsPerRow = gridMetrics.getSmallMetrics(viewWidth, GAME_GRID_CHILD_PADDING).itemsPerRow
		end

		if numRows and itemsPerRow then
			v8 = itemsPerRow * numRows
		end
	elseif numRows then
		v8 = gridMetrics.getSmallMetrics(viewWidth, GAME_GRID_CHILD_PADDING).itemsPerRow * numRows
	end

	if not module6() then
		locationType = nil
	end

	if not module7() then
		itemsPerRow = nil
	end

	return {
		passTiles = v7(passes, passesThumbnails, universeId, v8, locationType, itemsPerRow)
	}
end)(extended))
