local parent = script.Parent.Parent

local CaptureType = require(parent.Enums.CaptureType)
require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local defineFastFlag = game:DefineFastFlag("DontAssertOnUserIDInCaptureMetadata", false)

return function(data)
	if FFlagEnableCapturesGalleryRetrievalCoreScript and data.CaptureTime ~= nil then
		return {
			userId = 0,
			placeId = data.SourcePlaceId,
			unixTimestamp = data.CaptureTime.UnixTimestampMillis
		}
	end

	if FFlagUseRbxstorageInGallery and data.type == CaptureType.Video then
		local userId = tonumber(data.userId)

		if not defineFastFlag then
			assert(userId ~= nil, "userId should not be nil")
		end

		return {
			userId = userId or 0,
			placeId = data.placeId,
			unixTimestamp = data.creationTimestamp
		}
	else
		if FFlagUseRbxstorageInGallery and data.type ~= CaptureType.Screenshot then
			return nil
		end

		local filePath = data.filePath

		local v, v2, v3 = string.match(filePath, "(%d+)_(%d+)_(%d+)%.?%w*$")

		if v == nil or v2 == nil or v3 == nil then
			return nil
		end

		local v4 = tonumber(v)
		local placeId = tonumber(v2)
		local unixTimestamp = tonumber(v3)

		if not defineFastFlag then
			assert(v4 ~= nil, "userId should not be nil")
		end

		assert(placeId ~= nil, "placeId should not be nil")
		assert(unixTimestamp ~= nil, "unixTimestamp should not be nil")

		return {
			userId = v4 or 0,
			placeId = placeId,
			unixTimestamp = unixTimestamp
		}
	end
end
