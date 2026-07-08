local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local React = require(MomentsCommonParent.React)
local Signals = require(MomentsCommonParent.Signals)
local SignalsReact = require(MomentsCommonParent.SignalsReact)

require(MomentsCommonParent.MomentsTypes)

local useSignalState = SignalsReact.useSignalState
local TextOverlay = require(MomentsCommon.Components.TextOverlay)
local TextOverlayDisplay = require(MomentsCommon.Components.TextOverlayDisplay)

require(MomentsCommon.Media.MediaTypes)
require(MomentsCommon.Media.mediaNodeRegistry)

local overlayScale = require(MomentsCommon.Media.overlayScale)
local GetFFlagMomentsTextOverlayMediaRect = require(MomentsCommon.Flags.GetFFlagMomentsTextOverlayMediaRect)
local v11 = Signals.createSignal(Enum.ScaleType.Crop)

local function TextOverlayLayer(t1: {[any]: any}) -- line: 85
	-- upvalues: React (copy), Signals (copy), useSignalState (copy), v11 (copy), TextOverlayDisplay (copy)
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

	return React.createElement(TextOverlayDisplay, {
		draggable = false,
		editable = false,
		itemResolution = v19,
		itemSize = v18,
		scaleType = v20,
		textOverlayEdits = { t1.overlay }
	})
end
local function LegacyTextOverlayLayer(t2: {[any]: any}) -- line: 127
	-- upvalues: useSignalState (copy), overlayScale (copy), React (copy), TextOverlay (copy)
	local v22 = useSignalState(t2.getItemSize)
	local v23 = overlayScale(1, v22.X)

	return React.createElement(TextOverlay, {
		draggable = false,
		editable = false,
		additionalScale = v23,
		textOverlayEdit = t2.overlay
	})
end
local function createTextOverlayNode(p2, _) -- line: 140
	-- upvalues: GetFFlagMomentsTextOverlayMediaRect (copy), React (copy), LegacyTextOverlayLayer (copy), TextOverlayLayer (copy)
	local overlay = p2.overlay

	assert(overlay ~= nil, "createTextOverlayNode: spec.overlay (a TextOverlayEdit) is required")

	local v27 = p2.zIndex or overlay.zIndex

	return {
		kind = "text",
		usesDecoder = false,
		id = p2.id,
		assets = function() -- line: 148
			return {}
		end,
		download = function() -- line: 174
		end,
		zIndex = v27,
		render = function(p4) -- line: 152
			-- upvalues: GetFFlagMomentsTextOverlayMediaRect (copy), React (copy), LegacyTextOverlayLayer (copy), overlay (copy), TextOverlayLayer (copy)
			if not GetFFlagMomentsTextOverlayMediaRect() then
				return React.createElement(LegacyTextOverlayLayer, {
					overlay = overlay,
					getItemSize = p4.getItemSize
				})
			end

			return React.createElement(TextOverlayLayer, {
				overlay = overlay,
				getItemSize = p4.getItemSize,
				getResolution = p4.getResolution,
				getScaleType = p4.getScaleType
			})
		end,
		dispose = function() -- line: 178
		end
	}
end

return {
	kind = "text",
	create = createTextOverlayNode
}
