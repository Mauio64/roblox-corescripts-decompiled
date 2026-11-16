local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)

local roact = dependencies.Roact
local withLocalization = dependencies.withLocalization
local actions = dependencies.RoactNavigation.Actions
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FriendsLandingHeaderBarPresentational = require(script.FriendsLandingHeaderBarPresentational)
local appHeaderBar = dependencies.AppHeaderBar

local getActiveChildNavigationOptionsSafely = require(FriendsLanding.Navigator.getActiveChildNavigationOptionsSafely)
local AppCommonLib = require(parent.AppCommonLib)
local isTenFootInterface = AppCommonLib.isTenFootInterface

local extended = roact.PureComponent:extend("FriendsLandingHeaderBar")

function extended:init()
	function self.renderLeft(p, _, _)
		local makeBackButton = appHeaderBar.makeBackButton

		if isTenFootInterface() then
			return nil
		end

		return makeBackButton(function()
			p.dispatch(actions.back())
		end)
	end
end

function extended.render(p)
	return FriendsLandingContext.with(function(p2)
		local navigation = p.props.navigation
		local activeChildNavigationOptionsSafely = getActiveChildNavigationOptionsSafely(navigation)
		return withLocalization({ titleText = activeChildNavigationOptionsSafely.headerText.raw })(function(p3)
			local titleText = p3.titleText

			if p2.addFriendsPageSearchbarEnabled then
				return roact.createElement(FriendsLandingHeaderBarPresentational, {
					title = titleText,
					renderLeft = activeChildNavigationOptionsSafely.renderLeft or p.renderLeft(navigation),
					renderCenter = activeChildNavigationOptionsSafely.renderCenter,
					renderRight = activeChildNavigationOptionsSafely.renderRight,
					isSecondary = activeChildNavigationOptionsSafely.useSecondaryHeader
				})
			end

			return roact.createElement(FriendsLandingHeaderBarPresentational, {
				title = titleText,
				renderLeft = activeChildNavigationOptionsSafely.renderLeft or p.renderLeft(navigation),
				renderCenter = activeChildNavigationOptionsSafely.renderCenter,
				renderRight = activeChildNavigationOptionsSafely.renderRight
			})
		end)
	end)
end

return extended
