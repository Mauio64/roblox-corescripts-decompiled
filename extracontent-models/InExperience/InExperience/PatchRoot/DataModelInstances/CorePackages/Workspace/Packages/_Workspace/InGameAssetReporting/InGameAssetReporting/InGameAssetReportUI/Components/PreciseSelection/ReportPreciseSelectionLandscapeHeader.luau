local Parent = script:FindFirstAncestor("InGameAssetReporting").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local function renderHeaderBarCenter(p1) -- line: 32
	-- upvalues: withStyle (copy), React (copy)
	return function() -- line: 33
		-- upvalues: withStyle (copy), React (copy), p1 (copy)
		return withStyle(function(p2) -- line: 34
			-- upvalues: React (copy), p1 (copy)
			local Theme = p2.Theme
			local p2Font = p2.Font

			return React.createElement("TextLabel", {
				TextSize = 20,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = p1,
				Font = p2Font.Header2.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0)
			})
		end)
	end
end
local function renderHeaderBarLeft(p3) -- line: 54
	-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy)
	return function() -- line: 55
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), p3 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			BackButton = React.createElement(IconButton, {
				layoutOrder = 1,
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/pushBack"],
				onActivated = p3
			})
		})
	end
end
local function renderHeaderBarRight(p4, p5, p6, p7, p8, p9) -- line: 76
	-- upvalues: React (copy), Foundation (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	return function() -- line: 84
		-- upvalues: React (copy), Foundation (copy), p6 (copy), p7 (copy), p8 (copy), p9 (copy), Button (copy), ButtonVariant (copy), InputSize (copy), p4 (copy), p5 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 144, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			CoachmarkWrapper = React.createElement(Foundation.Coachmark, {
				title = p6,
				text = p7,
				isOpen = p8 or false,
				side = Foundation.Enums.PopoverSide.Bottom,
				align = Foundation.Enums.PopoverAlign.End,
				onClose = p9
			}, {
				NextButton = React.createElement(Button, {
					variant = ButtonVariant.Emphasis,
					inputSize = InputSize.Large,
					onActivated = p4,
					text = p5,
					width = UDim.new(0, 144)
				})
			})
		})
	end
end
local function LandscapeModeHeader(t1: {[any]: any}) -- line: 114
	-- upvalues: React (copy), HeaderBar (copy), IconButton (copy), IconSize (copy), Images (copy), Foundation (copy), Button (copy), ButtonVariant (copy), InputSize (copy), withStyle (copy)
	local createElement = React.createElement
	local t2 = {
		BorderSizePixel = 0,
		BackgroundTransparency = 0.1,
		LayoutOrder = 1,
		ZIndex = 2,
		BackgroundColor3 = Color3.fromHex("#000000"),
		Size = UDim2.new(1, 0, 0, 71)
	}
	local t3 = {}
	local createElement2 = React.createElement
	local v30 = HeaderBar
	local t4 = {
		backgroundTransparency = 1,
		barHeight = 72
	}
	local backAction = t1.backAction

	function t4.renderLeft() -- line: 55
		-- upvalues: React (copy), IconButton (copy), IconSize (copy), Images (copy), backAction (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			BackButton = React.createElement(IconButton, {
				layoutOrder = 1,
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/pushBack"],
				onActivated = backAction
			})
		})
	end

	local nextAction = t1.nextAction
	local nextText = t1.nextText
	local coachmarkTitle = t1.coachmarkTitle
	local coachmarkText = t1.coachmarkText
	local isCoachmarkOpen = t1.isCoachmarkOpen
	local onCoachmarkClose = t1.onCoachmarkClose

	function t4.renderRight() -- line: 84
		-- upvalues: React (copy), Foundation (copy), coachmarkTitle (copy), coachmarkText (copy), isCoachmarkOpen (copy), onCoachmarkClose (copy), Button (copy), ButtonVariant (copy), InputSize (copy), nextAction (copy), nextText (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 144, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			CoachmarkWrapper = React.createElement(Foundation.Coachmark, {
				title = coachmarkTitle,
				text = coachmarkText,
				isOpen = isCoachmarkOpen or false,
				side = Foundation.Enums.PopoverSide.Bottom,
				align = Foundation.Enums.PopoverAlign.End,
				onClose = onCoachmarkClose
			}, {
				NextButton = React.createElement(Button, {
					variant = ButtonVariant.Emphasis,
					inputSize = InputSize.Large,
					onActivated = nextAction,
					text = nextText,
					width = UDim.new(0, 144)
				})
			})
		})
	end

	local titleText = t1.titleText

	function t4.renderCenter() -- line: 33
		-- upvalues: withStyle (copy), React (copy), titleText (copy)
		return withStyle(function(p10) -- line: 34
			-- upvalues: React (copy), titleText (copy)
			local Theme = p10.Theme
			local p10Font = p10.Font

			return React.createElement("TextLabel", {
				TextSize = 20,
				TextWrapped = true,
				BackgroundTransparency = 1,
				Text = titleText,
				Font = p10Font.Header2.Font,
				TextColor3 = Theme.TextEmphasis.Color,
				TextTransparency = Theme.TextEmphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0)
			})
		end)
	end

	t3.Bar = createElement2(v30, t4)

	return createElement("Frame", t2, t3)
end

return LandscapeModeHeader
