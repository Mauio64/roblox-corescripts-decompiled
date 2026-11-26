local CorePackages = game:GetService("CorePackages")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dKU")
local Rodux = require(CorePackages.Packages.Rodux)

local module2 = require("@luauforge/bundled/dPy")

local characterHistoryStateChangeButtonActivated = AvatarExperienceCommon.State.Actions.CharacterHistoryStateChangeButtonActivated

return Rodux.createReducer({}, {
	[module2.name] = function(p2, p3)
		return p3.savedOutfit
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if p3.tryOn and p3.tryOn.LastSavedTriedOnOutfit then
			return table.clone(p3.tryOn.LastSavedTriedOnOutfit)
		end

		return p2
	end
})
