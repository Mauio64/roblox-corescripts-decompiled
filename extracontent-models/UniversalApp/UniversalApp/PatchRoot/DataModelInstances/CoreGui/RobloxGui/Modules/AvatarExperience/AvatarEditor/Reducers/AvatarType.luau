local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local ReceivedAvatarData = require(Modules.AvatarExperience.AvatarEditor.Actions.ReceivedAvatarData)
local SetAvatarType = require(Modules.AvatarExperience.AvatarEditor.Actions.SetAvatarType)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local CharacterHistoryStateChangeButtonActivated = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).State.Actions.CharacterHistoryStateChangeButtonActivated
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag

return Rodux.createReducer(Constants.AvatarType.R15, {
	[ReceivedAvatarData.name] = function(p1, p2) -- line: 23
		-- upvalues: Constants (copy)
		local playerAvatarType = p2.avatarData.playerAvatarType

		if playerAvatarType and playerAvatarType == Constants.AvatarType[playerAvatarType] then
			return playerAvatarType
		end

		return p1
	end,
	[SetAvatarType.name] = function(_, p4) -- line: 31
		return p4.avatarType
	end,
	[CharacterHistoryStateChangeButtonActivated.name] = function(p5, p6) -- line: 34
		-- upvalues: FFlagAXRootSlotBasedEditorFlag (copy)
		if FFlagAXRootSlotBasedEditorFlag and (p6.equipped and p6.equipped.AvatarType) then
			return p6.equipped.AvatarType
		end

		return p5
	end
})
