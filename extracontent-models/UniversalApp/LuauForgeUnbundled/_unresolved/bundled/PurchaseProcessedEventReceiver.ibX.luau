local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")

local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local messageBus = require("@luauforge/bundled/fBY").MessageBus
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo

local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Actions.SetCentralOverlay
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/CentralOverlay").Thunks.CloseCentralOverlay
local centralOverlayType = RobloxAppEnums.CentralOverlayType

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local avatarEditorNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarEditorNavigation
local characters = avatarEditorNavigation.Categories.Characters
local accessories = avatarEditorNavigation.Categories.Accessories
local purchased = avatarEditorNavigation.Subcategories[characters].Purchased

local getRbxthumbWithTypeSizeAndOptions = require("@luauforge/bundled/cgr").Utils.getRbxthumbWithTypeSizeAndOptions
local constants = require("@luauforge/bundled/cgr").Utils.Constants

local module2 = require("@luauforge/bundled/gut")
local productType = module2.Enum.ProductType
local paymentsProtocolConstants = module2.PaymentsProtocolConstants

local uiMode = RobloxAppEnums.UiMode

local v5 = {
	mid = paymentsProtocolConstants.MESSAGE_ON_PURCHASE_PROCESSED_EVENT,
	validateParams = t.table
}

local v6 = { Hat = 8, BackAccessory = 46 }

local v7 = {
	[8] = avatarEditorNavigation.Categories.Accessories,
	[46] = avatarEditorNavigation.Categories.Accessories
}

local v8 = {
	[8] = avatarEditorNavigation.Subcategories[accessories].Hats,
	[46] = avatarEditorNavigation.Subcategories[accessories].Back
}

local v9 = {
	[8] = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventoryWithPath",
	[46] = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventoryWithPath"
}

local v10 = {
	[8] = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.HeadAccessoriesInventoryPath",
	[46] = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.BackAccessoriesInventoryPath"
}

local fFlagShowConfirmationScreenForOOAP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagShowConfirmationScreenForOOAP

local subscriber = messageBus.Subscriber.new()

local function getFontColorSpanStart(p2): string
	if not (fFlagShowConfirmationScreenForOOAP and p2 ~= uiMode.TenFoot) then
		return "<font color=\"rgb(255, 255, 255)\">"
	end

	return "<font color=\"rgb(0, 0, 0)\">"
end

local function getDialogData(p2)
	return {
		avatarEditorCategory = v7[p2] or characters,
		avatarEditorSubCategory = v8[p2] or purchased,
		bodyTextKey = v9[p2] or "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
		inventoryPathKey = v10[p2]
	}
end

local function PurchaseProcessedEventReceiver()
	local state, setState = React.useState({
		id = nil,
		name = nil,
		thumbnailType = nil,
		assetTypeId = nil
	})

	local state2, setState2 = React.useState({
		bodyTextKey = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
		inventoryPathKey = nil
	})

	local v11 = useDispatch()

	local v12 = useNavigation()
	local v13

	if fFlagShowConfirmationScreenForOOAP then
		v13 = nil
	else
		v13 = React.useCallback(function()
			v11(closeCentralOverlay())
			v12.navigate(avatarScreen.AvatarEditor, {
				avatarEditorCategory = characters,
				avatarEditorSubcategory = purchased
			})

			setState({ id = nil, name = nil, thumbnailType = nil })
		end, { v11, v12 })
	end

	local v14 = React.useCallback(function()
		v11(closeCentralOverlay())
		setState({ id = nil, name = nil, thumbnailType = nil })
	end, { v11 })

	local v15 = React.useCallback(function(p2, p3, p4)
		local v16 = { id = p2, name = nil, thumbnailType = p4, assetTypeId = nil }

		if p2 then
			local success, result = pcall(function()
				return MarketplaceService:GetProductInfoAsync(p2, p3)
			end)

			if success then
				v16.name = result.Name

				if fFlagShowConfirmationScreenForOOAP then
					v16.assetTypeId = result.AssetTypeId

					local assetTypeId = v16.assetTypeId
					local v17 = {
						avatarEditorCategory = v7[assetTypeId] or characters,
						avatarEditorSubCategory = v8[assetTypeId] or purchased,
						bodyTextKey = v9[assetTypeId] or "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
						inventoryPathKey = v10[assetTypeId]
					}

					setState2({
						bodyTextKey = v17.bodyTextKey,
						inventoryPathKey = v17.inventoryPathKey
					})
				end
			end
		end

		setState(v16)
	end, {})

	local uiMode2 = useUiModeInfo().uiMode
	local v16

	if fFlagShowConfirmationScreenForOOAP then
		local v17 = useLocalization({ inventoryPath = state2.inventoryPathKey })
		v16 = useLocalization({
			titleText = "Feature.AvatarBundleReceivedInteractiveAlert.Title.ItemsAcquired",
			bodyText = {
				state2.bodyTextKey,
				avatarName = not state.name and "" or state.name,
				fontColorSpanStart = fFlagShowConfirmationScreenForOOAP and (uiMode2 == uiMode.TenFoot and "<font color=\"rgb(255, 255, 255)\">" or "<font color=\"rgb(0, 0, 0)\">") or "<font color=\"rgb(255, 255, 255)\">",
				fontColorSpanEnd = "</font>",
				inventoryPath = v17.inventoryPath
			},
			errorBodyText = {
				"Feature.AvatarBundleReceivedInteractiveAlert.BodyText.UnknownAddedToInventory",
				fontColorSpanStart = fFlagShowConfirmationScreenForOOAP and (uiMode2 == uiMode.TenFoot and "<font color=\"rgb(255, 255, 255)\">" or "<font color=\"rgb(0, 0, 0)\">") or "<font color=\"rgb(255, 255, 255)\">",
				fontColorSpanEnd = "</font>"
			},
			takeALookText = "Feature.AvatarBundleReceivedInteractiveAlert.Action.TakeALook",
			okButtonText = "Feature.AvatarBundleReceivedInteractiveAlert.Action.Ok"
		})
	else
		v16 = useLocalization({
			titleText = "Feature.AvatarBundleReceivedInteractiveAlert.Title.ItemsAcquired",
			bodyText = {
				"Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
				avatarName = not state.name and "" or state.name,
				fontColorSpanStart = fFlagShowConfirmationScreenForOOAP and (uiMode2 == uiMode.TenFoot and "<font color=\"rgb(255, 255, 255)\">" or "<font color=\"rgb(0, 0, 0)\">") or "<font color=\"rgb(255, 255, 255)\">",
				fontColorSpanEnd = "</font>"
			},
			errorBodyText = {
				"Feature.AvatarBundleReceivedInteractiveAlert.BodyText.UnknownAddedToInventory",
				fontColorSpanStart = fFlagShowConfirmationScreenForOOAP and (uiMode2 == uiMode.TenFoot and "<font color=\"rgb(255, 255, 255)\">" or "<font color=\"rgb(0, 0, 0)\">") or "<font color=\"rgb(255, 255, 255)\">",
				fontColorSpanEnd = "</font>"
			},
			takeALookText = "Feature.AvatarBundleReceivedInteractiveAlert.Action.TakeALook",
			okButtonText = "Feature.AvatarBundleReceivedInteractiveAlert.Action.Ok"
		})
	end

	React.useEffect(function()
		subscriber:subscribe(v5, function(p2)
			if not p2.nativeProduct then
				warn("PaymentProcessedEventReceiver: Response does not have nativeProduct key")
			elseif p2.nativeProduct.productType == productType.PlayStationPlusItem then
				if not p2.payload then
					warn("Response does not have payload key")
					return
				end

				local granted_asset_ids = p2.payload.granted_asset_ids
				local v17 = if granted_asset_ids and #granted_asset_ids > 0 then granted_asset_ids[1] else nil

				local granted_bundle_ids = p2.payload.granted_bundle_ids
				local v18 = if granted_bundle_ids and #granted_bundle_ids > 0 then granted_bundle_ids[1] else nil

				if v17 then
					v15(v17, Enum.InfoType.Asset, constants.RbxthumbTypes.Asset)
				end

				if v18 then
					v15(v18, Enum.InfoType.Bundle, constants.RbxthumbTypes.BundleThumbnail)
				end
			end
		end)

		return function()
			subscriber:unsubscribe(v5)
		end
	end, {})

	local useEffect = React.useEffect
	local function fn()
		if not state.id then
			return
		end

		local v17

		if fFlagShowConfirmationScreenForOOAP then
			local assetTypeId = state.assetTypeId
			local v18 = {
				avatarEditorCategory = v7[assetTypeId] or characters,
				avatarEditorSubCategory = v8[assetTypeId] or purchased,
				bodyTextKey = v9[assetTypeId] or "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
				inventoryPathKey = v10[assetTypeId]
			}

			v17 = function()
				v11(closeCentralOverlay())
				v12.navigate(avatarScreen.AvatarEditor, {
					avatarEditorCategory = v18.avatarEditorCategory,
					avatarEditorSubcategory = v18.avatarEditorSubCategory
				})

				setState({
					id = nil,
					name = nil,
					thumbnailType = nil,
					assetTypeId = nil
				})
			end
		end

		local rbxthumbWithTypeSizeAndOptions = getRbxthumbWithTypeSizeAndOptions(
			state.id,
			state.thumbnailType,
			420
		)
		local itemsReceivedAlert = centralOverlayType.ItemsReceivedAlert
		local v20 = {
			titleText = v16.titleText,
			avatarThumbnail = rbxthumbWithTypeSizeAndOptions,
			avatarThumbnailDisplayHeight = state.name and 276 or 0,
			bodyText = 0,
			primaryButtonText = 0,
			onPrimaryButtonActivated = 0,
			secondaryButtonText = 0,
			onSecondaryButtonActivated = 0
		}
		local v21 = if state.name then v16.bodyText else v16.errorBodyText
		v20.bodyText = v21
		v20.primaryButtonText = v16.takeALookText

		if not fFlagShowConfirmationScreenForOOAP then
			v17 = v13
		end

		v20.onPrimaryButtonActivated = v17

		v20.secondaryButtonText = v16.okButtonText
		v20.onSecondaryButtonActivated = v14
		v11(setCentralOverlay(itemsReceivedAlert, v20))
	end

	local v19 = if not fFlagShowConfirmationScreenForOOAP then v13 else nil
	useEffect(fn, {
		state,
		v16,
		v11,
		v19,
		v14,
		if fFlagShowConfirmationScreenForOOAP then v12 else nil
	})
end

return PurchaseProcessedEventReceiver
