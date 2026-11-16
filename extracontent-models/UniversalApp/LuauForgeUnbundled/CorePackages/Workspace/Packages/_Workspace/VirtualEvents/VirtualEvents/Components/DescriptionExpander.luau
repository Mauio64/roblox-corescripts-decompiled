local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/AppCommonLib").Text
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Style").GetTextSize
local useAnimation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Hooks/useAnimation")

local text2 = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local function DescriptionExpander(props)
	local v5 = useTokens()
	local bodyLarge = v5.Typography.BodyLarge

	local state, setState = React.useState(0)
	local function updateDescriptionHeight(p2, description)
		local v6 = if foundationFontFaceMigration then getTextSize(
			description,
			bodyLarge.FontSize,
			bodyLarge.Font,
			Vector2.new(p2, 1e999)
		).Y else text.GetTextHeight(description, bodyLarge.Font, bodyLarge.FontSize, p2)
		setState(v6)
	end

	local v6 = React.useCallback(function(p2)
		updateDescriptionHeight(p2.AbsoluteSize.X, props.description)
	end, { props.description })

	React.useEffect(function()
		updateDescriptionHeight(props.width, props.description)
	end, { props.description, props.width })

	local v7 = props.isExpanded and math.min(state, props.maxHeight) or math.min(state, 40)
	local state2, setState2 = React.useState(v7)

	useAnimation({
		startOffset = state2,
		endOffset = v7,
		duration = 0.1,
		easingStyle = "quadratic",
		setAnimationOffset = setState2
	})

	local element = React.createElement("ScrollingFrame", {
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, v7),
		CanvasSize = UDim2.new(0, 0, 0, state + 2),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = props.maxHeight + 10 < state,
		ScrollBarThickness = 0
	}, {
		Text = React.createElement(text2, {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = props.description,
			TextTruncate = Enum.TextTruncate.None,
			RichText = true,
			textStyle = v5.Color.Content.Emphasis,
			fontStyle = {
				Font = bodyLarge.Font,
				FontSize = bodyLarge.FontSize,
				LineHeight = 1
			},
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true
		})
	})

	local v9 = React.createElement("TextButton", {
		ZIndex = 2,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v7),
		Position = UDim2.fromScale(0, 0),
		Text = "",
		Active = state > 50,
		AutoButtonColor = false,
		AutomaticSize = Enum.AutomaticSize.None,
		[React.Event.Activated] = function()
			props.setIsExpanded(true)
		end
	}, {
		Text = React.createElement(text2, {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = props.description,
			TextTruncate = Enum.TextTruncate.AtEnd,
			RichText = true,
			textStyle = v5.Color.Content.Emphasis,
			fontStyle = {
				Font = bodyLarge.Font,
				FontSize = bodyLarge.FontSize,
				LineHeight = 1
			},
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true
		})
	})

	local createElement2 = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, state2),
		[React.Change.AbsoluteSize] = function(p2)
			v6(p2)
		end
	}

	if props.isExpanded then
		v9 = element
	end

	return createElement2("Frame", v11, { Description = v9 })
end

return DescriptionExpander
