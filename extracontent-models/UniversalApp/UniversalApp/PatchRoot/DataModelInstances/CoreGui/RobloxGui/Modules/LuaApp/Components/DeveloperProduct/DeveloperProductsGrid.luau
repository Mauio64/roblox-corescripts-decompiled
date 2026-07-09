local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local DeveloperProductTile = require(Modules.LuaApp.Components.DeveloperProduct.DeveloperProductTile)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local TagBasedImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).TagBasedImpressionsDetector
local EdpStoreAnalytics = require(CorePackages.Workspace.Packages.EdpStoreAnalytics)
local Constants = EdpStoreAnalytics.Constants
local EdpUnifiedImpressionsReporter = EdpStoreAnalytics.EdpUnifiedImpressionsReporter
local FFlagEnableEdpStoreUnifiedLogging = require(Modules.LuaApp.Flags.FFlagEnableEdpStoreUnifiedLogging)
local AppPage = require(Modules.LuaApp.AppPage)
local GetFFlagEnableEdpStoreGridPositionLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreGridPositionLogging)
local GAME_GRID_CHILD_PADDING = DiscoveryTypes.Constants.GAME_GRID_CHILD_PADDING
local GAME_GRID_TILE_FOOTER_HEIGHT = DiscoveryTypes.Constants.GAME_GRID_TILE_FOOTER_HEIGHT
local v22 = Roact.PureComponent:extend("DeveloperProductsGrid")

v22.validateProps = t.strictInterface({
	universeId = t.string,
	developerProducts = t.optional(t.table),
	numRows = t.optional(t.number),
	viewWidth = t.optional(t.number),
	layoutOrder = t.optional(t.integer),
	locationType = t.optional(t.string),
	developerProductTiles = t.optional(t.table)
})

function v22.init(p1) -- line: 45
	-- upvalues: Roact (copy), DeveloperProductTile (copy), GAME_GRID_TILE_FOOTER_HEIGHT (copy), FFlagEnableEdpStoreUnifiedLogging (copy), Signal (copy)
	function p1.renderDeveloperProduct(p2) -- line: 46
		-- upvalues: Roact (copy), DeveloperProductTile (copy)
		return Roact.createElement(DeveloperProductTile, p2)
	end
	function p1.getDeveloperProductsGridItemHeight(n1: number) -- line: 50
		-- upvalues: GAME_GRID_TILE_FOOTER_HEIGHT (copy)
		return n1 + GAME_GRID_TILE_FOOTER_HEIGHT
	end

	if FFlagEnableEdpStoreUnifiedLogging then
		p1.ref = Roact.createRef()
		p1.requestImpressionsSignal = Signal.new()
	end
end
function v22.render(p3) -- line: 59
	-- upvalues: FFlagEnableEdpStoreUnifiedLogging (copy), Roact (copy), DefaultMetricsGridView (copy), GridMetrics (copy), GAME_GRID_CHILD_PADDING (copy), TagBasedImpressionsDetector (copy), Constants (copy), AppPage (copy), EdpUnifiedImpressionsReporter (copy)
	local developerProductTiles = p3.props.developerProductTiles

	if FFlagEnableEdpStoreUnifiedLogging then
		return Roact.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p3.props.layoutOrder,
			[Roact.Change.AbsolutePosition] = function() -- line: 70
				-- upvalues: p3 (copy)
				p3.requestImpressionsSignal:fire()
			end
		}, {
			GridView = Roact.createElement(DefaultMetricsGridView, {
				[Roact.Ref] = p3.ref,
				renderItem = p3.renderDeveloperProduct,
				getItemHeight = p3.getDeveloperProductsGridItemHeight,
				getItemMetrics = GridMetrics.getSmallMetrics,
				itemPadding = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING),
				items = developerProductTiles
			}),
			UnifiedImpressionsDetector = Roact.createElement(TagBasedImpressionsDetector, {
				parentRef = p3.ref,
				pageFilter = function(p4) -- line: 84
					-- upvalues: p3 (copy), Constants (copy), AppPage (copy)
					return p3.props.locationType == Constants.StoreEnums.LocationType.Store and p4 == AppPage.PassesPage
				end,
				requestImpressionsSignal = p3.requestImpressionsSignal,
				extensions = { EdpUnifiedImpressionsReporter(p3.props.locationType) }
			})
		})
	end

	return Roact.createElement(DefaultMetricsGridView, {
		renderItem = p3.renderDeveloperProduct,
		getItemHeight = p3.getDeveloperProductsGridItemHeight,
		getItemMetrics = GridMetrics.getSmallMetrics,
		itemPadding = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING),
		items = developerProductTiles,
		LayoutOrder = p3.props.layoutOrder
	})
end

local v23 = memoize(function(p5, p6, p7, p8, p9) -- line: 105
	-- upvalues: GetFFlagEnableEdpStoreGridPositionLogging (copy)
	local t1 = {}

	if p8 and p8 == 0 then
		return t1
	end

	if p5 then
		for i, v in ipairs(p5) do
			if v.priceInRobux ~= nil and not v.storePageEnabled then
				local s1 = ""

				if p6 and p6[tostring(v.iconImageAssetId)] then
					s1 = p6[tostring(v.iconImageAssetId)].url
				end

				local v36 = nil
				local v37 = nil

				if GetFFlagEnableEdpStoreGridPositionLogging() and p9 and p9 > 0 then
					v36 = math.floor((i - 1) / p9) + 1
					v37 = (i - 1) % p9 + 1
				end

				table.insert(t1, {
					universeId = p7,
					developerProduct = v,
					developerProductThumbnail = s1,
					gridPositionRow = v36,
					gridPositionColumn = v37
				})

				if p8 and p8 <= #t1 then
					return t1
				end
			end
		end
	end

	return t1
end)

return (RoactRodux.connect(function(p10, p11) -- line: 150
	-- upvalues: GetFFlagEnableEdpStoreGridPositionLogging (copy), GridMetrics (copy), GAME_GRID_CHILD_PADDING (copy), v23 (copy)
	local developerProducts = p11.developerProducts
	local universeId = p11.universeId
	local numRows = p11.numRows
	local viewWidth = p11.viewWidth
	local DeveloperProductsThumbnails = p10.DeveloperProductsThumbnails
	local v45 = nil
	local itemsPerRow = nil

	if GetFFlagEnableEdpStoreGridPositionLogging() then
		if viewWidth then
			itemsPerRow = GridMetrics.getSmallMetrics(viewWidth, GAME_GRID_CHILD_PADDING).itemsPerRow
		end

		if numRows and itemsPerRow then
			v45 = itemsPerRow * numRows
		end
	elseif numRows then
		v45 = GridMetrics.getSmallMetrics(viewWidth, GAME_GRID_CHILD_PADDING).itemsPerRow * numRows
	end

	return {
		developerProductTiles = v23(developerProducts, DeveloperProductsThumbnails, universeId, v45, if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else itemsPerRow)
	}
end)(v22))
