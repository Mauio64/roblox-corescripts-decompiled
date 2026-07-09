local SocialTab = script:FindFirstAncestor("SocialTab")
local dependencies = require(SocialTab.dependencies)
local Mock = dependencies.Mock
local LocalizationProvider = dependencies.LocalizationProvider
local Roact = dependencies.Roact
local v6 = Mock.MagicMock.new({
	name = "Localization"
})

function v6.Format(_, p2, _) -- line: 9
	return p2
end

return function(p4) -- line: 13
	-- upvalues: Roact (copy), LocalizationProvider (copy), v6 (copy)
	return Roact.createElement(LocalizationProvider, {
		localization = v6
	}, {
		TestElement1 = p4
	})
end
