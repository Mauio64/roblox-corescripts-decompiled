local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local pillGroup = UIBlox.App.Control.PillGroup
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local module = require("@luauforge/bundled/fDf")

local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module2 = require("@luauforge/bundled/dPN")
local module3 = require("@luauforge/deferred/hgv")
local module4 = require("@luauforge/deferred/hgx")
local module5 = require("@luauforge/bundled/eie")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local module6 = require("@luauforge/deferred/heE")
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module7 = require("@luauforge/deferred/fDP")
local module8 = require("@luauforge/deferred/hgy")
local module9 = require("@luauforge/deferred/heG")
local logger = require("@game/CorePackages/Workspace/Packages/AppDebug").LogTree.logger("ax.topics")

local defineFastInt = game:DefineFastInt("AXTopicsNumInitialItems", 10)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local fFlagAXCatalogSearchSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSearchSupportDisableFilters
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXFixEmptyCatalogSearchChrome = AvatarExperienceFlags.FFlagAXFixEmptyCatalogSearchChrome

local module11 = require("@luauforge/bundled/dSW")

local function findRemovedTopic(items, list)
	for k, item in items do
		if not Cryo.List.find(list, item) then
			return item
		end
	end

	return nil
end

local v5 = memoize(function(p2)
	return Cryo.List.filterMap(p2, function(p3, p4)
		if defineFastInt < p4 then
			return nil
		end

		return {
			targetId = tonumber(p3.id) or 0,
			itemType = p3.type
		}
	end)
end)

local function CatalogTopicBar(props)
	local v6 = v5(props.items or {})
	local searchKeyword = props.searchKeyword
	local v7, v8 = module4()
	local v9, v10 = module3(v7, v6, searchKeyword)
	local v11 = if fFlagAXFixEmptyCatalogSearchChrome then useTokens() else nil
	local v12 = module5(module)
	local v13 = module5(avatarExperienceAnalyticsService)

	local v14 = React.useCallback(function(list)
		local v15 = v9
		local v16 = v7

		local catalogSelectionStore = module11.getCatalogSelectionStore()
		local selectedCategoryId = catalogSelectionStore.selectedCategoryId(false)
		local selectedSubcategoryId = catalogSelectionStore.selectedSubcategoryId(false)

		if #list > #v7 then
			local item = list[#list]
			local v17 = Cryo.List.find(v9, item) or 0
			v12.selectTopic(item, v17, selectedCategoryId, selectedSubcategoryId, nil, v15, v16)
		elseif #list == #v7 - 1 then
			if not findRemovedTopic(v7, list) then
				logger:warning(
					"sendTopicsChangedAnalyticsEvent, removedTopic not found: {} -> {}",
					v7,
					list
				)
			end
		else
			logger:warning("sendTopicsChangedAnalyticsEvent, invalid change: {} -> {}", v7, list)
		end
	end, { v7, v9, findRemovedTopic })

	local v15 = useDispatch()
	local v16 = useNavigation()
	local v17 = module8()

	local v18 = React.useCallback(function(p2)
		v14(p2)

		if props.searchKeyword then
			v17 = v17 or {}
			assert(v17, "")

			v8(p2)
			v15(module7(v16, v17))
		else
			v8(p2)
		end

		v15(module9(v13, v16.state.routeName))
	end, { v14, props.searchKeyword, v17, v15, v16, v13 })

	if fFlagAXFixEmptyCatalogSearchChrome then
		local v19

		if fFlagAXMigrateAllTabToSduiDev or fFlagAXMoveCatalogFilterToL1Navigation then
			v19 = false
		else
			v19 = not fFlagAXCatalogSearchSupportDisableFilters
				or props.showFilterButton == nil
				or props.showFilterButton
		end

		if not (v10 or #v9 > 0 or #v7 > 0 or v19) then
			return React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, v11.Size.Size_300),
				BackgroundTransparency = 1,
				LayoutOrder = props.layoutOrder,
				ref = props.frameRef
			})
		end
	end

	return React.createElement(module6, {
		height = module2.PillBarHeight,
		layoutOrder = props.layoutOrder,
		showFilterButton = not (fFlagAXMigrateAllTabToSduiDev or fFlagAXMoveCatalogFilterToL1Navigation) and (not fFlagAXCatalogSearchSupportDisableFilters or props.showFilterButton == nil or props.showFilterButton),
		layoutRef = props.frameRef,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	}, {
		Topics = React.createElement(pillGroup, {
			layoutOrder = 2,
			pills = v9,
			selectedPills = v7,
			isLoading = v10,
			onSelectionChanged = v18,
			leftPadding = 0
		})
	})
end

return (React.memo(CatalogTopicBar))
