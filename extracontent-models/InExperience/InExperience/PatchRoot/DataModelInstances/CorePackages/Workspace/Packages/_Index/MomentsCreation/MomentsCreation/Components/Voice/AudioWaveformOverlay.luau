local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local useState = React.useState
local useMemo = React.useMemo
local useCallback = React.useCallback

local resampleWaveformPeaks = require(MomentsCreation.Utils.resampleWaveformPeaks)

local GetFIntMomentsTTSWaveformMinBarHeightPercent = require(MomentsCreation.Flags.GetFIntMomentsTTSWaveformMinBarHeightPercent)

local GetFIntMomentsTTSWaveformMaxBarHeightPercent = require(MomentsCreation.Flags.GetFIntMomentsTTSWaveformMaxBarHeightPercent)
local GetFFlagMomentsTTSStartTimePositioning = require(MomentsCreation.Flags.GetFFlagMomentsTTSStartTimePositioning)

local function AudioWaveformOverlay(props)
	local v = useTokens()
	local state, setState = useState(0)

	local v2 = useCallback(function(p)
		setState(p.AbsoluteSize.X)
	end, {})

	local v3 = useMemo(function()
		if state <= 0 then
			return 0
		end

		return (math.max(1, (math.floor((state - 8) / 4))))
	end, { state })

	local samples = props.samples

	local v4 = #samples

	if GetFFlagMomentsTTSStartTimePositioning and props.audioDuration > 0 and props.videoDuration > 0 then
		local v5 = math.clamp((props.videoDuration - (props.startTime or 0)) / props.audioDuration, 0, 1)
		v4 = math.floor(#samples * v5 + 0.5)
	end

	local v5 = useMemo(function()
		local children = {}

		local v5 = GetFIntMomentsTTSWaveformMinBarHeightPercent() / 100
		local v6 = GetFIntMomentsTTSWaveformMaxBarHeightPercent() / 100
		local v7

		if v4 >= #samples then
			v7 = samples
		else
			v7 = table.move(samples, 1, v4, 1, {})
		end

		local v8 = resampleWaveformPeaks(v7, v3, v5, v6)

		for k, v9 in v8 do
			children["bar_" .. k] = React.createElement("Frame", {
				Size = UDim2.new(0, 2, v9, 0),
				BackgroundColor3 = v.Color.Content.Emphasis.Color3,
				BackgroundTransparency = 0.3,
				BorderSizePixel = 0,
				LayoutOrder = k
			}, {
				Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 2) })
			})
		end

		return children
	end, { v3, samples, v4, v })

	if props.videoDuration <= 0 then
		return nil
	end

	local v6 = math.clamp(props.audioDuration / props.videoDuration, 0, 1)
	local v7, thickness

	if GetFFlagMomentsTTSStartTimePositioning then
		v7 = math.clamp((props.startTime or 0) / props.videoDuration, 0, 1)

		v6 = math.clamp(props.audioDuration / props.videoDuration, 0, 1 - v7)
		thickness = 2
	else
		v7 = 0
		thickness = 1
	end

	local createElement = React.createElement
	local v8 = {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(v7, 0.5),
		Size = UDim2.new(v6, 0, 1, 0),
		BackgroundColor3 = v.Color.ActionEmphasis.Background.Color3,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ZIndex = 2,
		[React.Change.AbsoluteSize] = v2
	}
	local v9 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 6) }),
		Stroke = React.createElement("UIStroke", {
			Color = Color3.new(1, 1, 1),
			Transparency = props.isSelected and 0 or 0.6,
			Thickness = thickness
		}),
		DragDetector = 0,
		BarsContainer = 0
	}
	local dragDetector

	if GetFFlagMomentsTTSStartTimePositioning and props.dragDetectorRef ~= nil then
		dragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
			ref = props.dragDetectorRef
		})
	end

	v9.DragDetector = dragDetector

	v9.BarsContainer = React.createElement(View, {
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
		Bars = React.createElement(React.Fragment, nil, v5)
	})
	return createElement("Frame", v8, v9)
end

return AudioWaveformOverlay
