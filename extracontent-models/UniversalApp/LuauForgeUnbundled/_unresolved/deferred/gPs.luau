local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = require("@luauforge/deferred/gPt").ItemCardComponents.ItemCardThumbnail

local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module4 = require("@luauforge/bundled/dVl")
require("@luauforge/bundled/dPs")
require("@luauforge/bundled/dKT")

local getRbxthumbWithTypeSizeAndOptions = require("@luauforge/bundled/ciE").Utils.getRbxthumbWithTypeSizeAndOptions
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local addUnifiedEventLogging = AvatarExperienceAnalytics.addUnifiedEventLogging
local unifiedEventLogConstants = AvatarExperienceAnalytics.UnifiedEventLogConstants
local fFlagAXThumbTypeNilCheck = AvatarExperienceFlags.FFlagAXThumbTypeNilCheck

local fFlagAXMISEnableMultiShoppingUnifiedEvents = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedImpressionsOnThumbnail = AvatarExperienceFlags.FFlagAXUnifiedImpressionsOnThumbnail
local fFlagAXRecommendedItemsUnifiedSelectParity = AvatarExperienceFlags.FFlagAXRecommendedItemsUnifiedSelectParity

local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local module5 = require("@luauforge/deferred/gPu")

local extended = Roact.PureComponent:extend("BaseItemCard")

function extended:init()
	function self.onActivatedWithUnifiedSelect(...)
		module5(AvatarExperienceAnalytics.sendUnifiedEventLogForInstance, self.textButtonRef and self.textButtonRef.current)

		self.props.onActivated(...)
	end
end

extended.validateProps = t.strictInterface({
	itemId = t.optional(t.string),
	itemType = t.optional(t.string),
	gridInformation = t.optional(t.table),
	onActivated = t.callback,
	hideItemTitle = t.optional(t.boolean),
	itemData = t.optional(t.table)
})

function extended:render()
	local itemData2 = self.props.itemData

	local itemId = self.props.itemId
	local itemType = self.props.itemType
	self.textButtonRef = Roact.createRef()

	local name = nil
	local v5

	if itemType and itemId then
		local rbxThumbType = module4.GetRbxThumbType(itemType)

		if fFlagAXThumbTypeNilCheck and rbxThumbType then
		end

		v5 = getRbxthumbWithTypeSizeAndOptions(itemId, rbxThumbType, 150)
	end

	if itemData2 then
		name = itemData2.name
	end

	local createElement = React.createElement
	local v7 = {
		ref = self.textButtonRef,
		onActivated = 0,
		presentationSlot = 0,
		title = 0,
		Size = 0,
		AutomaticSize = 0
	}

	local v8 = if fFlagAXRecommendedItemsUnifiedSelectParity and fFlagAXUnifiedImpressionsOnThumbnail then self.onActivatedWithUnifiedSelect else self.props.onActivated
	v7.onActivated = v8

	local v9 = if v5 then React.createElement(itemCardThumbnail, { url = v5 }) else nil
	v7.presentationSlot = v9

	v7.title = name
	v7.Size = UDim2.fromScale(1, 0)
	v7.AutomaticSize = Enum.AutomaticSize.Y
	return createElement(catalogItemCard, v7)
end

function extended:addUnifiedEventLogging()
	local itemData2 = self.props.itemData

	local textButtonRef = self.textButtonRef
	local v6 = {
		action = unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED,
		itemId = self.props.itemId,
		itemType = 0,
		assetType = 0,
		bundleType = 0,
		price = 0,
		organicItemPrice = 0,
		gridPositionRow = 0,
		gridPositionColumn = 0,
		surface = 0
	}
	local v7 = if self.props.itemType == "Asset" then unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET else unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
	v6.itemType = v7

	local v8 = if (fFlagAXMISEnableMultiShoppingUnifiedEvents or fFlagAXUnifiedImpressionsOnThumbnail) and itemData2 then itemData2.assetType else nil
	v6.assetType = v8

	local v9 = if (fFlagAXMISEnableMultiShoppingUnifiedEvents or fFlagAXUnifiedImpressionsOnThumbnail) and itemData2 then itemData2.bundleType else nil
	v6.bundleType = v9

	local v10 = if itemData2 and itemData2.priceInRobux then itemData2.priceInRobux else nil
	v6.price = v10

	local v11 = if fFlagAXUnifiedImpressionsOnThumbnail and itemData2 and itemData2.priceInRobux then itemData2.priceInRobux else nil
	v6.organicItemPrice = v11

	local v12 = if self.props.gridInformation then self.props.gridInformation.row else nil
	v6.gridPositionRow = v12
	local v13 = if self.props.gridInformation then self.props.gridInformation.column else nil
	v6.gridPositionColumn = v13
	local v14 = if fFlagAXUnifiedImpressionsOnThumbnail then unifiedLoggingSurface.ITEM_DETAILS else nil
	v6.surface = v14
	addUnifiedEventLogging(textButtonRef, v6, {
		hasDeferredActions = true,
		isSelected = if fFlagAXMISEnableMultiShoppingUnifiedEvents then false else nil,
		sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
	})
end

if fFlagAXUnifiedImpressionsOnThumbnail then
	function extended:isReadyToLogUnifiedEvent(): boolean
		local itemData2 = self.props.itemData

		if itemData2 then
			return itemData2.assetType ~= nil or itemData2.bundleType ~= nil
		end

		return false
	end
end

if not fFlagAXMISEnableMultiShoppingUnifiedEvents or fFlagAXUnifiedImpressionsOnThumbnail then
	function extended:didMount()
		if not fFlagAXUnifiedImpressionsOnThumbnail then
			self:addUnifiedEventLogging()
		elseif self:isReadyToLogUnifiedEvent() then
			self:addUnifiedEventLogging()
			self.hasStampedUnifiedEvent = true
		end
	end
end

if fFlagAXMISEnableMultiShoppingUnifiedEvents or fFlagAXUnifiedImpressionsOnThumbnail then
	function extended:didUpdate(p2)
		if fFlagAXUnifiedImpressionsOnThumbnail then
			if p2.itemId ~= self.props.itemId or p2.itemType ~= self.props.itemType then
				self.hasStampedUnifiedEvent = false
			end

			if not self.hasStampedUnifiedEvent and self:isReadyToLogUnifiedEvent() then
				self:addUnifiedEventLogging()
				self.hasStampedUnifiedEvent = true
			end
		elseif p2.itemId ~= self.props.itemId or p2.itemType ~= self.props.itemType then
			self:addUnifiedEventLogging()
		end
	end
end

local function mapStateToProps(p2, p3)
	return {
		itemData = itemData(p2.AvatarExperience.Common, p3.itemId, p3.itemType)
	}
end

return (RoactRodux.connect(mapStateToProps)(extended))
