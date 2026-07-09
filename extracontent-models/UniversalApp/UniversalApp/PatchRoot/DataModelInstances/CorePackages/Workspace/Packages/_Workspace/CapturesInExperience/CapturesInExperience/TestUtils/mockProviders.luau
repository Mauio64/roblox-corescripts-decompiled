local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local JestGlobals = require(ParentParentParent.Dev.JestGlobals)
local Localization = require(ParentParentParent.Localization)
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local React = require(ParentParentParent.React)
local RoactRodux = require(ParentParentParent.RoactRodux)
local UnitTestHelpers = require(ParentParentParent.Dev.UnitTestHelpers)
local LocalizationProvider = Localization.LocalizationProvider
local Mock = LuaSocialLibrariesDeps.Mock
local jest = JestGlobals.jest
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local CapturesContext = require(ParentParent.Context.CapturesContext)
local createStore = require(ParentParent.TestUtils.createStore)
local mockAnalytics = require(ParentParent.TestUtils.mockAnalytics)
local t1 = {
	EligibleForCapturesFeature = true,
	EnableCapturesBulkManagement = true,
	EnableShareCaptureCTA = true
}

return function(t2: {[any]: any}, t3: {[any]: any}?) -- line: 27
	-- upvalues: Mock (copy), mockAnalytics (copy), jest (copy), createStore (copy), React (copy), RoactRodux (copy), CapturesPolicy (copy), t1 (copy), CapturesContext (copy), UnitTestHelpers (copy), LocalizationProvider (copy)
	local v19 = Mock.MagicMock.new({
		name = "Localization"
	})

	function v19.Format(_, p2, _) -- line: 29
		return p2
	end

	local v20 = mockAnalytics({}, jest)
	local v21 = createStore()

	if t3 then
		if t3.analytics then
			v20 = t3.analytics
		end

		if t3.store then
			v21 = t3.store
		end
	end

	return (React.createElement(RoactRodux.StoreProvider, {
		store = v21
	}, {
		PolicyProvider = React.createElement(CapturesPolicy.Provider, {
			policy = { CapturesPolicy.Mapper },
			policyData = t3 and t3.policyData or t1
		}, {
			ContextProvider = React.createElement(CapturesContext.Provider, {
				value = {
					fireAnalyticsEvent = v20.fireAnalyticsEvent,
					chromeEnabled = t3 and t3.chromeEnabled or nil
				}
			}, {
				StyleProvider = UnitTestHelpers.createStyleProvider({
					localizationProvider = React.createElement(LocalizationProvider, {
						localization = v19
					}, t2)
				})
			})
		})
	}))
end
