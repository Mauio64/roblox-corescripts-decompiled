local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Roact = dependencies.Roact
local withLocalization = dependencies.withLocalization
local Actions = dependencies.RoactNavigation.Actions
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local FriendsLandingHeaderBarPresentational = require(script.FriendsLandingHeaderBarPresentational)
local AppHeaderBar = dependencies.AppHeaderBar
local getActiveChildNavigationOptionsSafely = require(FriendsLanding.Navigator.getActiveChildNavigationOptionsSafely)
local FFlagEnableLeftNavOnConsole = dependencies.FFlagEnableLeftNavOnConsole
local GuiService = dependencies.GuiService
local v12 = Roact.PureComponent:extend("FriendsLandingHeaderBar")

function v12.init(p1) -- line: 18
	-- upvalues: AppHeaderBar (copy), FFlagEnableLeftNavOnConsole (copy), GuiService (copy), Actions (copy)
	function p1.renderLeft(p2, _, _) -- line: 19
		-- upvalues: AppHeaderBar (copy), FFlagEnableLeftNavOnConsole (copy), GuiService (copy), Actions (copy)
		local makeBackButton = AppHeaderBar.makeBackButton

		if FFlagEnableLeftNavOnConsole and GuiService:IsTenFootInterface() then
			return nil
		end

		return makeBackButton(function() -- line: 25
			-- upvalues: p2 (copy), Actions (copy)
			p2.dispatch(Actions.back())
		end)
	end
end
function v12.render(p5) -- line: 33
	-- upvalues: FriendsLandingContext (copy), getActiveChildNavigationOptionsSafely (copy), withLocalization (copy), Roact (copy), FriendsLandingHeaderBarPresentational (copy)
	return FriendsLandingContext.with(function(p6) -- line: 34
		-- upvalues: p5 (copy), getActiveChildNavigationOptionsSafely (copy), withLocalization (copy), Roact (copy), FriendsLandingHeaderBarPresentational (copy)
		local navigation = p5.props.navigation
		local v21 = getActiveChildNavigationOptionsSafely(navigation)
		local headerText = v21.headerText

		return withLocalization({
			titleText = headerText.raw
		})(function(p7) -- line: 40
			-- upvalues: p6 (copy), Roact (copy), FriendsLandingHeaderBarPresentational (copy), v21 (copy), p5 (copy), navigation (copy)
			local titleText = p7.titleText

			if p6.addFriendsPageSearchbarEnabled then
				return Roact.createElement(FriendsLandingHeaderBarPresentational, {
					title = titleText,
					renderLeft = v21.renderLeft or p5.renderLeft(navigation),
					renderCenter = v21.renderCenter,
					renderRight = v21.renderRight,
					isSecondary = v21.useSecondaryHeader
				})
			end

			return Roact.createElement(FriendsLandingHeaderBarPresentational, {
				title = titleText,
				renderLeft = v21.renderLeft or p5.renderLeft(navigation),
				renderCenter = v21.renderCenter,
				renderRight = v21.renderRight
			})
		end)
	end)
end

return v12
