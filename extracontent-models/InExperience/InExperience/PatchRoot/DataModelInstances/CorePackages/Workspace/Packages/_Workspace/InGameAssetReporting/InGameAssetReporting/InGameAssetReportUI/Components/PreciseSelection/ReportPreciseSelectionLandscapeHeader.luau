local parent = script:FindFirstAncestor("InGameAssetReporting").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local function renderHeaderBarCenter(titleText) -- 1 equivalent call inferred from this helper
	return function()
		return withStyle(function(p)
			local theme = p.Theme

			return React.createElement("TextLabel", {
				Text = titleText,
				FontFace = normalizeFontFace(p.Tokens.Typography.TitleLarge.Font),
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency,
				TextSize = 20,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			})
		end)
	end
end

local function renderHeaderBarLeft(onActivated) -- 1 equivalent call inferred from this helper
	return function()
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
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/pushBack"],
				layoutOrder = 1,
				onActivated = onActivated
			})
		})
	end
end

local function renderHeaderBarRight(onActivated, nextText, coachmarkTitle, coachmarkText, isCoachmarkOpen, onClose) -- 1 equivalent call inferred from this helper
	return function()
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
				onClose = onClose
			}, {
				NextButton = React.createElement(Button, {
					variant = ButtonVariant.Emphasis,
					inputSize = InputSize.Large,
					onActivated = onActivated,
					text = nextText,
					width = UDim.new(0, 144)
				})
			})
		})
	end
end

local function LandscapeModeHeader(props)
	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 0.1,
		BackgroundColor3 = Color3.fromHex("#000000"),
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 71),
		ZIndex = 2
	}, {
		Bar = React.createElement(HeaderBar, {
			backgroundTransparency = 1,
			barHeight = 72,
			renderLeft = renderHeaderBarLeft(props.backAction), -- inferred equivalent call
			renderRight = renderHeaderBarRight( -- inferred equivalent call
				props.nextAction,
				props.nextText,
				props.coachmarkTitle,
				props.coachmarkText,
				props.isCoachmarkOpen,
				props.onCoachmarkClose
			),
			renderCenter = renderHeaderBarCenter(props.titleText) -- inferred equivalent call
		})
	})
end

return LandscapeModeHeader
