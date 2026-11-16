local ContentProvider = game:GetService("ContentProvider")

local v = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
local function getRobuxStoreUrl()
	return ("%sUpgrades/Robux.aspx"):format(v)
end

return getRobuxStoreUrl
