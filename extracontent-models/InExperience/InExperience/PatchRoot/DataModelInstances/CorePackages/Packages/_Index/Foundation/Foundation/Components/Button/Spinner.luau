local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)

local Motion = require(parent.Motion)
local useMotion = Motion.useMotion
local usePresence = Motion.usePresence

local useSpinnerMotionStates = require(script.Parent.useSpinnerMotionStates)

local Flags = require(Foundation.Utility.Flags)
local Image = require(Foundation.Components.Image)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useRotation = require(Foundation.Utility.useRotation)
local withDefaults = require(Foundation.Utility.withDefaults)

local function IconSpinner(props)
	local rotation = useRotation(2)

	return React.createElement(Image, {
		Image = "icons/status/loading_large",
		imageStyle = props.style,
		Rotation = rotation,
		tag = "position-center-center anchor-center-center size-full-full",
		testId = props.testId
	}, {
		UIScale = React.createElement("UIScale", { Scale = props.scale })
	})
end

local v = {
	Path2DControlPoint.new(UDim2.fromScale(1, 0.5), UDim2.fromScale(0, 0.25), UDim2.fromScale(0, -0.25)),
	Path2DControlPoint.new(UDim2.fromScale(0.5, 0), UDim2.fromScale(0.25, 0), UDim2.fromScale(-0.25, 0)),
	Path2DControlPoint.new(UDim2.fromScale(0, 0.5), UDim2.fromScale(0, -0.33), UDim2.fromScale(0, 0.33)),
	Path2DControlPoint.new(UDim2.fromScale(0.5, 1), UDim2.fromScale(-0.25, 0), UDim2.fromScale(0.25, 0))
}

local function Path2DSpinner(props)
	local ref = React.useRef(nil)
	local rotation = useRotation(2)

	React.useEffect(function()
		local current = ref.current

		if current ~= nil then
			current:SetControlPoints(v)
		end
	end, {})

	local createElement = React.createElement
	local v2 = {
		tag = "position-center-center anchor-center-center size-full",
		Rotation = rotation,
		testId = props.testId
	}

	local createElement2 = React.createElement
	local v3 = {
		ref = ref,
		Closed = false,
		Color3 = props.style:map(function(p)
			return p.Color3
		end),
		Transparency = 0,
		Thickness = 0
	}
	local transparency

	if isPluginSecurity() then
		transparency = props.style:map(function(p)
			return p.Transparency
		end)
	end

	v3.Transparency = transparency

	v3.Thickness = props.Thickness
	return createElement(View, v2, {
		Circle = createElement2("Path2D", v3),
		UIScale = React.createElement("UIScale", { Scale = props.scale })
	})
end

local v2 = { style = {} }

local function Spinner(p, ref)
	local v3 = withDefaults(p, v2)

	local v4 = useSpinnerMotionStates()
	local v5, v6 = useMotion(v4.Default)
	local v7 = usePresence()

	React.useEffect(function()
		if v7.isPresent then
			v6(v4.Loading)
		else
			v6(v4.Default, { onAnimationComplete = v7.onExitComplete })
		end
	end, { v7.isPresent })

	local createElement = React.createElement
	local v8 = { tag = "position-center-center anchor-center-center", Size = v3.Size, ref = ref }

	local createElement2 = React.createElement
	local v9

	if Flags.FoundationUsePath2DSpinner then
		v9 = Path2DSpinner
	else
		v9 = IconSpinner
	end

	return createElement(View, v8, {
		Spinner = createElement2(v9, {
			scale = v5.scale,
			style = React.joinBindings({ style = v3.style, transparency = v5.transparency }):map(function(p2)
				return {
					Color3 = p2.style.Color3,
					Transparency = p2.style.Transparency + p2.transparency / 2
				}
			end),
			Thickness = math.max(math.floor(v3.Size.X.Offset / 8), 1),
			testId = v3.testId
		})
	})
end

return React.memo(React.forwardRef(Spinner))
