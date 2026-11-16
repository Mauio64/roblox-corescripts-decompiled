local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local t = require(CorePackages.Packages.t)

local module = require("@luauforge/bundled/fvZ")
local module2 = require("@luauforge/bundled/dLY")
local module3 = require("@luauforge/bundled/gOl")

local module4 = require("@luauforge/bundled/dSU")

local module5 = require("@luauforge/bundled/dCp")

local module6 = require("@luauforge/bundled/dHL")
local setOutfitTryOns = module6.Actions.SetOutfitTryOns
local module7 = require("@luauforge/bundled/dRQ")
local module8 = require("@luauforge/bundled/glS")
local module9 = require("@luauforge/bundled/goD")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local module10 = require("@luauforge/bundled/dMx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module11 = require("@luauforge/bundled/dYT")
local module12 = require("@luauforge/bundled/eda")
local module13 = require("@luauforge/bundled/fvF")
require("@luauforge/bundled/dMc")
local navigatedToNonTryOnPage = module6.Actions.NavigatedToNonTryOnPage
local navigatedToTryOnPage = module6.Actions.NavigatedToTryOnPage

local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXTryOnScreenFixes = AvatarExperienceFlags.FFlagAXTryOnScreenFixes
local fFlagAXFixLookTryOnReturnRemoval = AvatarExperienceFlags.FFlagAXFixLookTryOnReturnRemoval
local fFlagAXSpawnEffectPreview = AvatarExperienceFlags.FFlagAXSpawnEffectPreview
local setSpawnEffectPreview = module6.Actions.SetSpawnEffectPreview

local extended = Roact.PureComponent:extend("ItemSelectionManager")

local strictInterface = t.strictInterface
local v5 = {
	avatarRoute = t.table,
	itemSubType = t.optional(t.string),
	selectedAnimationPreview = t.optional(t.string),
	selectedSpawnEffectPreview = 0,
	lastToggledItem = 0,
	lastSavedTriedOnOutfit = 0,
	tryOnItems = 0,
	lookId = 0,
	externalNavigationRequestParams = 0,
	storeAndClearTryOns = 0,
	setOutfitTryOns = 0,
	clearAnimationPreview = 0,
	clearSpawnEffectPreview = 0,
	toggleTryOn = 0,
	clearAllResultsListFocusedWidget = 0,
	onNavigatedToNonTryOnPage = 0,
	onNavigatedToTryOnPage = 0,
	networking = 0,
	appAnalytics = 0,
	catalogAnalytics = 0
}
local v6 = if fFlagAXSpawnEffectPreview then t.optional(t.string) else nil
v5.selectedSpawnEffectPreview = v6
v5.lastToggledItem = t.optional(t.table)
v5.lastSavedTriedOnOutfit = t.optional(t.table)
v5.tryOnItems = t.optional(t.table)
local v7 = if fFlagAXFixLookTryOnReturnRemoval then t.optional(t.string) else nil
v5.lookId = v7
v5.externalNavigationRequestParams = t.optional(t.table)

v5.storeAndClearTryOns = t.callback
v5.setOutfitTryOns = t.callback
v5.clearAnimationPreview = t.callback
local v8 = if fFlagAXSpawnEffectPreview then t.callback else nil
v5.clearSpawnEffectPreview = v8
v5.toggleTryOn = t.callback
v5.clearAllResultsListFocusedWidget = t.callback
v5.onNavigatedToNonTryOnPage = t.callback
v5.onNavigatedToTryOnPage = t.callback

v5.networking = t.callback
v5.appAnalytics = t.table
v5.catalogAnalytics = t.table
extended.validateProps = strictInterface(v5)

extended.defaultProps = { lastToggledItem = {} }

function extended.render(p2): nil
	return nil
end

local v9 = {
	[avatarScreen.ItemDetails] = true,
	[avatarScreen.TryOnItem] = not fFlagAXTryOnScreenFixes or nil
}

local v10 = {
	[avatarScreen.LayeredClothingSort] = true,
	[avatarScreen.AccessoryAdjustment] = true,
	[avatarScreen.TryOnItem] = fFlagAXTryOnScreenFixes and true or nil
}

local function getIdAndType(p2)
	local current = p2.avatarRoute.current

	if v9[current.name] then
		return current.params.itemId, current.params.itemType
	end

	return nil, nil
end

local function shouldClearAnimationPreview(data): boolean
	if data.isUnequipped then
		return true
	end

	if data.itemType == module10.ItemType.Asset then
		return module10.AssetTypeIdToCategory[data.itemSubType] ~= module10.AssetCategories.Animation
	end

	return data.itemSubType ~= module10.BundleTypeIdStrings.Animations
end

local function shouldClearSpawnEffectPreview(p2): boolean
	if p2.isUnequipped then
		return true
	end

	return p2.itemSubType ~= module10.AssetTypeIdStrings.SpawnEffect
end

local function isSingleTryOn(p2): boolean
	return false
end

function extended.willUpdate(p2, data)
	if v10[data.avatarRoute.current.name] then
		return
	end

	local current = data.avatarRoute.current
	local itemId, itemType

	if v9[current.name] then
		itemId = current.params.itemId
		itemType = current.params.itemType
	end

	local itemSubType = data.itemSubType

	local props = p2.props
end

function extended.didUpdate(p2, p3)
	if p2.props.selectedAnimationPreview and p2.props.lastToggledItem ~= p3.lastToggledItem then
		local lastToggledItem = p2.props.lastToggledItem
		local v11

		if lastToggledItem.isUnequipped then
			v11 = true
		elseif lastToggledItem.itemType == module10.ItemType.Asset then
			v11 = module10.AssetTypeIdToCategory[lastToggledItem.itemSubType] ~= module10.AssetCategories.Animation
		else
			v11 = lastToggledItem.itemSubType ~= module10.BundleTypeIdStrings.Animations
		end

		if v11 then
			p2.props.clearAnimationPreview()
		end
	end

	if
		fFlagAXSpawnEffectPreview
		and p2.props.selectedSpawnEffectPreview
		and p2.props.lastToggledItem ~= p3.lastToggledItem
	then
		local lastToggledItem = p2.props.lastToggledItem

		if
			lastToggledItem.isUnequipped
			or lastToggledItem.itemSubType ~= module10.AssetTypeIdStrings.SpawnEffect
		then
			p2.props.clearSpawnEffectPreview()
		end
	end

	local name = p2.props.avatarRoute.opaque.name
	local isTryOnOutfitResetPage = avatarScreenProperties[name]
		and avatarScreenProperties[name].isTryOnOutfitResetPage
	local name2 = p3.avatarRoute.opaque.name
	local isRefinementPage = avatarScreenProperties[name2]
		and avatarScreenProperties[name2].isRefinementPage

	if isTryOnOutfitResetPage and name ~= name2 and not isRefinementPage then
		p2.props.onNavigatedToNonTryOnPage()
	end

	local isRefinementPage2 = avatarScreenProperties[name] and avatarScreenProperties[name].isRefinementPage

	if
		name ~= name2
		and name2 == avatarScreen.Catalog
		and name ~= module5.ExperienceDetail
		and not (isTryOnOutfitResetPage or isRefinementPage2)
	then
		p2.props.clearAllResultsListFocusedWidget()
	end
end

local v11 = RoactRodux.connect(function(p2, p3)
	local current = p3.avatarRoute.current
	local itemId, itemType

	if v9[current.name] then
		itemId = current.params.itemId
		itemType = current.params.itemType
	end

	local v12 = itemData(p2.AvatarExperience.Common, itemId, itemType)
	local itemSubType = module7.GetItemSubType(itemType, v12)
	local lastToggledItem = p2.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem

	local params = p2.AvatarExperience.ExternalNavigationRequest.params or {}

	local v13 = {
		itemSubType = itemSubType,
		lastToggledItem = lastToggledItem,
		lastSavedTriedOnOutfit = p2.AvatarExperience.AvatarScene.LastSavedTriedOnOutfit,
		tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems,
		lookId = 0,
		selectedAnimationPreview = 0,
		selectedSpawnEffectPreview = 0,
		externalNavigationRequestParams = 0
	}

	local v14 = if fFlagAXFixLookTryOnReturnRemoval then p2.AvatarExperience.AvatarScene.OutfitTryOn.LookId else nil
	v13.lookId = v14

	v13.selectedAnimationPreview = p2.AvatarExperience.AvatarScene.TryOn.AnimationPreview

	local v15 = if fFlagAXSpawnEffectPreview then p2.AvatarExperience.AvatarScene.TryOn.SpawnEffectPreview else nil
	v13.selectedSpawnEffectPreview = v15

	v13.externalNavigationRequestParams = params
	return v13
end, function(callback)
	return {
		storeAndClearTryOns = function()
			callback(module3())
		end,
		setOutfitTryOns = function(p2)
			callback(setOutfitTryOns(p2))
		end,
		clearAnimationPreview = function()
			callback(module2())
		end,
		clearSpawnEffectPreview = fFlagAXSpawnEffectPreview and function()
			callback(setSpawnEffectPreview(nil))
		end or nil,
		clearAllResultsListFocusedWidget = function()
			return callback(module4())
		end,
		onNavigatedToNonTryOnPage = function()
			return callback(navigatedToNonTryOnPage())
		end,
		onNavigatedToTryOnPage = function()
			return callback(navigatedToTryOnPage())
		end,
		toggleTryOn = function(p2, p3, p4, p5, p6, p7, p8, p9)
			callback(module(p2, p3, p4, p5, p6, p7, p8, p9))
		end
	}
end)(extended)

return (module9((roactServices.connect({
	catalogAnalytics = module13,
	appAnalytics = module11,
	networking = module12
})(v11))))
