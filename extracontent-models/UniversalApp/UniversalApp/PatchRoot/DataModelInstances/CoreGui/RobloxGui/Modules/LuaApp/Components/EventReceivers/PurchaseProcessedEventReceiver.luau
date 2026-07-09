local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local SetCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Actions.SetCentralOverlay
local CloseCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Thunks.CloseCentralOverlay
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarEditorNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarEditorNavigation
local Characters = AvatarEditorNavigation.Categories.Characters
local Accessories = AvatarEditorNavigation.Categories.Accessories
local Purchased = AvatarEditorNavigation.Subcategories[Characters].Purchased
local getRbxthumbWithTypeSizeAndOptions = require(CorePackages.Workspace.Packages.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = require(CorePackages.Workspace.Packages.UserLib).Utils.Constants
local PaymentsProtocol = require(CorePackages.Workspace.Packages.PaymentsProtocol)
local ProductType = PaymentsProtocol.Enum.ProductType
local PaymentsProtocolConstants = PaymentsProtocol.PaymentsProtocolConstants
local UiMode = RobloxAppEnums.UiMode
local t1 = {
	mid = PaymentsProtocolConstants.MESSAGE_ON_PURCHASE_PROCESSED_EVENT,
	validateParams = t.table
}
local _ = {
	Hat = 8,
	BackAccessory = 46
}
local t2 = {
	[8] = AvatarEditorNavigation.Categories.Accessories,
	[46] = AvatarEditorNavigation.Categories.Accessories
}
local t3 = {
	[8] = AvatarEditorNavigation.Subcategories[Accessories].Hats,
	[46] = AvatarEditorNavigation.Subcategories[Accessories].Back
}
local t4 = {
	[8] = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventoryWithPath",
	[46] = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventoryWithPath"
}
local t5 = {
	[8] = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.HeadAccessoriesInventoryPath",
	[46] = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.BackAccessoriesInventoryPath"
}
local FFlagShowConfirmationScreenForOOAP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagShowConfirmationScreenForOOAP
local v32 = MessageBus.Subscriber.new()

local function getFontColorSpanStart(p1) -- line: 75
	-- upvalues: FFlagShowConfirmationScreenForOOAP (copy), UiMode (copy)
	if FFlagShowConfirmationScreenForOOAP then
		if p1 == UiMode.TenFoot then
			return "<font color=\"rgb(255, 255, 255)\">"
		end

		return "<font color=\"rgb(0, 0, 0)\">"
	end

	return "<font color=\"rgb(255, 255, 255)\">"
end
local function getDialogData(n1: number) -- line: 87
	-- upvalues: t2 (copy), Characters (copy), t3 (copy), Purchased (copy), t4 (copy), t5 (copy)
	return {
		avatarEditorCategory = t2[n1] or Characters,
		avatarEditorSubCategory = t3[n1] or Purchased,
		bodyTextKey = t4[n1] or "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
		inventoryPathKey = t5[n1]
	}
end
local function PurchaseProcessedEventReceiver() -- line: 97
	-- upvalues: React (copy), useDispatch (copy), useNavigation (copy), FFlagShowConfirmationScreenForOOAP (copy), CloseCentralOverlay (copy), AvatarScreen (copy), Characters (copy), Purchased (copy), MarketplaceService (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), useUiModeInfo (copy), useLocalization (copy), UiMode (copy), v32 (copy), t1 (copy), ProductType (copy), Constants (copy), getRbxthumbWithTypeSizeAndOptions (copy), SetCentralOverlay (copy), CentralOverlayType (copy)
	local v38, v39 = React.useState({
		id = nil,
		name = nil,
		thumbnailType = nil,
		assetTypeId = nil
	})
	local v40, v41 = React.useState({
		bodyTextKey = "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
		inventoryPathKey = nil
	})
	local v42 = useDispatch()
	local u43 = nil
	local v44 = useNavigation()

	if not FFlagShowConfirmationScreenForOOAP then
		u43 = React.useCallback(function() -- line: 115
			-- upvalues: v42 (copy), CloseCentralOverlay (copy), v44 (copy), AvatarScreen (copy), Characters (copy), Purchased (copy), v39 (copy)
			v42(CloseCentralOverlay())
			v44.navigate(AvatarScreen.AvatarEditor, {
				avatarEditorCategory = Characters,
				avatarEditorSubcategory = Purchased
			})
			v39({
				id = nil,
				name = nil,
				thumbnailType = nil
			})
		end, {
			v42,
			v44
		})
	end

	local u45 = React.useCallback(function() -- line: 129
		-- upvalues: v42 (copy), CloseCentralOverlay (copy), v39 (copy)
		v42(CloseCentralOverlay())
		v39({
			id = nil,
			name = nil,
			thumbnailType = nil
		})
	end, { v42 })
	local v46 = React.useCallback(function(n2: number, s1: string, s2: string) -- line: 138
		-- upvalues: MarketplaceService (copy), FFlagShowConfirmationScreenForOOAP (copy), t2 (copy), Characters (copy), t3 (copy), Purchased (copy), t4 (copy), t5 (copy), v41 (copy), v39 (copy)
		local t6 = {
			name = nil,
			assetTypeId = nil,
			id = n2,
			thumbnailType = s2
		}

		if n2 then
			local ok, result = pcall(function() -- line: 147
				-- upvalues: MarketplaceService (copy), n2 (copy), s1 (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return MarketplaceService:GetProductInfoAsync(n2, s1)
				end

				return MarketplaceService:GetProductInfo(n2, s1)
			end)

			if ok then
				t6.name = result.Name

				if FFlagShowConfirmationScreenForOOAP then
					t6.assetTypeId = result.AssetTypeId

					local assetTypeId = t6.assetTypeId
					local t7 = {
						avatarEditorCategory = t2[assetTypeId] or Characters,
						avatarEditorSubCategory = t3[assetTypeId] or Purchased,
						bodyTextKey = t4[assetTypeId] or "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
						inventoryPathKey = t5[assetTypeId]
					}

					v41({
						bodyTextKey = t7.bodyTextKey,
						inventoryPathKey = t7.inventoryPathKey
					})
				end
			end
		end

		v39(t6)
	end, {})
	local uiMode = useUiModeInfo().uiMode
	local u48

	if not FFlagShowConfirmationScreenForOOAP then
		u48 = useLocalization({
			titleText = "Feature.AvatarBundleReceivedInteractiveAlert.Title.ItemsAcquired",
			takeALookText = "Feature.AvatarBundleReceivedInteractiveAlert.Action.TakeALook",
			okButtonText = "Feature.AvatarBundleReceivedInteractiveAlert.Action.Ok",
			bodyText = {
				"Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
				avatarName = not v38.name and "" or v38.name,
				fontColorSpanStart = not FFlagShowConfirmationScreenForOOAP and "<font color=\"rgb(255, 255, 255)\">" or (uiMode ~= UiMode.TenFoot and "<font color=\"rgb(0, 0, 0)\">" or "<font color=\"rgb(255, 255, 255)\">"),
				fontColorSpanEnd = "</font>"
			},
			errorBodyText = {
				"Feature.AvatarBundleReceivedInteractiveAlert.BodyText.UnknownAddedToInventory",
				fontColorSpanStart = not FFlagShowConfirmationScreenForOOAP and "<font color=\"rgb(255, 255, 255)\">" or (uiMode ~= UiMode.TenFoot and "<font color=\"rgb(0, 0, 0)\">" or "<font color=\"rgb(255, 255, 255)\">"),
				fontColorSpanEnd = "</font>"
			}
		})
	else
		local v49 = useLocalization({
			inventoryPath = v40.inventoryPathKey
		})

		u48 = useLocalization({
			titleText = "Feature.AvatarBundleReceivedInteractiveAlert.Title.ItemsAcquired",
			takeALookText = "Feature.AvatarBundleReceivedInteractiveAlert.Action.TakeALook",
			okButtonText = "Feature.AvatarBundleReceivedInteractiveAlert.Action.Ok",
			bodyText = {
				v40.bodyTextKey,
				avatarName = not v38.name and "" or v38.name,
				fontColorSpanStart = not FFlagShowConfirmationScreenForOOAP and "<font color=\"rgb(255, 255, 255)\">" or (uiMode ~= UiMode.TenFoot and "<font color=\"rgb(0, 0, 0)\">" or "<font color=\"rgb(255, 255, 255)\">"),
				fontColorSpanEnd = "</font>",
				inventoryPath = v49.inventoryPath
			},
			errorBodyText = {
				"Feature.AvatarBundleReceivedInteractiveAlert.BodyText.UnknownAddedToInventory",
				fontColorSpanStart = not FFlagShowConfirmationScreenForOOAP and "<font color=\"rgb(255, 255, 255)\">" or (uiMode ~= UiMode.TenFoot and "<font color=\"rgb(0, 0, 0)\">" or "<font color=\"rgb(255, 255, 255)\">"),
				fontColorSpanEnd = "</font>"
			}
		})
	end

	React.useEffect(function() -- line: 214
		-- upvalues: v32 (copy), t1 (copy), ProductType (copy), v46 (copy), Constants (copy)
		v32:subscribe(t1, function(p2) -- line: 215
			-- upvalues: ProductType (copy), v46 (copy), Constants (copy)
			if not p2.nativeProduct then
				warn("PaymentProcessedEventReceiver: Response does not have nativeProduct key")

				return
			end

			if p2.nativeProduct.productType == ProductType.PlayStationPlusItem then
				if not p2.payload then
					warn("Response does not have payload key")

					return
				end

				local granted_asset_ids = p2.payload.granted_asset_ids
				local v64 = if not granted_asset_ids or not (#granted_asset_ids > 0) then nil else granted_asset_ids[1]
				local granted_bundle_ids = p2.payload.granted_bundle_ids
				local v66 = if not granted_bundle_ids or not (#granted_bundle_ids > 0) then nil else granted_bundle_ids[1]

				if v64 then
					v46(v64, Enum.InfoType.Asset, Constants.RbxthumbTypes.Asset)
				end

				if v66 then
					v46(v66, Enum.InfoType.Bundle, Constants.RbxthumbTypes.BundleThumbnail)
				end
			end
		end)

		return function() -- line: 246
			-- upvalues: v32 (copy), t1 (copy)
			v32:unsubscribe(t1)
		end
	end, {})
	React.useEffect(function() -- line: 251
		-- upvalues: v38 (copy), FFlagShowConfirmationScreenForOOAP (copy), t2 (copy), Characters (copy), t3 (copy), Purchased (copy), t4 (copy), t5 (copy), v42 (copy), CloseCentralOverlay (copy), v44 (copy), AvatarScreen (copy), v39 (copy), getRbxthumbWithTypeSizeAndOptions (copy), SetCentralOverlay (copy), CentralOverlayType (copy), u48 (ref), u43 (ref), u45 (ref)
		if not v38.id then
			return
		end

		local v58 = nil

		if FFlagShowConfirmationScreenForOOAP then
			local assetTypeId = v38.assetTypeId
			local t8 = {
				avatarEditorCategory = t2[assetTypeId] or Characters,
				avatarEditorSubCategory = t3[assetTypeId] or Purchased,
				bodyTextKey = t4[assetTypeId] or "Feature.AvatarBundleReceivedInteractiveAlert.BodyText.AddedToInventory",
				inventoryPathKey = t5[assetTypeId]
			}

			function v58() -- line: 259
				-- upvalues: v42 (copy), CloseCentralOverlay (copy), v44 (copy), AvatarScreen (copy), t8 (copy), v39 (copy)
				v42(CloseCentralOverlay())
				v44.navigate(AvatarScreen.AvatarEditor, {
					avatarEditorCategory = t8.avatarEditorCategory,
					avatarEditorSubcategory = t8.avatarEditorSubCategory
				})
				v39({
					id = nil,
					name = nil,
					thumbnailType = nil,
					assetTypeId = nil
				})
			end
		end

		local v61 = getRbxthumbWithTypeSizeAndOptions(v38.id, v38.thumbnailType, 420)

		v42(SetCentralOverlay(CentralOverlayType.ItemsReceivedAlert, {
			titleText = u48.titleText,
			avatarThumbnail = v61,
			avatarThumbnailDisplayHeight = not v38.name and 0 or 276,
			bodyText = if not v38.name then u48.errorBodyText else u48.bodyText,
			primaryButtonText = u48.takeALookText,
			onPrimaryButtonActivated = if not FFlagShowConfirmationScreenForOOAP then u43 else v58,
			secondaryButtonText = u48.okButtonText,
			onSecondaryButtonActivated = u45
		}))
	end, {
		v38,
		u48,
		v42,
		if not FFlagShowConfirmationScreenForOOAP then u43 else nil,
		u45,
		if not FFlagShowConfirmationScreenForOOAP then nil else v44
	})
end

return PurchaseProcessedEventReceiver
