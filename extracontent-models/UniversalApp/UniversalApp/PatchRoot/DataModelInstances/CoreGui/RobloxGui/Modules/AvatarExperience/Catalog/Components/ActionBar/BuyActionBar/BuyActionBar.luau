local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useFocusController = require(CorePackages.Packages.RoactGamepad).useFocusController
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useInputType = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useInputType
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local tutils = require(CorePackages.Packages.tutils)
local Constants = require(Modules.LuaApp.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local ActionBar = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionBar)
local ActionBarWithTimedOptions = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionBarWithTimedOptions)
local ActionBarWithRentalOption = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionBarWithRentalOption)
local logOnOverlayClosed = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Debug.logOnOverlayClosed
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local AXShareButtonOnActionBarIXP = require(Modules.AvatarExperience.Experiments.AXShareButtonOnActionBarIXP)
local useShareButton = require(Modules.AvatarExperience.Common.Hooks.useShareButton)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local ItemStatus = AvatarExperienceCommon.Enums.ItemStatus

require(Modules.AvatarExperience.Common.Types)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local GetFaeFeatureAccessStore = require(Modules.AvatarExperience.Catalog.Stores.GetFaeFeatureAccessStore)
local ActionBarWithContextualTextContainer = require(Modules.AvatarExperience.Catalog.Components.ActionBar.ActionBarWithContextualText.ActionBarWithContextualTextContainer)
local BuyActionButtonTypeEnum = require(script.Parent.BuyActionButtonTypeEnum)
local useFetchRobuxOnMount = require(script.Parent.useFetchRobuxOnMount)
local useBuyActionBarButtonProps = require(script.Parent.useBuyActionBarButtonProps)
local useBuyActionBarContextualText = require(script.Parent.useBuyActionBarContextualText)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v33 = game:DefineFastFlag("AXFixItemDetailsMoreButtonHighlighted", false)
local v34 = game:DefineFastFlag("AXNoTimedOptionsForOwnedItems", false)
local FFlagAXShowFaeUpsell = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXShowFaeUpsell
local FFlagAXDurablesForMIS = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXDurablesForMIS
local FFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option

local function selectIsItemFAE(p1, s1: string?, s2: string) -- line: 76
	-- upvalues: ItemData (copy), ItemStatus (copy)
	local v44 = ItemData(p1.AvatarExperience.Common, s1, s2)

	if not v44 or not v44.itemStatus then
		return false
	end

	return table.find(v44.itemStatus, ItemStatus.IsFAE) ~= nil
end
local function selectBuyActionBarFaeFeatureAccess(p2, s3: string?, s4: string, t1: {[any]: any}) -- line: 88
	-- upvalues: ItemData (copy), ItemStatus (copy)
	local v49 = ItemData(p2.AvatarExperience.Common, s3, s4)
	local v50 = not not v49 and if v49.itemStatus then table.find(v49.itemStatus, ItemStatus.IsFAE) ~= nil else false

	return {
		showFaeUpsell = not not t1.showFaeUpsell and (v50 or false),
		canClaimFaeItem = not not t1.canClaimFaeItem and (v50 or false)
	}
end
local function BuyActionBar(t2: {[any]: any}) -- line: 101
	-- upvalues: useFetchRobuxOnMount (copy), FFlagAXShowFaeUpsell (copy), GetFaeFeatureAccessStore (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), useFocusController (copy), React (copy), useNavigation (copy), useInputType (copy), useDispatch (copy), v33 (copy), Constants (copy), logOnOverlayClosed (copy), AvatarScreen (copy), NavigateWithLock (copy), AXShareButtonOnActionBarIXP (copy), IxpUtils (copy), sendAXCounterV2 (copy), Constants2 (copy), useShareButton (copy), useSelector (copy), ItemData (copy), ItemStatus (copy), tutils (copy), useBuyActionBarButtonProps (copy), FFlagAXDurables2Option (copy), useBuyActionBarContextualText (copy), v34 (copy), ActionBarWithContextualTextContainer (copy), BuyActionButtonTypeEnum (copy), ActionBarWithRentalOption (copy), ActionBarWithTimedOptions (copy), FFlagAXDurablesForMIS (copy), ActionBar (copy)
	useFetchRobuxOnMount()

	local u52 = nil

	if FFlagAXShowFaeUpsell then
		u52 = GetFaeFeatureAccessStore.useFaeFeatureAccess()
	end

	local v53 = if not FFlagAXMigrateAXToGlobalAutofocus then useFocusController() else nil
	local v54, v55 = React.useState(false)
	local v56 = useNavigation()
	local v57 = useInputType()
	local v58 = useDispatch()
	local v59 = React.useCallback(function() -- line: 114
		-- upvalues: v33 (copy), v55 (copy), v57 (copy), Constants (copy), logOnOverlayClosed (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v53 (copy)
		if v33 then
			v55(false)
		else
			v55(true)
		end

		local v69 = v57 == Constants.InputType.Gamepad

		logOnOverlayClosed("BuyActionBar", v69)

		if not FFlagAXMigrateAXToGlobalAutofocus and v69 then
			v53.captureFocus()
		end
	end, {
		if not FFlagAXMigrateAXToGlobalAutofocus then v53 else nil,
		v57
	})
	local v60 = React.useCallback(function() -- line: 128
		-- upvalues: v56 (copy), AvatarScreen (copy), t2 (copy), v59 (copy), v58 (copy), NavigateWithLock (copy), v55 (copy)
		local v70 = v56.getParam("fromProfile")
		local v71 = v56.state.routeName == AvatarScreen.TryOnItem
		local v72 = v70 or v71

		v58(NavigateWithLock(function() -- line: 135
			-- upvalues: v56 (copy), AvatarScreen (copy), t2 (copy), v59 (copy), v72 (copy), v71 (copy)
			v56.navigate(AvatarScreen.CatalogContextMenu, {
				itemId = t2.itemId,
				itemType = t2.itemType,
				onOverlayClosed = v59,
				centered = v72,
				hideItemDetailsButtonVisible = v71,
				itemDetailsPeekViewRefs = t2.itemDetailsPeekViewRefs
			})
		end))
		v55(true)
	end, {
		v58,
		t2.itemDetailsPeekViewRefs,
		v59,
		t2.itemType,
		t2.itemId,
		v56
	})
	local v61 = nil

	if AXShareButtonOnActionBarIXP.isEnabled() and IxpUtils.readTestVariable(AXShareButtonOnActionBarIXP.ShowShareButtonOnActionBar) then
		local v62 = React.useCallback(function() -- line: 156
			-- upvalues: sendAXCounterV2 (copy), Constants2 (copy), t2 (copy)
			sendAXCounterV2(Constants2.Counter.ShareButtonProfileration.ShareButtonClicked, {
				itemId = t2.itemId,
				itemType = t2.itemType
			})
		end, {
			t2.itemId,
			t2.itemType
		})

		v61 = useShareButton(t2.itemId, t2.itemType, false, v62)
	end

	local v63 = if not FFlagAXShowFaeUpsell then nil else useSelector(function(p3) -- line: 167
		-- upvalues: t2 (copy), u52 (ref), ItemData (copy), ItemStatus (copy)
		local itemId = t2.itemId
		local itemType = t2.itemType
		local v76 = u52
		local v77 = ItemData(p3.AvatarExperience.Common, itemId, itemType)
		local v78 = not not v77 and if v77.itemStatus then table.find(v77.itemStatus, ItemStatus.IsFAE) ~= nil else false

		return {
			showFaeUpsell = not not v76.showFaeUpsell and (v78 or false),
			canClaimFaeItem = not not v76.canClaimFaeItem and (v78 or false)
		}
	end, tutils.shallowEqual)
	local v64 = useBuyActionBarButtonProps(v59, t2.itemId, t2.itemType, t2.selectedTimedOptionDays, t2.hidePrice, t2.showTimedOptionInBuyButton, if not FFlagAXShowFaeUpsell then nil else v63)
	local v65 = if not FFlagAXDurables2Option then nil else useBuyActionBarButtonProps(v59, t2.itemId, t2.itemType, 3, false, true)
	local v66 = nil

	if FFlagAXShowFaeUpsell then
		v66 = useBuyActionBarContextualText(u52.showFaeUpsell, u52.canClaimFaeItem)
	end

	local v67 = React.useCallback(function(p4) -- line: 199
		-- upvalues: ItemData (copy), t2 (copy)
		local v80 = ItemData(p4.AvatarExperience.Common, t2.itemId, t2.itemType)

		return not not v80 and (not not v80.isOwned and (not v80.expirationTime or false))
	end, {
		t2.itemId,
		t2.itemType
	})
	local v68 = if not v34 and not FFlagAXShowFaeUpsell then nil else useSelector(v67)

	if FFlagAXShowFaeUpsell and v66 and v63 and ((v63.showFaeUpsell or v63.canClaimFaeItem) and not v68) then
		return (React.createElement(ActionBarWithContextualTextContainer, {
			titleText = v66,
			actionButtonText = v64.buttonText,
			onActionActivated = v64.onActivated,
			onMoreActivated = v60,
			isActionDisabled = v64.buttonIsDisabled,
			isActionLoading = v64.buttonIsLoading
		}))
	end

	if ((if not v34 then t2.timedOptions else t2.timedOptions and not v68)) and (not FFlagAXDurables2Option or v64.buttonActionType == BuyActionButtonTypeEnum.PurchaseFromRoblox or v64.buttonActionType == BuyActionButtonTypeEnum.Loading) then
		return React.createElement(if not FFlagAXDurables2Option then ActionBarWithTimedOptions else ActionBarWithRentalOption, {
			timedOptions = t2.timedOptions,
			itemId = if not FFlagAXDurablesForMIS then nil else t2.itemId,
			itemType = if not FFlagAXDurablesForMIS then nil else t2.itemType,
			buttonProps = v64,
			rentalButtonProps = if not FFlagAXDurables2Option then nil else v65,
			onSelectedDaysChanged = t2.setSelectedTimedOptionDays,
			selectedTimedOptionIndexInReducer = if not FFlagAXDurablesForMIS then nil else t2.selectedTimedOptionIndexInReducer
		})
	end

	return React.createElement(ActionBar, {
		ZIndex = t2.ZIndex,
		leftPadding = t2.leftPadding,
		rightPadding = t2.rightPadding,
		topPadding = t2.topPadding,
		bottomPadding = t2.bottomPadding or 0,
		showMoreButton = t2.showMoreButton or true,
		showMiddleButton = not not v61 or nil,
		onMiddleButtonActivated = if not v61 then nil else v61.onActivated,
		middleButtonIcon = if not v61 then nil else v61.icon,
		buttonProps = v64,
		onMoreButtonActivated = v60,
		isMoreButtonSelected = v54,
		hideGradient = t2.hideGradient,
		showSecondaryButton = if not FFlagAXDurablesForMIS then nil else t2.showSecondaryButton,
		secondaryButtonText = if not FFlagAXDurablesForMIS then nil else t2.secondaryButtonText,
		onSecondaryButtonActivated = if not FFlagAXDurablesForMIS then nil else t2.onSecondaryButtonActivated
	})
end

return React.memo(BuyActionBar)
