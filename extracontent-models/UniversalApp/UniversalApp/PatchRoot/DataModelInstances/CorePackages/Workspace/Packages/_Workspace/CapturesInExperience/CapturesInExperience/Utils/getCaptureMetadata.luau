local ParentParent = script.Parent.Parent
local CaptureType = require(ParentParent.Enums.CaptureType)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local v5 = game:DefineFastFlag("DontAssertOnUserIDInCaptureMetadata", false)

return function(p1) -- line: 11
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), v5 (copy)
	if FFlagEnableCapturesGalleryRetrievalCoreScript and p1.CaptureTime ~= nil then
		return {
			userId = 0,
			placeId = p1.SourcePlaceId,
			unixTimestamp = p1.CaptureTime.UnixTimestampMillis
		}
	end

	if FFlagUseRbxstorageInGallery and p1.type == CaptureType.Video then
		local num = tonumber(p1.userId)

		if not v5 then
			assert(num ~= nil, "userId should not be nil")
		end

		return {
			userId = num or 0,
			placeId = p1.placeId,
			unixTimestamp = p1.creationTimestamp
		}
	end

	if FFlagUseRbxstorageInGallery and p1.type ~= CaptureType.Screenshot then
		return nil
	end

	local filePath = p1.filePath
	local v9, v10, v11 = string.match(filePath, "(%d+)_(%d+)_(%d+)%.?%w*$")

	if v9 == nil or v10 == nil or v11 == nil then
		return nil
	end

	local num = tonumber(v9)
	local num2 = tonumber(v10)
	local num3 = tonumber(v11)

	if not v5 then
		assert(num ~= nil, "userId should not be nil")
	end

	assert(num2 ~= nil, "placeId should not be nil")
	assert(num3 ~= nil, "unixTimestamp should not be nil")

	return {
		userId = num or 0,
		placeId = num2,
		unixTimestamp = num3
	}
end
