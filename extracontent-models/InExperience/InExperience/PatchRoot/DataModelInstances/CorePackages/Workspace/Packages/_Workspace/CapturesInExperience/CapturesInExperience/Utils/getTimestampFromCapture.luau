local parent = script.Parent.Parent

local getCaptureMetadata = require(parent.Utils.getCaptureMetadata)
require(parent.Types)

return function(p)
	local captureMetadata = getCaptureMetadata(p)

	if captureMetadata then
		return captureMetadata.unixTimestamp
	end

	return nil
end
