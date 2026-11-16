local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local useCallback = React.useCallback
local useMemo = React.useMemo

local View = Foundation.View

local TextOverlay = require(MomentsCommon.Components.TextOverlay)

local getCropSize = require(MomentsCommon.Utils.getCropSize)
local getFitSize = require(MomentsCommon.Utils.getFitSize)
local getScale = require(MomentsCommon.Utils.getScale)

require(MomentsCommon.Types)

local function TextOverlayDisplay(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v

	if props.textOverlayEdits then
		v = props.textOverlayEdits[1] or nil
	else
		v = nil
	end

	local size, additionalScale = useMemo(function()
		if not props.itemResolution then
			return UDim2.fromScale(1, 1), 1
		end

		local fitSize = getFitSize(props.itemSize, props.itemResolution)
		local cropSize = getCropSize(props.itemSize, props.itemResolution)
		local scale = getScale(props.itemSize, props.itemResolution, props.scaleType)

		if props.scaleType == Enum.ScaleType.Fit then
			return fitSize, scale
		end

		return cropSize, scale
	end, { props.scaleType, props.itemResolution, props.itemSize })

	local onDragEnd = useCallback(function()
		if ref2.current and props.onTextOverlayDragEnd then
			local v2 = { (Dash.joinDeep(v, { position = ref2.current.Position })) }
			props.onTextOverlayDragEnd(v2)
		end
	end, { props.onTextOverlayDragEnd, v })

	local v2 = useCallback(function(textOverlayEdit)
		return React.createElement(TextOverlay, {
			additionalScale = additionalScale,
			boundingUI = ref.current,
			containerRef = ref2,
			draggable = props.draggable,
			onActivated = props.onTextOverlayActivated,
			onDragEnd = onDragEnd,
			textOverlayEdit = textOverlayEdit
		})
	end, { props.draggable, props.onTextOverlayActivated, additionalScale })

	if props.textOverlayEdits and #props.textOverlayEdits ~= 0 then
		return React.createElement(View, {
			ref = ref,
			Size = size,
			tag = "anchor-center-center position-center-center",
			ZIndex = props.zIndex or 1
		}, { TextOverlay = v2(v) })
	end

	return nil
end

return TextOverlayDisplay
