local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local FilterSubsection = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterSubsection)
local CreatorFilter = require(Modules.AvatarExperience.Common.Enum.CreatorFilter)
local PriceFilter = require(Modules.AvatarExperience.Common.Enum.PriceFilter)
local SalesTypeFilter = require(Modules.AvatarExperience.Common.Enum.SalesTypeFilter)
local UnavailableItemFilter = require(Modules.AvatarExperience.Common.Enum.UnavailableItemFilter)
local WearTimeFilter = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.WearTimeFilter
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

require(Modules.AvatarExperience.Catalog.Hooks.useFiltersController)

local FilterTextBox = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterTextBox)
local PriceRangeInput = require(Modules.AvatarExperience.Catalog.Components.Filters.PriceRangeInput)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local v16 = game:DefineFastFlag("AXDurablesFilters", false)
local Focusable = RoactGamepad.Focusable
local uDim = UDim.new(0, 20)
local uDim2 = UDim.new(0, 12)

local function Filters(t1: {[any]: any}) -- line: 41
	-- upvalues: RoactGamepad (copy), useLocalization (copy), React (copy), v16 (copy), uDim2 (copy), uDim (copy), Focusable (copy), FilterUtils (copy), FilterSubsection (copy), SalesTypeFilter (copy), CreatorFilter (copy), FilterTextBox (copy), WearTimeFilter (copy), PriceFilter (copy), Constants (copy), PriceRangeInput (copy), UnavailableItemFilter (copy)
	local v22 = RoactGamepad.useRefCache()
	local filtersController = t1.filtersController
	local v24 = useLocalization({
		salesType = "Feature.Catalog.Label.Filter.SalesType",
		all = "Feature.Avatar.Heading.All",
		limited = "Feature.Catalog.Label.Limited",
		premium = "Feature.Catalog.Label.Premium",
		timedOptions = "Feature.Durables.Filter.Title",
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
	local v25, v26 = React.useBinding(0)
	local v27 = RoactGamepad.useRefCache()

	local function updateTotalHeight() -- line: 75
		-- upvalues: v16 (copy), v27 (copy), uDim2 (copy), uDim (copy), v26 (copy), t1 (copy)
		local v29 = not v16 and 0 or (v27.WearTime.current or 0)
		local v30 = uDim2.Offset * 2 + uDim.Offset * 3 + (v27.SalesType.current or 0) + (v27.Creator.current or 0) + v29 + (v27.Price.current or 0) + (v27.UnavailableItems.current or 0)

		v26(v30)

		if t1.onHeightChanged then
			t1.onHeightChanged(v30)
		end
	end

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		restorePreviousChildFocus = true,
		Size = v25:map(FilterUtils.mapHeightToSize),
		ref = t1.frameRef,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		defaultChild = v22.SalesType
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = uDim
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = uDim2,
			PaddingBottom = uDim2,
			PaddingLeft = uDim2
		}),
		SalesType = React.createElement(FilterSubsection, {
			LayoutOrder = 1,
			title = v24.salesType,
			items = {
				{
					text = v24.all,
					id = SalesTypeFilter.All
				},
				{
					text = v24.limited,
					id = SalesTypeFilter.Collectibles
				},
				{
					text = v24.timedOptions,
					id = SalesTypeFilter.TimedOptions
				}
			},
			selectedValue = filtersController.salesTypeFilter,
			setSelectedValue = filtersController.setSalesTypeFilter,
			frameRef = v22.SalesType,
			NextSelectionDown = v22.Creator,
			onHeightChanged = function(n1: number) -- line: 128
				-- upvalues: v27 (copy), updateTotalHeight (copy)
				v27.SalesType.current = n1
				updateTotalHeight()
			end
		}),
		Creator = React.createElement(FilterSubsection, {
			LayoutOrder = 2,
			title = v24.creator,
			items = {
				{
					text = v24.allCreators,
					id = CreatorFilter.AllCreators
				},
				{
					id = CreatorFilter.Username,
					customView = React.createElement(FilterTextBox, {
						text = filtersController.creatorUsername,
						placeholderText = v24.creatorName,
						onTextChanged = filtersController.setCreatorUsername,
						onFocused = function() -- line: 144
							-- upvalues: filtersController (copy), CreatorFilter (copy)
							filtersController.setCreatorFilter(CreatorFilter.Username)
						end
					})
				}
			},
			selectedValue = filtersController.creatorFilter,
			setSelectedValue = filtersController.setCreatorFilter,
			frameRef = v22.Creator,
			NextSelectionUp = v22.SalesType,
			NextSelectionDown = v22.Price,
			onHeightChanged = function(n2: number) -- line: 155
				-- upvalues: v27 (copy), updateTotalHeight (copy)
				v27.Creator.current = n2
				updateTotalHeight()
			end
		}),
		WearTime = if not v16 then nil else React.createElement(FilterSubsection, {
			LayoutOrder = 3,
			selectionMode = "single",
			title = v24.wearTimeTitle,
			items = {
				{
					text = v24.wearTimeAll,
					id = WearTimeFilter.All
				},
				{
					text = v24.wearTimeTimedOptionsOnly,
					id = WearTimeFilter.TimedOptionsOnly
				}
			},
			selectedValue = filtersController.wearTimeFilter,
			setSelectedValue = filtersController.setWearTimeFilter,
			frameRef = v22.WearTime,
			NextSelectionUp = v22.Creator,
			NextSelectionDown = v22.Price,
			onHeightChanged = function(n3: number) -- line: 174
				-- upvalues: v27 (copy), updateTotalHeight (copy)
				v27.WearTime.current = n3
				updateTotalHeight()
			end
		}),
		Price = React.createElement(FilterSubsection, {
			LayoutOrder = not v16 and 3 or 4,
			title = v24.price,
			items = {
				{
					text = v24.anyPrice,
					id = PriceFilter.AnyPrice
				},
				{
					text = v24.priceRange,
					id = PriceFilter.PriceRange,
					expandedViewHeight = Constants.SortAndFiltersRowHeight,
					expandedView = React.createElement(PriceRangeInput, {
						minPrice = filtersController.minPrice,
						maxPrice = filtersController.maxPrice,
						setMinPrice = filtersController.setMinPrice,
						setMaxPrice = filtersController.setMaxPrice,
						onFocused = function() -- line: 194
							-- upvalues: filtersController (copy), PriceFilter (copy)
							filtersController.setPriceFilter(PriceFilter.PriceRange)
						end
					})
				}
			},
			selectedValue = filtersController.priceFilter,
			setSelectedValue = filtersController.setPriceFilter,
			frameRef = v22.Price,
			NextSelectionUp = v22.Creator,
			NextSelectionDown = v22.UnavailableItems,
			onHeightChanged = function(n4: number) -- line: 205
				-- upvalues: v27 (copy), updateTotalHeight (copy)
				v27.Price.current = n4
				updateTotalHeight()
			end
		}),
		UnavailableItems = React.createElement(FilterSubsection, {
			LayoutOrder = not v16 and 4 or 5,
			title = v24.unavailableItems,
			items = {
				{
					text = v24.hide,
					id = UnavailableItemFilter.Hide
				},
				{
					text = v24.show,
					id = UnavailableItemFilter.Show
				}
			},
			selectedValue = filtersController.unavailableItemFilter,
			setSelectedValue = filtersController.setUnavailableItemFilter,
			frameRef = v22.UnavailableItems,
			NextSelectionUp = v22.Price,
			onHeightChanged = function(n5: number) -- line: 221
				-- upvalues: v27 (copy), updateTotalHeight (copy)
				v27.UnavailableItems.current = n5
				updateTotalHeight()
			end
		})
	})
end

return Filters
