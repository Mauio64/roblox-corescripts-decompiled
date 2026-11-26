local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsTypes")

local useSignalState = SignalsReact.useSignalState

local TextOverlayDisplay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/TextOverlayDisplay")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")

local signal = Signals.createSignal(Enum.ScaleType.Crop)

local function TextOverlayLayer(props)
	local getResolution = props.getResolution
	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return getResolution(p2)
		end)
	end, { getResolution })

	local v6 = useSignalState(props.getItemSize)
	local v7 = useSignalState(v5)
	local v8 = useSignalState(props.getScaleType or signal)

	if v7 == nil then
		v7 = v6
	end

	return React.createElement(TextOverlayDisplay, {
		itemResolution = v7,
		itemSize = v6,
		scaleType = v8,
		textOverlayEdits = { props.overlay },
		draggable = false,
		editable = false
	})
end

local function createTextOverlayNode(data, p2)
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
