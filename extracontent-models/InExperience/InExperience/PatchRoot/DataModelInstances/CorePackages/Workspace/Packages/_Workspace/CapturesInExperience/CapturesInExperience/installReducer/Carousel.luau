local parent = script.Parent.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Rodux = require(parent2.Rodux)

local CapturesRetrieved = require(parent.Actions.CapturesRetrieved)
local CaptureType = require(parent.Enums.CaptureType)
local CarouselClosed = require(parent.Actions.CarouselClosed)
local CarouselIndexSelected = require(parent.Actions.CarouselIndexSelected)
local CarouselOpened = require(parent.Actions.CarouselOpened)
local DeleteWarningModalClosed = require(parent.Actions.DeleteWarningModalClosed)
local DeleteWarningModalOpened = require(parent.Actions.DeleteWarningModalOpened)
require(parent.Types)

local FFlagUseRbxstorageInGallery = require(parent.Flags.FFlagUseRbxstorageInGallery)

local FFlagEnableCapturesGalleryRetrievalCoreScript = require(parent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

local function findNewSelectedCaptureIndex(captures, selectedCaptureIndex: number, selectedCapture)
	if
		FFlagUseRbxstorageInGallery
		or captures[selectedCaptureIndex] == nil
		or captures[selectedCaptureIndex].filePath ~= selectedCapture.filePath
		or FFlagEnableCapturesGalleryRetrievalCoreScript
	then
		return Cryo.List.findWhere(captures, function(data): boolean
			if FFlagEnableCapturesGalleryRetrievalCoreScript then
				return tostring(data.CaptureTime.UnixTimestampMillis) == tostring(selectedCapture.CaptureTime.UnixTimestampMillis)
			end

			if
				FFlagUseRbxstorageInGallery
				and data.type == CaptureType.Video
				and selectedCapture.type == CaptureType.Video
			then
				return data.thumbnailKey == selectedCapture.thumbnailKey
			end

			if
				FFlagUseRbxstorageInGallery
				and data.type == CaptureType.Screenshot
				and selectedCapture.type == CaptureType.Screenshot
			then
				return data.filePath == selectedCapture.filePath
			end

			return not FFlagUseRbxstorageInGallery and data.filePath == selectedCapture.filePath
		end)
	end

	return selectedCaptureIndex
end

return Rodux.createReducer({
	IsOpen = false,
	IsDeleteWarningModalOpen = false,
	SelectedCaptureIndex = 0
}, {
	[CapturesRetrieved.name] = function(p, p2)
		if p.IsOpen == false then
			return p
		end

		if #p2.captures == 0 then
			return Cryo.Dictionary.join(p, { IsOpen = false, SelectedCaptureIndex = 0 })
		end

		if p2.selectedCapture == nil then
			local v = #p2.captures
			return Cryo.Dictionary.join(p, {
				SelectedCaptureIndex = math.min(p.SelectedCaptureIndex, v)
			})
		end

		assert(p2.selectedCapture ~= nil, "CapturesRetrieved selectedCapture should not be nil")
		local selectedCapture = p2.selectedCapture

		local newSelectedCaptureIndex = findNewSelectedCaptureIndex(
			p2.captures,
			p.SelectedCaptureIndex,
			selectedCapture
		)

		if newSelectedCaptureIndex == p.SelectedCaptureIndex then
			return p
		end

		if newSelectedCaptureIndex ~= nil then
			return Cryo.Dictionary.join(p, { SelectedCaptureIndex = newSelectedCaptureIndex })
		end

		local v = #p2.captures
		return Cryo.Dictionary.join(p, {
			SelectedCaptureIndex = math.clamp(p.SelectedCaptureIndex - 1, 1, v)
		})
	end,
	[CarouselClosed.name] = function(p, _)
		return Cryo.Dictionary.join(p, { IsOpen = false, SelectedCaptureIndex = 0 })
	end,
	[CarouselIndexSelected.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { SelectedCaptureIndex = p2.index })
	end,
	[CarouselOpened.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { IsOpen = true, SelectedCaptureIndex = p2.index })
	end,
	[DeleteWarningModalClosed.name] = function(p, _)
		return Cryo.Dictionary.join(p, { IsDeleteWarningModalOpen = false })
	end,
	[DeleteWarningModalOpened.name] = function(p, _)
		return Cryo.Dictionary.join(p, { IsDeleteWarningModalOpen = true })
	end
})
