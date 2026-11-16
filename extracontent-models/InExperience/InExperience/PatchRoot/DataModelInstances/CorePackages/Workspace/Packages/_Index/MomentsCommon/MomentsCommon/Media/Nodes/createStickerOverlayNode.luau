local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(parent.MomentsTypes)

local useSignalState = SignalsReact.useSignalState

local StickerOverlay = require(MomentsCommon.Components.StickerOverlay)
local OverlayDisplay = require(MomentsCommon.Components.OverlayDisplay)

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)
local overlayScale = require(MomentsCommon.Media.overlayScale)

local GetFFlagMomentsStickerOverlayMediaRect = require(MomentsCommon.Flags.GetFFlagMomentsStickerOverlayMediaRect)

local signal = Signals.createSignal(Enum.ScaleType.Crop)

local function StickerOverlayLayer(props)
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

	return React.createElement(OverlayDisplay, {
		overlayComponent = StickerOverlay,
		itemResolution = itemResolution,
		itemSize = itemSize,
		scaleType = scaleType,
		overlayEdits = { props.overlay },
		draggable = false,
		editable = false
	})
end

local function LegacyStickerOverlayLayer(p)
	local additionalScale = overlayScale(1, useSignalState(p.getItemSize).X)

	return React.createElement(StickerOverlay, {
		additionalScale = additionalScale,
		draggable = false,
		editable = false,
		overlayEdit = p.overlay
	})
end

local function createStickerOverlayNode(data, _)
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
