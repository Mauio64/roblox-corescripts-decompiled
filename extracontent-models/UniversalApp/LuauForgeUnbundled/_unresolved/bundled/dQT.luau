local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local setFullView = require("@luauforge/bundled/dKU").Actions.SetFullView
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView
local fullViewPageDefaults = require("@luauforge/bundled/dPN").FullViewPageDefaults

return Rodux.createReducer(fullViewPageDefaults, {
	[setFullView.name] = function(p2, p3)
		return Cryo.Dictionary.join(p2, { [p3.avatarScreen] = p3.fullViewStatus })
	end
})
