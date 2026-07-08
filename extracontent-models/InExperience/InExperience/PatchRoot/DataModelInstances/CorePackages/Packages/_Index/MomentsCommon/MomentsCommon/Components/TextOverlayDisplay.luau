local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Dash = require(MomentsCommonParent.Dash)
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local useCallback = React.useCallback
local useMemo = React.useMemo
local View = Foundation.View
local TextOverlay = require(MomentsCommon.Components.TextOverlay)
local getCropSize = require(MomentsCommon.Utils.getCropSize)
local getFitSize = require(MomentsCommon.Utils.getFitSize)
local getScale = require(MomentsCommon.Utils.getScale)

require(MomentsCommon.Types)

local function TextOverlayDisplay(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), useMemo (copy), getFitSize (copy), getCropSize (copy), getScale (copy), useCallback (copy), Dash (copy), TextOverlay (copy), View (copy)
	local v15 = React.useRef(nil)
	local v16 = React.useRef(nil)
	local v17 = t1.textOverlayEdits and t1.textOverlayEdits[1] or nil
	local v18, v19 = useMemo(function() -- line: 39
		-- upvalues: t1 (copy), getFitSize (copy), getCropSize (copy), getScale (copy)
		if not t1.itemResolution then
			return UDim2.fromScale(1, 1), 1
		end

		local v22 = getFitSize(t1.itemSize, t1.itemResolution)
		local v23 = getCropSize(t1.itemSize, t1.itemResolution)
		local v24 = getScale(t1.itemSize, t1.itemResolution, t1.scaleType)

		if t1.scaleType == Enum.ScaleType.Fit then
			return v22, v24
		end

		return v23, v24
	end, {
		t1.scaleType,
		t1.itemResolution,
		t1.itemSize
	})
	local v20 = useCallback(function() -- line: 55
		-- upvalues: v16 (copy), t1 (copy), Dash (copy), v17 (copy)
		if not v16.current or not t1.onTextOverlayDragEnd then
			return
		end

		local v25 = Dash.joinDeep(v17, {
			position = v16.current.Position
		})

		t1.onTextOverlayDragEnd({ v25 })
	end, {
		t1.onTextOverlayDragEnd,
		v17
	})
	local v21 = useCallback(function(p1) -- line: 65
		-- upvalues: React (copy), TextOverlay (copy), v19 (copy), v15 (copy), v16 (copy), t1 (copy), v20 (copy)
		return React.createElement(TextOverlay, {
			additionalScale = v19,
			boundingUI = v15.current,
			containerRef = v16,
			draggable = t1.draggable,
			onActivated = t1.onTextOverlayActivated,
			onDragEnd = v20,
			textOverlayEdit = p1
		})
	end, {
		t1.draggable,
		t1.onTextOverlayActivated,
		v19
	})

	if not t1.textOverlayEdits or #t1.textOverlayEdits == 0 then
		return nil
	end

	return React.createElement(View, {
		tag = "anchor-center-center position-center-center",
		ref = v15,
		Size = v18,
		ZIndex = t1.zIndex or 1
	}, {
		TextOverlay = v21(v17)
	})
end

return TextOverlayDisplay
