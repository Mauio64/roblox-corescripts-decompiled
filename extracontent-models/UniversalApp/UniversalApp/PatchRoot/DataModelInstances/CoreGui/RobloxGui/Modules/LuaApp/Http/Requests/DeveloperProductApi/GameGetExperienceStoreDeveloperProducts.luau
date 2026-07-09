local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local GetFIntExperienceStoreApiPageSize = require(Modules.LuaApp.Flags.GetFIntExperienceStoreApiPageSize)

return function(p1, p2, p3) -- line: 5
	-- upvalues: GetFIntExperienceStoreApiPageSize (copy), Url (copy)
	local v7 = GetFIntExperienceStoreApiPageSize()

	return p1(string.format("%sexperience-store/v1/universes/%s/store?limit=%d&cursor=%s", Url.APIS_URL, p2, v7, p3), "GET")
end
