local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module = require("@luauforge/bundled/eda")

local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local compose = LuaSocialLibrariesDeps.SocialLibraries.config({}).RoduxTools.compose
local module2 = require("@luauforge/bundled/edL")

local function Container(p2)
	return Roact.createElement(module2, p2)
end

return compose(roactServices.connect({ networking = module }))(Container)
