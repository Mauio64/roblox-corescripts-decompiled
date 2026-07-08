local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage

local function getEventDetailsPageKey(s1: string?) -- line: 6
	-- upvalues: AppPage (copy)
	if s1 == nil then
		return AppPage.EventDetails .. "-Unknown"
	end

	return AppPage.EventDetails .. "-" .. s1
end

return getEventDetailsPageKey
