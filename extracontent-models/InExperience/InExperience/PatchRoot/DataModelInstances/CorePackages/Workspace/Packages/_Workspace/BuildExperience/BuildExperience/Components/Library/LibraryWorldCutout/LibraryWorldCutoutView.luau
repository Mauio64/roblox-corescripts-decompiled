local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local Radius = Foundation.Enums.Radius

local isTapRelease = require(script.Parent.isTapRelease)

local udim = UDim2.new(1, 0, 0, 100000)
local aspectRatio = {
	AspectRatio = 16 / 9,
	DominantAxis = Enum.DominantAxis.Width
}

local function useScreenHeight(state)
	local state2, setState = React.useState(0)
	React.useEffect(function()
		local layerCollector

		if state == nil then
			layerCollector = nil
		else
			layerCollector = state:FindFirstAncestorWhichIsA("LayerCollector")
		end

		if layerCollector == nil then
			return nil
		end

		setState(layerCollector.AbsoluteSize.Y)
		local absoluteSizeChangedConnection = layerCollector:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			setState(layerCollector.AbsoluteSize.Y)
		end)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { state })
	return state2
end

local function LibraryWorldCutoutView(props)
	local v = Foundation.Hooks.useTokens()
	local udim2 = UDim.new(0, props.inset)
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local v2 = useScreenHeight(state)

	local v3 = not (v2 > 0) and 800 or math.min(800, (math.floor(v2 * 0.5 * 16 / 9)))

	local onActivated = props.onActivated
	local onActivated2 = React.useCallback(function(_, p)
		local current = ref.current
		ref.current = nil

		if isTapRelease(current, p) then
			onActivated()
		end
	end, { onActivated })
	local v4 = React.useCallback(function(_, p)
		if p.UserInputType == Enum.UserInputType.Touch or p.UserInputType == Enum.UserInputType.MouseButton1 then
			ref.current = p.Position
		end
	end, {})
	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-large size-full-0 auto-y",
		testId = "Library.WorldCutout"
	}

	local createElement2 = React.createElement
	local title

	if props.isLoading then
		title = React.createElement(Skeleton, {
			Size = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_600),
			radius = Radius.Small,
			testId = "Library.WorldCutout.TitleSkeleton"
		})
	else
		title = React.createElement(Text, {
			Text = props.title,
			tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
			testId = "Library.WorldCutout.Title"
		})
	end

	local children = {
		Header = createElement2(View, {
			LayoutOrder = 1,
			padding = { left = udim2, right = udim2 },
			tag = "row align-y-center size-full-600",
			testId = "Library.WorldCutout.Header"
		}, { Title = title }),
		Cell = 0
	}

	local createElement3 = React.createElement
	local v6 = {
		LayoutOrder = 2,
		padding = { left = udim2, right = udim2 },
		ref = setState,
		sizeConstraint = {
			MaxSize = Vector2.new(v3 + 2 * props.inset, 1e999)
		},
		tag = "size-full-0 auto-y"
	}
	local window

	if props.isLoading then
		window = React.createElement(
			View,
			{ Size = udim, aspectRatio = aspectRatio, testId = "Library.WorldCutout.Skeleton" },
			{
				Skeleton = React.createElement(Skeleton, { radius = Radius.Medium })
			}
		)
	else
		window = React.createElement(View, {
			Size = udim,
			aspectRatio = aspectRatio,
			backgroundStyle = { Transparency = 1 },
			onActivated = onActivated2,
			selection = { Selectable = true },
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			ref = props.onRectChanged,
			onAbsolutePositionChanged = props.onRectChanged,
			onAbsoluteSizeChanged = props.onRectChanged,
			tag = "radius-medium",
			testId = "Library.WorldCutout.Window"
		}, {
			PressTracker = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				[React.Event.InputBegan] = v4
			})
		})
	end

	children.Cell = createElement3(View, v6, { Window = window })
	return createElement(View, v5, children)
end

return LibraryWorldCutoutView
