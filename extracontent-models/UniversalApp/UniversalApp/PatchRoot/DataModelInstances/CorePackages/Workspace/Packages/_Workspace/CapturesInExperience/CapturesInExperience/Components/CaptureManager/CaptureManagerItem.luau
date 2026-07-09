local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CapturesCommon = require(ParentParentParent.CapturesCommon)
local Cryo = require(ParentParentParent.Cryo)
local Foundation = require(ParentParentParent.Foundation)
local Checkbox = Foundation.Checkbox
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Images = require(ParentParentParent.UIBlox).App.ImageSet.Images
local FoundationText = Foundation.Text
local useAnalytics = require(ParentParent.Analytics.useAnalytics)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local CaptureType = require(ParentParent.Enums.CaptureType)
local Constants = require(ParentParent.Constants)
local EventNames = require(ParentParent.Analytics.EventNames)
local getContentFromObject = CapturesCommon.Utils.getContentFromObject
local getCropSize = CapturesCommon.Utils.getCropSize
local getFormatTime = require(ParentParent.Utils.getFormatTime)
local SelectCapture = require(ParentParent.Thunks.SelectCapture)

require(ParentParent.Types)

local FFlagUseRbxstorageInGallery = require(ParentParent.Flags.FFlagUseRbxstorageInGallery)
local FFlagEnableCapturesGalleryRetrievalCoreScript = require(ParentParent.Flags.FFlagEnableCapturesGalleryRetrievalCoreScript)

return function(t1: {[any]: any}) -- line: 43
	-- upvalues: useAnalytics (copy), useDispatch (copy), React (copy), useSelector (copy), Constants (copy), EventNames (copy), SelectCapture (copy), getCropSize (copy), Cryo (copy), FFlagEnableCapturesGalleryRetrievalCoreScript (copy), CaptureType (copy), FFlagUseRbxstorageInGallery (copy), getContentFromObject (copy), Checkbox (copy), Images (copy), FoundationText (copy), getFormatTime (copy)
	local v24 = useAnalytics()
	local v25 = useDispatch()
	local v26, v27 = React.useState(Vector2.new(0, 0))
	local v28, v29 = React.useState(Vector2.new(0, 0))
	local v30, v31 = React.useState(UDim2.fromScale(1, 1))
	local v32, v33 = React.useState(false)
	local v34 = useSelector(function(p1) -- line: 51
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].CaptureManager.SelectedCaptures
	end)
	local v35 = React.useCallback(function() -- line: 55
		-- upvalues: v33 (copy), v32 (copy), v24 (copy), EventNames (copy), v25 (copy), SelectCapture (copy), t1 (copy)
		v33(not v32)
		v24.fireEvent(EventNames.CapturesManagerItemActivated)
		v25(SelectCapture(t1.capture))
	end, {
		v32,
		t1.capture
	})
	local v36 = React.useCallback(function(p2) -- line: 61
		-- upvalues: v27 (copy)
		v27(p2.AbsoluteSize)
	end, {})
	local v37 = React.useCallback(function(p3) -- line: 65
		-- upvalues: v29 (copy)
		local Resolution = p3.Resolution

		v29(Resolution)
	end, {})

	React.useEffect(function() -- line: 70
		-- upvalues: v31 (copy), getCropSize (copy), v26 (copy), v28 (copy)
		v31(getCropSize(v26, v28))
	end, {
		v26,
		v28
	})
	React.useEffect(function() -- line: 74
		-- upvalues: v33 (copy), Cryo (copy), v34 (copy), t1 (copy)
		v33(Cryo.List.find(v34, t1.capture) ~= nil)
	end, {
		v34,
		t1.capture
	})

	return React.createElement("ImageButton", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Image = if not FFlagEnableCapturesGalleryRetrievalCoreScript then if t1.capture.type ~= CaptureType.Screenshot then if not FFlagUseRbxstorageInGallery then nil else t1.capture.thumbnailKey else t1.capture.contentId else nil,
		ImageContent = if not FFlagEnableCapturesGalleryRetrievalCoreScript then nil else getContentFromObject(t1.capture),
		ImageTransparency = not v32 and 0 or 0.5,
		ScaleType = Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		[React.Change.AbsoluteSize] = if FFlagUseRbxstorageInGallery then nil else v36,
		[React.Event.Activated] = v35
	}, {
		CheckboxFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			Position = UDim2.new(1, -34, 0, 8),
			Size = UDim2.fromOffset(26, 26)
		}, {
			Checkbox = if not v32 then React.createElement("ImageButton", {
				BackgroundTransparency = 1,
				Image = Images["squircles/hollow"].Image,
				ImageRectOffset = Images["squircles/hollow"].ImageRectOffset,
				ImageRectSize = Images["squircles/hollow"].ImageRectSize,
				ImageTransparency = 0.7,
				Size = UDim2.fromOffset(26, 26),
				[React.Event.Activated] = v35
			}) else React.createElement(Checkbox, {
				isChecked = true,
				isDisabled = false,
				LayoutOrder = 1,
				label = "",
				onActivated = v35
			})
		}),
		TimeLength = if not FFlagEnableCapturesGalleryRetrievalCoreScript or t1.capture.CaptureType ~= Enum.CaptureType.Video then if not FFlagEnableCapturesGalleryRetrievalCoreScript or t1.capture.CaptureType ~= Enum.CaptureType.Screenshot then if not FFlagUseRbxstorageInGallery or t1.capture.type ~= CaptureType.Video then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "text-title-large content-emphasis auto-xy size-full text-align-x-right text-align-y-bottom padding-x-small padding-y-xsmall",
			Text = getFormatTime(t1.capture.videoCapture.TimeLength)
		}) else nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "text-title-large content-emphasis auto-xy size-full text-align-x-right text-align-y-bottom padding-x-small padding-y-xsmall",
			Text = getFormatTime(t1.capture.TimeLength)
		}),
		VideoPreview = if FFlagUseRbxstorageInGallery or t1.capture.type ~= CaptureType.Video then nil else React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Playing = false,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = v30,
			Video = t1.capture.contentId,
			[React.Event.Loaded] = v37
		})
	})
end
