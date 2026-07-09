local GetImageData = require(script.GetImageData)
local GetImageSetData = require(script.GetImageSetData)
local GetImageSetPathPattern = require(script.GetImageSetPathPattern)

require(script.types)

return {
	GetImageData = GetImageData,
	GetImageSetData = GetImageSetData,
	GetImageSetPathPattern = GetImageSetPathPattern
}
