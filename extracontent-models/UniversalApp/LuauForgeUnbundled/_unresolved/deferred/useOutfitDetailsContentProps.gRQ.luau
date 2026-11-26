local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module3 = require("@luauforge/bundled/ciE")
local constants = module3.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = module3.Utils.getRbxthumbWithTypeSizeAndOptions

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateDown
local module4 = require("@luauforge/bundled/dFm")
local toastType = require("@luauforge/bundled/dzF").Enums.ToastType

local inventoryItemAvailability = require("@luauforge/bundled/fCn").Enums.InventoryItemAvailability

local normalizeBackgroundId = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Backgrounds.normalizeBackgroundId
local module5 = require("@luauforge/bundled/dRg")
local module6 = require("@luauforge/bundled/fCe")
local module7 = require("@luauforge/bundled/dPN")
local module8 = require("@luauforge/bundled/dVn")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXModeratedItemsFlow = AvatarExperienceFlags.FFlagAXModeratedItemsFlow
local fFlagAXBackgroundsInRevampedOutfitDetails = AvatarExperienceFlags.FFlagAXBackgroundsInRevampedOutfitDetails

local getPageMargin = UIBlox.App.Container.getPageMargin

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

require("@luauforge/deferred/gRP")
require("@luauforge/bundled/dPs")

local v5 = module8.BASE_URL .. "report-appeals#/"

local v6 = {
	toastMessage = "CommonUI.Messages.Label.ActionNotAvailableOnCurrentDevice",
	isLocalized = false,
	toastType = toastType.InformationMessage
}

local function fn(p2)
	return p2.AvatarExperience.AvatarEditor.OutfitInfos
end

local function fn2(p2)
	return p2.AvatarExperience.Common.AssetInfos
end

local function fn3(p2)
	return p2.ScreenSize
end

local function fn4(p2)
	return p2.getCustomOutfitNames()
end

local function fn5(p2)
	return p2.getWebViewSupport()
end

local function useOutfitDetailsContentProps(p2)
	local outfitId = p2.outfitId

	local v7 = useTokens()
	local v8 = useDispatch()

	local v9 = useSelector(fn)
	local v10 = if v9 then v9[outfitId] else nil
	local v11 = useSelector(fn2)
	local v12 = useSelector(fn3)

	local v13 = useLocalization({
		details = "Feature.Avatar.Label.DetailsButton",
		moderated = "Feature.Catalog.Message.AvatarModerationModerated",
		pending = "Feature.Catalog.Message.AvatarModerationPending",
		background = fFlagAXBackgroundsInRevampedOutfitDetails and "Feature.Avatar.Label.Backgrounds" or nil
	})

	local v14 = useAppPolicy(fn4)
	local v15 = useAppPolicy(fn5)

	local v16 = getRbxthumbWithTypeSizeAndOptions(outfitId, constants.RbxthumbTypes.Outfit, 420)

	local v17 = nil

	local moderationStatus = if v10 then v10.moderationStatus or nil else nil
	local moderationPendingOrRejected = module6.isModerationPendingOrRejected(moderationStatus)
	local v18 = moderationStatus == Enum.ModerationStatus.ReviewedRejected

	if moderationPendingOrRejected then
		v16 = module5.BrokenAvatarThumbnail
		v17 = 0.25
	end

	local useMemo = React.useMemo
	local function fn6()
		if not (v10 and v10.assets) then
			return { viewItems = nil, totalItemCount = module7.ShimmerCardsToDisplay }
		end

		local v19 = {}
		local v20 = {}

		for k in v10.assets do
			table.insert(v19, k)
		end

		table.sort(v19, function(a, b): boolean
			local v21 = tonumber(a)
			local v22 = tonumber(b)

			if v21 and v22 then
				return v21 < v22
			end

			return a < b
		end)

		for k, v21 in v19 do
			for k2, v22 in v10.assets[v21] do
				local v23 = getRbxthumbWithTypeSizeAndOptions(k2, constants.RbxthumbTypes.Asset, 150)

				local v24 = v11[k2]
				local name = v24 and v24.name

				if v24 and v24.outfitModerationStatus then
					v23 ..= `&filters=__{v24.outfitModerationStatus}__`
				end

				local availabilityStatus = if fFlagAXModeratedItemsFlow then v22.availabilityStatus else nil

				table.insert(v20, {
					key = k2,
					name = name,
					thumbnailUrl = v23,
					itemStatus = availabilityStatus == inventoryItemAvailability.Unavailable and {
						type = "placeholder",
						iconType = "Unavailable"
					} or availabilityStatus == inventoryItemAvailability.Revoked and {
						type = "placeholder",
						iconType = "Error"
					} or nil
				})
			end
		end

		if fFlagAXBackgroundsInRevampedOutfitDetails then
			local backgroundId = normalizeBackgroundId(v10.profileConfiguration and v10.profileConfiguration.BackgroundAssetId)

			if backgroundId ~= nil then
				local v21 = tostring(backgroundId)
				local v22 = v11[v21]

				local v24 = if v22 and v22.name then v22.name else v13.background
				local v23 = {
					key = v21,
					name = v24,
					thumbnailUrl = getRbxthumbWithTypeSizeAndOptions(
						v21,
						constants.RbxthumbTypes.Asset,
						150
					)
				}
				table.insert(v20, v23)
			end
		end

		return {
			viewItems = v20,
			totalItemCount = #v20
		}
	end

	local v20 = if fFlagAXBackgroundsInRevampedOutfitDetails then v13.background else nil
	local v21 = useMemo(fn6, { v10, v11, v20 })

	local viewItems = v21.viewItems
	local totalItemCount = v21.totalItemCount

	local v22 = React.useMemo(function()
		local fontSize = v7.Typography.TitleMedium.FontSize
		return module6.GridItemHeightGetter(module7.ItemTileType.BundleItemTile, fontSize)
	end, { v7 })

	local pageMargin = getPageMargin(v12.X)

	local v23 = React.useCallback(function()
		if not v15 then
			v8(module4(v6))
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage({
				name = appPage.GenericWebPage,
				detail = v5,
				extraProps = { title = "" }
			}))
		else
			v8(navigateDown({
				name = appPage.GenericWebPage,
				detail = v5,
				extraProps = { title = "" }
			}))
		end
	end, { v8, v15 })
	local v24

	if v10 and v10.creatingUniverseId ~= nil then
		v24 = string.len(v10.creatingUniverseId) > 0
	else
		v24 = false
	end

	local v26 = if v10 then v10.name or nil else nil
	return {
		outfitName = v26,
		outfitInfo = v10,
		outfitThumbnailUrl = v16,
		outfitThumbnailTransparency = v17,
		viewItems = viewItems,
		totalItemCount = totalItemCount,
		screenHeight = v12.Y,
		contentMargin = pageMargin,
		showModerationBanner = moderationPendingOrRejected,
		showItemInfoList = v24,
		isModerated = v18,
		localized = v13,
		onGoToAppeals = v23,
		getItemHeight = v22,
		showCustomOutfitNames = v14
	}
end

return useOutfitDetailsContentProps
