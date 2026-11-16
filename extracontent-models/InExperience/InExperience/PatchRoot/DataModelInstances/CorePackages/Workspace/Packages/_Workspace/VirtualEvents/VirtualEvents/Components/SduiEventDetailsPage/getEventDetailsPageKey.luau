local parent = script:FindFirstAncestor("VirtualEvents").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local function getEventDetailsPageKey(p: string?)
	if p == nil then
		return AppPage.EventDetails .. "-Unknown"
	end

	return AppPage.EventDetails .. "-" .. p
end

return getEventDetailsPageKey
