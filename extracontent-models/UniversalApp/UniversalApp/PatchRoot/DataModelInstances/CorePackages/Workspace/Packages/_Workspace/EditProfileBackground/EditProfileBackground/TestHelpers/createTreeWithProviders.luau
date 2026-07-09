local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local createTreeWithProviders = require(Parent.Dev.SocialTestHelpers).TestHelpers.createTreeWithProviders
local React = require(Parent.React)
local RoactAppExperiment = require(Parent.RoactAppExperiment)
local MagicMock = require(Parent.LuaSocialLibrariesDeps).Mock.MagicMock
local mockPolicyProvider = require(Parent.Dev.UnitTestHelpers).mockPolicyProvider

return function(p1, p2) -- line: 11
	-- upvalues: React (copy), RoactAppExperiment (copy), MagicMock (copy), mockPolicyProvider (copy), createTreeWithProviders (copy)
	return React.createElement(RoactAppExperiment.Provider, {
		value = MagicMock.new()
	}, {
		Element = mockPolicyProvider(createTreeWithProviders(p1, p2), p2 and p2.mockPolicy)
	})
end
