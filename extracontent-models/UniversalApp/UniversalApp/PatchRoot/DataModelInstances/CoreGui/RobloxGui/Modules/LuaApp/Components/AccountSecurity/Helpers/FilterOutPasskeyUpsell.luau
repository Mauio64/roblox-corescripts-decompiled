local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PromptType = require(Modules.LuaApp.Enum.AccountSecurity.PromptType)

local function filterOutPasskeyUpsell(p1) -- line: 4
	-- upvalues: PromptType (copy)
	if typeof(p1) ~= "table" or #p1 == 0 then
		return p1
	end

	local t1 = {}

	for i = 1, #p1 do
		local v7 = p1[i]

		if v7 and PromptType.fromRawValue(v7.promptType) ~= PromptType.PasskeyUpsell then
			table.insert(t1, v7)
		end
	end

	return t1
end

return filterOutPasskeyUpsell
