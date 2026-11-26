local LocalizationService = game:GetService("LocalizationService")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local module = require("@luauforge/bundled/egs")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local module2 = require("@luauforge/bundled/dPU")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module5 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dPs")
local module6 = require("@luauforge/bundled/fCe")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module7 = require("@luauforge/bundled/dFs")
local module8 = require("@luauforge/bundled/dzE")
local module9 = require("@luauforge/bundled/dPT")
local module10 = require("@luauforge/bundled/gKU")
local module11 = require("@luauforge/bundled/dPr")
local module12 = require("@luauforge/bundled/dKU")
local setTryOnManagerPeekViewState = module12.Actions.SetTryOnManagerPeekViewState
local setLookDetailsPeekViewSelectedTab = module12.Actions.SetLookDetailsPeekViewSelectedTab
local tryOnLooksOutfit = module12.Actions.TryOnLooksOutfit
local module13 = require("@luauforge/bundled/fCI")

local module14 = require("@luauforge/bundled/dFm")
local localization = require("@game/CorePackages/Workspace/Packages/RobloxAppLocales").Localization
local clearTryOns = module12.Actions.ClearTryOns
local setFullView = module12.Actions.SetFullView
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView
local module15 = require("@luauforge/deferred/gTo")

local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module16 = require("@luauforge/bundled/dXh")
local module17 = require("@luauforge/bundled/fIH")
local module18 = require("@luauforge/deferred/gTq")
local defineFastFlag = game:DefineFastFlag("RemoveTryOnLookV2MutedError", false)
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore

local fFlagParseHeadShapeFromAPIResponse = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagParseHeadShapeFromAPIResponse

local fFlagAXCatalogMakeupSupport = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local function keyMapper(p2)
	return module2.FetchLookDetailInfoKey .. p2
end

local function translateString(p2, p3)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v5 = localization.new(robloxLocaleId)
	v5:SetLocale(robloxLocaleId)

	return v5:Format(p2, p3)
end

local function handleErrorCases(object, p2, p3, p4)
	if not defineFastFlag then
		module7(tostring(p4) .. tostring(p3))
	end

	object:dispatch(clearTryOns())

	if p2 ~= nil then
		object:dispatch(navigateWithLock(function()
			module16.closeTryOnManager(p2)
		end))
	end

	object:dispatch(module14({
		isLocalized = false,
		toastType = module8.NetworkingError,
		toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
	}))
end

local function processAssetItem(data)
	local v5 = data.id ~= nil and data.assetType ~= nil
	assert(v5, "Asset is missing required fields")

	local v6 = {
		itemId = data.id,
		itemType = widgetConstants.ContentType.Asset,
		itemSubType = tostring(data.assetType),
		tryOnItemOrder = data.tryOnItemOrder,
		isNotSelectable = not module6.isItemSelectable(data),
		order = 0
	}
	local v7 = if data.meta then data.meta.order else nil
	v6.order = v7
	return v6
end

local function processAssetItemInBundle(data)
	local v5 = data.id ~= nil and data.assetType ~= nil
	assert(v5, "Asset is missing required fields")

	local v6 = {
		itemId = tostring(data.id),
		itemType = widgetConstants.ContentType.Asset,
		itemSubType = tostring(data.assetType),
		tryOnItemOrder = data.tryOnItemOrder,
		headShape = 0
	}
	local v7 = if fFlagParseHeadShapeFromAPIResponse and data.meta then data.meta.headShape else nil
	v6.headShape = v7
	return v6
end

local function processBundleItem(data)
	local v5 = data.id ~= nil and data.bundleType ~= nil
	assert(v5, "Bundle is missing required fields")
	local v6 = 0
	local v7 = {}

	for k, v8 in data.assetsInBundle do
		if not v8.isIncluded then
			continue
		end

		v8.tryOnItemOrder = k
		v6 += 1
		table.insert(v7, processAssetItemInBundle(v8))
	end

	local v8 = {
		itemId = data.id,
		itemType = widgetConstants.ContentType.Bundle,
		itemSubType = tostring(data.bundleType),
		items = v7,
		numberOfAssetsIncluded = 0,
		tryOnItemOrder = 0,
		isNotSelectable = 0
	}

	if not (v6 > 0) then
		v6 = nil
	end

	v8.numberOfAssetsIncluded = v6
	v8.tryOnItemOrder = data.tryOnItemOrder
	v8.isNotSelectable = not module6.isItemSelectable(data)
	return v8
end

local function GetLookDetailsComplete(p2, p3)
	local v5 = { GetExperienceSourceLanguage.GetLookDetailsV2(p2, p3), (GetExperienceSourceLanguage.HasFavoritedLook(p2, p3)) }

	return module.allSettled(v5):andThen(function(list)
		if list[1] ~= module.Status.Resolved then
			return module.reject("Failed to fetch look details")
		end

		local expect = v5[1]:expect()

		local v6 = false

		if list[2] == module.Status.Resolved then
			v6 = v5[2]:expect().responseBody.isFavorited
		else
			warn("HasFavoritedLook API call failed for lookId:", p3)
		end

		if expect.responseBody.look then
			expect.responseBody.look.isFavorited = v6
		end

		return expect
	end)
end

return function(p2, p3, p4, p5, p6, p7, p8)
	return function(object)
		if module18() then
			object:dispatch(setFullView(avatarScreen.Catalog, fullView.None))
		end

		if p7 then
			object:dispatch(setLookDetailsPeekViewSelectedTab(p7))
		end

		return performFetch.Single(module2.FetchLookDetailInfoKey .. p5, function(object2)
			return GetLookDetailsComplete(p2, p5):andThen(function(p9)
				local look = p9.responseBody.look
				local discounts = nil

				if look then
					local v6 = if fFlagAXCatalogMakeupSupport then look.lookType == module5.LookType.Makeup else nil

					local v7 = {}
					local v8 = {}

					for k, item in look.items do
						item.id = tostring(item.id)

						local restrictionInfo, v9 = module9.CreateRestrictionInfo(item.itemRestrictions)
						item.itemRestrictionsMap = v9

						item.tryOnItemOrder = k

						if item.itemType == widgetConstants.ContentType.Asset then
							if item.timedOptions then
								table.insert(item.timedOptions, {
									days = 0,
									price = item.priceInRobux,
									selected = true
								})
							end

							table.insert(v7, item)
						elseif item.itemType == widgetConstants.ContentType.Bundle then
							table.insert(v8, item)
						else
							warn("TryOnLookV2 - Unknown item type: " .. item.itemType)
						end

						if item.discountInformation and discounts == nil then
							discounts = item.discountInformation.discounts
						end
					end

					local v9

					if not (fFlagAXCatalogMakeupSupport and v6) then
						v9 = module10.buildBlockyLookDetailItem(v8, translateString)
					end

					if v9 then
						table.insert(v8, v9)
						module10.adjustTryOnItemOrderForBlockyBundle(v7, v8, look.items)
					end

					local clone = table.clone(look.items)

					if v9 then
						table.insert(clone, v9)
					end

					object2:dispatch(module15(p2, p4, clone))

					object2:dispatch(module11(
						p5,
						look.totalPrice,
						nil,
						v7,
						v8,
						look.lookType,
						look.totalValue,
						look.curator,
						look.description,
						look.moderationStatus,
						look.name,
						look.displayProperties,
						look.favoriteCount,
						look.isFavorited,
						discounts
					))

					if p8 then
						return module.resolve()
					end

					local v10 = {}

					for k, v11 in v7 do
						table.insert(v10, processAssetItem(v11))
					end

					local v11 = {}

					for k, v12 in v8 do
						table.insert(v11, processBundleItem(v12))
					end

					if module17 then
						if p6 then
							object2:dispatch(setTryOnManagerPeekViewState(p6))
						end
					else
						object2:dispatch(setTryOnManagerPeekViewState(peekViewState.SuperBrief))
					end

					local v12

					if not (fFlagAXCatalogMakeupSupport and v6 or not look.avatarProperties) then
						v12 = module6.convertBodyColor3HexesToColor3s(look.avatarProperties.bodyColor3s)
					end

					local rangeAndSliderValueForColor3s

					if v12 then
						local defaultBodyColorRanges = object2:getState().AvatarExperience.AvatarEditor.DefaultBodyColorRanges
						rangeAndSliderValueForColor3s = {}

						for k, v13 in v12 do
							local rangeAndSliderValueForColor3, v14 = module13.findRangeAndSliderValueForColor3(
								v13,
								defaultBodyColorRanges
							)

							rangeAndSliderValueForColor3s[k] = rangeAndSliderValueForColor3
						end
					end

					local scale

					if not (fFlagAXCatalogMakeupSupport and v6 or not look.avatarProperties) then
						scale = look.avatarProperties.scale
					end

					local v13 = look.lookType

					if
						AvatarExperienceFlags.FFlagAXTryOnAvatarMomentLookAsAvatar
						and v13 == module5.LookType.AvatarMoment
					then
						v13 = module5.LookType.Avatar
					end

					object2:dispatch(tryOnLooksOutfit({
						assetItemIdTypeAndSubtype = v10,
						bundleItemIdTypeAndSubtype = v11,
						lookId = p5,
						analyticsInfo = p4,
						lookType = v13,
						bodyColor3s = v12,
						bodyPartColorRangeIds = rangeAndSliderValueForColor3s,
						scale = scale
					}))

					if p3 ~= nil then
						local state = object2:getState()
						local routeName

						if fFlagSignalsNavP3gAvatarExperience then
							routeName = getLegacyNavigationStore(false).getCurrentRoute(false).routeName
						elseif fFlagUseNavigationSelectors then
							routeName = selectors.selectCurrentRoactNavigationRoute(state).routeName
						else
							routeName = state.Navigation.currentRoute.routeName
						end

						if routeName == avatarScreen.Checkout then
							module16.closeFocusedScreen(p3)
						elseif routeName == avatarScreen.MySharedAvatars or p6 == peekViewState.Full then
							object2:dispatch(navigateWithLock(function()
								module16.closeFiltersAndItemDetails(p3)
								module16.closeTryOnManager(p3, { avatarScreen.TryOnManager })
								p3.navigate(avatarScreen.LookDetails)
							end))
						end
					end

					return module.resolve()
				end

				logging.warn("Unexpectedly received an empty response from Look Details V2")

				if module18() then
					handleErrorCases(
						object2,
						p3,
						p5,
						"Unexpectedly received an empty response from Look Details V2"
					)
				else
					object2:dispatch(module14({
						isLocalized = false,
						toastType = module8.NetworkingError,
						toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
					}))
				end
			end):catch(function(p9)
				logging.warn("Failed to fetch Look Details V2")

				if module18() then
					handleErrorCases(object2, p3, p5, "Failed to fetch Look Details V2 with lookId: ")
				else
					object2:dispatch(module14({
						isLocalized = false,
						toastType = module8.NetworkingError,
						toastMessage = "Feature.Toast.NetworkingError.SomethingIsWrong"
					}))
				end

				return module.reject(p9)
			end)
		end)(object)
	end
end
