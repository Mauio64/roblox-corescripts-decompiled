local parent = script:FindFirstAncestor("InGameAssetReporting").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local function renderHeaderBarLeft(onActivated, _, _) -- 1 equivalent call inferred from this helper
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

local function renderHeaderBarRight(_, onActivated, onActivated2, isUndoEnabled, isRedoEnabled) -- 1 equivalent call inferred from this helper
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
			}),
			UndoButton = React.createElement(IconButton, {
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/undo"],
				isDisabled = not isUndoEnabled,
				layoutOrder = 1,
				onActivated = onActivated
			}),
			RedoButton = React.createElement(IconButton, {
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/redo"],
				isDisabled = not isRedoEnabled,
				layoutOrder = 2,
				onActivated = onActivated2
			})
		})
	end
end

local InGameAssetReportPortraitHeaderFooter = {}

function InGameAssetReportPortraitHeaderFooter.PortraitModeHeader(props)
	local isRedoEnabled = props.isRedoEnabled or props.isUndoEnabled

	local createElement = React.createElement
	local v = {
		BorderSizePixel = 0,
		BackgroundTransparency = 0.1,
		BackgroundColor3 = Color3.fromHex("#000000"),
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 72),
		ZIndex = 2
	}

	local createElement2 = React.createElement

	local backAction = props.backAction
	local _isRedoEnabled = props.isRedoEnabled
	local _isUndoEnabled = props.isUndoEnabled
	local v2 = {
		backgroundTransparency = 1,
		barHeight = 72,
		margin = 12,
		renderLeft = renderHeaderBarLeft(backAction), -- inferred equivalent call
		renderRight = 0,
		renderCenter = 0,
		isSecondary = true
	}
	local renderRight

	if isRedoEnabled then
		local _annotationPoints = props.annotationPoints
		renderRight = renderHeaderBarRight( -- inferred equivalent call
			nil,
			props.undoAnnotationPoints,
			props.redoAnnotationPoints,
			props.isUndoEnabled,
			props.isRedoEnabled
		)
	else
		renderRight = function() end
	end

	v2.renderRight = renderRight

	v2.renderCenter = renderHeaderBarCenter(props.titleText) -- inferred equivalent call
	return createElement("Frame", v, { Bar = createElement2(HeaderBar, v2) })
end

function InGameAssetReportPortraitHeaderFooter.PortraitModeFooter(p)
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
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Container = React.createElement("Frame", {
			Size = UDim2.new(0, 400, 1, 0),
			BackgroundTransparency = 1
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 12),
				PaddingBottom = UDim.new(0, 12),
				PaddingLeft = UDim.new(0, 32),
				PaddingRight = UDim.new(0, 32)
			}),
			ActionButtons = React.createElement(ButtonStack, {
				marginBetween = 8,
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = { onActivated = p.nextAction, text = p.nextText }
					}
				}
			})
		})
	})
end

return InGameAssetReportPortraitHeaderFooter
