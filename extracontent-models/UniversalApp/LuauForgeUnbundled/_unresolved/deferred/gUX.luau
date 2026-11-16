local CorePackages = game:GetService("CorePackages")

local RoactRodux = require(CorePackages.Packages.RoactRodux)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local catalogItemCard = AvatarExperienceCommon.Components.CatalogItemCard.CatalogItemCard
local itemCardThumbnail = require("@luauforge/deferred/gkN").ItemCardComponents.ItemCardThumbnail
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
require("@luauforge/bundled/dHK")
require(CorePackages.Packages.Foundation)
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module3 = require("@luauforge/bundled/dMx")
local module4 = require("@luauforge/bundled/dRQ")
local module5 = require("@luauforge/deferred/gUW")
local logOnOverlayClosed = AvatarExperienceNavigation.Debug.logOnOverlayClosed
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module6 = require("@luauforge/deferred/ggD")
local module7 = require("@luauforge/bundled/fvF")
local wasLastInputGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").wasLastInputGamepad
local module8 = require("@luauforge/bundled/cgr")
local constants = module8.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module8.Utils.getRbxthumbWithTypeSizeAndOptions

local module9 = require("@luauforge/deferred/gUY")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local useAdaptiveScrolling = AvatarExperienceCommon.Hooks.useAdaptiveScrolling
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService

function LUAUFORGE_MODULE_GLOBALS_gUX_shouldProvideControlsToViewItemDetails(p2): boolean
	if not p2.itemId then
		return false
	end

	if p2.isSelected then
		return true
	end

	return false
end

local function PPEEmoteItemTile(props)
	local v5 = useAdaptiveScrolling()
	local ref = Roact.createRef()
	local v6 = useDispatch()
	local v7 = useFocusGuiObject()
	local v8 = useNavigation()
	local v9 = useAvatarRoute()
	local v10 = useRoactService(module7)
	local v11 = wasLastInputGamepad()
	local v12 = useLocalization({ details = "Feature.Avatar.Label.DetailsButton" })

	local v13 = React.useCallback(function()
		local itemSubType = module4.GetItemSubType(props.itemType, props.itemData)
		local v14 = if props.itemData then props.itemData.priceInRobux else nil
		v6(module6({
			itemId = not props.itemId and "" or props.itemId,
			itemType = module3.ItemType.Asset,
			itemSubType = itemSubType,
			priceInRobux = v14,
			catalogAnalytics = v10,
			avatarRoute = v9,
			navigation = v8,
			itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
			resultsListRef = props.resultsListRef,
			mountAsFullView = true,
			closePreviousItemDetails = true
		}))
	end, {
		props.itemType,
		props.itemData,
		props.itemId,
		props.itemDetailsPeekViewRefs,
		props.resultsListRef,
		v8,
		v9,
		v10,
		v6
	})

	local v14 = React.useCallback(function(p2)
		if not v5 then
			return
		end

		if p2 then
			v5.setSelectedItemInstance(nil)
		elseif ref.current then
			v5.setSelectedItemInstance(ref.current)
		end
	end, { ref.current })

	local v15 = React.useCallback(function()
		if props.itemId == props.emoteAssetId then
			props.setEmoteAssetId(nil, v8)
			v14(true)
		else
			if props.avatarType == module3.AvatarType.R6 then
				v8.navigate(avatarScreen.R15UpgradePrompt, {
					bodyTextKey = "Feature.Avatar.Label.PPEEmoteR15Warning",
					onSwitchSelected = function()
						props.setEmoteAssetId(props.itemId, v8)
						v14(false)
					end,
					onOverlayClosed = function()
						logOnOverlayClosed("EmotesScrollView", v11)

						if v11 then
							v7(ref.current)
						end
					end
				})
				return
			end

			props.setEmoteAssetId(props.itemId, v8)
			v14(false)
		end
	end, {
		props.itemId,
		props.emoteAssetId,
		props.setEmoteAssetId,
		props.avatarType,
		v8,
		v14,
		v11,
		v7
	})

	local v18 = if LUAUFORGE_MODULE_GLOBALS_gUX_shouldProvideControlsToViewItemDetails(props) then v13 else nil
	local v19 = useTableWrappedCallbackRef((module9({
		onSelectItem = v15,
		onOpenItemDetailsPage = v18
	})))
	local createElement = React.createElement
	local v21 = {
		ref = v19,
		onActivated = v15,
		isSelected = props.isSelected,
		onOverlayButtonActivated = v13,
		overlayButtonText = v12.details,
		presentationSlot = 0,
		title = 0,
		Size = 0,
		AutomaticSize = 0
	}
	local v22 = if props.thumbnail then React.createElement(itemCardThumbnail, {
		url = props.thumbnail
	}) else nil
	v21.presentationSlot = v22

	v21.title = props.name
	v21.Size = UDim2.fromScale(1, 0)
	v21.AutomaticSize = Enum.AutomaticSize.Y
	return createElement(catalogItemCard, v21)
end

local function mapStateToProps(p2, p3)
	local emoteAssetId = p2.AvatarExperience.ProfilePictureEditor.ProfilePictureParams.emoteAssetId
	local avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType

	local itemId = p3.itemId
	local v5, name, v6

	if itemId then
		v5 = itemData(p2.AvatarExperience.Common, itemId, module3.ItemType.Asset)

		if v5 then
			name = v5.name or nil
		end

		v6 = getRbxthumbWithTypeSizeAndOptions(itemId, constants.RbxthumbTypes.Asset, 150)
	end

	return {
		itemData = v5,
		emoteAssetId = emoteAssetId,
		name = name,
		thumbnail = v6,
		avatarType = avatarType
	}
end

local function mapDispatchToProps(callback)
	return {
		setEmoteAssetId = function(p2, p3)
			return callback(module5(p2, p3))
		end,
		navigateWithLock = function(p2)
			callback(navigateWithLock(p2))
		end
	}
end

return (RoactRodux.connect(mapStateToProps, mapDispatchToProps)(PPEEmoteItemTile))
