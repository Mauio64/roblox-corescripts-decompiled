local ParentParent = script.Parent.Parent
local getCaptureMetadata = require(ParentParent.Utils.getCaptureMetadata)

require(ParentParent.Types)

return function(p1) -- line: 6
	-- upvalues: getCaptureMetadata (copy)
	local v4 = getCaptureMetadata(p1)

	if v4 then
		return v4.unixTimestamp
	end

	return nil
end
