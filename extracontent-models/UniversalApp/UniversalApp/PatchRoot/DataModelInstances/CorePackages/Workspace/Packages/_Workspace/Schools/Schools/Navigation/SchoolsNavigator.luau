local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local RoactNavigation = require(SchoolsParent.RoactNavigation)
local AddSchoolUpsellContainer = require(Schools.Components.AddSchoolUpsell.AddSchoolUpsellContainer)
local VerifyEmail = require(Schools.Components.VerifyEmail)
local SchoolMemberListPageContainer = require(Schools.Components.SchoolMemberListPage.SchoolMemberListPageContainer)
local SchoolWaitlistContainer = require(Schools.Components.SchoolWaitlist.SchoolWaitlistContainer)
local Routes = require(Schools.Navigation.Routes)
local t1 = {
	overlayEnabled = true,
	overlayTransparency = 1,
	absorbInput = true,
	disableBackButton = true
}
local t2 = {
	overlayEnabled = false,
	absorbInput = true
}
local t3 = {
	{
		[Routes.AddSchoolUpsell] = {
			screen = AddSchoolUpsellContainer,
			navigationOptions = t1
		}
	},
	{
		[Routes.VerifyEmail] = {
			screen = VerifyEmail,
			navigationOptions = t2
		}
	},
	{
		[Routes.SchoolWaitlist] = {
			screen = SchoolWaitlistContainer,
			navigationOptions = t2
		}
	},
	{
		[Routes.SchoolMemberList] = {
			screen = SchoolMemberListPageContainer,
			navigationOptions = t2
		}
	}
}
local v13 = RoactNavigation.createRobloxStackNavigator(t3, {
	initialRouteName = Routes.AddSchoolUpsell,
	defaultNavigationOptions = t1,
	mode = RoactNavigation.StackPresentationStyle.Overlay
})
local v14 = React.PureComponent:extend("SchoolsNavigatorWrapper")

function v14.render(p1) -- line: 70
	-- upvalues: React (copy), v13 (copy)
	return React.createElement(v13, p1.props)
end

v14.router = v13.router

return v14
