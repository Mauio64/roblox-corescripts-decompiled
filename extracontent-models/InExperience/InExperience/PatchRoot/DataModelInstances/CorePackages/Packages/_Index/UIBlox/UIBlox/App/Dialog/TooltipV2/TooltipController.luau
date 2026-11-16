local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent.Parent
local parent4 = parent3.Parent

local React = require(parent4.React)
local Roact = require(parent4.Roact)
local Portal = Roact.Portal
local LuauPolyfill = require(parent4.LuauPolyfill)

require(parent.Types)
local Constants = require(parent.Constants)
local withAnimation = require(parent3.Core.Animation.withAnimation)
local TooltipCallout = require(parent.TooltipCallout)

local TooltipOrientation = require(parent2.Tooltip.Enum.TooltipOrientation)

local function argmax(items, set)
	local v = nil

	for k, item in pairs(items) do
		if set[k] or not (v == nil or items[v] < item) then
			continue
		end

		v = k
	end

	return v
end

local function getDistances(vector2: Vector2, state: Vector2)
	return {
		[TooltipOrientation.Top] = vector2.Y - Constants.SCREEN_MARGIN,
		[TooltipOrientation.Bottom] = state.Y - vector2.Y - Constants.SCREEN_MARGIN,
		[TooltipOrientation.Left] = vector2.X - Constants.SCREEN_MARGIN,
		[TooltipOrientation.Right] = state.X - vector2.X - Constants.SCREEN_MARGIN
	}
end

function getOrientationAndContentOffset(p, p2, vector2: Vector2, vector2_2: Vector2)
	local v = Vector2.zero
	local set = {}

	while true do
		if not p or set[p] then
			local v2 = argmax(p2, set)

			if not v2 then
				return p, v
			end

			p = v2
		end

		if p == TooltipOrientation.Top or p == TooltipOrientation.Bottom then
			if vector2.Y + Constants.DISTANCE_TO_CONTENT + vector2_2.Y <= p2[p] then
				local v2 = TooltipOrientation.Left

				if p2[TooltipOrientation.Right] < p2[TooltipOrientation.Left] then
					v2 = TooltipOrientation.Right
				end

				local v3 = p2[v2]

				if Constants.MIN_DISTANCE_TO_CARET_MIDDLE <= v3 then
					v = math.max(0, vector2_2.X / 2 - v3) * -1 * Constants.ORIENTATION_VECTOR[v2]

					return p, v
				end

				set[Constants.OPPOSITE_ORIENTATION[p]] = true
			end
		elseif vector2.X + Constants.DISTANCE_TO_CONTENT + vector2_2.X <= p2[p] then
			local v2 = TooltipOrientation.Top

			if p2[TooltipOrientation.Bottom] < p2[TooltipOrientation.Top] then
				v2 = TooltipOrientation.Bottom
			end

			local v3 = p2[v2]

			if Constants.MIN_DISTANCE_TO_CARET_MIDDLE <= v3 then
				v = math.max(0, vector2_2.Y / 2 - v3) * -1 * Constants.ORIENTATION_VECTOR[v2]

				return p, v
			end

			set[Constants.OPPOSITE_ORIENTATION[p]] = true
		end

		set[p] = true

		p = Constants.OPPOSITE_ORIENTATION[p]
	end
end

local function TooltipController(props)
	local state, setState = React.useState(Vector2.zero)
	local state2, setState2 = React.useState(Vector2.zero)
	local state3, setState3 = React.useState(Vector2.zero)
	local state4, setState4 = React.useState(Vector2.zero)
	local state5, setState5 = React.useState(Vector2.zero)

	local v = React.useCallback(function(p)
		setState(p.AbsolutePosition)
		setState2(p.AbsoluteSize)
	end)

	local function fn(p)
		if p then
			setState4(p.AbsolutePosition)
			setState3(p.AbsoluteSize)
		end
	end

	local triggerPointRadius = state2 / 2
	local triggerPointCenter = state + triggerPointRadius - state4

	local preferredOrientation = props.preferredOrientation or TooltipOrientation.Top

	local orientation, contentOffsetVector = React.useMemo(function()
		local distances = getDistances(triggerPointCenter, state3)

		return getOrientationAndContentOffset(preferredOrientation, distances, triggerPointRadius, state5)
	end, { preferredOrientation, state3, triggerPointCenter, triggerPointRadius, state5 })

	local v2 = not props.disabled and props.active
	local v3

	if v2 then
		v3 = Constants.ACTIVE_ANIMATION_TARGETS
	else
		v3 = Constants.INACTIVE_ANIMATION_TARGETS
	end

	local function renderWithAnimation(p)
		if p.transparency == 1 then
			return nil
		end

		local v4 = {
			orientation = orientation,
			triggerPointCenter = triggerPointCenter,
			triggerPointRadius = triggerPointRadius,
			contentOffsetVector = contentOffsetVector,
			onContentSizeChanged = setState5,
			distanceOffset = p.distanceOffset,
			transparency = p.transparency
		}

		local v5 = LuauPolyfill.Object.assign({}, props.tooltipProps, v4)

		local v6 = {
			Tooltip = React.createElement(TooltipCallout, v5)
		}
		local tooltipLayer

		if props.DEBUG_useTargetDirectly then
			tooltipLayer = React.createElement("Frame", {
				ZIndex = props.DisplayOrder,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = fn,
				[React.Change.AbsolutePosition] = fn,
				ref = fn
			}, v6)
		else
			tooltipLayer = React.createElement("ScreenGui", {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				IgnoreGuiInset = true,
				DisplayOrder = props.DisplayOrder,
				[React.Change.AbsoluteSize] = fn,
				[React.Change.AbsolutePosition] = fn,
				ref = fn
			}, v6)
		end

		return React.createElement(Portal, { target = props.guiTarget }, {
			TooltipLayer = tooltipLayer
		})
	end

	local portal = withAnimation(v3, renderWithAnimation, Constants.ANIMATION_OPTIONS)

	local triggerPointName = props.triggerPointName or "TriggerPoint"

	return React.createElement(React.Fragment, nil, {
		Portal = portal,
		[triggerPointName] = props.renderTriggerPoint(v)
	})
end

return TooltipController
