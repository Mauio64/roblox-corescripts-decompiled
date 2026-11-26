local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/bundled/dXb")

return Rodux.createReducer(avatarScreen.None, {
	[module.name] = function(p2, p3)
		return p3.entryPage
	end
})
