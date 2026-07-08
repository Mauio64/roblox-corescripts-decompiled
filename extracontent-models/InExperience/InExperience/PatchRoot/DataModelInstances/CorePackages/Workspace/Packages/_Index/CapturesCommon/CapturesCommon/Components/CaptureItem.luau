local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local CaptureType = require(ParentParent.Enums.CaptureType)
local MediaPlayer = require(ParentParent.Components.MediaPlayer)

require(ParentParent.Types)

local getCropSize = require(ParentParent.Utils.getCropSize)
local getFitSize = require(ParentParent.Utils.getFitSize)
local FFlagUseRbxStorageInCapturesCommon = require(ParentParent.Flags.FFlagUseRbxStorageInCapturesCommon)

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), getFitSize (copy), getCropSize (copy), CaptureType (copy), FFlagUseRbxStorageInCapturesCommon (copy), MediaPlayer (copy)
	local v10, v11 = React.useState(Vector2.new(0, 0))
	local v12, v13 = React.useState(Vector2.new(0, 0))
	local v14, v15 = React.useState(UDim2.fromScale(1, 1))
	local v16 = React.useCallback(function(p1) -- line: 30
		-- upvalues: v13 (copy)
		local Resolution = p1.Resolution

		v13(Resolution)
	end, {})
	local v17 = React.useCallback(function(p2) -- line: 35
		-- upvalues: v11 (copy)
		v11(p2.AbsoluteSize)
	end, {})

	React.useEffect(function() -- line: 39
		-- upvalues: t1 (copy), v15 (copy), getFitSize (copy), v10 (copy), v12 (copy), getCropSize (copy)
		if t1.scaleType == Enum.ScaleType.Fit then
			v15(getFitSize(v10, v12))

			return
		end

		v15(getCropSize(v10, v12))
	end, {
		v10,
		v12
	})

	return React.createElement("ImageButton", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Image = if t1.capture.type ~= CaptureType.Screenshot then if not FFlagUseRbxStorageInCapturesCommon then nil else t1.capture.thumbnailKey else t1.capture.contentId,
		ScaleType = t1.scaleType or Enum.ScaleType.Crop,
		Size = UDim2.fromScale(1, 1),
		[React.Change.AbsoluteSize] = if FFlagUseRbxStorageInCapturesCommon then nil else v17,
		[React.Event.Activated] = t1.onActivated
	}, {
		Overlay = t1.overlay,
		VideoPreview = if not FFlagUseRbxStorageInCapturesCommon or (t1.capture.type ~= CaptureType.Video or (not t1.shouldUseMediaPlayer or not t1.mediaPlayerProps)) then if FFlagUseRbxStorageInCapturesCommon or t1.capture.type ~= CaptureType.Video then nil else if not t1.shouldUseMediaPlayer or not t1.mediaPlayerProps then React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Playing = t1.isVideoPlaying == true,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = v14,
			Video = t1.capture.contentId,
			[React.Event.Loaded] = v16
		}) else React.createElement(MediaPlayer, t1.mediaPlayerProps) else React.createElement(MediaPlayer, t1.mediaPlayerProps)
	})
end
