local SocialTabLoader = require(script.Parent.SocialTabLoader)
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local compose = require(CorePackages.Packages.LuaSocialLibrariesDeps).SocialLibraries.config({}).RoduxTools.compose
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)

local function Container(p1) -- line: 14
	-- upvalues: Roact (copy), SocialTabLoader (copy)
	return Roact.createElement(SocialTabLoader, p1)
end

return compose(RoactRodux.connect(mapStateToProps, mapDispatchToProps), RoactAppPolicy.connect(function(p2, _) -- line: 20
	return {
		showUserAlias = p2.getShowAlias()
	}
end))(Container)
