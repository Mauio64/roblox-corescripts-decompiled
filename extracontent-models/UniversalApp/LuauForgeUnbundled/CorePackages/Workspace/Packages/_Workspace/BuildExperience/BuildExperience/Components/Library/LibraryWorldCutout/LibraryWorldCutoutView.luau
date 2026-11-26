local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local radius = Foundation.Enums.Radius

local isTapRelease = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryWorldCutout/isTapRelease")

local udim = UDim2.new(1, 0, 0, 100000)
local v5 = {
	AspectRatio = 16 / 9,
	DominantAxis = Enum.DominantAxis.Width
}

local function useScreenHeight(state)
	local state2, setState = React.useState(0)
	React.useEffect(function()
		local layerCollector = if state ~= nil then state:FindFirstAncestorWhichIsA("LayerCollector") else nil

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
	local v6 = Foundation.Hooks.useTokens()
	local udim2 = UDim.new(0, props.inset)
	local ref = React.useRef(nil)
	local state, setState = React.useState(nil)
	local v7 = useScreenHeight(state)

	local v8 = not (v7 > 0) and 800 or math.min(800, (math.floor(v7 * 0.5 * 16 / 9)))

	local onActivated = props.onActivated
	local v9 = React.useCallback(function(p2, p3)
		local current = ref.current
		ref.current = nil

		if isTapRelease(current, p3) then
			onActivated()
		end
	end, { onActivated })
	local v10 = React.useCallback(function(p2, p3)
		if
			p3.UserInputType == Enum.UserInputType.Touch
			or p3.UserInputType == Enum.UserInputType.MouseButton1
		then
			ref.current = p3.Position
		end
	end, {})
	local createElement = React.createElement
	local v12 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col gap-large size-full-0 auto-y",
		testId = "Library.WorldCutout"
	}

	local createElement2 = React.createElement

	local v16 = if props.isLoading then React.createElement(skeleton, {
		Size = UDim2.fromOffset(v6.Size.Size_2800, v6.Size.Size_600),
		radius = radius.Small,
		testId = "Library.WorldCutout.TitleSkeleton"
	}) else React.createElement(text, {
		Text = props.title,
		tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
		testId = "Library.WorldCutout.Title"
	})
	local children = {
		Header = createElement2(view, {
			LayoutOrder = 1,
			padding = { left = udim2, right = udim2 },
			tag = "row align-y-center size-full-600",
			testId = "Library.WorldCutout.Header"
		}, { Title = v16 }),
		Cell = 0
	}

	local createElement3 = React.createElement
	local v18 = {
		LayoutOrder = 2,
		padding = { left = udim2, right = udim2 },
		ref = setState,
		sizeConstraint = {
			MaxSize = Vector2.new(v8 + 2 * props.inset, 1e999)
		},
		tag = "size-full-0 auto-y"
	}
	local v20

	if props.isLoading then
		v20 = React.createElement(
			view,
			{ Size = udim, aspectRatio = v5, testId = "Library.WorldCutout.Skeleton" },
			{
				Skeleton = React.createElement(skeleton, { radius = radius.Medium })
			}
		)
	else
		v20 = React.createElement(view, {
			Size = udim,
			aspectRatio = v5,
			backgroundStyle = { Transparency = 1 },
			onActivated = v9,
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
				[React.Event.InputBegan] = v10
			})
		})
	end

	children.Cell = createElement3(view, v18, { Window = v20 })
	return createElement(view, v12, children)
end

return LibraryWorldCutoutView
