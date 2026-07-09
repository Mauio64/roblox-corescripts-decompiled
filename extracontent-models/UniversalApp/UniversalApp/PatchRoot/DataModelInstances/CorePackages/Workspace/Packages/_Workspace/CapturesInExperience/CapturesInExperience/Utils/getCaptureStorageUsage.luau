local CaptureService = game:GetService("CaptureService")
local ParentParent = script.Parent.Parent
local CaptureType = require(ParentParent.Enums.CaptureType)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

function formatBytes(n1: number) -- line: 12
	local t1 = {
		"Bytes",
		"KB",
		"MB",
		"GB",
		"TB"
	}
	local v9 = math.floor(math.log(n1) / 6.931471805599453)
	local v10 = n1 / math.pow(1024, v9)
	local s1 = "%.2f%s"

	if v9 <= 2 then
		v10 = math.round(v10)
		s1 = "%d%s"
	end

	if not t1[v9 + 1] then
		return ""
	end

	return string.format(s1, v10, t1[v9 + 1])
end

local function getCaptureStorageUsage(t2: {[any]: any}) -- line: 31
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy), CaptureService (copy)
	if #t2 == 0 then
		return
	end

	local t3 = {}

	if not FFlagEnableCapturesGalleryRetrievalCoreScript then
		for _, v in ipairs(t2) do
			if not FFlagUseRbxstorageInGallery or v.type ~= CaptureType.Video then
				table.insert(t3, v.filePath)
			end
		end
	end

	local _, result = pcall(function() -- line: 47
		-- upvalues: CaptureService (copy), t3 (copy)
		return CaptureService:GetCaptureStorageSizeAsync(t3)
	end)

	return formatBytes(result)
end

return getCaptureStorageUsage
