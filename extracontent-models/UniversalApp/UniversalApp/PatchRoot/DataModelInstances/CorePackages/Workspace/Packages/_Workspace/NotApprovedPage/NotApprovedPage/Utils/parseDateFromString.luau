local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")
local NotApprovedPageParent = NotApprovedPage.Parent
local RobloxLocaleIdKey = require(NotApprovedPageParent.Localization).RobloxLocaleIdKey

require(NotApprovedPage.Common.Types)

local function parseDateFromString(s1: string, p1) -- line: 12
	-- upvalues: RobloxLocaleIdKey (copy)
	local dateTime = DateTime.fromIsoDate(s1)

	if not dateTime then
		return s1
	end

	return dateTime:FormatLocalTime("LLL", p1[RobloxLocaleIdKey])
end

return parseDateFromString
