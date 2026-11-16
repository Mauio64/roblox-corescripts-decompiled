local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fuL")
local module2 = require("@luauforge/deferred/gXT")
local module3 = require("@luauforge/deferred/gXW")
local module4 = require("@luauforge/deferred/gXX")
local module5 = require("@luauforge/bundled/dMp")
local module6 = require("@luauforge/bundled/dMo")
local wearTimeFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.WearTimeFilter
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
require("@luauforge/deferred/gXY")
local module7 = require("@luauforge/deferred/gXZ")
local module8 = require("@luauforge/deferred/gYa")
local module9 = require("@luauforge/bundled/dMx")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local defineFastFlag = game:DefineFastFlag("AXDurablesFilters", false)
local fFlagAXTimedOptionsSalesTypeFilter = AvatarExperienceFlags.FFlagAXTimedOptionsSalesTypeFilter
local fFlagAXCatalogSpecialFeaturesFilter = AvatarExperienceFlags.FFlagAXCatalogSpecialFeaturesFilter
local specialFeatureFilter

if fFlagAXCatalogSpecialFeaturesFilter then
	specialFeatureFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.SpecialFeatureFilter
else
	specialFeatureFilter = nil
end

local focusable = RoactGamepad.Focusable

local udim = UDim.new(0, 20)
local udim2 = UDim.new(0, 12)

local function Filters(props)
	local v5 = RoactGamepad.useRefCache()

	local filtersController = props.filtersController

	local v6 = useLocalization({
		salesType = "Feature.Catalog.Label.Filter.SalesType",
		all = "Feature.Avatar.Heading.All",
		limited = "Feature.Catalog.Label.Limited",
		premium = "Feature.Catalog.Label.Premium",
		timedOptions = not fFlagAXTimedOptionsSalesTypeFilter and "Feature.Durables.Filter.Title" or nil,
		specialFeatures = fFlagAXCatalogSpecialFeaturesFilter and "Feature.Catalog.Label.Attributes" or nil,
		emissive = fFlagAXCatalogSpecialFeaturesFilter and "Feature.Catalog.Label.Emissive" or nil,
		advancedMaterials = fFlagAXCatalogSpecialFeaturesFilter and "Feature.Catalog.Label.AdvancedMaterials" or nil,
		creator = "Feature.Catalog.Label.Filter.Creator",
		allCreators = "Feature.Catalog.LabelAllCreators",
		username = "Feature.Catalog.Label.Username",
		creatorName = "Feature.Catalog.Label.CreatorName",
		price = "Feature.Catalog.Label.Price",
		anyPrice = "Feature.Catalog.LabelAnyPrice",
		priceRange = "Feature.Catalog.Label.PriceRange",
		unavailableItems = "Feature.Catalog.Label.Filter.UnavailableItems",
		show = "Feature.Catalog.Label.Filter.Show",
		hide = "Feature.Catalog.Label.Filter.Hide",
		wearTimeTitle = "Feature.Durables.Filter.Title",
		wearTimeAll = "Feature.Durables.Filter.All",
		wearTimeTimedOptionsOnly = "Feature.Durables.Filter.TimedOptions"
	})

	local v7, v8 = React.useBinding(0)

	local v9 = RoactGamepad.useRefCache()

	local function updateTotalHeight()
		local current = defineFastFlag and v9.WearTime.current or 0

		local v10 = udim2.Offset * 2 + udim.Offset * 3 + (v9.SalesType.current or 0) + (v9.Creator.current or 0) + current + (v9.Price.current or 0) + (v9.UnavailableItems.current or 0)

		if fFlagAXCatalogSpecialFeaturesFilter then
			v10 += (v9.SpecialFeatures.current or 0) + udim.Offset
		end

		v8(v10)

		if props.onHeightChanged then
			props.onHeightChanged(v10)
		end
	end

	local createElement = React.createElement
	local frame = focusable.Frame
	local v10 = {
		Size = v7:map(module.mapHeightToSize),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = props.frameRef,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		defaultChild = v5.SalesType,
		restorePreviousChildFocus = true
	}

	local children = {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = udim
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = udim2,
			PaddingBottom = udim2,
			PaddingLeft = udim2
		}),
		SalesType = 0,
		SpecialFeatures = 0,
		Creator = 0,
		WearTime = 0,
		Price = 0,
		UnavailableItems = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		LayoutOrder = fFlagAXCatalogSpecialFeaturesFilter and 0 or 1,
		title = v6.salesType,
		items = 0,
		selectedValue = 0,
		setSelectedValue = 0,
		frameRef = 0,
		NextSelectionDown = 0,
		onHeightChanged = 0
	}

	local v13 = if fFlagAXTimedOptionsSalesTypeFilter then {
		{ text = v6.all, id = module5.All },
		{ text = v6.limited, id = module5.Collectibles }
	} else {
		{ text = v6.all, id = module5.All },
		{ text = v6.limited, id = module5.Collectibles },
		{ text = v6.timedOptions, id = module5.TimedOptions }
	}
	v12.items = v13

	v12.selectedValue = filtersController.salesTypeFilter
	v12.setSelectedValue = filtersController.setSalesTypeFilter
	v12.frameRef = v5.SalesType

	local v14 = if fFlagAXCatalogSpecialFeaturesFilter then v5.SpecialFeatures else v5.Creator
	v12.NextSelectionDown = v14

	function v12.onHeightChanged(current)
		v9.SalesType.current = current
		updateTotalHeight()
	end

	children.SalesType = createElement2(module2, v12)
	local v15

	if fFlagAXCatalogSpecialFeaturesFilter then
		v15 = React.createElement(module2, {
			LayoutOrder = 1,
			selectionMode = "multiple",
			title = v6.specialFeatures,
			items = {
				{ text = v6.emissive, id = specialFeatureFilter.Emissive },
				{
					text = v6.advancedMaterials,
					id = specialFeatureFilter.AdvancedMaterials
				}
			},
			selectedValue = filtersController.specialFeaturesFilter,
			setSelectedValue = filtersController.toggleSpecialFeature,
			frameRef = v5.SpecialFeatures,
			NextSelectionUp = v5.SalesType,
			NextSelectionDown = v5.Creator,
			onHeightChanged = function(current)
				v9.SpecialFeatures.current = current
				updateTotalHeight()
			end
		})
	end

	children.SpecialFeatures = v15

	local createElement3 = React.createElement
	local v17 = {
		LayoutOrder = 2,
		title = v6.creator,
		items = {
			{ text = v6.allCreators, id = module3.AllCreators },
			{
				id = module3.Username,
				customView = React.createElement(module7, {
					text = filtersController.creatorUsername,
					placeholderText = v6.creatorName,
					onTextChanged = filtersController.setCreatorUsername,
					onFocused = function()
						filtersController.setCreatorFilter(module3.Username)
					end
				})
			}
		},
		selectedValue = filtersController.creatorFilter,
		setSelectedValue = filtersController.setCreatorFilter,
		frameRef = v5.Creator,
		NextSelectionUp = 0,
		NextSelectionDown = 0,
		onHeightChanged = 0
	}

	local v18 = if fFlagAXCatalogSpecialFeaturesFilter then v5.SpecialFeatures else v5.SalesType
	v17.NextSelectionUp = v18

	v17.NextSelectionDown = v5.Price
	function v17.onHeightChanged(current)
		v9.Creator.current = current
		updateTotalHeight()
	end

	children.Creator = createElement3(module2, v17)
	local v19

	if defineFastFlag then
		v19 = React.createElement(module2, {
			LayoutOrder = 3,
			selectionMode = "single",
			title = v6.wearTimeTitle,
			items = {
				{ text = v6.wearTimeAll, id = wearTimeFilter.All },
				{
					text = v6.wearTimeTimedOptionsOnly,
					id = wearTimeFilter.TimedOptionsOnly
				}
			},
			selectedValue = filtersController.wearTimeFilter,
			setSelectedValue = filtersController.setWearTimeFilter,
			frameRef = v5.WearTime,
			NextSelectionUp = v5.Creator,
			NextSelectionDown = v5.Price,
			onHeightChanged = function(current)
				v9.WearTime.current = current
				updateTotalHeight()
			end
		})
	end

	children.WearTime = v19

	children.Price = React.createElement(module2, {
		LayoutOrder = defineFastFlag and 4 or 3,
		title = v6.price,
		items = {
			{ text = v6.anyPrice, id = module4.AnyPrice },
			{
				text = v6.priceRange,
				id = module4.PriceRange,
				expandedViewHeight = module9.SortAndFiltersRowHeight,
				expandedView = React.createElement(module8, {
					minPrice = filtersController.minPrice,
					maxPrice = filtersController.maxPrice,
					setMinPrice = filtersController.setMinPrice,
					setMaxPrice = filtersController.setMaxPrice,
					onFocused = function()
						filtersController.setPriceFilter(module4.PriceRange)
					end
				})
			}
		},
		selectedValue = filtersController.priceFilter,
		setSelectedValue = filtersController.setPriceFilter,
		frameRef = v5.Price,
		NextSelectionUp = v5.Creator,
		NextSelectionDown = v5.UnavailableItems,
		onHeightChanged = function(current)
			v9.Price.current = current
			updateTotalHeight()
		end
	})

	children.UnavailableItems = React.createElement(module2, {
		LayoutOrder = defineFastFlag and 5 or 4,
		title = v6.unavailableItems,
		items = {
			{ text = v6.hide, id = module6.Hide },
			{ text = v6.show, id = module6.Show }
		},
		selectedValue = filtersController.unavailableItemFilter,
		setSelectedValue = filtersController.setUnavailableItemFilter,
		frameRef = v5.UnavailableItems,
		NextSelectionUp = v5.Price,
		onHeightChanged = function(current)
			v9.UnavailableItems.current = current
			updateTotalHeight()
		end
	})
	return createElement(frame, v10, children)
end

return Filters
