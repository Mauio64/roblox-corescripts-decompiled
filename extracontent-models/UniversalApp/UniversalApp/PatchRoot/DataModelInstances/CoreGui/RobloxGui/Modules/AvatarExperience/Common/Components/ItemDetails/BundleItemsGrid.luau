local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local BaseItemCard = require(Modules.AvatarExperience.Catalog.Components.ItemsList.BaseItemCard)
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local FetchBundleAssetsDetails = require(Modules.AvatarExperience.Catalog.Thunks.FetchBundleAssetsDetails)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local withTextSizeOffset = UIBlox.Core.Style.withTextSizeOffset
local v16 = Roact.PureComponent:extend("BundlesItemsGrid")

function v16.init(p1) -- line: 24
	-- upvalues: Roact (copy), BaseItemCard (copy)
	function p1.renderItemTile(p2) -- line: 25
		-- upvalues: Roact (copy), BaseItemCard (copy)
		return Roact.createElement(BaseItemCard, {
			itemId = p2.id,
			itemType = p2.type,
			gridInformation = p2.gridInformation,
			onActivated = function() -- line: 30
			end
		})
	end
end
function v16.willUpdate(p3, p4) -- line: 35
	if p3.props.bundleItemsList ~= p4.bundleItemsList then
		local t1 = {}
		local bundleItemsList = p4.bundleItemsList

		if bundleItemsList then
			for _, v25 in bundleItemsList do
				table.insert(t1, (tonumber(v25.id)))
			end
		end

		p3.props.fetchBundleAssetsDetails(p3.props.networking, p3.props.bundleId or p4.bundleId, t1)
	end
end
function v16.render(p5) -- line: 52
	-- upvalues: Constants (copy), withTextSizeOffset (copy), withStyle (copy), Utils (copy), Roact (copy), LoadableGridView (copy), CatalogConstants (copy)
	local bundleItemsList = p5.props.bundleItemsList
	local propsLayoutOrder = p5.props.LayoutOrder
	local t2 = nil

	if bundleItemsList then
		t2 = {}

		for _, v31 in bundleItemsList do
			if v31.type == Constants.ItemType.Asset then
				table.insert(t2, v31)
			end
		end
	end

	return withTextSizeOffset(function(p6) -- line: 65
		-- upvalues: withStyle (copy), Constants (copy), Utils (copy), Roact (copy), LoadableGridView (copy), p5 (copy), t2 (ref), propsLayoutOrder (copy), CatalogConstants (copy)
		return withStyle(function(p7) -- line: 66
			-- upvalues: p6 (copy), Constants (copy), Utils (copy), Roact (copy), LoadableGridView (copy), p5 (copy), t2 (ref), propsLayoutOrder (copy), CatalogConstants (copy)
			local p7Font = p7.Font
			local v44 = p7Font.BaseSize * p7Font.Header2.RelativeSize + p6
			local BundleItemTile = Constants.ItemTileType.BundleItemTile
			local v46 = Utils.GridItemHeightGetter(BundleItemTile, v44)

			return Roact.createElement(LoadableGridView, {
				renderItem = p5.renderItemTile,
				getItemHeight = v46,
				items = t2,
				LayoutOrder = propsLayoutOrder,
				totalNumItems = CatalogConstants.bundleIncludedItemsCount
			})
		end)
	end)
end

local function mapDispatchToProps(p8) -- line: 84
	-- upvalues: FetchBundleAssetsDetails (copy)
	return {
		fetchBundleAssetsDetails = function(p9, p10, p11) -- line: 86
			-- upvalues: p8 (copy), FetchBundleAssetsDetails (copy)
			p8(FetchBundleAssetsDetails(p9, p10, p11))
		end
	}
end

local v18 = RoactRodux.connect(function(p12, p13) -- line: 92
	local str = tostring(p13.itemId)
	local v36 = p12.AvatarExperience.Common.BundleInfos[str]

	return {
		bundleId = str,
		bundleItemsList = v36 and v36.items
	}
end, mapDispatchToProps)(v16)

return (RoactServices.connect({
	networking = RoactNetworking
})(v18))
