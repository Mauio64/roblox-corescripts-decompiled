local parent = script:FindFirstAncestor("AppCommonLib").Parent

local MockableProxyServices = require(parent.MockableProxyServices)
local VRService = MockableProxyServices.VRService

local isSpatial = require(script.Parent.isSpatial)

local function connectToIsSpatialChanged(callback, flag: boolean?)
	local v = isSpatial()

	local vREnabledChangedConnection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function()
		local spatial = isSpatial()

		if spatial == v then
			return
		end

		v = spatial
		callback(spatial)
	end)

	if flag then
		callback(v)
	end

	return vREnabledChangedConnection
end

return connectToIsSpatialChanged
