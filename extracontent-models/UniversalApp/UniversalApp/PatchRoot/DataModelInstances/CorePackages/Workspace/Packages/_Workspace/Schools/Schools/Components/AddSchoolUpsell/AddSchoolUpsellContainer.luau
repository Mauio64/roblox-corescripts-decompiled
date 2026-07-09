local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local RoactUtils = require(SchoolsParent.RoactUtils)
local NavigationRodux = require(SchoolsParent.NavigationRodux)
local useNavigationFocus = require(SchoolsParent.Navigation).useNavigationFocus
local AddSchoolUpsell = require(script.Parent.AddSchoolUpsell)
local Routes = require(Schools.Navigation.Routes)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateBack = NavigationRodux.Thunks.NavigateBack

local function AddSchoolUpsellContainer(t1: {[any]: any}) -- line: 19
	-- upvalues: useDispatch (copy), useNavigationFocus (copy), React (copy), Routes (copy), NavigateBack (copy), AddSchoolUpsell (copy)
	local v13 = useDispatch()
	local navigation = t1.navigation
	local v15 = useNavigationFocus()
	local v16 = React.useCallback(function() -- line: 25
		-- upvalues: navigation (copy), Routes (copy)
		navigation.navigate(Routes.VerifyEmail)
	end, { navigation })
	local v17 = React.useCallback(function() -- line: 29
		-- upvalues: navigation (copy), v13 (copy), NavigateBack (copy)
		if navigation.isFocused() then
			v13(NavigateBack())
		end
	end, {
		navigation,
		v13
	})

	return React.createElement(AddSchoolUpsell, {
		isOpen = v15,
		onContinue = v16,
		onClose = v17
	})
end

return AddSchoolUpsellContainer
