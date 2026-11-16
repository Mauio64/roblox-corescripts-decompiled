local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(parent.MomentsTypes)

local useSignalState = SignalsReact.useSignalState

local TextOverlayDisplay = require(MomentsCommon.Components.TextOverlayDisplay)

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)

local signal = Signals.createSignal(Enum.ScaleType.Crop)

local function TextOverlayLayer(props)
	local getResolution = props.getResolution
	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			return getResolution(p)
		end)
	end, { getResolution })

	local itemSize = useSignalState(props.getItemSize)
	local itemResolution = useSignalState(v)
	local scaleType = useSignalState(props.getScaleType or signal)

	if itemResolution == nil then
		itemResolution = itemSize
	end

	return React.createElement(TextOverlayDisplay, {
		itemResolution = itemResolution,
		itemSize = itemSize,
		scaleType = scaleType,
		textOverlayEdits = { props.overlay },
		draggable = false,
		editable = false
	})
end

local function createTextOverlayNode(data, _)
	local overlay = data.overlay
	assert(overlay ~= nil, "createTextOverlayNode: spec.overlay (a TextOverlayEdit) is required")

	local zIndex = data.zIndex or overlay.zIndex

	return {
		id = data.id,
		kind = "text",
		assets = function()
			return {}
		end,
		download = function() end,
		usesDecoder = false,
		zIndex = zIndex,
		render = function(props)
			return React.createElement(TextOverlayLayer, {
				overlay = overlay,
				getItemSize = props.getItemSize,
				getResolution = props.getResolution,
				getScaleType = props.getScaleType
			})
		end,
		dispose = function() end
	}
end

return { kind = "text", create = createTextOverlayNode }
