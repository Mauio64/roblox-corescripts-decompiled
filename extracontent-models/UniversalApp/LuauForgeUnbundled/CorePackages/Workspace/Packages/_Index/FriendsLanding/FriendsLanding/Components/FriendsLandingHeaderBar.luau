local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")

local roact = dependencies.Roact
local withLocalization = dependencies.withLocalization
local actions = dependencies.RoactNavigation.Actions
local FriendsLandingContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingContext")
local FriendsLandingHeaderBarPresentational = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/FriendsLandingHeaderBar/FriendsLandingHeaderBarPresentational")
local appHeaderBar = dependencies.AppHeaderBar

local getActiveChildNavigationOptionsSafely = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Navigator/getActiveChildNavigationOptionsSafely")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/AppCommonLib").isTenFootInterface

local extended = roact.PureComponent:extend("FriendsLandingHeaderBar")

function extended:init()
	function self.renderLeft(p3, p4, p5)
		local makeBackButton = appHeaderBar.makeBackButton

		if isTenFootInterface() then
			return nil
		end

		return makeBackButton(function()
			p3.dispatch(actions.back())
		end)
	end
end

function extended.render(p2)
	return FriendsLandingContext.with(function(p3)
		local navigation = p2.props.navigation
		local v5 = getActiveChildNavigationOptionsSafely(navigation)
		return withLocalization({ titleText = v5.headerText.raw })(function(p4)
			local titleText = p4.titleText

			if p3.addFriendsPageSearchbarEnabled then
				return roact.createElement(FriendsLandingHeaderBarPresentational, {
					title = titleText,
					renderLeft = v5.renderLeft or p2.renderLeft(navigation),
					renderCenter = v5.renderCenter,
					renderRight = v5.renderRight,
					isSecondary = v5.useSecondaryHeader
				})
			end

			return roact.createElement(FriendsLandingHeaderBarPresentational, {
				title = titleText,
				renderLeft = v5.renderLeft or p2.renderLeft(navigation),
				renderCenter = v5.renderCenter,
				renderRight = v5.renderRight
			})
		end)
	end)
end

return extended
