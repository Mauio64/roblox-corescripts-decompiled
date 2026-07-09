local SocialTestHelpers = script:FindFirstAncestor("SocialTestHelpers")
local SocialTestHelpersParent = SocialTestHelpers.Parent
local dependencies = require(SocialTestHelpers.dependencies)
local Roact = dependencies.Roact
local RoactNavigation = dependencies.RoactNavigation
local RoactRodux = dependencies.RoactRodux
local Rodux = dependencies.Rodux
local LocalizationProvider = dependencies.LocalizationProvider
local Mock = dependencies.Mock
local UnitTestHelpers = dependencies.UnitTestHelpers
local mockNavigation = UnitTestHelpers.mockNavigation
local mockPolicyProvider = UnitTestHelpers.mockPolicyProvider
local Foundation = require(SocialTestHelpersParent.Foundation)
local createStyleProvider = UnitTestHelpers.createStyleProvider
local ApolloProvider = dependencies.ApolloClient.ApolloProvider
local mockApolloClient = dependencies.GraphQLServer.ApolloClientTestUtils.mockApolloClient
local FoundationProvider = Foundation.FoundationProvider
local DesignTokenProvider = require(SocialTestHelpersParent.Style).DesignTokenProvider
local v19 = Mock.MagicMock.new({
	name = "Localization"
})

function v19.Format(_, p2, _) -- line: 26
	return p2
end

local function v20(p4) -- line: 30
	-- upvalues: Rodux (copy)
	return Rodux.Store.new(function() -- line: 31
		-- upvalues: p4 (copy)
		return p4
	end, {}, { Rodux.thunkMiddleware })
end

local v21 = Rodux.Store.new(function() -- line: 36
	return {}
end, {}, { Rodux.thunkMiddleware })

return function(p5, p6) -- line: 40
	-- upvalues: Roact (copy), RoactRodux (copy), v20 (copy), v21 (copy), createStyleProvider (copy), LocalizationProvider (copy), v19 (copy), ApolloProvider (copy), mockApolloClient (copy), DesignTokenProvider (copy), RoactNavigation (copy), mockNavigation (copy), FoundationProvider (copy), mockPolicyProvider (copy)
	local v28 = Roact.createFragment({
		storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
			store = if not p6.state then p6.store or v21 else v20(p6.state)
		}, {
			styleProvider = createStyleProvider({
				localizationProvider = Roact.createElement(LocalizationProvider, {
					localization = v19
				}, {
					apolloClient = Roact.createElement(ApolloProvider, {
						client = p6.apolloClient or mockApolloClient({})
					}, {
						designTokenProvider = Roact.createElement(DesignTokenProvider, {
							tokenMappers = {
								App = function(_, p8) -- line: 54
									return {
										Page = {
											BackgroundColor = p8.Color.Surface.Surface_0.Color3,
											BackgroundTransparency = p8.Color.Surface.Surface_0.Transparency,
											SafeAreaMargin = Vector2.new(p8.Size.Size_1600, p8.Size.Size_600)
										}
									}
								end,
								FriendsLanding = function(_, _) -- line: 63
									return {
										AddFriendsPage = {
											GridViewItemMetrics = {
												minimumItemsPerRow = 6,
												minimumItemWidth = 258
											}
										},
										FriendsLandingPage = {
											GridHorizontalSpacing = 24,
											GridVerticalSpacing = 24,
											GridViewItemMetrics = {
												minimumItemsPerRow = 6,
												minimumItemWidth = 258
											}
										},
										ShowMore = {}
									}
								end
							}
						}, {
							myElement = if not p6.navigation then mockNavigation(Roact.createElement(p5, p6.props)) else Roact.createElement(RoactNavigation.Provider, {
								value = p6.navigation
							}, Roact.createElement(p5, p6.props))
						})
					})
				})
			})
		})
	})

	if p6.includeFoundationProvider then
		v28 = Roact.createElement(FoundationProvider, {
			device = "Phone",
			theme = "Dark"
		}, v28)
	end

	if p6.includeMockPolicyProvider then
		v28 = mockPolicyProvider(v28, p6.mockPolicy)
	end

	if p6.mockProvider then
		v28 = p6.mockProvider(v28)
	end

	return v28
end
