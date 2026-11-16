local CaptureService = game:GetService("CaptureService")

local parent = script.Parent.Parent

local CaptureType = require(parent.Enums.CaptureType)
require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

function formatBytes(p: number)
	local v = { "Bytes", "KB", "MB", "GB", "TB" }

	local v2 = math.floor(math.log(p) / 6.931471805599453)
	local v3 = p / math.pow(1024, v2)
	local v4

	if v2 <= 2 then
		v3 = math.round(v3)
		v4 = "%d%s"
	else
		v4 = "%.2f%s"
	end

	if v[v2 + 1] then
		return string.format(v4, v3, v[v2 + 1])
	end

	return ""
end

local function getCaptureStorageUsage(list)
	if #list == 0 then
		return
	end

	local filePaths = {}

	if not FFlagEnableCapturesGalleryRetrievalCoreScript then
		for _, item in ipairs(list) do
			if not FFlagUseRbxstorageInGallery or item.type ~= CaptureType.Video then
				table.insert(filePaths, item.filePath)
			end
		end
	end

	local _, result = pcall(function()
		return CaptureService:GetCaptureStorageSizeAsync(filePaths)
	end)

	return formatBytes(result)
end

return getCaptureStorageUsage
