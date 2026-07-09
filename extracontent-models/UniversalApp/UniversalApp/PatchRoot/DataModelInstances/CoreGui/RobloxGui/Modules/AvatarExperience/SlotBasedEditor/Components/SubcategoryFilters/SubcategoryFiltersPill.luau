local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local FFlagAXBodyPartsPillLabel = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXBodyPartsPillLabel

local function selectSubcategoryFilterIndex(p1) -- line: 17
	return p1.AvatarExperience.AvatarEditor.Categories.subcategoryFilter
end
local function SubcategoryFiltersPill(t1: {[any]: any}) -- line: 21
	-- upvalues: useNavigation (copy), React (copy), useTokens (copy), useSelector (copy), selectSubcategoryFilterIndex (copy), useLocalization (copy), AvatarScreen (copy), Foundation (copy), FFlagAXBodyPartsPillLabel (copy)
	local v14 = useNavigation()
	local v15 = React.useRef(nil)
	local v16 = useTokens()
	local v17 = useSelector(selectSubcategoryFilterIndex)
	local v18 = if not t1.categoryInfo.SubcategoryFilters then nil else t1.categoryInfo.SubcategoryFilters[v17]
	local v19 = useLocalization({
		pillText = if not v18 then nil else v18.Title
	})
	local v20 = React.useCallback(function() -- line: 33
		-- upvalues: v15 (copy), v16 (copy), v14 (copy), AvatarScreen (copy)
		local current = v15.current
		local v22 = if not current then nil else Vector2.new(current.AbsolutePosition.X, current.AbsolutePosition.Y + current.AbsoluteSize.Y + v16.Gap.Small)

		v14.navigate(AvatarScreen.SubcategoryFiltersDropdown, {
			dropdownPosition = v22
		})
	end, {
		v14,
		v16
	})

	return React.createElement(Foundation.Pill, {
		isChecked = false,
		icon = {
			name = "icons/actions/truncationExpand_small",
			position = Foundation.Enums.IconPosition.Right
		},
		text = v19.pillText,
		ref = v15,
		onActivated = v20,
		LayoutOrder = if not FFlagAXBodyPartsPillLabel then nil else t1.LayoutOrder
	})
end

return SubcategoryFiltersPill
