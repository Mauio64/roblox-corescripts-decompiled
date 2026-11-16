local parent = script:FindFirstAncestor("Home").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport

local defineFastString = game:DefineFastString(
	"SduiHomeSortDetailExcludedTopicIds",
	"100000000, 300000000, 600000000, 100000010"
)

local defineFastString2 = game:DefineFastString("SduiHomeSortDetailSupportedInputDataTypes", "experience_carousel")

local set = {}
local set2 = {}

if FFlagLuaAppSduiHomePageSupport then
	for k in defineFastString:gmatch("([^,%s]+)") do
		set[k] = true
	end

	for k in defineFastString2:gmatch("([^,%s]+)") do
		set2[k] = true
	end
end

local function isHomeSortDetailSortIncluded(p, p2): boolean
	return p ~= nil and p2 ~= nil and set[tostring(p)] ~= true and set2[tostring(p2)] == true
end

return isHomeSortDetailSortIncluded
