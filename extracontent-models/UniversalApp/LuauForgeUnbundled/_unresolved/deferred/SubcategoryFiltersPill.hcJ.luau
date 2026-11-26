local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local fFlagAXBodyPartsPillLabel = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBodyPartsPillLabel

local function selectSubcategoryFilterIndex(p2)
	return p2.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
end

local function SubcategoryFiltersPill(p2)
	local v5 = useNavigation()
	local ref = React.useRef(nil)
	local v6 = useTokens()
	local v7 = useSelector(selectSubcategoryFilterIndex)
	local v8 = if p2.categoryInfo.SubcategoryFilters then p2.categoryInfo.SubcategoryFilters[v7] else nil

	local v11 = if v8 then v8.Title else nil
	local v12 = useLocalization({ pillText = v11 })

	local v13 = React.useCallback(function()
		local current = ref.current

		local v14 = if current then Vector2.new(
			current.AbsolutePosition.X,
			current.AbsolutePosition.Y + current.AbsoluteSize.Y + v6.Gap.Small
		) else nil

		v5.navigate(avatarScreen.SubcategoryFiltersDropdown, { dropdownPosition = v14 })
	end, { v5, v6 })

	local createElement = React.createElement
	local pill = Foundation.Pill
	local v14 = {
		icon = {
			name = "icons/actions/truncationExpand_small",
			position = Foundation.Enums.IconPosition.Right
		},
		text = v12.pillText,
		isChecked = false,
		ref = ref,
		onActivated = v13,
		LayoutOrder = 0
	}

	local v15 = if fFlagAXBodyPartsPillLabel then p2.LayoutOrder else nil
	v14.LayoutOrder = v15
	return createElement(pill, v14)
end

return SubcategoryFiltersPill
