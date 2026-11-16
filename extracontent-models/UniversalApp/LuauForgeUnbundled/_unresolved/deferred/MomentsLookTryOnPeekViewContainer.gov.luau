local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")

local module = require("@luauforge/deferred/gow")

local module2 = require("@luauforge/deferred/goy")

local function MomentsLookTryOnPeekViewContainer(p2)
	local v5 = module2(p2.navigation)
	return React.createElement(module, v5)
end

return MomentsLookTryOnPeekViewContainer
