local parent = script:FindFirstAncestor("InGameAssetReporting").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local function renderHeaderBarCenter(titleText) -- 1 equivalent call inferred from this helper
	return function()
		return withStyle(function(props)
			local theme = props.Theme
			local font = props.Font

			local createElement = React.createElement
			local v = {
				Text = titleText,
				Font = 0,
				FontFace = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextSize = 20,
				TextWrapped = true,
				TextXAlignment = 0,
				TextYAlignment = 0,
				Size = 0,
				BackgroundTransparency = 1
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = font.Header2.Font
			end

			v.Font = font2
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
			end

			v.FontFace = fontFace

			v.TextColor3 = theme.TextEmphasis.Color
			v.TextTransparency = theme.TextEmphasis.Transparency

			v.TextXAlignment = Enum.TextXAlignment.Center
			v.TextYAlignment = Enum.TextYAlignment.Center
			v.Size = UDim2.new(1, 0, 1, 0)
			return createElement("TextLabel", v)
		end)
	end
end

local function renderHeaderBarLeft(onActivated, onActivated2, onActivated3, isRedoEnabled, isUndoEnabled) -- 1 equivalent call inferred from this helper
	local v = isRedoEnabled or isUndoEnabled
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
			}),
			UndoButton = v and React.createElement(IconButton, {
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/undo"],
				isDisabled = not isUndoEnabled,
				layoutOrder = 2,
				onActivated = onActivated2
			}),
			RedoButton = v and React.createElement(IconButton, {
				iconSize = IconSize.Medium,
				icon = Images["icons/actions/edit/redo"],
				isDisabled = not isRedoEnabled,
				layoutOrder = 3,
				onActivated = onActivated3
			})
		})
	end
end

local function renderHeaderBarRight(onActivated, _, nextText) -- 1 equivalent call inferred from this helper
	return function()
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 144, 1, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			Buttons = React.createElement(ButtonStack, {
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = { onActivated = onActivated, text = nextText }
					}
				}
			})
		})
	end
end

local function LandscapeModeHeader(props)
	local createElement = React.createElement
	local v = {
		BorderSizePixel = 0,
		BackgroundTransparency = 0.1,
		BackgroundColor3 = Color3.fromHex("#000000"),
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 71),
		ZIndex = 2
	}

	local createElement2 = React.createElement
	local v2 = {
		backgroundTransparency = 1,
		barHeight = 72,
		renderLeft = renderHeaderBarLeft( -- inferred equivalent call
			props.backAction,
			props.undoAnnotationPoints,
			props.redoAnnotationPoints,
			props.isRedoEnabled,
			props.isUndoEnabled
		),
		renderRight = 0,
		renderCenter = 0
	}

	local nextAction = props.nextAction
	local _annotationPoints = props.annotationPoints
	v2.renderRight = renderHeaderBarRight(nextAction, nil, props.nextText) -- inferred equivalent call
	v2.renderCenter = renderHeaderBarCenter(props.titleText) -- inferred equivalent call
	return createElement("Frame", v, { Bar = createElement2(HeaderBar, v2) })
end

return LandscapeModeHeader
