local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local CatalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local ItemCardThumbnail = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).ItemCardComponents.ItemCardThumbnail
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local UnifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local FFlagAXThumbTypeNilCheck = AvatarExperienceFlags.FFlagAXThumbTypeNilCheck
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents
local v21 = Roact.PureComponent:extend("BaseItemCard")

v21.validateProps = t.strictInterface({
	itemId = t.optional(t.string),
	itemType = t.optional(t.string),
	gridInformation = t.optional(t.table),
	onActivated = t.callback,
	hideItemTitle = t.optional(t.boolean),
	itemData = t.optional(t.table)
})

function v21.render(p1) -- line: 49
	-- upvalues: Roact (copy), CatalogUtils (copy), FFlagAXThumbTypeNilCheck (copy), getRbxthumbWithTypeSizeAndOptions (copy), React (copy), CatalogItemCard (copy), ItemCardThumbnail (copy)
	local itemData = p1.props.itemData
	local itemId = p1.props.itemId
	local itemType = p1.props.itemType

	p1.textButtonRef = Roact.createRef()

	local v27 = nil
	local name = nil

	if itemType and itemId then
		local v29 = CatalogUtils.GetRbxThumbType(itemType)

		v27 = if not FFlagAXThumbTypeNilCheck or not v29 then getRbxthumbWithTypeSizeAndOptions(itemId, v29, 150) else getRbxthumbWithTypeSizeAndOptions(itemId, v29, 150)
	end

	if itemData then
		name = itemData.name
	end

	return React.createElement(CatalogItemCard, {
		ref = p1.textButtonRef,
		onActivated = p1.props.onActivated,
		presentationSlot = if not v27 then nil else React.createElement(ItemCardThumbnail, {
			url = v27
		}),
		title = name,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	})
end
function v21.addUnifiedEventLogging(p2) -- line: 85
	-- upvalues: addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogConstants (copy)
	local itemData = p2.props.itemData

	addUnifiedEventLogging(p2.textButtonRef, {
		action = UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
		itemId = p2.props.itemId,
		itemType = if p2.props.itemType ~= "Asset" then UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE else UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
		assetType = if not FFlagAXMISEnableMultiShoppingUnifiedEvents or not itemData then nil else itemData.assetType,
		bundleType = if not FFlagAXMISEnableMultiShoppingUnifiedEvents or not itemData then nil else itemData.bundleType,
		price = if not itemData or not itemData.priceInRobux then nil else itemData.priceInRobux,
		gridPositionRow = if not p2.props.gridInformation then nil else p2.props.gridInformation.row,
		gridPositionColumn = if not p2.props.gridInformation then nil else p2.props.gridInformation.column
	}, {
		hasDeferredActions = true,
		isSelected = not FFlagAXMISEnableMultiShoppingUnifiedEvents and nil,
		sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
	})
end

if not FFlagAXMISEnableMultiShoppingUnifiedEvents then
	function v21.didMount(p3) -- line: 107
		p3:addUnifiedEventLogging()
	end
end

if FFlagAXMISEnableMultiShoppingUnifiedEvents then
	function v21.didUpdate(p4, p5) -- line: 113
		if p5.itemId ~= p4.props.itemId or p5.itemType ~= p4.props.itemType then
			p4:addUnifiedEventLogging()
		end
	end
end

local function mapStateToProps(p6, p7) -- line: 120
	-- upvalues: ItemData (copy)
	return {
		itemData = ItemData(p6.AvatarExperience.Common, p7.itemId, p7.itemType)
	}
end

return (RoactRodux.connect(mapStateToProps)(v21))
