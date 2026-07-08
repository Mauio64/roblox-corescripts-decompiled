local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local ParentParent = scriptParentParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Portal = require(ParentParentParent.Roact).Portal
local LuauPolyfill = require(ParentParentParent.LuauPolyfill)

require(scriptParent.Types)

local Constants = require(scriptParent.Constants)
local withAnimation = require(ParentParent.Core.Animation.withAnimation)
local TooltipCallout = require(scriptParent.TooltipCallout)
local TooltipOrientation = require(scriptParentParent.Tooltip.Enum.TooltipOrientation)

local function argmax(t1: {[any]: any}, t2: {[any]: any}) -- line: 19
	local v17 = nil

	for k, v in pairs(t1) do
		if not t2[k] and (v17 == nil or v > t1[v17]) then
			v17 = k
		end
	end

	return v17
end
local function getDistances(vector2: Vector2, vector2_2: Vector2) -- line: 32
	-- upvalues: TooltipOrientation (copy), Constants (copy)
	return {
		[TooltipOrientation.Top] = vector2.Y - Constants.SCREEN_MARGIN,
		[TooltipOrientation.Bottom] = vector2_2.Y - vector2.Y - Constants.SCREEN_MARGIN,
		[TooltipOrientation.Left] = vector2.X - Constants.SCREEN_MARGIN,
		[TooltipOrientation.Right] = vector2_2.X - vector2.X - Constants.SCREEN_MARGIN
	}
end

function getOrientationAndContentOffset(p1, p2, vector2: Vector2, vector2_3: Vector2) -- line: 43
	-- upvalues: argmax (copy), TooltipOrientation (copy), Constants (copy)
	local t3 = {}
	local zero = Vector2.zero

	while true do
		if not p1 or t3[p1] then
			local v28 = argmax(p2, t3)

			if not v28 then
				return p1, zero
			end

			p1 = v28
		end

		if p1 == TooltipOrientation.Top or p1 == TooltipOrientation.Bottom then
			if vector2.Y + Constants.DISTANCE_TO_CONTENT + vector2_3.Y <= p2[p1] then
				local Left = TooltipOrientation.Left

				if p2[TooltipOrientation.Right] < p2[TooltipOrientation.Left] then
					Left = TooltipOrientation.Right
				end

				local v30 = p2[Left]

				if v30 >= Constants.MIN_DISTANCE_TO_CARET_MIDDLE then
					zero = math.max(0, vector2_3.X / 2 - v30) * -1 * Constants.ORIENTATION_VECTOR[Left]

					return p1, zero
				end

				t3[Constants.OPPOSITE_ORIENTATION[p1]] = true
			end
		elseif vector2.X + Constants.DISTANCE_TO_CONTENT + vector2_3.X <= p2[p1] then
			local Top = TooltipOrientation.Top

			if p2[TooltipOrientation.Bottom] < p2[TooltipOrientation.Top] then
				Top = TooltipOrientation.Bottom
			end

			local v32 = p2[Top]

			if v32 >= Constants.MIN_DISTANCE_TO_CARET_MIDDLE then
				zero = math.max(0, vector2_3.Y / 2 - v32) * -1 * Constants.ORIENTATION_VECTOR[Top]

				return p1, zero
			end

			t3[Constants.OPPOSITE_ORIENTATION[p1]] = true
		end

		t3[p1] = true
		p1 = Constants.OPPOSITE_ORIENTATION[p1]
	end
end

local function TooltipController(p3) -- line: 106
	-- upvalues: React (copy), TooltipOrientation (copy), getDistances (copy), Constants (copy), LuauPolyfill (copy), TooltipCallout (copy), Portal (copy), withAnimation (copy)
	local v34, v35 = React.useState(Vector2.zero)
	local v36, v37 = React.useState(Vector2.zero)
	local v38, v39 = React.useState(Vector2.zero)
	local v40, v41 = React.useState(Vector2.zero)
	local v42, v43 = React.useState(Vector2.zero)
	local v44 = React.useCallback(function(p4) -- line: 113
		-- upvalues: v35 (copy), v37 (copy)
		v35(p4.AbsolutePosition)
		v37(p4.AbsoluteSize)
	end)

	local function v45(p5) -- line: 119
		-- upvalues: v41 (copy), v39 (copy)
		if p5 then
			v41(p5.AbsolutePosition)
			v39(p5.AbsoluteSize)
		end
	end

	local v46 = v36 / 2
	local v47 = v34 + v46 - v40
	local v48 = p3.preferredOrientation or TooltipOrientation.Top
	local v49, v50 = React.useMemo(function() -- line: 131
		-- upvalues: getDistances (copy), v47 (copy), v38 (copy), v48 (copy), v46 (copy), v42 (copy)
		local v57 = getDistances(v47, v38)

		return getOrientationAndContentOffset(v48, v57, v46, v42)
	end, {
		v48,
		v38,
		v47,
		v46,
		v42
	})
	local v51 = if not (not p3.disabled and p3.active) then Constants.INACTIVE_ANIMATION_TARGETS else Constants.ACTIVE_ANIMATION_TARGETS

	local function renderWithAnimation(p6) -- line: 142
		-- upvalues: v49 (copy), v47 (copy), v46 (copy), v50 (copy), v43 (copy), LuauPolyfill (copy), p3 (copy), React (copy), TooltipCallout (copy), v45 (copy), Portal (copy)
		if p6.transparency == 1 then
			return nil
		end

		local t4 = {
			orientation = v49,
			triggerPointCenter = v47,
			triggerPointRadius = v46,
			contentOffsetVector = v50,
			onContentSizeChanged = v43,
			distanceOffset = p6.distanceOffset,
			transparency = p6.transparency
		}
		local v60 = LuauPolyfill.Object.assign({}, p3.tooltipProps, t4)
		local t5 = {
			Tooltip = React.createElement(TooltipCallout, v60)
		}
		local v62 = if not p3.DEBUG_useTargetDirectly then React.createElement("ScreenGui", {
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			IgnoreGuiInset = true,
			DisplayOrder = p3.DisplayOrder,
			[React.Change.AbsoluteSize] = v45,
			[React.Change.AbsolutePosition] = v45,
			ref = v45
		}, t5) else React.createElement("Frame", {
			ZIndex = p3.DisplayOrder,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v45,
			[React.Change.AbsolutePosition] = v45,
			ref = v45
		}, t5)

		return React.createElement(Portal, {
			target = p3.guiTarget
		}, {
			TooltipLayer = v62
		})
	end

	local v53 = withAnimation(v51, renderWithAnimation, Constants.ANIMATION_OPTIONS)
	local v54 = p3.triggerPointName or "TriggerPoint"

	return React.createElement(React.Fragment, nil, {
		Portal = v53,
		[v54] = p3.renderTriggerPoint(v44)
	})
end

return TooltipController
