local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local module = require("@luauforge/deferred/fzF")
local module2 = require("@luauforge/deferred/fzI")
local module3 = require("@luauforge/deferred/fzJ")
local module4 = require("@luauforge/bundled/fup")

local view = Foundation.View
local chipGroup = Foundation.ChipGroup

local enums = Foundation.Enums
local chipSize = enums.ChipSize
local chipVariant = enums.ChipVariant

local function RobloxPlusThemeSelector(props)
	local categories = module2.buildCategories(props.themeKeys, props.categoryLabels)

	local state, setState = React.useState(function()
		return module2.findCategoryIndex(categories, props.selectedThemeKey) or 1
	end)

	local categoryIndex = module2.findCategoryIndex(categories, props.selectedThemeKey)
	React.useEffect(function()
		if categoryIndex ~= nil then
			setState(categoryIndex)
		end
	end, { categoryIndex })

	local v5 = categories[state] or categories[1]
	local themeKeys = if v5 then v5.themeKeys else props.themeKeys

	local v6 = {}

	for k, category in categories do
		v6[k] = {
			text = category.label,
			isChecked = k == state,
			variant = chipVariant.Standard,
			onActivated = function()
				setState(k)
			end
		}
	end

	local robloxThemeKeys = props.robloxThemeKeys or module4.RobloxThemeKeys
	local showExclusiveThemes = props.showExclusiveThemes ~= false

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-xlarge size-full-0 auto-y"
	}

	local v9 = {
		RobloxThemes = React.createElement(view, {
			LayoutOrder = 1,
			tag = "size-full-0 auto-y"
		}, {
			Options = React.createElement(module, {
				LayoutOrder = 1,
				themeKeys = robloxThemeKeys,
				themeLabels = props.themeLabels,
				selectedThemeKey = props.selectedThemeKey,
				columns = math.min(props.columns, #robloxThemeKeys),
				testIdPrefix = "RobloxPlusThemeSelector--roblox",
				onActivated = props.onSelect,
				isUpdating = props.isUpdating
			})
		}),
		ExclusiveThemes = 0
	}
	local v10

	if showExclusiveThemes then
		local createElement2 = React.createElement

		local children = {
			Header = React.createElement(module3, {
				LayoutOrder = 1,
				title = props.exclusiveThemesLabel or "",
				showPlusIcon = true,
				badgeText = props.newBadgeText,
				testId = "RobloxPlusThemeSelector--exclusive-themes-header"
			}),
			Banner = 0,
			Categories = 0,
			Options = 0
		}

		local v13 = if props.banner ~= nil then React.createElement(
			view,
			{ LayoutOrder = 2, tag = "size-full-0 auto-y" },
			{ Content = props.banner }
		) else nil
		children.Banner = v13

		children.Categories = React.createElement(chipGroup, {
			LayoutOrder = 3,
			size = chipSize.Small,
			chips = v6,
			testId = "RobloxPlusThemeSelector--categories"
		})

		children.Options = React.createElement(module, {
			LayoutOrder = 4,
			themeKeys = themeKeys,
			themeLabels = props.themeLabels,
			selectedThemeKey = props.selectedThemeKey,
			columns = props.columns,
			testIdPrefix = "RobloxPlusThemeSelector",
			onActivated = props.onSelect,
			isUpdating = props.isUpdating
		})
		v10 = createElement2(view, {
			LayoutOrder = 2,
			tag = "col gap-medium size-full-0 auto-y"
		}, children)
	end

	v9.ExclusiveThemes = v10
	return createElement(view, v8, v9)
end

return RobloxPlusThemeSelector
