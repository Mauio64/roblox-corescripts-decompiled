local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local isPluginSecurity = require(Foundation.Utility.isPluginSecurity)
local Motion = require(FoundationParent.Motion)
local useMotion = Motion.useMotion
local usePresence = Motion.usePresence
local useSpinnerMotionStates = require(script.Parent.useSpinnerMotionStates)
local Flags = require(Foundation.Utility.Flags)
local Image = require(Foundation.Components.Image)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useRotation = require(Foundation.Utility.useRotation)
local withDefaults = require(Foundation.Utility.withDefaults)

local function IconSpinner(t1: {[any]: any}) -- line: 26
	-- upvalues: useRotation (copy), React (copy), Image (copy)
	local v20 = useRotation(2)

	return React.createElement(Image, {
		Image = "icons/status/loading_large",
		tag = "position-center-center anchor-center-center size-full-full",
		imageStyle = t1.style,
		Rotation = v20,
		testId = t1.testId
	}, {
		UIScale = React.createElement("UIScale", {
			Scale = t1.scale
		})
	})
end

local t2 = {
	Path2DControlPoint.new(UDim2.fromScale(1, 0.5), UDim2.fromScale(0, 0.25), UDim2.fromScale(0, -0.25)),
	Path2DControlPoint.new(UDim2.fromScale(0.5, 0), UDim2.fromScale(0.25, 0), UDim2.fromScale(-0.25, 0)),
	Path2DControlPoint.new(UDim2.fromScale(0, 0.5), UDim2.fromScale(0, -0.33), UDim2.fromScale(0, 0.33)),
	Path2DControlPoint.new(UDim2.fromScale(0.5, 1), UDim2.fromScale(-0.25, 0), UDim2.fromScale(0.25, 0))
}

local function Path2DSpinner(t3: {[any]: any}) -- line: 50
	-- upvalues: React (copy), useRotation (copy), t2 (copy), View (copy), isPluginSecurity (copy)
	local v22 = React.useRef(nil)
	local v23 = useRotation(2)

	React.useEffect(function() -- line: 54
		-- upvalues: v22 (copy), t2 (copy)
		local current = v22.current

		if current ~= nil then
			current:SetControlPoints(t2)
		end
	end, {})

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full",
		Rotation = v23,
		testId = t3.testId
	}, {
		Circle = React.createElement("Path2D", {
			Closed = false,
			ref = v22,
			Color3 = t3.style:map(function(p1) -- line: 69
				return p1.Color3
			end),
			Transparency = if not isPluginSecurity() then nil else t3.style:map(function(p2) -- line: 73
				return p2.Transparency
			end),
			Thickness = t3.Thickness
		}),
		UIScale = React.createElement("UIScale", {
			Scale = t3.scale
		})
	})
end

local t4 = {
	style = {}
}

local function Spinner(t5: {[any]: any}, p3) -- line: 95
	-- upvalues: withDefaults (copy), t4 (copy), useSpinnerMotionStates (copy), useMotion (copy), usePresence (copy), React (copy), View (copy), Flags (copy), Path2DSpinner (copy), IconSpinner (copy)
	local v26 = withDefaults(t5, t4)
	local v27 = useSpinnerMotionStates()
	local v28, v29 = useMotion(v27.Default)
	local v30 = usePresence()

	React.useEffect(function() -- line: 102
		-- upvalues: v30 (copy), v29 (copy), v27 (copy)
		if v30.isPresent then
			v29(v27.Loading)

			return
		end

		v29(v27.Default, {
			onAnimationComplete = v30.onExitComplete
		})
	end, { v30.isPresent })

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center",
		Size = v26.Size,
		ref = p3
	}, {
		Spinner = React.createElement(if not Flags.FoundationUsePath2DSpinner then IconSpinner else Path2DSpinner, {
			scale = v28.scale,
			style = React.joinBindings({
				style = v26.style,
				transparency = v28.transparency
			}):map(function(p4) -- line: 122
				return {
					Color3 = p4.style.Color3,
					Transparency = p4.style.Transparency + p4.transparency / 2
				}
			end),
			Thickness = math.max(math.floor(v26.Size.X.Offset / 8), 1),
			testId = v26.testId
		})
	})
end

return React.memo(React.forwardRef(Spinner))
