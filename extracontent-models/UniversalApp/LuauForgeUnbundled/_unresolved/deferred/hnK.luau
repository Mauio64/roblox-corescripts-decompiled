local module = require("@luauforge/deferred/hnL")

local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local compose = LuaSocialLibrariesDeps.SocialLibraries.config({}).RoduxTools.compose
local module2 = require("@luauforge/deferred/hnN")
local module3 = require("@luauforge/deferred/hnO")

local function Container(p2)
	return Roact.createElement(module, p2)
end

return compose(RoactRodux.connect(module2, module3), roactAppPolicy.connect(function(p2, p3)
	return { showUserAlias = p2.getShowAlias() }
end))(Container)
