local parent = script.Parent.Parent

local CaptureService = game:GetService("CaptureService")

local CapturesRetrieved = require(parent.Actions.CapturesRetrieved)
local Constants = require(parent.Constants)
require(parent.Types)
local fetchCapturesFromGallery = require(parent.Utils.fetchCapturesFromGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local FFlagCaptureServiceRetrieveCapturesSafeguard = require(parent.Flags.FFlagCaptureServiceRetrieveCapturesSafeguard)
local FFlagCapturesFetchUseSharedUtility = require(parent.Flags.FFlagCapturesFetchUseSharedUtility)

local function getSelectedCapture(p) -- 1 equivalent call inferred from this helper
	local selectedCaptureIndex = p[Constants.RoduxKey].Carousel.SelectedCaptureIndex

	if selectedCaptureIndex == nil then
		return nil
	end

	return p[Constants.RoduxKey].Captures[selectedCaptureIndex]
end

return function()
	return function(object)
		local selectedCapture = getSelectedCapture(object:getState()) -- inferred equivalent call

		if FFlagCapturesFetchUseSharedUtility then
			object:dispatch(CapturesRetrieved(fetchCapturesFromGallery(), selectedCapture))
		elseif FFlagEnableCapturesGalleryRetrievalCoreScript then
			local success, result = pcall(function()
				local capturesFromGalleryAsync, v = CaptureService:ReadCapturesFromGalleryAsync()

				if capturesFromGalleryAsync == Enum.ReadCapturesFromGalleryResult.Success then
					return v
				end

				return nil
			end)

			local v = {}

			if not success then
				warn("Failed to retrieve captures from gallery")
				return
			end

			local currentPage = result:GetCurrentPage()

			for _, v2 in ipairs(currentPage) do
				table.insert(v, v2)
			end

			object:dispatch(CapturesRetrieved(v, selectedCapture))
		elseif FFlagCaptureServiceRetrieveCapturesSafeguard then
			local success, result = pcall(function()
				return CaptureService:RetrieveCaptures()
			end)

			if success then
				object:dispatch(CapturesRetrieved(result, selectedCapture))
			else
				warn("Failed to retrieve captures from gallery")
			end
		else
			object:dispatch(CapturesRetrieved(CaptureService:RetrieveCaptures(), selectedCapture))
		end
	end
end
