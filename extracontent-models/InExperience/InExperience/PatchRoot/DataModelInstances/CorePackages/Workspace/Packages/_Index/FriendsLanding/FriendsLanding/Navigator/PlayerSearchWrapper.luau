local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local roact = dependencies.Roact
local withStyle = dependencies.UIBlox.Style.withStyle

local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)

local extended = roact.PureComponent:extend("PlayerSearchWrapper")

extended.defaultProps = { layoutOrder = 1, onActivated = nil, searchText = "" }

function extended.render(p)
	return FriendsLandingContext.with(function(p2)
		return withStyle(function(p3)
			local searchKeyword = p.props.navigation.getParam("searchText", nil) or ""

			local param = p.props.navigation.getParam("shouldShowUserSearchLandingPage", nil)

			return roact.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = p3.Theme.BackgroundDefault.Color,
					BackgroundTransparency = 0,
					BorderSizePixel = 0
				},
				{ roact.createElement(p2.playerSearchPage, {
						searchParameters = {
							searchKeyword = searchKeyword,
							isKeywordSuggestionEnabled = true
						},
						shouldShowUserSearchLandingPage = param
					}) }
			)
		end)
	end)
end

return extended
