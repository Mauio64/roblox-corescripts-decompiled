local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
require("@luauforge/bundled/dKU")

local module = require("@luauforge/bundled/dQs")
local module2 = require("@luauforge/bundled/dRf")
local module3 = require("@luauforge/bundled/dRg")

local characterHistoryStateChangeButtonActivated = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Actions.CharacterHistoryStateChangeButtonActivated

return Rodux.createReducer(module3.AvatarType.R15, {
	[module.name] = function(p2, p3)
		local playerAvatarType = p3.avatarData.playerAvatarType

		if playerAvatarType and module3.AvatarType[playerAvatarType] == playerAvatarType then
			return playerAvatarType
		end

		return p2
	end,
	[module2.name] = function(p2, p3)
		return p3.avatarType
	end,
	[characterHistoryStateChangeButtonActivated.name] = function(p2, p3)
		if p3.equipped and p3.equipped.AvatarType then
			return p3.equipped.AvatarType
		end

		return p2
	end
})
