local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local JestGlobals = require(ProfileQRCodeParent.Dev.JestGlobals)
local createTreeWithProviders = require(ProfileQRCodeParent.Dev.SocialTestHelpers).TestHelpers.createTreeWithProviders
local mockAnalytics = require(script.Parent.mockAnalytics)
local Analytics = require(ProfileQRCode.Analytics)
local React = require(ProfileQRCodeParent.React)
local RoactAppExperiment = require(ProfileQRCodeParent.RoactAppExperiment)
local MagicMock = require(ProfileQRCodeParent.LuaSocialLibrariesDeps).Mock.MagicMock
local mockPolicyProvider = require(ProfileQRCodeParent.Dev.UnitTestHelpers).mockPolicyProvider

return function(p1, p2) -- line: 14
	-- upvalues: mockAnalytics (copy), JestGlobals (copy), React (copy), Analytics (copy), RoactAppExperiment (copy), MagicMock (copy), mockPolicyProvider (copy), createTreeWithProviders (copy)
	local v13 = mockAnalytics({
		uid = "123"
	}, JestGlobals.jest)

	return React.createElement(Analytics.Context.Provider, {
		value = if not p2.mockAnalytics then v13.value else p2.mockAnalytics
	}, { React.createElement(RoactAppExperiment.Provider, {
		value = MagicMock.new()
	}, {
		Element = mockPolicyProvider(createTreeWithProviders(p1, p2), p2.mockPolicy)
	}) }), v13
end
