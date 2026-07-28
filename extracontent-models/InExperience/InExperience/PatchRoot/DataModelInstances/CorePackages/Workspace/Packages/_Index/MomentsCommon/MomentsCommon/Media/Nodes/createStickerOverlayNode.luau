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
local v11 = Signals.createSignal(Enum.ScaleType.Crop)

local function StickerOverlayLayer(t1: {[any]: any}) -- line: 85
	-- upvalues: React (copy), Signals (copy), useSignalState (copy), v11 (copy), OverlayDisplay (copy), StickerOverlay (copy)
	local getResolution = t1.getResolution
	local v17 = React.useMemo(function() -- line: 97
		-- upvalues: Signals (copy), getResolution (copy)
		return Signals.createComputed(function(p1) -- line: 98
			-- upvalues: getResolution (copy)
			return getResolution(p1)
		end)
	end, { getResolution })
	local v18 = useSignalState(t1.getItemSize)
	local v19 = useSignalState(v17)
	local v20 = useSignalState(t1.getScaleType or v11)

	return React.createElement(OverlayDisplay, {
		draggable = false,
		editable = false,
		overlayComponent = StickerOverlay,
		itemResolution = v19,
		itemSize = v18,
		scaleType = v20,
		overlayEdits = { t1.overlay }
	})
end
local function LegacyStickerOverlayLayer(t2: {[any]: any}) -- line: 128
	-- upvalues: useSignalState (copy), overlayScale (copy), React (copy), StickerOverlay (copy)
	local v22 = useSignalState(t2.getItemSize)
	local v23 = overlayScale(1, v22.X)

	return React.createElement(StickerOverlay, {
		draggable = false,
		editable = false,
		additionalScale = v23,
		overlayEdit = t2.overlay
	})
end
local function createStickerOverlayNode(p2, _) -- line: 141
	-- upvalues: GetFFlagMomentsStickerOverlayMediaRect (copy), React (copy), LegacyStickerOverlayLayer (copy), StickerOverlayLayer (copy)
	local overlay = p2.overlay

	assert(overlay ~= nil, "createStickerOverlayNode: spec.overlay (a StickerOverlayEdit) is required")

	local v27 = p2.zIndex or overlay.zIndex

	return {
		kind = "sticker",
		usesDecoder = false,
		id = p2.id,
		assets = function() -- line: 153
			return {}
		end,
		download = function() -- line: 179
		end,
		zIndex = v27,
		render = function(p4) -- line: 157
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
		dispose = function() -- line: 183
		end
	}
end

return {
	kind = "sticker",
	create = createStickerOverlayNode
}
