local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/eeo")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local Foundation = require(CorePackages.Packages.Foundation)
local radioGroup = Foundation.RadioGroup
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module2 = require("@luauforge/deferred/gXK")
local module3 = require("@luauforge/bundled/fuD")
local module4 = require("@luauforge/deferred/gft")
local module5 = require("@luauforge/bundled/dTM")
local module6 = require("@luauforge/bundled/geT")
local module7 = require("@luauforge/bundled/eeH")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local focusNavigableSurfaceIdentifierEnum = module.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = module.useFocusNavigableSurfaceRegistryConnection

local function SubcategoryFiltersDropdown()
	local v5 = useSelector(module3.getAvatarEditorCategoryInfoFromState)
	local v6 = useSelector(module3.getAvatarEditorSubcategoryFilterFromState)

	local useState = React.useState
	local v7 = if v6 then v6.NavigationKey else nil
	local state, setState = useState(v7)
	local v8 = useDispatch()
	local v9 = module7(module6)
	local v10 = useNavigation()
	local params = v10.state.params
	local v11 = not v6 or v6.NavigationKey ~= state
	local subcategoryFilters = v5.SubcategoryFilters or {}

	local ref = React.useRef(nil)
	useFocusNavigableSurfaceRegistryConnection(
		ref.current,
		focusNavigableSurfaceIdentifierEnum.CentralOverlay
	)

	local v12 = React.useCallback(function()
		module5.closeFocusedScreen(v10)
	end, { v10 })

	local v13 = React.useCallback(function()
		local v14 = nil

		for k, subcategoryFilter in subcategoryFilters do
			if subcategoryFilter.NavigationKey == state then
				v14 = k
				break
			end
		end

		v8(module4(v5.Category, v5.Subcategory, v9, v14))

		v12()
	end, { subcategoryFilters, v5, v8, state, v9, v12 })

	local v14 = useLocalization((React.useMemo(function()
		local titlesByNavigationKey = { header = v5.SubcategoryFiltersHeader }

		for k, subcategoryFilter in subcategoryFilters do
			titlesByNavigationKey[subcategoryFilter.NavigationKey] = subcategoryFilter.Title
		end

		return titlesByNavigationKey
	end, { v5, subcategoryFilters })))

	local v15 = React.useMemo(function()
		local children = {}

		for k, subcategoryFilter in subcategoryFilters do
			table.insert(
				children,
				React.createElement(radioGroup.Item, {
					value = subcategoryFilter.NavigationKey,
					label = v14[subcategoryFilter.NavigationKey]
				})
			)
		end

		return children
	end, { subcategoryFilters, v14 })

	return React.createElement(module2, {
		canApply = v11,
		onApply = v13,
		onClose = v12,
		dropdownPosition = params.dropdownPosition,
		headerText = v14.header,
		ref = ref
	}, {
		Container = React.createElement(Foundation.View, { tag = "size-full-0 auto-y" }, {
			RadioGroup = React.createElement(
				radioGroup.Root,
				{ onValueChanged = setState, value = state },
				v15
			)
		})
	})
end

return SubcategoryFiltersDropdown
