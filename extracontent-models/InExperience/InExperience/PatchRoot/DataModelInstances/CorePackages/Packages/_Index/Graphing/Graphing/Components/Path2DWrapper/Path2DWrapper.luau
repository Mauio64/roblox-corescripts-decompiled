local parent = script:FindFirstAncestor("Graphing").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)

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

function Path2DWrapper(props)
	local ref = React.useRef(nil)
	local maxPointsPerPath = getMaxPointsPerPath() -- inferred equivalent call
	local pointCount = props.PointCount or props.ControlPoints and #props.ControlPoints or 0

	local function applyControlPoints(list)
		local current = ref.current

		if not current then
			return
		end

		local total = 1

		for _, child in current:GetChildren() do
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

	React.useLayoutEffect(function()
		if props.ObserveControlPoints then
			local observeControlPoints = props.ObserveControlPoints
			return Signals.createEffect(function(p)
				applyControlPoints(observeControlPoints(p))
			end)
		end

		if props.ControlPoints then
			applyControlPoints(props.ControlPoints)
		end

		return function() end
	end, { props.ObserveControlPoints, props.ControlPoints })

	local tag = props.Tag or ""
	local v = props.ClipContents == nil or props.ClipContents
	local v2 = 1
	local children = {}

	for _ = 2, pointCount, maxPointsPerPath - 1 do
		local v3 = tostring(v2)
		children[v3] = React.createElement("Path2D", {
			Color3 = props.Color3,
			Thickness = props.Thickness,
			ZIndex = props.ZIndex,
			[React.Tag] = tag
		})

		v2 += 1
	end

	return React.createElement(v and "CanvasGroup" or "Frame", {
		ref = ref,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex
	}, children)
end

return Path2DWrapper
