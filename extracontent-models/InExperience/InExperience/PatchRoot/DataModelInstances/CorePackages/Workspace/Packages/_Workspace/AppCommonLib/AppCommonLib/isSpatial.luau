local parent = script:FindFirstAncestor("AppCommonLib").Parent

local MockableProxyServices = require(parent.MockableProxyServices)
local VRService = MockableProxyServices.VRService
local isVRModeInStudio = require(script.Parent.isVRModeInStudio)

local function isSpatial()
	return if isVRModeInStudio() then true else VRService.VREnabled
end

return isSpatial
