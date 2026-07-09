local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local Rodux = require(ParentParentParent.Rodux)
local CapturesRetrieved = require(ParentParent.Actions.CapturesRetrieved)
local CaptureType = require(ParentParent.Enums.CaptureType)
local CarouselClosed = require(ParentParent.Actions.CarouselClosed)
local CarouselIndexSelected = require(ParentParent.Actions.CarouselIndexSelected)
local CarouselOpened = require(ParentParent.Actions.CarouselOpened)
local DeleteWarningModalClosed = require(ParentParent.Actions.DeleteWarningModalClosed)
local DeleteWarningModalOpened = require(ParentParent.Actions.DeleteWarningModalOpened)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)
local t1 = {
	IsOpen = false,
	IsDeleteWarningModalOpen = false,
	SelectedCaptureIndex = 0
}

local function findNewSelectedCaptureIndex(t2: {[any]: any}, n1: number, p1) -- line: 32
	-- upvalues: FFlagUseRbxstorageInGallery (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), Cryo (copy), CaptureType (copy)
	if not FFlagUseRbxstorageInGallery and (t2[n1] ~= nil and t2[n1].filePath == p1.filePath and not FFlagEnableCapturesGalleryRetrievalCoreScript) then
		return n1
	end

	return Cryo.List.findWhere(t2, function(p2) -- line: 47
		-- upvalues: FFlagEnableCapturesGalleryRetrievalCoreScript (copy), p1 (copy), FFlagUseRbxstorageInGallery (copy), CaptureType (copy)
		if FFlagEnableCapturesGalleryRetrievalCoreScript then
			return tostring(p2.CaptureTime.UnixTimestampMillis) == tostring(p1.CaptureTime.UnixTimestampMillis)
		end

		if FFlagUseRbxstorageInGallery and p2.type == CaptureType.Video and p1.type == CaptureType.Video then
			return p2.thumbnailKey == p1.thumbnailKey
		end

		if FFlagUseRbxstorageInGallery and p2.type == CaptureType.Screenshot and p1.type == CaptureType.Screenshot then
			return p2.filePath == p1.filePath
		end

		if not FFlagUseRbxstorageInGallery then
			return p2.filePath == p1.filePath
		end

		return false
	end)
end

return Rodux.createReducer(t1, {
	[CapturesRetrieved.name] = function(t3: {[any]: any}, p3) -- line: 72
		-- upvalues: Cryo (copy), findNewSelectedCaptureIndex (copy)
		if t3.IsOpen == false then
			return t3
		end

		if #p3.captures == 0 then
			return Cryo.Dictionary.join(t3, {
				IsOpen = false,
				SelectedCaptureIndex = 0
			})
		end

		if p3.selectedCapture == nil then
			local v21 = #p3.captures

			return Cryo.Dictionary.join(t3, {
				SelectedCaptureIndex = math.min(t3.SelectedCaptureIndex, v21)
			})
		end

		assert(p3.selectedCapture ~= nil, "CapturesRetrieved selectedCapture should not be nil")

		local selectedCapture = p3.selectedCapture
		local v23 = findNewSelectedCaptureIndex(p3.captures, t3.SelectedCaptureIndex, selectedCapture)

		if v23 == t3.SelectedCaptureIndex then
			return t3
		end

		if v23 ~= nil then
			return Cryo.Dictionary.join(t3, {
				SelectedCaptureIndex = v23
			})
		end

		local v24 = #p3.captures

		return Cryo.Dictionary.join(t3, {
			SelectedCaptureIndex = math.clamp(t3.SelectedCaptureIndex - 1, 1, v24)
		})
	end,
	[CarouselClosed.name] = function(t4: {[any]: any}, _: {[any]: any}) -- line: 117
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t4, {
			IsOpen = false,
			SelectedCaptureIndex = 0
		})
	end,
	[CarouselIndexSelected.name] = function(t6: {[any]: any}, t7: {[any]: any}) -- line: 124
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t6, {
			SelectedCaptureIndex = t7.index
		})
	end,
	[CarouselOpened.name] = function(t8: {[any]: any}, t9: {[any]: any}) -- line: 130
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t8, {
			IsOpen = true,
			SelectedCaptureIndex = t9.index
		})
	end,
	[DeleteWarningModalClosed.name] = function(t10: {[any]: any}, _: {[any]: any}) -- line: 137
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t10, {
			IsDeleteWarningModalOpen = false
		})
	end,
	[DeleteWarningModalOpened.name] = function(t12: {[any]: any}, _: {[any]: any}) -- line: 143
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t12, {
			IsDeleteWarningModalOpen = true
		})
	end
})
