local Parent = script:FindFirstAncestor("AppCommonLib").Parent
local VRService = require(Parent.MockableProxyServices).VRService
local isVRModeInStudio = require(script.Parent.isVRModeInStudio)

local function isSpatial() -- line: 7
	-- upvalues: isVRModeInStudio (copy), VRService (copy)
	if isVRModeInStudio() then
		return true
	end

	return VRService.VREnabled
end

return isSpatial
