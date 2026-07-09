local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.Common.Services.Analytics)
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local FullView = AvatarExperienceCommon.Enums.FullView
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local SendAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendAnalytics)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local ImpressionsUtil = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.ImpressionsUtil
local OrganicEventImpressionsSchema = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).ImpressionsReporter.OrganicEventImpressionsSchema
local addUnifiedEventLogging = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).addUnifiedEventLogging
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local UnifiedEventLogConstants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogConstants
local FFlagAXMISEnableMultiShoppingUnifiedEvents = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMISEnableMultiShoppingUnifiedEvents

local function selectEquippedEmotes(p1) -- line: 42
	return p1.AvatarExperience.AvatarEditor.EquippedEmotes
end
local function selectAvatarType(p2) -- line: 46
	return p2.AvatarExperience.AvatarEditor.Character.AvatarType
end
local function useEmoteTileProps(t1: {[any]: any}, p3) -- line: 65
	-- upvalues: useAvatarRoute (copy), useNavigation (copy), useAdaptiveScrolling (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), Analytics2 (copy), ReactFocusNavigation (copy), Responsive (copy), useSelector (copy), selectAvatarType (copy), selectEquippedEmotes (copy), React (copy), ItemData (copy), Constants (copy), SetFullView (copy), FullView (copy), SendAnalytics (copy), AvatarScreen (copy), NavigateWithLock (copy), ToggleEquipAsset (copy), Cryo (copy), ImpressionEnums (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), addUnifiedEventLogging (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogConstants (copy)
	local v40 = useAvatarRoute()
	local v41 = useNavigation()
	local v42 = useAdaptiveScrolling()
	local v43 = useDispatch()
	local v44 = useRoactService(Analytics)
	local v45 = useRoactService(Analytics2)
	local v46 = ReactFocusNavigation.useFocusGuiObject()
	local v47 = Responsive.usePreferredInput()
	local v48 = useSelector(selectAvatarType)
	local v49 = useSelector(selectEquippedEmotes)
	local selectedSlot = v49.selectedSlot
	local slotInfo = v49.slotInfo
	local v52 = slotInfo and slotInfo[selectedSlot]
	local v53 = v52 and v52.assetId == t1.itemId
	local v54 = React.useCallback(function(p4) -- line: 82
		-- upvalues: ItemData (copy), t1 (copy), Constants (copy)
		return ItemData(p4.AvatarExperience.Common, t1.itemId, Constants.ItemType.Asset)
	end, { t1.itemId })
	local v55 = useSelector(v54)
	local v56 = React.useCallback(function(b1: boolean, b2: boolean) -- line: 88
		-- upvalues: v42 (copy), p3 (copy), v43 (copy), SetFullView (copy), v45 (copy), v40 (copy), FullView (copy), v44 (copy), SendAnalytics (copy), t1 (copy), Constants (copy)
		if v42 then
			if b1 then
				v42.setSelectedItemInstance(nil)
			else
				local current = p3.current

				if current and b2 then
					v42.setSelectedItemInstance(current)
				end
			end
		end

		if not b1 and b2 then
			v43(SetFullView(v45, v40.opaque.name, FullView.None))
		end

		local v64 = if not b2 then v44.unequipAsset else v44.equipAsset

		v43(SendAnalytics(v64, t1.itemId, Constants.AssetTypeIdStrings.EmoteAnimation))
	end, {
		v42,
		v43,
		v45,
		v40,
		t1.itemId
	})
	local v57 = React.useCallback(function() -- line: 109
		-- upvalues: v47 (copy), Responsive (copy), v46 (copy), p3 (copy)
		if v47 == Responsive.Input.Directional then
			v46(p3.current)
		end
	end, {
		v47,
		v46
	})
	local v58 = React.useCallback(function() -- line: 115
		-- upvalues: v48 (copy), Constants (copy), v41 (copy), AvatarScreen (copy), v57 (copy)
		if v48 == Constants.AvatarType.R6 then
			v41.navigate(AvatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Message.R15EmotesPrompt",
				onOverlayClosed = v57
			})
		end
	end, {
		v48,
		v41,
		v57
	})
	local v59 = React.useCallback(function() -- line: 125
		-- upvalues: v48 (copy), Constants (copy), v43 (copy), NavigateWithLock (copy), v58 (copy), ToggleEquipAsset (copy), t1 (copy), v41 (copy), v56 (copy), v53 (copy)
		if v48 == Constants.AvatarType.R6 then
			v43(NavigateWithLock(v58))
		end

		local v65 = v43(ToggleEquipAsset(Constants.AssetTypeIdStrings.EmoteAnimation, t1.itemId, v41))

		v56(v53, v65 or false)
	end, {
		v48,
		t1.itemId,
		v53,
		v44,
		v41,
		v56,
		v58,
		v43
	})

	React.useEffect(function() -- line: 147
		-- upvalues: p3 (copy), v55 (copy), Cryo (copy), t1 (copy), ImpressionEnums (copy), OrganicEventImpressionsSchema (copy), ImpressionsUtil (copy), addUnifiedEventLogging (copy), v53 (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogConstants (copy)
		if p3.current and (v55 and not Cryo.isEmpty(v55)) then
			local t2 = {
				itemType = "Asset",
				itemId = t1.itemId,
				surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY
			}

			if t1.impressionsTag then
				p3.current:SetAttribute(t1.impressionsTag, t1.itemId)
			end

			local v67 = OrganicEventImpressionsSchema[t1.impressionsSchema]

			ImpressionsUtil.writeItemAttributes(v67, p3.current, t2)
			addUnifiedEventLogging(p3, {
				action = if not v53 then UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_SELECTED else UnifiedEventLogEnums.MarketplaceUnifiedAction.ITEM_DESELECTED,
				itemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET,
				itemId = t1.itemId,
				gridPositionRow = if not t1.gridInformation then nil else t1.gridInformation.row,
				gridPositionColumn = if not t1.gridInformation then nil else t1.gridInformation.column
			}, {
				hasDeferredActions = not FFlagAXMISEnableMultiShoppingUnifiedEvents or nil,
				sessionTagName = UnifiedEventLogConstants.L2_SESSION_TAG_NAME
			})
		end
	end, {
		t1.itemId,
		v55,
		v53,
		t1.gridInformation
	})

	return {
		item = v55,
		onActivated = v59,
		isSelected = v53,
		itemId = t1.itemId,
		index = t1.index,
		itemWidth = t1.itemWidth,
		impressionsTag = t1.impressionsTag
	}
end

return useEmoteTileProps
