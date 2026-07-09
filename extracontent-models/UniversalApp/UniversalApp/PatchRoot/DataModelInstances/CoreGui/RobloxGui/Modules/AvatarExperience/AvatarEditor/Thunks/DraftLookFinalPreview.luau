local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.Types)

local Utils = require(Modules.AvatarExperience.Common.Utils)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local SetLookDetailsPeekViewSelectedTab = AvatarExperienceRodux.Actions.SetLookDetailsPeekViewSelectedTab
local SetTryOnManagerPeekViewState = AvatarExperienceRodux.Actions.SetTryOnManagerPeekViewState
local TryOnLooksOutfit = AvatarExperienceRodux.Actions.TryOnLooksOutfit
local NavigateWithLock = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Thunks.NavigateWithLock
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)

local function processAssetItem(p1) -- line: 27
	-- upvalues: WidgetConstants (copy)
	assert(p1.id ~= nil and p1.assetType ~= nil, "Asset is missing required fields")

	return {
		isNotSelectable = true,
		itemId = p1.id,
		itemType = WidgetConstants.ContentType.Asset,
		itemSubType = tostring(p1.assetType),
		tryOnItemOrder = p1.tryOnItemOrder
	}
end
local function processAssetItemInBundle(p2) -- line: 41
	-- upvalues: WidgetConstants (copy)
	assert(p2.id ~= nil and p2.assetType ~= nil, "Asset is missing required fields")

	return {
		itemId = tostring(p2.id),
		itemType = WidgetConstants.ContentType.Asset,
		itemSubType = tostring(p2.assetType),
		tryOnItemOrder = p2.tryOnItemOrder
	}
end
local function processBundleItem(p3) -- line: 54
	-- upvalues: processAssetItemInBundle (copy), WidgetConstants (copy)
	assert(p3.id ~= nil and p3.bundleType ~= nil, "Bundle is missing required fields")

	local n1 = 0
	local t1 = {}

	for v23, v24 in p3.assetsInBundle do
		if v24.isIncluded then
			v24.tryOnItemOrder = v23
			n1 += 1
			table.insert(t1, (processAssetItemInBundle(v24)))
		end
	end

	return {
		isNotSelectable = true,
		itemId = p3.id,
		itemType = WidgetConstants.ContentType.Bundle,
		itemSubType = tostring(p3.bundleType),
		items = t1,
		numberOfAssetsIncluded = if not (n1 > 0) then nil else n1,
		tryOnItemOrder = p3.tryOnItemOrder
	}
end

return function(p4) -- line: 80
	-- upvalues: Constants (copy), processAssetItem (copy), processBundleItem (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), TryOnLooksOutfit (copy), Utils (copy), NavigateWithLock (copy), NavigationUtils (copy), AvatarScreen (copy), SetLookDetailsPeekViewSelectedTab (copy)
	return function(p5) -- line: 81
		-- upvalues: Constants (copy), processAssetItem (copy), processBundleItem (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), TryOnLooksOutfit (copy), Utils (copy), p4 (copy), NavigateWithLock (copy), NavigationUtils (copy), AvatarScreen (copy), SetLookDetailsPeekViewSelectedTab (copy)
		local DraftLookId = Constants.DraftLookId
		local v28 = p5:getState().AvatarExperience.AvatarScene.Looks[DraftLookId]

		if not v28 then
			return
		end

		local lookAssetInfos = v28.lookAssetInfos
		local lookBundleInfos = v28.lookBundleInfos
		local t2 = {}

		for _, v33 in lookAssetInfos do
			table.insert(t2, (processAssetItem(v33)))
		end

		local t3 = {}

		for _, v36 in lookBundleInfos do
			table.insert(t3, (processBundleItem(v36)))
		end

		p5:dispatch(SetTryOnManagerPeekViewState(PeekViewState.Full))
		p5:dispatch(TryOnLooksOutfit({
			assetItemIdTypeAndSubtype = t2,
			bundleItemIdTypeAndSubtype = t3,
			lookId = DraftLookId,
			lookType = v28.lookType,
			bodyColor3s = if not v28.avatarProperties then nil else Utils.convertBodyColor3HexesToColor3s(v28.avatarProperties.bodyColor3s),
			scale = if not v28.avatarProperties then nil else v28.avatarProperties.scale
		}))

		if p4 ~= nil then
			p5:dispatch(NavigateWithLock(function() -- line: 117
				-- upvalues: NavigationUtils (copy), p4 (copy), AvatarScreen (copy), p5 (copy), SetLookDetailsPeekViewSelectedTab (copy)
				NavigationUtils.closeFiltersAndItemDetails(p4)
				p4.navigate(AvatarScreen.LookDetails)
				p5:dispatch(SetLookDetailsPeekViewSelectedTab(1))
			end))
		end
	end
end
