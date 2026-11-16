local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local React = require(CorePackages.Packages.React)

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

local function renderCenter(titleText) -- 1 equivalent call inferred from this helper
	return function()
		return withStyle(function(props)
			local currentCamera = game.Workspace.CurrentCamera

			local v = currentCamera == nil and 300 or currentCamera.ViewportSize.X - 150

			local theme = props.Theme
			local font = props.Font

			local createElement = React.createElement
			local v2 = {
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

			v2.Font = font2
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font)
			end

			v2.FontFace = fontFace

			v2.TextColor3 = theme.TextEmphasis.Color
			v2.TextTransparency = theme.TextEmphasis.Transparency

			v2.TextXAlignment = Enum.TextXAlignment.Center
			v2.TextYAlignment = Enum.TextYAlignment.Center
			v2.Size = UDim2.new(0, v, 1, 0)
			return createElement("TextLabel", v2)
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

local function ScreenshotDialogPortraitModeHeader(props)
	local isRedoEnabled = props.isRedoEnabled or props.isUndoEnabled

	local createElement = React.createElement
	local v = {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromHex("#4F545F"),
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 48),
		ZIndex = 2
	}

	local createElement2 = React.createElement

	local backAction = props.backAction
	local _isRedoEnabled = props.isRedoEnabled
	local _isUndoEnabled = props.isUndoEnabled
	local v2 = {
		backgroundTransparency = 1,
		barHeight = 48,
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

	v2.renderCenter = renderCenter(props.titleText) -- inferred equivalent call
	return createElement("Frame", v, { Bar = createElement2(HeaderBar, v2) })
end

return ScreenshotDialogPortraitModeHeader
