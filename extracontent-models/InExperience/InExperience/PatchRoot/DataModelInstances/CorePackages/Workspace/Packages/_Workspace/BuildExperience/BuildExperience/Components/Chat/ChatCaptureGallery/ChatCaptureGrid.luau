local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local CaptureGridItem = require(BuildExperience.Components.MediaSelectionPage.CaptureGridItem)

local Button = Foundation.Button
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local udim = UDim2.new(0.25, -3, 0, 1)

local function renderTile(layoutOrder: number, content)
	return React.createElement(View, {
		LayoutOrder = layoutOrder,
		Size = udim,
		testId = `ChatCaptureGrid.Tile.{layoutOrder}`,
		aspectRatio = {
			AspectRatio = 1,
			AspectType = Enum.AspectType.ScaleWithParentSize,
			DominantAxis = Enum.DominantAxis.Width
		}
	}, { Content = content })
end

local function renderEmptyState(emptyText: string) -- 1 equivalent call inferred from this helper
	return React.createElement(Text, {
		LayoutOrder = 1,
		Text = emptyText,
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

	local v = {}

	if props.isLoading then
		for i = 1, 8 do
			v[`Placeholder-{i}`] = renderTile(
				i,
				React.createElement(View, {
					tag = "size-full radius-medium bg-shift-200",
					testId = `ChatCaptureGrid.Placeholder.{i}`
				})
			)
		end
	else
		for k, capture in props.captures do
			v[`Capture-{k}`] = renderTile(k, React.createElement(CaptureGridItem, {
				capture = capture,
				imageContentEnabled = k <= state,
				isSelected = props.isSelected(capture),
				onActivated = props.onCaptureToggled,
				testId = `ChatCaptureGrid.Capture.{k}`
			}))
		end
	end

	local createElement = React.createElement
	local emptyState

	if #props.captures == 0 and not props.isLoading then
		emptyState = renderEmptyState(props.emptyText) -- inferred equivalent call
	end

	local grid

	if #props.captures > 0 or props.isLoading then
		grid = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row wrap gap-xsmall size-full-0 auto-y"
		}, {
			Captures = React.createElement(React.Fragment, nil, v)
		})
	end

	local showMore

	if not (props.isFinished or props.isLoading) then
		showMore = React.createElement(Button, {
			LayoutOrder = 2,
			fillBehavior = FillBehavior.Fill,
			onActivated = props.onShowMore,
			size = InputSize.Medium,
			text = props.showMoreText,
			variant = ButtonVariant.Standard,
			testId = "ChatCaptureGrid.ShowMore"
		})
	end

	return createElement(View, { tag = "col gap-medium size-full-0 auto-y" }, {
		EmptyState = emptyState,
		Grid = grid,
		ShowMore = showMore
	})
end

return React.memo(ChatCaptureGrid)
