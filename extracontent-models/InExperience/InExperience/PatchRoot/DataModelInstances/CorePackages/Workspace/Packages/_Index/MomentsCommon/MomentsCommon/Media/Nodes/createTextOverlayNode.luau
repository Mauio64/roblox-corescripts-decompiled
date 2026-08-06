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
local FFlagMomentsOverlayContainerScaleFallback = require(MomentsCommon.Flags.FFlagMomentsOverlayContainerScaleFallback)
local v12 = Signals.createSignal(Enum.ScaleType.Crop)

local function TextOverlayLayer(t1: {[any]: any}) -- line: 86
	-- upvalues: React (copy), Signals (copy), useSignalState (copy), v12 (copy), FFlagMomentsOverlayContainerScaleFallback (copy), TextOverlayDisplay (copy)
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

	return React.createElement(TextOverlayDisplay, {
		draggable = false,
		editable = false,
		itemResolution = v20,
		itemSize = v19,
		scaleType = v21,
		textOverlayEdits = { t1.overlay }
	})
end
local function LegacyTextOverlayLayer(t2: {[any]: any}) -- line: 138
	-- upvalues: useSignalState (copy), overlayScale (copy), React (copy), TextOverlay (copy)
	local v23 = useSignalState(t2.getItemSize)
	local v24 = overlayScale(1, v23.X)

	return React.createElement(TextOverlay, {
		draggable = false,
		editable = false,
		additionalScale = v24,
		textOverlayEdit = t2.overlay
	})
end
local function createTextOverlayNode(p2, _) -- line: 151
	-- upvalues: GetFFlagMomentsTextOverlayMediaRect (copy), React (copy), LegacyTextOverlayLayer (copy), TextOverlayLayer (copy)
	local overlay = p2.overlay

	assert(overlay ~= nil, "createTextOverlayNode: spec.overlay (a TextOverlayEdit) is required")

	local v28 = p2.zIndex or overlay.zIndex

	return {
		kind = "text",
		usesDecoder = false,
		id = p2.id,
		assets = function() -- line: 159
			return {}
		end,
		download = function() -- line: 185
		end,
		zIndex = v28,
		render = function(p4) -- line: 163
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
		dispose = function() -- line: 189
		end
	}
end

return {
	kind = "text",
	create = createTextOverlayNode
}
