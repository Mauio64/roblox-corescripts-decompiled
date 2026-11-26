local vrService = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/MockableProxyServices").VRService

local isSpatial = require("@game/CorePackages/Workspace/Packages/_Workspace/AppCommonLib/AppCommonLib/isSpatial")

local function connectToIsSpatialChanged(callback, p2)
	local v5 = isSpatial()

	local vREnabledChangedConnection = vrService:GetPropertyChangedSignal("VREnabled"):Connect(function()
		local v6 = isSpatial()

		if v6 == v5 then
			return
		end

		v5 = v6
		callback(v6)
	end)

	if p2 then
		callback(v5)
	end

	return vREnabledChangedConnection
end

return connectToIsSpatialChanged
