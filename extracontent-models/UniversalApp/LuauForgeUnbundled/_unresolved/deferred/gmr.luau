local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useInputType = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useInputType
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module = require("@luauforge/bundled/dMB")
local tutils = require(CorePackages.Packages.tutils)

local module2 = require("@luauforge/bundled/dwA")
local module3 = require("@luauforge/bundled/dMx")
local module4 = require("@luauforge/deferred/gms")

local module5 = require("@luauforge/deferred/fvB")

local module6 = require("@luauforge/deferred/fwm")
local logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Debug.logOnOverlayClosed
local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module7 = require("@luauforge/deferred/gmu")
local module8 = require("@luauforge/deferred/gfy")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module11 = require("@luauforge/deferred/gmv")
local getFaeFeatureAccessStore = AvatarExperienceCatalog.Stores.GetFaeFeatureAccessStore
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local itemStatus = AvatarExperienceCommon.Enums.ItemStatus
require("@luauforge/bundled/dMc")
require("@luauforge/bundled/dHK")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local itemData = AvatarExperienceCommon.State.Selectors.ItemData

local module13 = require("@luauforge/deferred/gmw")

local module14 = require("@luauforge/deferred/fvU")
local module15 = require("@luauforge/deferred/fwn")
local module16 = require("@luauforge/deferred/fvE")
local module17 = require("@luauforge/deferred/gmz")

local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local defineFastFlag = game:DefineFastFlag("AXFixItemDetailsMoreButtonHighlighted", false)
local defineFastFlag2 = game:DefineFastFlag("AXNoTimedOptionsForOwnedItems", false)
local fFlagAXShowFaeUpsell = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXShowFaeUpsell
local fFlagAXDurablesForMIS = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXDurablesForMIS
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXGifting = AvatarExperienceFlags.FFlagAXGifting

local avatarItemGiftEntryPoint = module11.Components.AvatarItemGiftEntryPoint

local function selectIsItemFAE(p2, p3, p4): boolean
	local v6 = itemData(p2.AvatarExperience.Common, p3, p4)

	if v6 and v6.itemStatus then
		return table.find(v6.itemStatus, itemStatus.IsFAE) ~= nil
	end

	return false
end

local function selectCollectibleItemId(p2, p3, p4)
	local v6 = itemData(p2.AvatarExperience.Common, p3, p4)

	if v6 then
		return v6.collectibleItemId
	end

	return nil
end

local function selectBuyActionBarFaeFeatureAccess(p2, p3, p4, p5)
	local v6 = itemData(p2.AvatarExperience.Common, p3, p4)
	local v7 = if v6 and v6.itemStatus then table.find(v6.itemStatus, itemStatus.IsFAE) ~= nil else false

	return {
		showFaeUpsell = p5.showFaeUpsell and v7 or false,
		canClaimFaeItem = p5.canClaimFaeItem and v7 or false
	}
end

local function BuyActionBar(props)
	module15()

	local v6 = if fFlagAXShowFaeUpsell then getFaeFeatureAccessStore.useFaeFeatureAccess() else nil

	local state, setState = React.useState(false)
	local v7 = useNavigation()
	local v8 = useInputType()
	local v9 = useDispatch()

	local v10 = React.useCallback(function()
		if defineFastFlag then
			setState(false)
		else
			setState(true)
		end

		logOnOverlayClosed("BuyActionBar", v8 == module2.InputType.Gamepad)
	end, { v8 })

	local v11 = React.useCallback(function()
		local param = v7.getParam("fromProfile")
		local v12 = v7.state.routeName == avatarScreen.TryOnItem
		local v13

		if fFlagEnableSplitPane and param and not v12 and v5.isSupportPaneLayoutActive() then
			v13 = false
		else
			v13 = param or v12
		end

		v9(navigateWithLock(function()
			v7.navigate(avatarScreen.CatalogContextMenu, {
				itemId = props.itemId,
				itemType = props.itemType,
				onOverlayClosed = v10,
				centered = v13,
				hideItemDetailsButtonVisible = v12,
				itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs
			})
		end))
		setState(true)
	end, { v9, props.itemDetailsPeekViewRefs, v10, props.itemType, props.itemId, v7 })
	local v12

	if module7.isEnabled() and module.readTestVariable(module7.ShowShareButtonOnActionBar) then
		local v13 = React.useCallback(function()
			sendAXCounterV2(module3.Counter.ShareButtonProfileration.ShareButtonClicked, {
				itemId = props.itemId,
				itemType = props.itemType
			})
		end, { props.itemId, props.itemType })

		v12 = module8(props.itemId, props.itemType, false, v13)
	end

	local v13

	if fFlagAXShowFaeUpsell then
		v13 = useSelector(function(p2)
			local itemId = props.itemId
			local itemType = props.itemType
			local v14 = v6
			local v15 = itemData(p2.AvatarExperience.Common, itemId, itemType)
			local v16

			if v15 and v15.itemStatus then
				v16 = table.find(v15.itemStatus, itemStatus.IsFAE) ~= nil
			else
				v16 = false
			end

			return {
				showFaeUpsell = v14.showFaeUpsell and v16 or false,
				canClaimFaeItem = v14.canClaimFaeItem and v16 or false
			}
		end, tutils.shallowEqual)
	end

	local itemId = props.itemId
	local itemType = props.itemType
	local selectedTimedOptionDays = props.selectedTimedOptionDays
	local hidePrice = props.hidePrice
	local showTimedOptionInBuyButton = props.showTimedOptionInBuyButton
	local v15 = if fFlagAXShowFaeUpsell then v13 else nil
	local v16 = module16(
		v10,
		itemId,
		itemType,
		selectedTimedOptionDays,
		hidePrice,
		showTimedOptionInBuyButton,
		v15
	)
	local v17

	if fFlagAXDurables2Option then
		v17 = module16(v10, props.itemId, props.itemType, 3, false, true)
	end

	local v18 = if fFlagAXShowFaeUpsell then module17(v6.showFaeUpsell, v6.canClaimFaeItem) else nil

	local v19 = React.useCallback(function(p2)
		local v20 = itemData(p2.AvatarExperience.Common, props.itemId, props.itemType)
		return v20 and v20.isOwned and not v20.expirationTime or false
	end, { props.itemId, props.itemType })

	local v20 = if defineFastFlag2 or fFlagAXShowFaeUpsell then useSelector(v19) else nil
	local v21

	if fFlagAXGifting then
		v21 = React.useCallback(function(p2)
			local itemId2 = props.itemId
			local itemType2 = props.itemType
			local v22 = itemData(p2.AvatarExperience.Common, itemId2, itemType2)

			if v22 then
				return v22.collectibleItemId
			end

			return nil
		end, { props.itemId, props.itemType })
	end

	local v22 = if fFlagAXGifting then useSelector(v21) else nil
	local v23

	if fFlagAXGifting then
		v23 = React.useMemo(function()
			return React.createElement(avatarItemGiftEntryPoint, {
				collectibleItemId = v22,
				LayoutOrder = 1
			})
		end, { v22 })
	end

	if fFlagAXShowFaeUpsell and v18 and v13 and (v13.showFaeUpsell or v13.canClaimFaeItem) and not v20 then
		return React.createElement(module13, {
			titleText = v18,
			actionButtonText = v16.buttonText,
			onActionActivated = v16.onActivated,
			onMoreActivated = v11,
			isActionDisabled = v16.buttonIsDisabled,
			isActionLoading = v16.buttonIsLoading
		})
	end

	local v24 = if defineFastFlag2 then props.timedOptions and not v20 else props.timedOptions

	if
		v24
		and (not fFlagAXDurables2Option or v16.buttonActionType == module14.PurchaseFromRoblox or v16.buttonActionType == module14.Loading)
	then
		local createElement = React.createElement
		local v25 = if fFlagAXDurables2Option then module6 else module5
		local v26 = {
			timedOptions = props.timedOptions,
			itemId = 0,
			itemType = 0,
			buttonProps = 0,
			rentalButtonProps = 0,
			onMoreButtonActivated = 0,
			onSelectedDaysChanged = 0,
			selectedTimedOptionIndexInReducer = 0
		}
		local v27 = if fFlagAXDurablesForMIS then props.itemId else nil
		v26.itemId = v27
		local v28 = if fFlagAXDurablesForMIS then props.itemType else nil
		v26.itemType = v28
		v26.buttonProps = v16

		if not fFlagAXDurables2Option then
			v17 = nil
		end

		v26.rentalButtonProps = v17

		if not fFlagAXDurables2Option then
			v11 = nil
		end

		v26.onMoreButtonActivated = v11
		v26.onSelectedDaysChanged = props.setSelectedTimedOptionDays

		local v29 = if fFlagAXDurablesForMIS then props.selectedTimedOptionIndexInReducer else nil
		v26.selectedTimedOptionIndexInReducer = v29
		return createElement(v25, v26)
	else
		local createElement = React.createElement
		local v26 = {
			ZIndex = props.ZIndex,
			leftPadding = props.leftPadding,
			rightPadding = props.rightPadding,
			topPadding = props.topPadding,
			bottomPadding = props.bottomPadding or 0,
			showMoreButton = props.showMoreButton or true,
			showMiddleButton = v12 and true or nil,
			onMiddleButtonActivated = 0,
			middleButtonIcon = 0,
			buttonProps = 0,
			onMoreButtonActivated = 0,
			isMoreButtonSelected = 0,
			hideGradient = 0,
			showSecondaryButton = 0,
			secondaryButtonText = 0,
			onSecondaryButtonActivated = 0,
			giftButton = 0
		}

		local v27 = if v12 then v12.onActivated else nil
		v26.onMiddleButtonActivated = v27
		local v28 = if v12 then v12.icon else nil
		v26.middleButtonIcon = v28
		v26.buttonProps = v16
		v26.onMoreButtonActivated = v11
		v26.isMoreButtonSelected = state
		v26.hideGradient = props.hideGradient
		local v29 = if fFlagAXDurablesForMIS then props.showSecondaryButton else nil
		v26.showSecondaryButton = v29
		local v30 = if fFlagAXDurablesForMIS then props.secondaryButtonText else nil
		v26.secondaryButtonText = v30
		local v31 = if fFlagAXDurablesForMIS then props.onSecondaryButtonActivated else nil
		v26.onSecondaryButtonActivated = v31

		if not fFlagAXGifting then
			v23 = nil
		end

		v26.giftButton = v23
		return createElement(module4, v26)
	end
end

return React.memo(BuyActionBar)
