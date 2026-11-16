local fFlagLuaAppSduiHomePageSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagLuaAppSduiHomePageSupport

local defineFastString = game:DefineFastString(
	"SduiHomeSortDetailExcludedTopicIds",
	"100000000, 300000000, 600000000, 100000010"
)

local defineFastString2 = game:DefineFastString(
	"SduiHomeSortDetailSupportedInputDataTypes",
	"experience_carousel"
)

local set = {}
local set2 = {}

if fFlagLuaAppSduiHomePageSupport then
	for k in defineFastString:gmatch("([^,%s]+)") do
		set[k] = true
	end

	for k in defineFastString2:gmatch("([^,%s]+)") do
		set2[k] = true
	end
end

local function isHomeSortDetailSortIncluded(p2, p3): boolean
	return p2 ~= nil and p3 ~= nil and set[tostring(p2)] ~= true and set2[tostring(p3)] == true
end

return isHomeSortDetailSortIncluded
