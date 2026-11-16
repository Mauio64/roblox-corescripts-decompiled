local parent = script.Parent.Parent

local CaptureService = game:GetService("CaptureService")

require(parent.Types)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local FFlagCaptureServiceRetrieveCapturesSafeguard = require(parent.Flags.FFlagCaptureServiceRetrieveCapturesSafeguard)

local function fetchCapturesFromGallery()
	if FFlagEnableCapturesGalleryRetrievalCoreScript then
		local success, result = pcall(function()
			local capturesFromGalleryAsync, v = CaptureService:ReadCapturesFromGalleryAsync()

			if capturesFromGalleryAsync == Enum.ReadCapturesFromGalleryResult.Success then
				return v
			end

			return nil
		end)

		if not (success and result) then
			warn("Failed to retrieve captures from gallery")
			return {}
		end

		local currentPage = result:GetCurrentPage()
		local result2 = {}

		for _, v in ipairs(currentPage) do
			table.insert(result2, v)
		end

		return result2
	else
		if not FFlagCaptureServiceRetrieveCapturesSafeguard then
			return CaptureService:RetrieveCaptures()
		end

		local success, result = pcall(function()
			return CaptureService:RetrieveCaptures()
		end)

		if success then
			return result
		end

		warn("Failed to retrieve captures from gallery")
		return {}
	end
end

return fetchCapturesFromGallery
