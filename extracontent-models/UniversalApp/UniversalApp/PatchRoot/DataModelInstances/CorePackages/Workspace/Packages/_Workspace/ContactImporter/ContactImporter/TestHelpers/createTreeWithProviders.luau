local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local JestGlobals = require(ParentParentParent.Dev.JestGlobals)
local createTreeWithProviders = require(ParentParentParent.Dev.SocialTestHelpers).TestHelpers.createTreeWithProviders
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local dependencies = require(ParentParent.dependencies)
local mockAnalytics = require(ParentParent.TestHelpers.mockAnalytics)
local Analytics = require(ParentParent.Analytics)
local Roact = dependencies.Roact
local React = dependencies.React
local RoactExperimentProvider = dependencies.RoactExperimentProvider
local MagicMock = LuaSocialLibrariesDeps.Mock.MagicMock
local RoactNavigation = dependencies.RoactNavigation
local RoactRodux = require(ParentParentParent.RoactRodux)
local Rodux = require(ParentParentParent.Rodux)
local UniversalAppPolicy = require(ParentParentParent.UniversalAppPolicy).UniversalAppPolicy
local v17 = Rodux.Store.new(function() -- line: 20
	return {}
end, {}, { Rodux.thunkMiddleware })

return function(p1, t1: {[any]: any}) -- line: 23
	-- upvalues: mockAnalytics (copy), JestGlobals (copy), Roact (copy), RoactNavigation (copy), MagicMock (copy), UniversalAppPolicy (copy), RoactRodux (copy), v17 (copy), React (copy), RoactExperimentProvider (copy), Analytics (copy), createTreeWithProviders (copy)
	local v20 = mockAnalytics({
		uid = "123"
	}, JestGlobals.jest)

	return Roact.createElement(RoactNavigation.Provider, {
		value = t1.navigation or MagicMock.new()
	}, {
		policyProvider = Roact.createElement(UniversalAppPolicy.Provider, {
			policy = { function() -- line: 42
				-- upvalues: t1 (copy)
				return {
					getShouldHideContactImporterUpsell = function() -- line: 44
						-- upvalues: t1 (copy)
						return t1.policy or false
					end,
					getContactImporterEnabled = function() -- line: 47
						-- upvalues: t1 (copy)
						return t1.policy or false
					end,
					getContactsToastEnabled = function() -- line: 50
						-- upvalues: t1 (copy)
						return t1.policy or false
					end,
					getUpsellVoiceForPhoneVerification = function() -- line: 53
						-- upvalues: t1 (copy)
						return t1.policy or false
					end,
					getWebViewSupport = function() -- line: 56
						-- upvalues: t1 (copy)
						return t1.policy or false
					end
				}
			end }
		}, {
			storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
				store = t1.store or v17
			}, { React.createElement(RoactExperimentProvider, {
				value = if not t1.experiment then MagicMock.new() else t1.experiment
			}, {
				Element = Roact.createElement(Analytics.Context.Provider, {
					value = if not t1.mockAnalytics then v20.value else t1.mockAnalytics
				}, {
					Element = createTreeWithProviders(p1, t1)
				})
			}) })
		})
	}), v20
end
