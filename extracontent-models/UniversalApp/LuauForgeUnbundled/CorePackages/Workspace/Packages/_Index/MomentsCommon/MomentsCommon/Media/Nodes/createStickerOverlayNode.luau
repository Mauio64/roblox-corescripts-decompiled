local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsTypes")

local useSignalState = SignalsReact.useSignalState

local StickerOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/StickerOverlay")
local OverlayDisplay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/OverlayDisplay")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/MediaTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/mediaNodeRegistry")
local overlayScale = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Media/overlayScale")

local GetFFlagMomentsStickerOverlayMediaRect = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsStickerOverlayMediaRect")

local signal = Signals.createSignal(Enum.ScaleType.Crop)

local function StickerOverlayLayer(props)
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

	return React.createElement(OverlayDisplay, {
		overlayComponent = StickerOverlay,
		itemResolution = v7,
		itemSize = v6,
		scaleType = v8,
		overlayEdits = { props.overlay },
		draggable = false,
		editable = false
	})
end

local function LegacyStickerOverlayLayer(p2)
	local v6 = overlayScale(1, useSignalState(p2.getItemSize).X)

	return React.createElement(StickerOverlay, {
		additionalScale = v6,
		draggable = false,
		editable = false,
		overlayEdit = p2.overlay
	})
end

local function createStickerOverlayNode(data, p2)
	local overlay = data.overlay
	assert(overlay ~= nil, "createStickerOverlayNode: spec.overlay (a StickerOverlayEdit) is required")

	local zIndex = data.zIndex or overlay.zIndex

	return {
		id = data.id,
		kind = "sticker",
		assets = function()
			return {}
		end,
		download = function() end,
		usesDecoder = false,
		zIndex = zIndex,
		render = function(props)
			if GetFFlagMomentsStickerOverlayMediaRect() then
				return React.createElement(StickerOverlayLayer, {
					overlay = overlay,
					getItemSize = props.getItemSize,
					getResolution = props.getResolution,
					getScaleType = props.getScaleType
				})
			end

			return React.createElement(LegacyStickerOverlayLayer, {
				overlay = overlay,
				getItemSize = props.getItemSize
			})
		end,
		dispose = function() end
	}
end

return { kind = "sticker", create = createStickerOverlayNode }
