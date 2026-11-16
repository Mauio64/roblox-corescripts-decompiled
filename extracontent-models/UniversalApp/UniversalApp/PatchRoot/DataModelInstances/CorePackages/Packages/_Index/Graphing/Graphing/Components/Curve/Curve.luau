local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)
local Signals = require(parent.Signals)

local CanvasContext = require(Graphing.CanvasContext)
local StyleUtil = require(Graphing.Util.StyleUtil)
require(Graphing.Types)
local useViewportBinding = require(Graphing.Util.useViewportBinding)
local useViewportVisibility = useViewportBinding.useViewportVisibility

local maxControlPoints = nil
local function getMaxPointsPerPath() -- 1 equivalent call inferred from this helper
	if not maxControlPoints then
		local path2D = Instance.new("Path2D")
		maxControlPoints = path2D:GetMaxControlPoints()
		path2D:Destroy()
	end

	assert(maxControlPoints, "MAX_POINTS_PER_PATH was nil")
	return maxControlPoints
end

local function curvePointsToControlPoints(p, items)
	local path2DControlPoints = {}

	for _, item in items do
		local plotToView = p.plotToView(item.Position)
		local v

		if item.LeftTangent then
			v = item.LeftTangent
		else
			v = Vector2.new(0, 0)
		end

		local v2

		if item.RightTangent then
			v2 = item.RightTangent
		else
			v2 = Vector2.new(0, 0)
		end

		local v3 = p.plotToView(item.Position + v) - plotToView
		local v4 = p.plotToView(item.Position + v2) - plotToView

		table.insert(
			path2DControlPoints,
			Path2DControlPoint.new(
				UDim2.fromScale(plotToView.X, plotToView.Y),
				UDim2.fromScale(v3.X, v3.Y),
				UDim2.fromScale(v4.X, v4.Y)
			)
		)
	end

	return path2DControlPoints
end

local function applyControlPoints(instance, list, maxPointsPerPath: number)
	local total = 1

	for _, child in instance:GetChildren() do
		local v = #list
		local v2 = {}

		for i = total, total + maxPointsPerPath - 1 do
			if v < i then
				break
			end

			table.insert(v2, list[i])
		end

		child:SetControlPoints(v2)
		total += maxPointsPerPath - 1
	end
end

function Curve(props)
	local v = React.useContext(CanvasContext)
	local maxPointsPerPath = getMaxPointsPerPath() -- inferred equivalent call
	local ref = React.useRef(nil)

	if ref.current == nil then
		local signal, set = Signals.createSignal(nil)
		ref.current = { get = signal, set = set }
	end

	local current = ref.current

	local pointCount = props.PointCount or props.Points and #props.Points or 0

	React.useLayoutEffect(function()
		local v2

		if props.ObservePoints then
			local observePoints = props.ObservePoints
			v2 = Signals.createComputed(function(p)
				v.viewportRectGetter(p)
				return curvePointsToControlPoints(v, observePoints(p))
			end)
		else
			local points = props.Points or {}
			v2 = Signals.createComputed(function(p)
				v.viewportRectGetter(p)
				return curvePointsToControlPoints(v, points)
			end)
		end

		return Signals.createEffect(function(p)
			local v3 = v2(p)
			local thickness

			if props.ObserveThickness then
				thickness = props.ObserveThickness(p)
			end

			local v4 = current.get(p)

			if v4 then
				applyControlPoints(v4, v3, maxPointsPerPath)

				if thickness then
					for _, child in v4:GetChildren() do
						child.Thickness = thickness
					end
				end
			end
		end)
	end, { v, props.ObservePoints, props.Points, props.ObserveThickness })

	if not useViewportVisibility(function(p)
		local points = props.Points

		if not points or #points == 0 then
			return true
		end

		local v2 = 1e999
		local v3 = 1e999
		local v4 = -1e999
		local v5 = -1e999

		for _, point in points do
			local v6 = { point.Position }

			if point.LeftTangent then
				table.insert(v6, point.Position + point.LeftTangent)
			end

			if point.RightTangent then
				table.insert(v6, point.Position + point.RightTangent)
			end

			for _, v7 in v6 do
				if v7.X < v2 then
					v2 = v7.X
				end

				if v7.Y < v3 then
					v3 = v7.Y
				end

				if v4 < v7.X then
					v4 = v7.X
				end

				if v5 < v7.Y then
					v5 = v7.Y
				end
			end
		end

		return p.isRectInViewport(Rect.new(v2, v3, v4, v5))
	end, { props.Points }) then
		return nil
	end

	local tag = props.Tag or ""
	local v2 = not (props.ClipContents == nil) and props.ClipContents
	local v3 = 1
	local children = {}

	for _ = 2, pointCount, maxPointsPerPath - 1 do
		local v4 = tostring(v3)
		children[v4] = React.createElement("Path2D", {
			Color3 = props.Color3 or StyleUtil.CURVE_COLOR3,
			Thickness = props.Thickness or StyleUtil.CURVE_THICKNESS,
			ZIndex = props.ZIndex,
			[React.Tag] = tag
		})

		v3 += 1
	end

	return React.createElement(v2 and "CanvasGroup" or "Frame", {
		ref = current.set,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex
	}, children)
end

return Curve
