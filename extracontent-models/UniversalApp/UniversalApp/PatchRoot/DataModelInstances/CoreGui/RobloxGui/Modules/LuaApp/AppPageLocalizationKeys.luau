local AppPageProperties = require(game:GetService("CoreGui").RobloxGui.Modules.LuaApp.AppPageProperties)
local t1 = {}

for k, v in pairs(AppPageProperties) do
	t1[k] = v.nameLocalizationKey
end

return t1
