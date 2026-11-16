local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eda")

local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/fuD")
local module4 = require("@luauforge/bundled/dME")
local module5 = require("@luauforge/deferred/gkM")
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")
local module7 = require("@luauforge/bundled/fwh")

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset

local extended = Roact.PureComponent:extend("BundlesItemsGrid")

function extended:init()
	function self.renderItemTile(props)
		return Roact.createElement(module5, {
			itemId = props.id,
			itemType = props.type,
			gridInformation = props.gridInformation,
			onActivated = function() end
		})
	end
end

function extended.willUpdate(p2, p3)
	if p2.props.bundleItemsList ~= p3.bundleItemsList then
		local ids = {}
		local bundleItemsList = p3.bundleItemsList

		if bundleItemsList then
			for k, bundleItem in bundleItemsList do
				table.insert(ids, (tonumber(bundleItem.id)))
			end
		end

		p2.props.fetchBundleAssetsDetails(p2.props.networking, p2.props.bundleId or p3.bundleId, ids)
	end
end

function extended.render(p2)
	local bundleItemsList = p2.props.bundleItemsList
	local layoutOrder = p2.props.LayoutOrder
	local bundleItems

	if bundleItemsList then
		bundleItems = {}

		for k, bundleItem in bundleItemsList do
			if bundleItem.type == module2.ItemType.Asset then
				table.insert(bundleItems, bundleItem)
			end
		end
	else
		bundleItems = nil
	end

	return withTextSizeOffset(function(p3)
		return withStyle(function(p4)
			local font = p4.Font
			local v5 = font.BaseSize * font.Header2.RelativeSize + p3

			local bundleItemTile = module2.ItemTileType.BundleItemTile
			local gridItemHeightGetter = module3.GridItemHeightGetter(bundleItemTile, v5)

			return Roact.createElement(DefaultMetricsGridView, {
				renderItem = p2.renderItemTile,
				getItemHeight = gridItemHeightGetter,
				items = bundleItems,
				LayoutOrder = layoutOrder,
				totalNumItems = module4.bundleIncludedItemsCount
			})
		end)
	end)
end

local function mapDispatchToProps(callback)
	return {
		fetchBundleAssetsDetails = function(p2, p3, p4)
			callback(module7(p2, p3, p4))
		end
	}
end

local v5 = RoactRodux.connect(function(p2, p3)
	local itemId = tostring(p3.itemId)
	local bundleInfo = p2.AvatarExperience.Common.BundleInfos[itemId]
	return {
		bundleId = itemId,
		bundleItemsList = bundleInfo and bundleInfo.items
	}
end, mapDispatchToProps)(extended)

return (roactServices.connect({ networking = module })(v5))
