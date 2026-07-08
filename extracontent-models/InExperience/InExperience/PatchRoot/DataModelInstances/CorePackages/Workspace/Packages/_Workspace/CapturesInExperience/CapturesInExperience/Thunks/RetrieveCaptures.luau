local ParentParent = script.Parent.Parent
local CaptureService = game:GetService("CaptureService")
local CapturesRetrieved = require(ParentParent.Actions.CapturesRetrieved)
local Constants = require(ParentParent.Constants)

require(ParentParent.Types)

local fetchCapturesFromGallery = require(ParentParent.Utils.fetchCapturesFromGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local FFlagCaptureServiceRetrieveCapturesSafeguard = require(ParentParent.Flags.FFlagCaptureServiceRetrieveCapturesSafeguard)
local FFlagCapturesFetchUseSharedUtility = require(ParentParent.Flags.FFlagCapturesFetchUseSharedUtility)

local function getSelectedCapture(p1) -- line: 16
	-- upvalues: Constants (copy)
	local SelectedCaptureIndex = p1[Constants.RoduxKey].Carousel.SelectedCaptureIndex

	if SelectedCaptureIndex ~= nil then
		return p1[Constants.RoduxKey].Captures[SelectedCaptureIndex]
	end

	return nil
end

return function() -- line: 25
	-- upvalues: Constants (copy), FFlagCapturesFetchUseSharedUtility (copy), fetchCapturesFromGallery (copy), CapturesRetrieved (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureService (copy), FFlagCaptureServiceRetrieveCapturesSafeguard (copy)
	return function(p2) -- line: 26
		-- upvalues: Constants (copy), FFlagCapturesFetchUseSharedUtility (copy), fetchCapturesFromGallery (copy), CapturesRetrieved (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureService (copy), FFlagCaptureServiceRetrieveCapturesSafeguard (copy)
		local v13 = p2:getState()
		local SelectedCaptureIndex = v13[Constants.RoduxKey].Carousel.SelectedCaptureIndex
		local v15 = if SelectedCaptureIndex == nil then nil else v13[Constants.RoduxKey].Captures[SelectedCaptureIndex]

		if FFlagCapturesFetchUseSharedUtility then
			local v16 = fetchCapturesFromGallery()

			p2:dispatch(CapturesRetrieved(v16, v15))

			return
		end

		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			local ok, result = pcall(function() -- line: 34
				-- upvalues: CaptureService (copy)
				local v26, v27 = CaptureService:ReadCapturesFromGalleryAsync()

				if v26 == Enum.ReadCapturesFromGalleryResult.Success then
					return v27
				end

				return nil
			end)
			local t1 = {}

			if ok then
				local CurrentPage = result:GetCurrentPage()

				for _, v in ipairs(CurrentPage) do
					table.insert(t1, v)
				end

				p2:dispatch(CapturesRetrieved(t1, v15))

				return
			end

			warn("Failed to retrieve captures from gallery")

			return
		end

		if FFlagCaptureServiceRetrieveCapturesSafeguard then
			local ok, result = pcall(function() -- line: 54
				-- upvalues: CaptureService (copy)
				return CaptureService:RetrieveCaptures()
			end)

			if ok then
				p2:dispatch(CapturesRetrieved(result, v15))

				return
			end

			warn("Failed to retrieve captures from gallery")

			return
		end

		local v25 = CaptureService:RetrieveCaptures()

		p2:dispatch(CapturesRetrieved(v25, v15))
	end
end
