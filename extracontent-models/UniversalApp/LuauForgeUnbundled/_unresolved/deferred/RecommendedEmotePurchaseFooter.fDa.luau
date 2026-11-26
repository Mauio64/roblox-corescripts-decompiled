local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module5 = require("@luauforge/bundled/dPN")

local module6 = require("@luauforge/deferred/fDb")

local module7 = require("@luauforge/deferred/fDM")

local module8 = require("@luauforge/deferred/fDu")
local module9 = require("@luauforge/deferred/fDe")
local module10 = require("@luauforge/deferred/fDN")

local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local itemStatus = AvatarExperienceCommon.Enums.ItemStatus
local avatarRouteContext = AvatarExperienceNavigation.AvatarRoute.Context.AvatarRouteContext
local getFaeFeatureAccessStore = AvatarExperienceCatalog.Stores.GetFaeFeatureAccessStore

local fFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local fFlagAXDurables2Option = AvatarExperienceFlags.FFlagAXDurables2Option
local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS

local button = Foundation.Button
local iconButton = Foundation.IconButton
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize
local images = UIBlox.App.ImageSet.Images

local function getFoundationIcon(p2): nil | string
	if p2 == images["icons/common/robux"] then
		return "icons/common/robux"
	end

	if p2 == images["icons/menu/avatar_on"] then
		return "icons/menu/avatar_on"
	end

	if p2 == images["icons/actions/block"] then
		return "icons/actions/block"
	end

	return nil
end

local function selectIsItemFAE(p2, p3)
	local v5 = itemData(p2.AvatarExperience.Common, p3, module5.ItemType.Asset)
	local isItemFAE

	if v5 == nil or v5.itemStatus == nil then
		isItemFAE = false
	else
		isItemFAE = table.find(v5.itemStatus, itemStatus.IsFAE) ~= nil
	end

	return isItemFAE
end

local function RecommendedEmotePurchaseFooterContent(p2)
	module10()

	local v5 = useSelector(function(p3)
		return itemData(p3.AvatarExperience.Common, p2.emoteAssetId, module5.ItemType.Asset)
	end)

	local asset = module5.ItemType.Asset
	local timedOptions = if v5 then v5.timedOptions else nil
	local state, setState = React.useState(nil)
	local v6

	if fFlagAXShowFaeUpsell then
		local v7 = getFaeFeatureAccessStore.useFaeFeatureAccess()
		v6 = useSelector(function(p3)
			local emoteAssetId = p2.emoteAssetId
			local v8 = itemData(p3.AvatarExperience.Common, emoteAssetId, module5.ItemType.Asset)
			local v9

			if v8 == nil or v8.itemStatus == nil then
				v9 = false
			else
				v9 = table.find(v8.itemStatus, itemStatus.IsFAE) ~= nil
			end

			local v10 = {
				showFaeUpsell = v7.showFaeUpsell == true and v9,
				canClaimFaeItem = 0
			}

			if v7.canClaimFaeItem ~= true then
				v9 = false
			end

			v10.canClaimFaeItem = v9
			return v10
		end)
	end

	React.useEffect(function()
		setState(nil)
	end, { p2.emoteAssetId })

	local function fn() end
	local emoteAssetId = p2.emoteAssetId

	if not fFlagAXShowFaeUpsell then
		v6 = nil
	end

	local v10 = module9(fn, emoteAssetId, asset, state, timedOptions and true or nil, nil, v6)
	local v11

	if fFlagAXDurables2Option then
		v11 = module9(function() end, p2.emoteAssetId, asset, 3, false, true)
	end

	if
		timedOptions
		and (not fFlagAXDurables2Option or v10.buttonActionType == module8.PurchaseFromRoblox or v10.buttonActionType == module8.Loading)
	then
		local createElement = React.createElement
		local v12 = if fFlagAXDurables2Option then module7 else module6
		local v14 = if fFlagAXDurablesForMIS then p2.emoteAssetId else nil

		if not fFlagAXDurablesForMIS then
			asset = nil
		end

		if not fFlagAXDurables2Option then
			v11 = nil
		end

		local v15 = if fFlagAXDurables2Option then p2.onOpenCatalogContextMenu else nil
		return createElement(v12, {
			timedOptions = timedOptions,
			itemId = v14,
			itemType = asset,
			buttonProps = v10,
			rentalButtonProps = v11,
			onMoreButtonActivated = v15,
			onSelectedDaysChanged = setState
		})
	else
		local createElement = React.createElement
		local fragment = React.Fragment
		local createElement2 = React.createElement
		local v13 = {
			text = v10.buttonText,
			icon = 0,
			variant = 0,
			size = 0,
			fillBehavior = 0,
			isDisabled = 0,
			isLoading = 0,
			onActivated = 0,
			LayoutOrder = 1
		}
		local buttonIcon = v10.buttonIcon
		v13.icon = buttonIcon == images["icons/common/robux"] and "icons/common/robux"
			or buttonIcon == images["icons/menu/avatar_on"] and "icons/menu/avatar_on"
			or buttonIcon == images["icons/actions/block"] and "icons/actions/block"
			or nil
		v13.variant = buttonVariant.Emphasis
		v13.size = inputSize.Medium
		v13.fillBehavior = fillBehavior.Fill
		v13.isDisabled = v10.buttonIsDisabled
		v13.isLoading = v10.buttonIsLoading
		v13.onActivated = v10.onActivated
		return createElement(fragment, nil, {
			Purchase = createElement2(button, v13),
			Overflow = React.createElement(iconButton, {
				icon = iconName.ThreeDotsHorizontal,
				size = iconSize.Medium,
				variant = buttonVariant.Standard,
				onActivated = p2.onOpenCatalogContextMenu,
				LayoutOrder = 2
			})
		})
	end
end

local function RecommendedEmotePurchaseFooter(p2)
	return React.createElement(avatarRouteContext.Provider, { value = p2.avatarRoute }, {
		Content = React.createElement(RecommendedEmotePurchaseFooterContent, p2)
	})
end

return RecommendedEmotePurchaseFooter
