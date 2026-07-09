local InExperienceSideSheet = script:FindFirstAncestor("InExperienceSideSheet")
local Enums = require(InExperienceSideSheet.Common.Enums)
local GetActionBindingsStore = require(InExperienceSideSheet.Stores.GetActionBindingsStore)

local function setIsRespawnEnabled(b1: boolean) -- line: 7
	-- upvalues: GetActionBindingsStore (copy), Enums (copy)
	local v6 = GetActionBindingsStore().sessionActionBindings[Enums.ActionBinding.Respawn]

	if v6 then
		v6.setIsEnabled(b1)
	end
end

return setIsRespawnEnabled
