local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local React = require(CorePackages.Packages.React)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local withStyle = UIBlox.Style.withStyle

local function renderWrappingCenter(titleText) -- 1 equivalent call inferred from this helper
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

local function renderHeaderBarRight(finishAnnotationAction, annotationPoints) -- 1 equivalent call inferred from this helper
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
						props = {
							onActivated = function()
								finishAnnotationAction(annotationPoints)
							end,
							text = RobloxTranslator:FormatByKey("Feature.ReportAbuse.Action.Next")
						}
					}
				}
			})
		})
	end
end

local function LandscapeModeHeader(props)
	return React.createElement("Frame", {
		BackgroundTransparency = 0,
		BackgroundColor3 = Color3.fromHex("#4F545F"),
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 47),
		ZIndex = 2
	}, {
		Bar = React.createElement(HeaderBar, {
			backgroundTransparency = 1,
			barHeight = 48,
			renderLeft = renderHeaderBarLeft( -- inferred equivalent call
				props.backAction,
				props.undoAnnotationPoints,
				props.redoAnnotationPoints,
				props.isRedoEnabled,
				props.isUndoEnabled
			),
			renderRight = renderHeaderBarRight(props.finishAnnotationAction, props.annotationPoints), -- inferred equivalent call
			renderCenter = renderWrappingCenter(props.titleText) -- inferred equivalent call
		})
	})
end

return LandscapeModeHeader
