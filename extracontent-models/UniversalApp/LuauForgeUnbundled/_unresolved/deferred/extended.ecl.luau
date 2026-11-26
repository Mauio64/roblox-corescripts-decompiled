local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local appNotificationService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppNotificationService

local module = require("@luauforge/deferred/eco")
local module2 = require("@luauforge/deferred/ehT")
local module3 = require("@luauforge/deferred/ehU")

local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local compose = LuaSocialLibrariesDeps.SocialLibraries.config({}).RoduxTools.compose
local module4 = require("@luauforge/deferred/eig")

local function Container(p2)
	return Roact.createElement(module, p2)
end

local v5 = compose(
	RoactRodux.connect(module2, module3),
	roactServices.connect({ notificationService = appNotificationService })
)(Container)

local extended = Roact.PureComponent:extend("ClassWrapper")

function extended.render(p2)
	return Roact.createElement(v5, p2.props)
end

extended.router = module4.router

return extended
