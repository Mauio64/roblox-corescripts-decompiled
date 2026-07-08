local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)
local Text = require(VirtualEvents.Parent.AppCommonLib).Text
local useAnimation = require(VirtualEvents.Hooks.useAnimation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens

local function DescriptionExpander(t1: {[any]: any}) -- line: 22
	-- upvalues: useTokens (copy), React (copy), Text (copy), useAnimation (copy), FoundationText (copy)
	local v10 = useTokens()
	local BodyLarge = v10.Typography.BodyLarge
	local v12, v13 = React.useState(0)

	local function updateDescriptionHeight(p1, p2) -- line: 27
		-- upvalues: Text (copy), BodyLarge (copy), v13 (copy)
		local v23 = Text.GetTextHeight(p2, BodyLarge.Font, BodyLarge.FontSize, p1)

		v13(v23)
	end

	local v15 = React.useCallback(function(p3) -- line: 32
		-- upvalues: t1 (copy), Text (copy), BodyLarge (copy), v13 (copy)
		local AbsoluteSizeX = p3.AbsoluteSize.X
		local description = t1.description
		local v27 = Text.GetTextHeight(description, BodyLarge.Font, BodyLarge.FontSize, AbsoluteSizeX)

		v13(v27)
	end, { t1.description })

	React.useEffect(function() -- line: 36
		-- upvalues: t1 (copy), Text (copy), BodyLarge (copy), v13 (copy)
		local width = t1.width
		local description = t1.description
		local v30 = Text.GetTextHeight(description, BodyLarge.Font, BodyLarge.FontSize, width)

		v13(v30)
	end, {
		t1.description,
		t1.width
	})

	local v16 = t1.isExpanded and math.min(v12, t1.maxHeight) or math.min(v12, 40)
	local v17, v18 = React.useState(v16)

	useAnimation({
		duration = 0.1,
		easingStyle = "quadratic",
		startOffset = v17,
		endOffset = v16,
		setAnimationOffset = v18
	})

	local v19 = React.createElement("ScrollingFrame", {
		ZIndex = 2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		Size = UDim2.new(1, 0, 0, v16),
		CanvasSize = UDim2.new(0, 0, 0, v12 + 2),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollingEnabled = v12 > t1.maxHeight + 10
	}, {
		Text = React.createElement(FoundationText, {
			RichText = true,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t1.description,
			TextTruncate = Enum.TextTruncate.None,
			textStyle = v10.Color.Content.Emphasis,
			fontStyle = {
				LineHeight = 1,
				Font = BodyLarge.Font,
				FontSize = BodyLarge.FontSize
			},
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
	local v20 = React.createElement("TextButton", {
		ZIndex = 2,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v16),
		Position = UDim2.fromScale(0, 0),
		Text = "",
		Active = v12 > 50,
		AutoButtonColor = false,
		AutomaticSize = Enum.AutomaticSize.None,
		[React.Event.Activated] = function() -- line: 89
			-- upvalues: t1 (copy)
			t1.setIsExpanded(true)
		end
	}, {
		Text = React.createElement(FoundationText, {
			BackgroundTransparency = 1,
			RichText = true,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = t1.description,
			TextTruncate = Enum.TextTruncate.AtEnd,
			textStyle = v10.Color.Content.Emphasis,
			fontStyle = {
				LineHeight = 1,
				Font = BodyLarge.Font,
				FontSize = BodyLarge.FontSize
			},
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})

	return React.createElement("Frame", {
		LayoutOrder = t1.layoutOrder,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v17),
		[React.Change.AbsoluteSize] = function(p4) -- line: 115
			-- upvalues: v15 (copy)
			v15(p4)
		end
	}, {
		Description = if not t1.isExpanded then v20 else v19
	})
end

return DescriptionExpander
