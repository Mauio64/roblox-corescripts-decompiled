local ParentParent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")

require(ParentParent.Types)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local FFlagCaptureServiceRetrieveCapturesSafeguard = require(ParentParent.Flags.FFlagCaptureServiceRetrieveCapturesSafeguard)

local function fetchCapturesFromGallery() -- line: 12
	-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureService (copy), FFlagCaptureServiceRetrieveCapturesSafeguard (copy)
	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		local ok, result = pcall(function() -- line: 14
			-- upvalues: CaptureService (copy)
			local v14, v15 = CaptureService:ReadCapturesFromGalleryAsync()

			if v14 == Enum.ReadCapturesFromGalleryResult.Success then
				return v15
			end

			return nil
		end)

		if ok and result then
			local t1 = {}
			local CurrentPage = result:GetCurrentPage()

			for _, v in ipairs(CurrentPage) do
				table.insert(t1, v)
			end

			return t1
		end

		warn("Failed to retrieve captures from gallery")

		return {}
	end

	if FFlagCaptureServiceRetrieveCapturesSafeguard then
		local ok, result = pcall(function() -- line: 35
			-- upvalues: CaptureService (copy)
			return CaptureService:RetrieveCaptures()
		end)

		if ok then
			return result
		end

		warn("Failed to retrieve captures from gallery")

		return {}
	end

	return CaptureService:RetrieveCaptures()
end

return fetchCapturesFromGallery
