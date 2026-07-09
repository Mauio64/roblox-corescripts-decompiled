local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local avatarEditorPropertyChanged = require(Modules.AvatarExperience.AvatarEditor.Analytics.avatarEditorPropertyChanged)
local clickNavigationTab = require(Modules.AvatarExperience.AvatarEditor.Analytics.clickNavigationTab)
local clickShopForMore = require(Modules.AvatarExperience.AvatarEditor.Analytics.clickShopForMore)
local avatarEditorOpenedFromLandingPage = require(Modules.AvatarExperience.AvatarEditor.Analytics.avatarEditorOpenedFromLandingPage)
local catalogToAvatarBackButton = require(Modules.AvatarExperience.AvatarEditor.Analytics.catalogToAvatarBackButton)
local catalogToAvatarButton = require(Modules.AvatarExperience.AvatarEditor.Analytics.catalogToAvatarButton)
local AnalyticsService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).AnalyticsService
local Constants = require(Modules.AvatarExperience.Common.Constants)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local Constants2 = AvatarExperienceAnalytics.Constants
local FFlagAXImproveSlotBasedEditorPerformance = require(Modules.AvatarExperience.Flags.FFlagAXImproveSlotBasedEditorPerformance)
local reportAvatarEventCounterV1 = AvatarExperienceAnalytics.reportAvatarEventCounterV1
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local t1 = {}
local u21 = nil

local function getAvatarEditorAnalyticsInner(p1) -- line: 31
	-- upvalues: avatarEditorPropertyChanged (copy), Constants (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy), GetAvatarEditorCategories (copy), FFlagAXEditorSubcategoryFilters (copy), clickNavigationTab (copy), clickShopForMore (copy), catalogToAvatarBackButton (copy), catalogToAvatarButton (copy), avatarEditorOpenedFromLandingPage (copy), ImpressionEnums (copy), FFlagAXImproveSlotBasedEditorPerformance (copy), u21 (ref)
	local t2 = {}

	local function sendEvent(p2, p3, p4, p5, p6, p7) -- line: 34
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		avatarEditorPropertyChanged(p1.EventStream, p2, p6, p3, p4, p5, p7)
	end

	function t2.equipAsset(p8, p9, p10, p11, _, p13) -- line: 47
		-- upvalues: Constants (copy), avatarEditorPropertyChanged (copy), p1 (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy)
		local v41 = Constants.AssetTypeIdStringToName[p11] or "UnknownAssetTypeId: " .. p11

		avatarEditorPropertyChanged(p1.EventStream, "EquipAsset", v41, p8, p9, p10, p13)
		reportAvatarEventCounterV1(Constants2.AVATAR_EVENT_COUNTER_NAME.AXEquipAsset)
	end
	function t2.unequipAsset(p14, p15, p16, p17, _, p19) -- line: 60
		-- upvalues: Constants (copy), avatarEditorPropertyChanged (copy), p1 (copy), reportAvatarEventCounterV1 (copy), Constants2 (copy)
		local v48 = Constants.AssetTypeIdStringToName[p17] or "UnknownAssetTypeId: " .. p17

		avatarEditorPropertyChanged(p1.EventStream, "UnequipAsset", v48, p14, p15, p16, p19)
		reportAvatarEventCounterV1(Constants2.AVATAR_EVENT_COUNTER_NAME.AXUnequipAsset)
	end
	function t2.clickNavigationTab(p20, p21, p22) -- line: 73
		-- upvalues: GetAvatarEditorCategories (copy), FFlagAXEditorSubcategoryFilters (copy), clickNavigationTab (copy), p1 (copy)
		local v52 = GetAvatarEditorCategories()[p20]

		if v52 then
			local v53 = v52.Subcategories and v52.Subcategories[p21]
			local v54 = if not FFlagAXEditorSubcategoryFilters or (not p22 or (not v53 or not v53.SubcategoryFilters)) then nil else v53.SubcategoryFilters[p22]
			local v55 = v52 and v52.Name or ""
			local v56 = v53 and v53.Name or ""
			local v57 = (not FFlagAXEditorSubcategoryFilters or not v54) and "" or v54.Name

			clickNavigationTab(p1.EventStream, "clickNavigationTab", v55, v56, if not FFlagAXEditorSubcategoryFilters then nil else v57)
		end
	end
	function t2.setAvatarHeadSize(p23, p24, p25) -- line: 98
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		avatarEditorPropertyChanged(p1.EventStream, "SetHeadSize", "HeadSize", p23, p24, p25, nil)
	end
	function t2.setAvatarHeight(p26, p27, p28) -- line: 102
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		avatarEditorPropertyChanged(p1.EventStream, "SetHeight", "Height", p26, p27, p28, nil)
	end
	function t2.setAvatarWidth(p29, p30, p31) -- line: 106
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		avatarEditorPropertyChanged(p1.EventStream, "SetWidth", "Width", p29, p30, p31, nil)
	end
	function t2.setAvatarBodyType(p32, p33, p34) -- line: 110
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		avatarEditorPropertyChanged(p1.EventStream, "SetBodyType", "BodyType", p32, p33, p34, nil)
	end
	function t2.setAvatarProportion(p35, p36, p37) -- line: 114
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		avatarEditorPropertyChanged(p1.EventStream, "SetProportion", "Proportion", p35, p36, p37, nil)
	end
	function t2.toggleAvatarType(p38, p39, p40) -- line: 118
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		avatarEditorPropertyChanged(p1.EventStream, "SetAvatarType", "AvatarType", p38, p39, p40, nil)
	end
	function t2.setBodyColors(p41, p42, p43) -- line: 122
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		local v79 = p41[next(p41)] or "empty"

		for _, v81 in p41 do
			v79 = v81 == v79 and v79 or "mixed"
		end

		avatarEditorPropertyChanged(p1.EventStream, "SetBodyColors", "BodyColors", v79, p42, p43, nil)
	end
	function t2.setBodyColor3s(p44, p45, p46) -- line: 132
		-- upvalues: avatarEditorPropertyChanged (copy), p1 (copy)
		local v85 = p44[next(p44)]:ToHex() or "empty"

		for _, v87 in p44 do
			v85 = v85 == v87:ToHex() and v85 or "mixed"
		end

		avatarEditorPropertyChanged(p1.EventStream, "SetBodyColor3s", "BodyColor3s", v85, p45, p46, nil)
	end
	function t2.clickShopForMore(p47, p48) -- line: 142
		-- upvalues: GetAvatarEditorCategories (copy), clickShopForMore (copy), p1 (copy)
		local v90 = GetAvatarEditorCategories()[p47]

		if v90 then
			local v91 = v90.Subcategories and v90.Subcategories[p48]
			local v92 = v90 and v90.Name or ""
			local v93 = v91 and v91.Name or ""

			clickShopForMore(p1.EventStream, "ClickShopForMore", v92, v93)
		end
	end
	function t2.catalogToAvatarBackButton() -- line: 152
		-- upvalues: catalogToAvatarBackButton (copy), p1 (copy)
		catalogToAvatarBackButton(p1.EventStream, "ClickCatalogToAvatarBackButton")
	end
	function t2.catalogToAvatarButton() -- line: 156
		-- upvalues: catalogToAvatarButton (copy), p1 (copy)
		catalogToAvatarButton(p1.EventStream, "ClickCatalogToAvatarButton")
	end
	function t2.avatarEditorOpenedFromLandingPage() -- line: 160
		-- upvalues: avatarEditorOpenedFromLandingPage (copy), p1 (copy)
		avatarEditorOpenedFromLandingPage(p1.EventStream, "AvatarEditorLandingPageButtonClicked")
	end
	function t2.outfitCreated(_) -- line: 164
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants2 (copy)
		reportAvatarEventCounterV1(Constants2.AVATAR_EVENT_COUNTER_NAME.AXCreateCostume)
	end
	function t2.outfitClicked(p50, _, p52) -- line: 168
		-- upvalues: ImpressionEnums (copy), p1 (copy)
		local t3 = {
			surface = ImpressionEnums.MarketplaceSurfaceType.MARKETPLACE_USER_INVENTORY,
			actionType = ImpressionEnums.ActionType.ITEM_CLICK,
			contentType = ImpressionEnums.MarketplaceItemType.CHARACTER,
			characterType = if not p52 then ImpressionEnums.CharacterType.PURCHASED else ImpressionEnums.CharacterType.CREATION,
			itemId = p50
		}

		p1.EventStream:sendTelemetryEvent("clickToWearOutfit", "marketplaceOrganicFELog", t3)
	end
	function t2.colorPickerChanged(_, _, _) -- line: 183
		-- upvalues: reportAvatarEventCounterV1 (copy), Constants2 (copy)
		reportAvatarEventCounterV1(Constants2.AVATAR_EVENT_COUNTER_NAME.AXColorPickerChanged)
	end

	if FFlagAXImproveSlotBasedEditorPerformance then
		u21 = t2
	end

	return t2
end

function t1.mock(p56) -- line: 196
	-- upvalues: getAvatarEditorAnalyticsInner (copy)
	return (getAvatarEditorAnalyticsInner(p56))
end
function t1.get(_) -- line: 200
	-- upvalues: FFlagAXImproveSlotBasedEditorPerformance (copy), u21 (ref), AnalyticsService (copy), getAvatarEditorAnalyticsInner (copy)
	if FFlagAXImproveSlotBasedEditorPerformance and u21 then
		return u21
	end

	local v28 = AnalyticsService

	return (getAvatarEditorAnalyticsInner(v28))
end

return t1
