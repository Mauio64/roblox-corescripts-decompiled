local parent = script.Parent.Parent

local getCaptureMetadata = require(parent.Utils.getCaptureMetadata)
require(parent.Types)

return function(p)
	local captureMetadata = getCaptureMetadata(p)

	return if captureMetadata then captureMetadata.placeId else nil
end
