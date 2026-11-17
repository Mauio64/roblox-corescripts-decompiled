local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local Localization = require(parent2.Localization)
local React = require(parent2.React)
local UIBlox = require(parent2.UIBlox)
local Foundation = require(parent2.Foundation)
local Style = require(parent2.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle

local CapturesContext = require(parent.Context.CapturesContext)
local CapturesPolicy = require(parent.App.CapturesPolicy)
local OnOffButton = require(parent.Components.CoreUI.OnOffButton)
local VideoCaptureCTA = require(parent.Components.CoreUI.VideoCaptureCTA)

local useKeyboardEnabled = require(parent.Hooks.useKeyboardEnabled)

local udim = UDim.new(0, 8)

local keyOne = UserInputService:GetPlatform() == Enum.Platform.OSX and "Opt" or "Alt"

return (CapturesPolicy.connect(function(p)
	return { eligibleForVideoCapture = p.eligibleForVideoCapture() }
end)(function(props)
	local v = useStyle()
	local chromeEnabled = React.useContext(CapturesContext).chromeEnabled

	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(GuiService.PreferredTextSize)

	React.useEffect(function()
		local function onPreferredTextSizeChangedSignal()
			setState2(GuiService.PreferredTextSize)
		end
		local preferredTextSizeChangedConnection = GuiService:GetPropertyChangedSignal("PreferredTextSize"):Connect(onPreferredTextSizeChangedSignal)

		return function()
			preferredTextSizeChangedConnection:Disconnect()
		end
	end, {})

	local v2 = useLocalization({
		capturesTitle = "Feature.Captures.Title.Captures",
		educationalText = "Feature.Captures.Label.EducationalText",
		hotkeyEducationalText = {
			"Feature.Captures.Label.HotkeyEducationalText",
			keyOne = keyOne,
			keyTwo = UserInputService:GetStringForKeyCode(Enum.KeyCode.One)
		}
	})
	local text

	if useKeyboardEnabled() then
		text = v2.hotkeyEducationalText
	else
		text = v2.educationalText
	end

	local color = v.Theme.BackgroundDefault.Color
	local transparency = v.Theme.BackgroundDefault.Transparency

	local color2 = v.Theme.TextDefault.Color
	local font = v.Tokens.Typography.BodySmall.Font
	local textSize = v.Font.BaseSize * v.Font.CaptionBody.RelativeSize

	local color3 = v.Theme.TextEmphasis.Color
	local font2 = v.Tokens.Typography.TitleLarge.Font
	local textSize2 = v.Font.BaseSize * v.Font.Header2.RelativeSize

	local v3 = React.useCallback(function(p)
		setState(p.AbsoluteSize)

		if props.onAbsoluteSizeChanged then
			props.onAbsoluteSizeChanged(p.AbsoluteSize)
		end
	end, {})

	local v4 = React.useMemo(function()
		return GetTextSize(text, textSize, font, Vector2.new(10000, 10000)).X
	end, { font, textSize, state2, text })

	local x = state.X
	local v5 = v4 < x - 224 - 24

	local v6 = (v5 or v4 < x - 24) and 20 or GetTextSize(text, textSize, font, Vector2.new(x - 24, 10000)).Y + 10

	local createElement = React.createElement
	local v7 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = color,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		[React.Change.AbsoluteSize] = v3
	}
	local v8 = {
		UICorner = React.createElement("UICorner", { CornerRadius = udim }),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12)
		}),
		Layout = 0,
		CapturesToggleCTA = 0,
		Space = 0,
		VideoCaptureCTA = 0
	}
	local layout

	if not chromeEnabled then
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		})
	end

	v8.Layout = layout
	local capturesToggleCTA

	if not chromeEnabled then
		local createElement2 = React.createElement
		local v9 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = color,
			BackgroundTransparency = transparency,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0)
		}
		local v10 = {
			TextFrame = React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0)
				},
				{
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top
					}),
					Title = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						FontFace = normalizeFontFace(font2),
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, 30),
						Text = v2.capturesTitle,
						TextColor3 = color3,
						TextSize = textSize2,
						TextXAlignment = Enum.TextXAlignment.Left
					}),
					EducationalLabel = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						FontFace = normalizeFontFace(font),
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, v6),
						Text = text,
						TextColor3 = color2,
						TextSize = textSize,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left
					})
				}
			),
			CapturesToggleFrame = 0
		}

		local createElement3 = React.createElement
		local anchorPoint

		if v5 then
			anchorPoint = Vector2.new(1, 0.5)
		else
			anchorPoint = Vector2.new(1, 0)
		end

		local position

		if v5 then
			position = UDim2.fromScale(1, 0.5)
		else
			position = UDim2.new(1, 0, 0, -10)
		end

		v10.CapturesToggleFrame = createElement3(
			"Frame",
			{
				AnchorPoint = anchorPoint,
				BackgroundTransparency = 1,
				Position = position,
				Size = UDim2.fromOffset(224, 44)
			},
			{
				OnOffButton = React.createElement(OnOffButton, { height = 44, width = 224 })
			}
		)
		capturesToggleCTA = createElement2("Frame", v9, v10)
	end

	v8.CapturesToggleCTA = capturesToggleCTA
	local space

	if props.eligibleForVideoCapture and not chromeEnabled then
		space = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, 20),
			LayoutOrder = 2
		})
	end

	v8.Space = space
	local videoCaptureCTA

	if props.eligibleForVideoCapture then
		videoCaptureCTA = React.createElement(VideoCaptureCTA, {
			closeSettingsMenu = props.closeSettingsMenu,
			LayoutOrder = 3
		})
	end

	v8.VideoCaptureCTA = videoCaptureCTA
	return createElement("Frame", v7, v8)
end))
