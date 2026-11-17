local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)
local Style = require(VirtualEvents.Parent.Style)
local GetTextSize = Style.GetTextSize
local useAnimation = require(VirtualEvents.Hooks.useAnimation)

local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function DescriptionExpander(props)
	local v = useTokens()
	local bodyLarge = v.Typography.BodyLarge

	local state, setState = React.useState(0)
	local function updateDescriptionHeight(p, description) -- 2 equivalent calls inferred from this helper
		setState(GetTextSize(description, bodyLarge.FontSize, bodyLarge.Font, Vector2.new(p, 1e999)).Y)
	end

	local v2 = React.useCallback(function(p)
		updateDescriptionHeight(p.AbsoluteSize.X, props.description) -- inferred equivalent call
	end, { props.description })

	React.useEffect(function()
		updateDescriptionHeight(props.width, props.description) -- inferred equivalent call
	end, { props.description, props.width })

	local endOffset = props.isExpanded and math.min(state, props.maxHeight) or math.min(state, 40)
	local state2, setState2 = React.useState(endOffset)

	useAnimation({
		startOffset = state2,
		endOffset = endOffset,
		duration = 0.1,
		easingStyle = "quadratic",
		setAnimationOffset = setState2
	})

	local element = React.createElement("ScrollingFrame", {
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, endOffset),
		CanvasSize = UDim2.new(0, 0, 0, state + 2),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = props.maxHeight + 10 < state,
		ScrollBarThickness = 0
	}, {
		Text = React.createElement(Text, {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = props.description,
			TextTruncate = Enum.TextTruncate.None,
			RichText = true,
			textStyle = v.Color.Content.Emphasis,
			fontStyle = { Font = bodyLarge.Font, FontSize = bodyLarge.FontSize, LineHeight = 1 },
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true
		})
	})

	local description = React.createElement("TextButton", {
		ZIndex = 2,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, endOffset),
		Position = UDim2.fromScale(0, 0),
		Text = "",
		Active = state > 50,
		AutoButtonColor = false,
		AutomaticSize = Enum.AutomaticSize.None,
		[React.Event.Activated] = function()
			props.setIsExpanded(true)
		end
	}, {
		Text = React.createElement(Text, {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = props.description,
			TextTruncate = Enum.TextTruncate.AtEnd,
			RichText = true,
			textStyle = v.Color.Content.Emphasis,
			fontStyle = { Font = bodyLarge.Font, FontSize = bodyLarge.FontSize, LineHeight = 1 },
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true
		})
	})

	local createElement = React.createElement
	local v3 = {
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, state2),
		[React.Change.AbsoluteSize] = function(p)
			v2(p)
		end
	}

	if props.isExpanded then
		description = element
	end

	return createElement("Frame", v3, { Description = description })
end

return DescriptionExpander
