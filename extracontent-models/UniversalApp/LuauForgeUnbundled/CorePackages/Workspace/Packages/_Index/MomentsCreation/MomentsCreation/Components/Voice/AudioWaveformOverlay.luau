local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local useState = React.useState
local useMemo = React.useMemo
local useCallback = React.useCallback

local resampleWaveformPeaks = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/resampleWaveformPeaks")

local GetFIntMomentsTTSWaveformMinBarHeightPercent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSWaveformMinBarHeightPercent")

local GetFIntMomentsTTSWaveformMaxBarHeightPercent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFIntMomentsTTSWaveformMaxBarHeightPercent")
local GetFFlagMomentsTTSStartTimePositioning = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSStartTimePositioning")

local function AudioWaveformOverlay(props)
	local v5 = useTokens()
	local state, setState = useState(0)

	local v6 = useCallback(function(p2)
		setState(p2.AbsoluteSize.X)
	end, {})

	local v7 = useMemo(function()
		if state <= 0 then
			return 0
		end

		return (math.max(1, (math.floor((state - 8) / 4))))
	end, { state })

	local samples = props.samples

	local v8 = #samples

	if GetFFlagMomentsTTSStartTimePositioning and props.audioDuration > 0 and props.videoDuration > 0 then
		local v9 = math.clamp((props.videoDuration - (props.startTime or 0)) / props.audioDuration, 0, 1)
		v8 = math.floor(#samples * v9 + 0.5)
	end

	local v9 = useMemo(function()
		local children = {}

		local v10 = GetFIntMomentsTTSWaveformMinBarHeightPercent() / 100
		local v11 = GetFIntMomentsTTSWaveformMaxBarHeightPercent() / 100
		local v12 = if v8 >= #samples then samples else table.move(samples, 1, v8, 1, {})
		local v13 = resampleWaveformPeaks(v12, v7, v10, v11)

		for k, v14 in v13 do
			children["bar_" .. k] = React.createElement("Frame", {
				Size = UDim2.new(0, 2, v14, 0),
				BackgroundColor3 = v5.Color.Content.Emphasis.Color3,
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0,
				LayoutOrder = k
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, 2)
				})
			})
		end

		return children
	end, { v7, samples, v8, v5 })

	if props.videoDuration <= 0 then
		return nil
	end

	local v10 = math.clamp(props.audioDuration / props.videoDuration, 0, 1)
	local v11, v12

	if GetFFlagMomentsTTSStartTimePositioning then
		v11 = math.clamp((props.startTime or 0) / props.videoDuration, 0, 1)

		v10 = math.clamp(props.audioDuration / props.videoDuration, 0, 1 - v11)
		v12 = 2
	else
		v11 = 0
		v12 = 1
	end

	local createElement = React.createElement
	local v14 = {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(v11, 0.5),
		Size = UDim2.new(v10, 0, 1, 0),
		BackgroundColor3 = v5.Color.ActionEmphasis.Background.Color3,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ZIndex = 2,
		[React.Change.AbsoluteSize] = v6
	}
	local v15 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 6) }),
		Stroke = React.createElement("UIStroke", {
			Color = Color3.new(1, 1, 1),
			Transparency = props.isSelected and 0 or 0.6,
			Thickness = v12
		}),
		DragDetector = 0,
		BarsContainer = 0
	}

	local v16 = if GetFFlagMomentsTTSStartTimePositioning and props.dragDetectorRef ~= nil then React.createElement("UIDragDetector", {
		DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
		ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
		ref = props.dragDetectorRef
	}) else nil
	v15.DragDetector = v16

	v15.BarsContainer = React.createElement(view, {
		tag = "size-full-full clip",
		ZIndex = 1,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 2),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		padding = { left = UDim.new(0, 4), right = UDim.new(0, 4) }
	}, {
		Bars = React.createElement(React.Fragment, nil, v9)
	})
	return createElement("Frame", v14, v15)
end

return AudioWaveformOverlay
