local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local RoactUtils = require(SchoolsParent.RoactUtils)
local NavigationRodux = require(SchoolsParent.NavigationRodux)
local SchoolMembersMock = require(Schools.Common.SchoolMembersMock)
local useSchool = require(Schools.Hooks.useSchool)
local useClassYears = require(Schools.Hooks.useClassYears)
local useSchoolMembers = require(Schools.Hooks.useSchoolMembers)
local SchoolMemberListPage = require(script.Parent.SchoolMemberListPage)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateBack = NavigationRodux.Thunks.NavigateBack

local function SchoolMemberListPageContainer(t1: {[any]: any}) -- line: 21
	-- upvalues: useDispatch (copy), useSchool (copy), useClassYears (copy), React (copy), SchoolMembersMock (copy), useSchoolMembers (copy), NavigateBack (copy), SchoolMemberListPage (copy)
	local v15 = useDispatch()
	local navigation = t1.navigation
	local v17 = useSchool()
	local v18 = useClassYears()
	local v19, v20 = React.useState(SchoolMembersMock.ALL_YEARS)
	local v21 = useSchoolMembers(v19)
	local v22 = React.useCallback(function(s1: string) -- line: 32
		-- upvalues: v20 (copy)
		v20(s1)
	end, {})
	local v23 = React.useCallback(function() -- line: 36
		-- upvalues: navigation (copy), v15 (copy), NavigateBack (copy)
		if navigation.isFocused() then
			v15(NavigateBack())
		end
	end, {
		navigation,
		v15
	})

	return React.createElement(SchoolMemberListPage, {
		schoolName = v17.name,
		location = v17.location,
		memberCount = v17.memberCount,
		classYears = v18,
		members = v21,
		gradYear = v19,
		onGradYearChanged = v22,
		onBack = v23
	})
end

return SchoolMemberListPageContainer
