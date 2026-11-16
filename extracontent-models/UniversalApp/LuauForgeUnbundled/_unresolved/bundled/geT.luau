local module = require("@luauforge/bundled/geU")
local module2 = require("@luauforge/bundled/geV")
local module3 = require("@luauforge/bundled/geW")

local module4 = require("@luauforge/bundled/geX")
local module5 = require("@luauforge/bundled/geY")
local module6 = require("@luauforge/bundled/geZ")
local analyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AnalyticsService
local module7 = require("@luauforge/bundled/dMx")
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums
local module8 = require("@luauforge/bundled/dOj")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local constants = AvatarExperienceAnalytics.Constants

local module11 = require("@luauforge/bundled/gfa")
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1

local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters

local v6 = nil

local function getAvatarEditorAnalyticsInner(p2)
	local function sendEvent(p3, p4, p5, p6, p7, p8)
		module(p2.EventStream, p3, p7, p4, p5, p6, p8)
	end

	local avatarEditorAnalyticsInner = {
		equipAsset = function(p3, p4, p5, p6, p7, p8)
			local v7 = module7.AssetTypeIdStringToName[p6] or "UnknownAssetTypeId: " .. p6
			module(p2.EventStream, "EquipAsset", v7, p3, p4, p5, p8)

			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXEquipAsset)
		end,
		unequipAsset = function(p3, p4, p5, p6, p7, p8)
			local v7 = module7.AssetTypeIdStringToName[p6] or "UnknownAssetTypeId: " .. p6
			module(p2.EventStream, "UnequipAsset", v7, p3, p4, p5, p8)

			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXUnequipAsset)
		end,
		clickNavigationTab = function(p3, p4, p5)
			local v7 = module8()[p3]

			if v7 then
				local v8 = v7.Subcategories and v7.Subcategories[p4]
				local v9

				if fFlagAXEditorSubcategoryFilters and p5 and v8 and v8.SubcategoryFilters then
					v9 = v8.SubcategoryFilters[p5]
				end

				local name = v7 and v7.Name or ""
				local name2 = v8 and v8.Name or ""

				local v10 = not (fFlagAXEditorSubcategoryFilters and v9) and "" or v9.Name

				local eventStream = p2.EventStream

				if not fFlagAXEditorSubcategoryFilters then
					v10 = nil
				end

				module2(eventStream, "clickNavigationTab", name, name2, v10)
			end
		end,
		setAvatarHeadSize = function(p3, p4, p5)
			module(p2.EventStream, "SetHeadSize", "HeadSize", p3, p4, p5, nil)
		end,
		setAvatarHeight = function(p3, p4, p5)
			module(p2.EventStream, "SetHeight", "Height", p3, p4, p5, nil)
		end,
		setAvatarWidth = function(p3, p4, p5)
			module(p2.EventStream, "SetWidth", "Width", p3, p4, p5, nil)
		end,
		setAvatarBodyType = function(p3, p4, p5)
			module(p2.EventStream, "SetBodyType", "BodyType", p3, p4, p5, nil)
		end,
		setAvatarProportion = function(p3, p4, p5)
			module(p2.EventStream, "SetProportion", "Proportion", p3, p4, p5, nil)
		end,
		toggleAvatarType = function(p3, p4, p5)
			module(p2.EventStream, "SetAvatarType", "AvatarType", p3, p4, p5, nil)
		end,
		setBodyColors = function(items, p3, p4)
			local v7 = items[next(items)] or "empty"

			for k, item in items do
				v7 = item == v7 and v7 or "mixed"
			end

			module(p2.EventStream, "SetBodyColors", "BodyColors", v7, p3, p4, nil)
		end,
		setBodyColor3s = function(items, p3, p4)
			local v7 = items[next(items)]:ToHex() or "empty"

			for k, item in items do
				v7 = item:ToHex() == v7 and v7 or "mixed"
			end

			module(p2.EventStream, "SetBodyColor3s", "BodyColor3s", v7, p3, p4, nil)
		end,
		clickShopForMore = function(p3, p4)
			local v7 = module8()[p3]

			if v7 then
				local v8 = v7.Subcategories and v7.Subcategories[p4]
				local name = v7 and v7.Name or ""
				local name2 = v8 and v8.Name or ""
				module3(p2.EventStream, "ClickShopForMore", name, name2)
			end
		end,
		catalogToAvatarBackButton = function()
			module5(p2.EventStream, "ClickCatalogToAvatarBackButton")
		end,
		catalogToAvatarButton = function()
			module6(p2.EventStream, "ClickCatalogToAvatarButton")
		end,
		avatarEditorOpenedFromLandingPage = function()
			module4(p2.EventStream, "AvatarEditorLandingPageButtonClicked")
		end,
		outfitCreated = function(p3)
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXCreateCostume)
		end,
		outfitClicked = function(itemId, p3, p4)
			local v7 = {
				surface = impressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
				actionType = impressionEnums.ActionType.ITEM_CLICK,
				contentType = impressionEnums.MarketplaceItemType.CHARACTER,
				characterType = 0,
				itemId = 0
			}

			local v8 = if p4 then impressionEnums.CharacterType.CREATION else impressionEnums.CharacterType.PURCHASED
			v7.characterType = v8

			v7.itemId = itemId

			p2.EventStream:sendTelemetryEvent("clickToWearOutfit", "marketplaceOrganicFELog", v7)
		end,
		colorPickerChanged = function(p3, p4, p5)
			reportAvatarEventCounterV1(constants.AVATAR_EVENT_COUNTER_NAME.AXColorPickerChanged)
		end
	}

	if module11 then
		v6 = avatarEditorAnalyticsInner
	end

	return avatarEditorAnalyticsInner
end

return {
	mock = function(p2)
		return getAvatarEditorAnalyticsInner(p2)
	end,
	get = function(p2)
		if module11 and v6 then
			return v6
		end

		return getAvatarEditorAnalyticsInner(analyticsService)
	end
}
