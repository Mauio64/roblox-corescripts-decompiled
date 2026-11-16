local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local Cryo = require(CorePackages.Packages.Cryo)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local module5 = require("@luauforge/bundled/eeH")
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local module6 = require("@luauforge/bundled/dMx")
local module7 = require("@luauforge/bundled/geT")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module8 = require("@luauforge/bundled/fvg")
local module9 = require("@luauforge/bundled/gnZ")
local fullView = AvatarExperienceCommon.Enums.FullView
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module10 = require("@luauforge/deferred/gOC")
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local impressionsUtil = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.ImpressionsUtil

local organicEventImpressionsSchema = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").ImpressionsReporter.OrganicEventImpressionsSchema
local addUnifiedEventLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").addUnifiedEventLogging
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local unifiedEventLogConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogConstants

local fFlagAXMISEnableMultiShoppingUnifiedEvents = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMISEnableMultiShoppingUnifiedEvents

local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

local function selectEquippedEmotes(p2)
	return p2.AvatarExperience.AvatarEditor.EquippedEmotes
end

local function selectAvatarType(p2)
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType
end

local function useEmoteTileProps(data, p2)
	local v5 = useAvatarRoute()
	local v6 = useNavigation()
	local v7 = useAdaptiveScrolling()
	local v8 = useDispatch()
	local v9 = module5(module7)
	local v10 = module5(avatarExperienceAnalyticsService)
	local v11 = ReactFocusNavigation.useFocusGuiObject()
	local v12 = Responsive.usePreferredInput()

	local v13 = useSelector(selectAvatarType)
	local v14 = useSelector(selectEquippedEmotes)
	local selectedSlot = v14.selectedSlot
	local slotInfo = v14.slotInfo
	local v15 = slotInfo and slotInfo[selectedSlot]
	local v16 = v15 and v15.assetId == data.itemId

	local v17 = useSelector((React.useCallback(function(p3)
		return itemData(p3.AvatarExperience.Common, data.itemId, module6.ItemType.Asset)
	end, { data.itemId })))

	local v18 = React.useCallback(function(p3, p4)
		if v7 then
			if p3 then
				v7.setSelectedItemInstance(nil)
			else
				local current = p2.current

				if current and p4 then
					v7.setSelectedItemInstance(current)
				end
			end
		end

		if not p3 and p4 then
			v8(module9(v10, v5.opaque.name, fullView.None))
		end

		local v19 = if p4 then v9.equipAsset else v9.unequipAsset
		v8(module10(v19, data.itemId, module6.AssetTypeIdStrings.EmoteAnimation))
	end, { v7, v8, v10, v5, data.itemId })

	local v19 = React.useCallback(function()
		if v12 == Responsive.Input.Directional then
			v11(p2.current)
		end
	end, { v12, v11 })

	local v20 = React.useCallback(function()
		if v13 == module6.AvatarType.R6 then
			v6.navigate(avatarScreen.R15UpgradePrompt, {
				onOverlayClosed = v19,
				bodyTextKey = "Feature.Avatar.Message.R15EmotesPrompt"
			})
		end
	end, { v13, v6, v19 })

	local v21 = React.useCallback(function()
		if v13 == module6.AvatarType.R6 then
			v8(navigateWithLock(v20))
		end

		v18(v16, v8(module8(module6.AssetTypeIdStrings.EmoteAnimation, data.itemId, v6)) or false)
	end, { v13, data.itemId, v16, v9, v6, v18, v20, v8 })

	React.useEffect(function()
		if p2.current and v17 and not Cryo.isEmpty(v17) then
			local v22 = {
				itemId = data.itemId,
				itemType = "Asset",
				surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
			}

			if data.impressionsTag then
				p2.current:SetAttribute(data.impressionsTag, data.itemId)
			end

			local v23 = organicEventImpressionsSchema[data.impressionsSchema]
			impressionsUtil.writeItemAttributes(v23, p2.current, v22)

			local gridInformation = fFlagAXUnifiedEventStrictPayloads and data.gridInformation

			if gridInformation then
				local v27 = if v16 then unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED else unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED
				addUnifiedEventLogging(p2, {
					action = v27,
					itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
					itemId = data.itemId,
					assetType = Enum.AssetType.EmoteAnimation.Value,
					gridPositionRow = gridInformation.row,
					gridPositionColumn = gridInformation.column
				}, {
					hasDeferredActions = not fFlagAXMISEnableMultiShoppingUnifiedEvents or nil,
					sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
				})
			else
				local v27 = if v16 then unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED else unifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED
				local v26 = {
					action = v27,
					itemType = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
					itemId = data.itemId,
					gridPositionRow = 0,
					gridPositionColumn = 0
				}
				local v28 = if data.gridInformation then data.gridInformation.row else nil
				v26.gridPositionRow = v28
				local v29 = if data.gridInformation then data.gridInformation.column else nil
				v26.gridPositionColumn = v29
				addUnifiedEventLogging(p2, v26, {
					hasDeferredActions = not fFlagAXMISEnableMultiShoppingUnifiedEvents or nil,
					sessionTagName = unifiedEventLogConstants.L2_SESSION_TAG_NAME
				})
			end
		end
	end, { data.itemId, v17, v16, data.gridInformation })

	return {
		item = v17,
		onActivated = v21,
		isSelected = v16,
		itemId = data.itemId,
		index = data.index,
		itemWidth = data.itemWidth,
		impressionsTag = data.impressionsTag
	}
end

return useEmoteTileProps
