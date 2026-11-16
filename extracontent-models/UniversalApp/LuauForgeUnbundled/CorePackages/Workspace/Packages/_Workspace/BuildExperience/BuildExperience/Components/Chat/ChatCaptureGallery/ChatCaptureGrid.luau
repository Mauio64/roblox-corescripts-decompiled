local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local CaptureGridItem = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MediaSelectionPage/CaptureGridItem")

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local udim = UDim2.new(0.25, -3, 0, 1)

local function renderTile(p2, p3)
	return React.createElement(view, {
		LayoutOrder = p2,
		Size = udim,
		testId = `ChatCaptureGrid.Tile.{p2}`,
		aspectRatio = {
			AspectRatio = 1,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Width
		}
	}, { Content = p3 })
end

local function renderEmptyState(p2)
	return React.createElement(text, {
		LayoutOrder = 1,
		Text = p2,
		tag = "size-full-0 auto-y text-body-medium text-align-x-center content-muted"
	})
end

local function ChatCaptureGrid(props)
	local state, setState = React.useState(function()
		if props.shouldProgressivelyLoad then
			return 0
		end

		return #props.captures
	end)

	local ref = React.useRef(state)

	React.useEffect(function()
		if props.isLoading then
			ref.current = 0
			setState(0)
		elseif props.shouldProgressivelyLoad then
			local flag = false
			task.spawn(function()
				task.wait(0.3)

				for i = ref.current + 1, #props.captures do
					task.wait()

					if flag then
						break
					end

					ref.current = i
					setState(i)
				end
			end)

			return function()
				flag = true
			end
		else
			ref.current = #props.captures
			setState(#props.captures)
		end
	end, { props.isLoading, props.shouldProgressivelyLoad, #props.captures })

	local v5 = {}

	if props.isLoading then
		for i = 1, 8 do
			v5[`Placeholder-{i}`] = renderTile(
				i,
				React.createElement(view, {
					tag = "size-full radius-medium bg-shift-200",
					testId = `ChatCaptureGrid.Placeholder.{i}`
				})
			)
		end
	else
		for k, capture in props.captures do
			v5[`Capture-{k}`] = renderTile(k, React.createElement(CaptureGridItem, {
				capture = capture,
				imageContentEnabled = k <= state,
				isSelected = props.isSelected(capture),
				onActivated = props.onCaptureToggled,
				testId = `ChatCaptureGrid.Capture.{k}`
			}))
		end
	end

	local createElement = React.createElement
	local v9

	if #props.captures == 0 and not props.isLoading then
		local emptyText = props.emptyText
		v9 = React.createElement(text, {
			LayoutOrder = 1,
			Text = emptyText,
			tag = "size-full-0 auto-y text-body-medium text-align-x-center content-muted"
		})
	end

	local v10 = if #props.captures > 0 or props.isLoading then React.createElement(
		view,
		{ LayoutOrder = 1, tag = "row wrap gap-xsmall size-full-0 auto-y" },
		{
			Captures = React.createElement(React.Fragment, nil, v5)
		}
	) else nil

	local v11 = if not (props.isFinished or props.isLoading) then React.createElement(button, {
		LayoutOrder = 2,
		fillBehavior = fillBehavior.Fill,
		onActivated = props.onShowMore,
		size = inputSize.Medium,
		text = props.showMoreText,
		variant = buttonVariant.Standard,
		testId = "ChatCaptureGrid.ShowMore"
	}) else nil
	return createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, {
		EmptyState = v9,
		Grid = v10,
		ShowMore = v11
	})
end

return React.memo(ChatCaptureGrid)
