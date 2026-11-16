local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")

local Enums = require(InExperienceSideSheet.Common.Enums)

local GetActionBindingsStore = require(InExperienceSideSheet.Stores.GetActionBindingsStore)

local function setIsRespawnEnabled(flag: boolean)
	local sessionActionBinding = GetActionBindingsStore().sessionActionBindings[Enums.ActionBinding.Respawn]

	if sessionActionBinding then
		sessionActionBinding.setIsEnabled(flag)
	end
end

return setIsRespawnEnabled
