local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

return function(p1) -- line: 14
	-- upvalues: Utils2 (copy), Utils (copy), RetrievalStatus (copy), PerformFetch (copy), Constants (copy)
	local v10 = Utils2.getAvatarEditorCategoryInfoFromState(p1).RenderOutfitItemTiles == true
	local v11 = Utils.selectAssetTypeKey(p1)
	local Failed = RetrievalStatus.Failed

	if v11 then
		if v10 then
			return (PerformFetch.GetStatus(p1, Constants.OutfitsKey .. v11))
		end

		Failed = PerformFetch.GetStatus(p1, Constants.UserInventoryKey .. v11)
	end

	return Failed
end
