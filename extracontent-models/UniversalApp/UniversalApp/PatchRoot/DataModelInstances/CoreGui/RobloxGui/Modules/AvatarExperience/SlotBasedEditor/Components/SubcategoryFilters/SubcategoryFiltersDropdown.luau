local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local Foundation = require(CorePackages.Packages.Foundation)
local RadioGroup = Foundation.RadioGroup
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FormResponsiveDropdown = require(Modules.AvatarExperience.Common.Components.FormResponsiveDropdown)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Analytics = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection

local function SubcategoryFiltersDropdown() -- line: 35
	-- upvalues: useSelector (copy), Utils (copy), React (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), useNavigation (copy), useFocusNavigableSurfaceRegistryConnection (copy), FocusNavigableSurfaceIdentifierEnum (copy), NavigationUtils (copy), SetCategoryAndSubcategory (copy), useLocalization (copy), RadioGroup (copy), FormResponsiveDropdown (copy), Foundation (copy)
	local v21 = useSelector(Utils.getAvatarEditorCategoryInfoFromState)
	local v22 = useSelector(Utils.getAvatarEditorSubcategoryFilterFromState)
	local v23, v24 = React.useState(if not v22 then nil else v22.NavigationKey)
	local v25 = useDispatch()
	local v26 = useRoactService(Analytics)
	local v27 = useNavigation()
	local params = v27.state.params
	local v29 = not v22 or v23 ~= v22.NavigationKey
	local v30 = v21.SubcategoryFilters or {}
	local v31 = React.useRef(nil)

	useFocusNavigableSurfaceRegistryConnection(v31.current, FocusNavigableSurfaceIdentifierEnum.CentralOverlay)

	local v32 = React.useCallback(function() -- line: 50
		-- upvalues: NavigationUtils (copy), v27 (copy)
		NavigationUtils.closeFocusedScreen(v27)
	end, { v27 })
	local v33 = React.useCallback(function() -- line: 54
		-- upvalues: v30 (copy), v23 (copy), v25 (copy), SetCategoryAndSubcategory (copy), v21 (copy), v26 (copy), v32 (copy)
		local v37 = nil

		for v38, v39 in v30 do
			if v39.NavigationKey == v23 then
				v37 = v38

				break
			end
		end

		v25(SetCategoryAndSubcategory(v21.Category, v21.Subcategory, v26, v37))
		v32()
	end, {
		v30,
		v21,
		v25,
		v23,
		v26,
		v32
	})
	local v34 = React.useMemo(function() -- line: 73
		-- upvalues: v21 (copy), v30 (copy)
		local t1 = {
			header = v21.SubcategoryFiltersHeader
		}

		for _, v42 in v30 do
			t1[v42.NavigationKey] = v42.Title
		end

		return t1
	end, {
		v21,
		v30
	})
	local v35 = useLocalization(v34)
	local v36 = React.useMemo(function() -- line: 82
		-- upvalues: v30 (copy), React (copy), RadioGroup (copy), v35 (copy)
		local t2 = {}

		for _, v45 in v30 do
			table.insert(t2, (React.createElement(RadioGroup.Item, {
				value = v45.NavigationKey,
				label = v35[v45.NavigationKey]
			})))
		end

		return t2
	end, {
		v30,
		v35
	})

	return React.createElement(FormResponsiveDropdown, {
		canApply = v29,
		onApply = v33,
		onClose = v32,
		dropdownPosition = params.dropdownPosition,
		headerText = v35.header,
		ref = v31
	}, {
		Container = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y"
		}, {
			RadioGroup = React.createElement(RadioGroup.Root, {
				onValueChanged = v24,
				value = v23
			}, v36)
		})
	})
end

return SubcategoryFiltersDropdown
