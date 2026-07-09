local Parent = script:FindFirstAncestor("AppCommonLib").Parent
local VRService = require(Parent.MockableProxyServices).VRService
local isSpatial = require(script.Parent.isSpatial)

local function connectToIsSpatialChanged(p1: ((...any) -> ...any), b1: boolean?) -- line: 8
	-- upvalues: isSpatial (copy), VRService (copy)
	local u7 = isSpatial()
	local connection = VRService:GetPropertyChangedSignal("VREnabled"):Connect(function() -- line: 14
		-- upvalues: isSpatial (copy), u7 (ref), p1 (copy)
		local v9 = isSpatial()

		if v9 == u7 then
			return
		end

		u7 = v9
		p1(v9)
	end)

	if b1 then
		p1(u7)
	end

	return connection
end

return connectToIsSpatialChanged
