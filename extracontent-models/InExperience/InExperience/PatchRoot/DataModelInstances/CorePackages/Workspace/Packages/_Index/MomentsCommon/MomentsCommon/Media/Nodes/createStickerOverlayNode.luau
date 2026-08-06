local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local Signals = require(MomentsCommonParent.Signals)
local SignalsReact = require(MomentsCommonParent.SignalsReact)

require(MomentsCommonParent.MomentsTypes)

local useSignalState = SignalsReact.useSignalState
local StickerOverlay = require(MomentsCommon.Components.StickerOverlay)
local OverlayDisplay = require(MomentsCommon.Components.OverlayDisplay)

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)

local overlayScale = require(MomentsCommon.Media.overlayScale)
local GetFFlagMomentsStickerOverlayMediaRect = require(MomentsCommon.Flags.GetFFlagMomentsStickerOverlayMediaRect)
local FFlagMomentsOverlayContainerScaleFallback = require(MomentsCommon.Flags.FFlagMomentsOverlayContainerScaleFallback)
local v12 = Signals.createSignal(Enum.ScaleType.Crop)

local function StickerOverlayLayer(t1: {[any]: any}) -- line: 86
	-- upvalues: React (copy), Signals (copy), useSignalState (copy), v12 (copy), FFlagMomentsOverlayContainerScaleFallback (copy), OverlayDisplay (copy), StickerOverlay (copy)
	local getResolution = t1.getResolution
	local v18 = React.useMemo(function() -- line: 98
		-- upvalues: Signals (copy), getResolution (copy)
		return Signals.createComputed(function(p1) -- line: 99
			-- upvalues: getResolution (copy)
			return getResolution(p1)
		end)
	end, { getResolution })
	local v19 = useSignalState(t1.getItemSize)
	local v20 = useSignalState(v18)
	local v21 = useSignalState(t1.getScaleType or v12)

	if FFlagMomentsOverlayContainerScaleFallback and v20 == nil then
		v20 = v19
	end

	return React.createElement(OverlayDisplay, {
		draggable = false,
		editable = false,
		overlayComponent = StickerOverlay,
		itemResolution = v20,
		itemSize = v19,
		scaleType = v21,
		overlayEdits = { t1.overlay }
	})
end
local function LegacyStickerOverlayLayer(t2: {[any]: any}) -- line: 139
	-- upvalues: useSignalState (copy), overlayScale (copy), React (copy), StickerOverlay (copy)
	local v23 = useSignalState(t2.getItemSize)
	local v24 = overlayScale(1, v23.X)

	return React.createElement(StickerOverlay, {
		draggable = false,
		editable = false,
		additionalScale = v24,
		overlayEdit = t2.overlay
	})
end
local function createStickerOverlayNode(p2, _) -- line: 152
	-- upvalues: GetFFlagMomentsStickerOverlayMediaRect (copy), React (copy), LegacyStickerOverlayLayer (copy), StickerOverlayLayer (copy)
	local overlay = p2.overlay

	assert(overlay ~= nil, "createStickerOverlayNode: spec.overlay (a StickerOverlayEdit) is required")

	local v28 = p2.zIndex or overlay.zIndex

	return {
		kind = "sticker",
		usesDecoder = false,
		id = p2.id,
		assets = function() -- line: 164
			return {}
		end,
		download = function() -- line: 190
		end,
		zIndex = v28,
		render = function(p4) -- line: 168
			-- upvalues: GetFFlagMomentsStickerOverlayMediaRect (copy), React (copy), LegacyStickerOverlayLayer (copy), overlay (copy), StickerOverlayLayer (copy)
			if not GetFFlagMomentsStickerOverlayMediaRect() then
				return React.createElement(LegacyStickerOverlayLayer, {
					overlay = overlay,
					getItemSize = p4.getItemSize
				})
			end

			return React.createElement(StickerOverlayLayer, {
				overlay = overlay,
				getItemSize = p4.getItemSize,
				getResolution = p4.getResolution,
				getScaleType = p4.getScaleType
			})
		end,
		dispose = function() -- line: 194
		end
	}
end

return {
	kind = "sticker",
	create = createStickerOverlayNode
}
