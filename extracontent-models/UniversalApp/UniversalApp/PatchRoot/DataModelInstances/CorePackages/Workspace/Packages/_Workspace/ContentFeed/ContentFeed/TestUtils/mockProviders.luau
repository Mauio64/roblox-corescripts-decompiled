local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local AppFeaturePolicies = require(ParentParentParent.UniversalAppPolicy).AppFeaturePolicies
local Dash = require(ParentParentParent.Dash)
local Localization = require(ParentParentParent.Localization)
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local React = require(ParentParentParent.React)
local RoactAppPolicy = require(ParentParentParent.UniversalAppPolicy).RoactAppPolicy
local RoactNavigation = require(ParentParentParent.RoactNavigation)
local RoactRodux = require(ParentParentParent.RoactRodux)
local UnitTestHelpers = require(ParentParentParent.Dev.UnitTestHelpers)
local LocalizationProvider = Localization.LocalizationProvider
local Mock = LuaSocialLibrariesDeps.Mock
local createMockNavigation = require(ParentParent.TestUtils.createMockNavigation)
local createMockStore = require(ParentParent.TestUtils.createMockStore)
local FeedContext = require(ParentParent.App.FeedContext)
local t1 = {
	navigateBack = Dash.noop,
	navigateToReportPage = Dash.noop
}
local t2 = {
	EligibleForExternalContentSharing = true
}

return function(t3: {[any]: any}, t4: {[any]: any}?) -- line: 30
	-- upvalues: Mock (copy), t1 (copy), createMockNavigation (copy), t2 (copy), createMockStore (copy), Dash (copy), React (copy), RoactRodux (copy), RoactAppPolicy (copy), AppFeaturePolicies (copy), FeedContext (copy), RoactNavigation (copy), LocalizationProvider (copy), UnitTestHelpers (copy)
	local v21 = Mock.MagicMock.new({
		name = "Localization"
	})

	function v21.Format(_, p2, _) -- line: 32
		return p2
	end

	local v22 = t1
	local v23 = createMockNavigation()
	local v24 = t2
	local v25 = createMockStore()
	local v26 = true

	if t4 then
		if t4.context then
			v22 = Dash.join(v22, t4.context)
		end

		if t4.store then
			v25 = t4.store
		end

		if t4.navigation then
			v23 = createMockNavigation(t4.navigation)
		end

		if t4.policyData then
			v24 = t4.policyData
		end

		if t4.shouldMockStyleProvider ~= nil then
			v26 = t4.shouldMockStyleProvider
		end
	end

	local v27 = React.createElement(RoactRodux.StoreProvider, {
		store = v25
	}, {
		PolicyProvider = React.createElement(RoactAppPolicy.Provider, {
			policy = { AppFeaturePolicies },
			policyData = v24
		}, {
			ContextProvider = React.createElement(FeedContext.Provider, {
				value = v22
			}, {
				NavigationProvider = React.createElement(RoactNavigation.Provider, {
					value = v23
				}, {
					localizationProvider = React.createElement(LocalizationProvider, {
						localization = v21
					}, t3)
				})
			})
		})
	})

	if v26 then
		return UnitTestHelpers.createStyleProvider({
			StyleProvider = v27
		})
	end

	return v27
end
