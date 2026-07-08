local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local Roact = dependencies.Roact
local withStyle = dependencies.UIBlox.Style.withStyle
local FriendsLandingContext = require(FriendsLanding.FriendsLandingContext)
local v6 = Roact.PureComponent:extend("PlayerSearchWrapper")

v6.defaultProps = {
	layoutOrder = 1,
	onActivated = nil,
	searchText = ""
}

function v6.render(p1) -- line: 18
	-- upvalues: FriendsLandingContext (copy), withStyle (copy), Roact (copy)
	return FriendsLandingContext.with(function(p2) -- line: 19
		-- upvalues: withStyle (copy), p1 (copy), Roact (copy)
		return withStyle(function(p3) -- line: 20
			-- upvalues: p1 (copy), Roact (copy), p2 (copy)
			local v10 = p1.props.navigation.getParam("searchText", nil) or ""
			local v11 = p1.props.navigation.getParam("shouldShowUserSearchLandingPage", nil)

			return Roact.createElement("Frame", {
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = p3.Theme.BackgroundDefault.Color
			}, { Roact.createElement(p2.playerSearchPage, {
				searchParameters = {
					isKeywordSuggestionEnabled = true,
					searchKeyword = v10
				},
				shouldShowUserSearchLandingPage = v11
			}) })
		end)
	end)
end

return v6
