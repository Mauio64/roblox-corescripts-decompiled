local ContentProvider = game:GetService("ContentProvider")
local v2 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")

local function getRobuxStoreUrl() -- line: 4
	-- upvalues: v2 (copy)
	return ("%sUpgrades/Robux.aspx"):format(v2)
end

return getRobuxStoreUrl
