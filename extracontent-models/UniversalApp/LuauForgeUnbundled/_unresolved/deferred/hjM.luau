local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dPs")
local module3 = require("@luauforge/bundled/fCe")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module4 = require("@luauforge/bundled/dKU")
local setLookDetailsPeekViewSelectedTab = module4.Actions.SetLookDetailsPeekViewSelectedTab
local setTryOnManagerPeekViewState = module4.Actions.SetTryOnManagerPeekViewState
local tryOnLooksOutfit = module4.Actions.TryOnLooksOutfit

local navigateWithLock = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Thunks.NavigateWithLock
local module5 = require("@luauforge/bundled/dXh")

local function processAssetItem(lookAssetInfo)
	local v5 = lookAssetInfo.id ~= nil and lookAssetInfo.assetType ~= nil
	assert(v5, "Asset is missing required fields")

	return {
		itemId = lookAssetInfo.id,
		itemType = widgetConstants.ContentType.Asset,
		itemSubType = tostring(lookAssetInfo.assetType),
		tryOnItemOrder = lookAssetInfo.tryOnItemOrder,
		isNotSelectable = true
	}
end

local function processAssetItemInBundle(data)
	local v5 = data.id ~= nil and data.assetType ~= nil
	assert(v5, "Asset is missing required fields")

	return {
		itemId = tostring(data.id),
		itemType = widgetConstants.ContentType.Asset,
		itemSubType = tostring(data.assetType),
		tryOnItemOrder = data.tryOnItemOrder
	}
end

local function processBundleItem(lookBundleInfo)
	local v5 = lookBundleInfo.id ~= nil and lookBundleInfo.bundleType ~= nil
	assert(v5, "Bundle is missing required fields")
	local v6 = 0
	local v7 = {}

	for k, v8 in lookBundleInfo.assetsInBundle do
		if not v8.isIncluded then
			continue
		end

		v8.tryOnItemOrder = k
		v6 += 1
		table.insert(v7, processAssetItemInBundle(v8))
	end

	local v8 = {
		itemId = lookBundleInfo.id,
		itemType = widgetConstants.ContentType.Bundle,
		itemSubType = tostring(lookBundleInfo.bundleType),
		items = v7,
		numberOfAssetsIncluded = 0,
		tryOnItemOrder = 0,
		isNotSelectable = true
	}

	if not (v6 > 0) then
		v6 = nil
	end

	v8.numberOfAssetsIncluded = v6
	v8.tryOnItemOrder = lookBundleInfo.tryOnItemOrder
	return v8
end

return function(p2)
	return function(object)
		local draftLookId = module2.DraftLookId
		local look = object:getState().AvatarExperience.AvatarScene.Looks[draftLookId]

		if not look then
			return
		end

		local lookAssetInfos = look.lookAssetInfos
		local lookBundleInfos = look.lookBundleInfos

		local v5 = {}

		for k, lookAssetInfo in lookAssetInfos do
			table.insert(v5, processAssetItem(lookAssetInfo))
		end

		local v6 = {}

		for k, lookBundleInfo in lookBundleInfos do
			table.insert(v6, processBundleItem(lookBundleInfo))
		end

		object:dispatch(setTryOnManagerPeekViewState(peekViewState.Full))

		local v8 = {
			assetItemIdTypeAndSubtype = v5,
			bundleItemIdTypeAndSubtype = v6,
			lookId = draftLookId,
			lookType = look.lookType,
			bodyColor3s = 0,
			scale = 0
		}
		local v9 = if look.avatarProperties then module3.convertBodyColor3HexesToColor3s(look.avatarProperties.bodyColor3s) else nil
		v8.bodyColor3s = v9

		local v10 = if look.avatarProperties then look.avatarProperties.scale else nil
		v8.scale = v10
		object:dispatch(tryOnLooksOutfit(v8))

		if p2 ~= nil then
			object:dispatch(navigateWithLock(function()
				module5.closeFiltersAndItemDetails(p2)
				p2.navigate(avatarScreen.LookDetails)
				object:dispatch(setLookDetailsPeekViewSelectedTab(1))
			end))
		end
	end
end
