local Modules = script:FindFirstAncestor("Modules")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local compose = require(CorePackages.Packages.LuaSocialLibrariesDeps).SocialLibraries.config({}).RoduxTools.compose
local UserSearchTileUniversalWrapper = require(script.Parent.UserSearchTileUniversalWrapper)

local function Container(p1) -- line: 13
	-- upvalues: Roact (copy), UserSearchTileUniversalWrapper (copy)
	return Roact.createElement(UserSearchTileUniversalWrapper, p1)
end

return compose(RoactServices.connect({
	networking = RoactNetworking
}))(Container)
