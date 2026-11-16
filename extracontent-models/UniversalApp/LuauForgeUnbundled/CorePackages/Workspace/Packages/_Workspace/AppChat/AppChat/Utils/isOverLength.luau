local countChars = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/countChars")
local countUtf16Units = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/countUtf16Units")

local function isOverLength(list, p2, p3): boolean
	if #list <= math.min(p2, p3) then
		return false
	end

	return p3 < countUtf16Units(list) or p2 < countChars(list)
end

return isOverLength
