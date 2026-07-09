local Modules = game:GetService("CoreGui").RobloxGui.Modules
local DisplayType = require(Modules.LuaApp.Enum.AccountSecurity.DisplayType)
local PromptType = require(Modules.LuaApp.Enum.AccountSecurity.PromptType)

return require(Modules.Common.Rodux).makeActionCreator(script.Name, function(p1, p2, p3) -- line: 7
	-- upvalues: PromptType (copy), DisplayType (copy)
	assert(p2 == nil or (PromptType.isEnumValue(p2) or p1 and (typeof(p3) == "table" and DisplayType.isEnumValue(DisplayType.fromRawValue(p3.displayType)))), "Expected the passed prompt type must either be a valid enum value or nil")

	return {
		isGeneric = p1,
		promptType = p2,
		metadata = p3,
		lastUpdatedPromptTypeAt = DateTime.now()
	}
end)
