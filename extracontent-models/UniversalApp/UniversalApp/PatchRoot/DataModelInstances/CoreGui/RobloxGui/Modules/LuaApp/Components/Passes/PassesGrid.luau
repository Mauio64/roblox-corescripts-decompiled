local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local GridMetrics = UIBlox.App.Grid.GridMetrics
local DefaultMetricsGridView = UIBlox.App.Grid.DefaultMetricsGridView
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PassTile = require(Modules.LuaApp.Components.Passes.PassTile)
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local TagBasedImpressionsDetector = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).TagBasedImpressionsDetector
local EdpStoreAnalytics = require(CorePackages.Workspace.Packages.EdpStoreAnalytics)
local Constants = EdpStoreAnalytics.Constants
local EdpUnifiedImpressionsReporter = EdpStoreAnalytics.EdpUnifiedImpressionsReporter
local FFlagEnableEdpStoreUnifiedLogging = require(Modules.LuaApp.Flags.FFlagEnableEdpStoreUnifiedLogging)
local AppPage = require(Modules.LuaApp.AppPage)
local GetFFlagEnableEdpStoreClickLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreClickLogging)
local GetFFlagEnableEdpStoreGridPositionLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreGridPositionLogging)
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local GAME_GRID_CHILD_PADDING = DiscoveryTypes.Constants.GAME_GRID_CHILD_PADDING
local GAME_GRID_TILE_FOOTER_HEIGHT = DiscoveryTypes.Constants.GAME_GRID_TILE_FOOTER_HEIGHT
local v25 = Roact.PureComponent:extend("PassesGrid")

v25.validateProps = t.strictInterface({
	universeId = t.string,
	passes = t.optional(t.table),
	numRows = t.optional(t.number),
	viewWidth = t.optional(t.number),
	layoutOrder = t.optional(t.integer),
	textSizeOffset = t.number,
	locationType = if not GetFFlagEnableEdpStoreClickLogging() then nil else t.optional(t.string),
	passTiles = t.optional(t.table)
})

function v25.init(p1) -- line: 51
	-- upvalues: Roact (copy), PassTile (copy), GAME_GRID_TILE_FOOTER_HEIGHT (copy), FFlagEnableEdpStoreUnifiedLogging (copy), Signal (copy)
	function p1.renderPass(p2) -- line: 52
		-- upvalues: Roact (copy), PassTile (copy)
		return Roact.createElement(PassTile, p2)
	end
	function p1.getPassesGridItemHeight(n1: number) -- line: 56
		-- upvalues: GAME_GRID_TILE_FOOTER_HEIGHT (copy), p1 (copy)
		return n1 + GAME_GRID_TILE_FOOTER_HEIGHT + p1.props.textSizeOffset
	end

	if FFlagEnableEdpStoreUnifiedLogging then
		p1.ref = Roact.createRef()
		p1.requestImpressionsSignal = Signal.new()
	end
end
function v25.render(p3) -- line: 66
	-- upvalues: FFlagEnableEdpStoreUnifiedLogging (copy), Roact (copy), DefaultMetricsGridView (copy), GridMetrics (copy), GAME_GRID_CHILD_PADDING (copy), TagBasedImpressionsDetector (copy), AppPage (copy), Constants (copy), Logging (copy), EdpUnifiedImpressionsReporter (copy)
	local passTiles = p3.props.passTiles

	if FFlagEnableEdpStoreUnifiedLogging then
		return Roact.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = p3.props.layoutOrder,
			[Roact.Change.AbsolutePosition] = function() -- line: 77
				-- upvalues: p3 (copy)
				p3.requestImpressionsSignal:fire()
			end
		}, {
			GridView = Roact.createElement(DefaultMetricsGridView, {
				[Roact.Ref] = p3.ref,
				renderItem = p3.renderPass,
				getItemHeight = p3.getPassesGridItemHeight,
				getItemMetrics = GridMetrics.getSmallMetrics,
				itemPadding = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING),
				items = passTiles
			}),
			UnifiedImpressionsDetector = Roact.createElement(TagBasedImpressionsDetector, {
				parentRef = p3.ref,
				pageFilter = function(p4) -- line: 91
					-- upvalues: AppPage (copy), p3 (copy), Constants (copy), Logging (copy)
					if p4 == AppPage.GameDetail then
						return p3.props.locationType == Constants.StoreEnums.LocationType.Edp
					end

					if p4 == AppPage.PassesPage then
						return p3.props.locationType == Constants.StoreEnums.LocationType.Store
					end

					Logging.warn("Skip Impression Logging for page: " .. p4)

					return false
				end,
				requestImpressionsSignal = p3.requestImpressionsSignal,
				extensions = { EdpUnifiedImpressionsReporter(p3.props.locationType) }
			})
		})
	end

	return Roact.createElement(DefaultMetricsGridView, {
		renderItem = p3.renderPass,
		getItemHeight = p3.getPassesGridItemHeight,
		getItemMetrics = GridMetrics.getSmallMetrics,
		itemPadding = Vector2.new(GAME_GRID_CHILD_PADDING, GAME_GRID_CHILD_PADDING),
		items = passTiles,
		LayoutOrder = p3.props.layoutOrder
	})
end

local v26 = memoize(function(p5, t1: {[any]: any}?, p6, p7, p8, p9) -- line: 118
	-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), GetFFlagEnableEdpStoreClickLogging (copy)
	local t2 = {}

	if p7 and p7 == 0 then
		return t2
	end

	if p5 then
		for i, v in ipairs(p5) do
			if v.price ~= nil then
				local s1 = ""

				if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
					if v.displayIconImageAssetId then
						s1 = string.format("rbxthumb://type=Asset&id=%s&w=150&h=150", (tostring(v.displayIconImageAssetId)))
					end
				elseif t1 and t1[tostring(v.id)] then
					s1 = t1[tostring(v.id)].url
				end

				local v40 = nil
				local v41 = nil

				if GetFFlagEnableEdpStoreGridPositionLogging() and p9 and p9 > 0 then
					v40 = math.floor((i - 1) / p9) + 1
					v41 = (i - 1) % p9 + 1
				end

				table.insert(t2, {
					universeId = p6,
					pass = v,
					passThumbnail = s1,
					locationType = if not GetFFlagEnableEdpStoreClickLogging() then nil else p8,
					gridPositionRow = v40,
					gridPositionColumn = v41
				})

				if p7 and p7 <= #t2 then
					return t2
				end
			end
		end
	end

	return t2
end)

return (RoactRodux.connect(function(p10, p11) -- line: 168
	-- upvalues: FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), GetFFlagEnableEdpStoreClickLogging (copy), GetFFlagEnableEdpStoreGridPositionLogging (copy), GridMetrics (copy), GAME_GRID_CHILD_PADDING (copy), v26 (copy)
	local passes = p11.passes
	local universeId = p11.universeId
	local numRows = p11.numRows
	local viewWidth = p11.viewWidth
	local v48 = if not FFlagLuaAppGamePassesDataHydrationMigrationEnabled then p10.PassesThumbnails else nil
	local v49 = if not GetFFlagEnableEdpStoreClickLogging() then nil else p11.locationType
	local v50 = nil
	local itemsPerRow = nil

	if GetFFlagEnableEdpStoreGridPositionLogging() then
		if viewWidth then
			itemsPerRow = GridMetrics.getSmallMetrics(viewWidth, GAME_GRID_CHILD_PADDING).itemsPerRow
		end

		if numRows and itemsPerRow then
			v50 = itemsPerRow * numRows
		end
	elseif numRows then
		v50 = GridMetrics.getSmallMetrics(viewWidth, GAME_GRID_CHILD_PADDING).itemsPerRow * numRows
	end

	return {
		passTiles = v26(passes, v48, universeId, v50, if not GetFFlagEnableEdpStoreClickLogging() then nil else v49, if not GetFFlagEnableEdpStoreGridPositionLogging() then nil else itemsPerRow)
	}
end)(v25))
