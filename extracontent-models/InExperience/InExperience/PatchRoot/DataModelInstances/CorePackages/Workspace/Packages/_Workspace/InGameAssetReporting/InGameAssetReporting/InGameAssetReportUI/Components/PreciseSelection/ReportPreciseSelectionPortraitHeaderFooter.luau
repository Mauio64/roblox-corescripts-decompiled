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

local function renderHeaderBarLeft(onActivated) -- 1 equivalent call inferred from this helper
	return function()
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 30, 1, 0)
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

local function renderHeaderBarCenter(titleText) -- 1 equivalent call inferred from this helper
	return function()
		return withStyle(function(p)
			local currentCamera = game.Workspace.CurrentCamera

			local v = currentCamera == nil and 300 or currentCamera.ViewportSize.X - 150

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
				Size = UDim2.new(0, v, 1, 0),
				BackgroundTransparency = 1
			})
		end)
	end
end

local function renderHeaderBarRight()
	return function()
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 60, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		})
	end
end

local ReportPreciseSelectionPortraitHeaderFooter = {}

function ReportPreciseSelectionPortraitHeaderFooter.PortraitModeHeader(p)
	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 0.1,
		BackgroundColor3 = Color3.fromHex("#000000"),
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 72),
		ZIndex = 2
	}, {
		Bar = React.createElement(HeaderBar, {
			backgroundTransparency = 1,
			barHeight = 72,
			margin = 12,
			renderLeft = renderHeaderBarLeft(p.backAction), -- inferred equivalent call
			renderRight = function()
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 60, 1, 0)
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				})
			end,
			renderCenter = renderHeaderBarCenter(p.titleText), -- inferred equivalent call
			isSecondary = true
		})
	})
end

function ReportPreciseSelectionPortraitHeaderFooter.PortraitModeFooter(props)
	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 0.1,
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundColor3 = Color3.fromHex("#000000"),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		LayoutOrder = 4
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		CoachmarkWrapper = React.createElement(Foundation.Coachmark, {
			title = props.coachmarkTitle,
			text = props.coachmarkText,
			isOpen = props.isCoachmarkOpen or false,
			side = Foundation.Enums.PopoverSide.Top,
			align = Foundation.Enums.PopoverAlign.Center,
			onClose = props.onCoachmarkClose
		}, {
			NextButton = React.createElement(Button, {
				variant = ButtonVariant.Emphasis,
				inputSize = InputSize.Large,
				width = UDim.new(0, 400),
				onActivated = props.nextAction,
				text = props.nextText
			})
		})
	})
end

return ReportPreciseSelectionPortraitHeaderFooter
