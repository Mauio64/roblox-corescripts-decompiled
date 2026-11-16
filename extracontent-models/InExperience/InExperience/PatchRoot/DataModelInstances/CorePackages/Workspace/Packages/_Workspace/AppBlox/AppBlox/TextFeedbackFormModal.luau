local parent = script:FindFirstAncestor("AppBlox").Parent

local CentralOverlay = require(parent.CentralOverlay)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Localization = require(parent.Localization)
local NavigationRodux = require(parent.NavigationRodux)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SharedFlags = require(parent.SharedFlags)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local UrlBuilder = require(parent.UrlBuilder)

local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local defineFastFlag = game:DefineFastFlag("LuaAppTextFeedbackFormModalStandardInput", false)
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AppPage = RobloxAppEnums.AppPage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local urlBuilder = UrlBuilder.UrlBuilder

local function TextFeedbackFormModal(props)
	local v = useDispatch()
	local v2 = useTokens()
	local v3 = useLocalization({
		submitText = "CommonUI.Controls.Action.Submit",
		defaultPlaceholderText = "Feature.GameDetails.Label.TellUsMorePlaceholder",
		termsOfUseText = {
			"Feature.GameDetails.Message.AnonymousFeedbackTermsOfUse",
			underlineStart = "<u>",
			underlineEnd = "</u>"
		}
	})

	local ref = React.useRef("")
	local state, setState = React.useState(false)

	local v4 = React.useCallback(function(flag: boolean?)
		v(CloseCentralOverlay())

		if props.onClose then
			props.onClose(flag)
		end
	end, { v, props.onClose })

	local v5 = React.useCallback(function(p)
		if not p then
			return
		end

		if p.Text:len() > 500 then
			p.Text = p.Text:sub(1, 500)
		end

		ref.current = p.Text
		setState(p.Text:len() >= 10)
	end, {})

	local onActivated = React.useCallback(function()
		if not state then
			return
		end

		v4(true)
		props.onSubmit(ref.current)
	end, { state, props.onSubmit, v4 })

	local v6 = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local v7 = React.useCallback(function()
		local v7 = {
			name = AppPage.GenericWebPage,
			detail = urlBuilder.static.about.terms(),
			extraProps = { title = "" }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v7), nil)
		else
			v(NavigateDown(v7, nil))
		end

		v4(false)
	end, { v, v4 })

	local onClose = React.useCallback(function()
		v4(false)
	end, { v4 })

	local createElement = React.createElement
	local root = Dialog.Root

	local children = {
		DialogTitle = React.createElement(Dialog.Title, { text = props.dialogTitle }),
		DialogText = 0,
		DialogContent = 0,
		DialogActions = 0,
		DisclaimerText = 0
	}
	local dialogText

	if props.dialogText then
		dialogText = React.createElement(Dialog.Text, { Text = props.dialogText, LayoutOrder = 2 })
	end

	children.DialogText = dialogText

	local createElement2 = React.createElement
	local content = Dialog.Content

	local createElement3 = React.createElement
	local v8 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = 0
	}
	local backgroundColor

	if not defineFastFlag then
		backgroundColor = v2.Color.Shift.Shift_200.Color3
	end

	v8.BackgroundColor3 = backgroundColor

	v8.BackgroundTransparency = defineFastFlag and 1 or v2.Color.Shift.Shift_200.Transparency

	v8.Size = UDim2.fromScale(1, 0)

	local createElement4 = React.createElement
	local v9 = {}
	v9.AutomaticSize = Enum.AutomaticSize.Y
	v9.BackgroundTransparency = 1
	v9.ClearTextOnFocus = false
	local font

	if not FoundationFontFaceMigration then
		if defineFastFlag then
			font = v2.Typography.BodyMedium.Font
		else
			font = v2.Typography.CaptionMedium.Font
		end
	end

	v9.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		local v10

		if defineFastFlag then
			v10 = v2.Typography.BodyMedium.Font
		else
			v10 = v2.Typography.CaptionMedium.Font
		end

		fontFace = normalizeFontFace(v10)
	end

	v9.FontFace = fontFace
	local lineHeight

	if defineFastFlag then
		lineHeight = v2.Typography.BodyMedium.LineHeight
	else
		lineHeight = v2.LineHeight.LineHeight_140
	end

	v9.LineHeight = lineHeight

	v9.MultiLine = true
	v9.PlaceholderColor3 = v2.Color.Content.Muted.Color3
	v9.PlaceholderText = props.placeholderText or v3.defaultPlaceholderText
	v9.Size = UDim2.new(1, 0, 0, v2.Size.Size_1000)
	v9.Text = ref.current
	local textColor

	if defineFastFlag then
		textColor = v2.Color.Content.Emphasis.Color3
	else
		textColor = v2.Color.Content.Default.Color3
	end

	v9.TextColor3 = textColor
	local textSize

	if defineFastFlag then
		textSize = v2.Typography.BodyMedium.FontSize
	else
		textSize = v2.Typography.CaptionMedium.FontSize
	end

	v9.TextSize = textSize
	local textTransparency

	if defineFastFlag then
		textTransparency = v2.Color.Content.Emphasis.Transparency
	else
		textTransparency = v2.Color.Content.Default.Transparency
	end

	v9.TextTransparency = textTransparency

	v9.TextTruncate = Enum.TextTruncate.SplitWord
	v9.TextWrapped = true
	v9.TextXAlignment = Enum.TextXAlignment.Left
	v9.TextYAlignment = Enum.TextYAlignment.Top
	v9[React.Change.Text] = v5
	local children2 = {
		InputBox = createElement4("TextBox", v9, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1e999, v2.Size.Size_3000)
			})
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v2.Padding.Small),
			PaddingLeft = UDim.new(0, v2.Padding.Small),
			PaddingRight = UDim.new(0, v2.Padding.Small),
			PaddingTop = UDim.new(0, v2.Padding.Small)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v2.Radius.Medium) }),
		UIStroke = 0
	}
	local uiStroke

	if defineFastFlag then
		uiStroke = React.createElement("UIStroke", {
			Color = v2.Color.Stroke.Emphasis.Color3,
			Transparency = v2.Color.Stroke.Emphasis.Transparency,
			Thickness = v2.Stroke.Standard,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner
		})
	end

	children2.UIStroke = uiStroke
	children.DialogContent = createElement2(content, { LayoutOrder = 3 }, {
		TextBoxContainer = createElement3("Frame", v8, children2)
	})

	children.DialogActions = React.createElement(Dialog.Actions, {
		actions = {
			{
				isDisabled = not state,
				onActivated = onActivated,
				text = v3.submitText,
				variant = props.buttonVariant or ButtonVariant.Standard
			}
		},
		LayoutOrder = 4
	})
	local disclaimerText

	if props.showTermsOfUseDisclaimer and v6 then
		disclaimerText = React.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansMedium,
			LayoutOrder = 5,
			LineHeight = v2.LineHeight.LineHeight_140,
			RichText = true,
			Size = UDim2.fromScale(1, 0),
			Text = v3.termsOfUseText,
			TextColor3 = v2.Color.Content.Muted.Color3,
			TextSize = v2.FontSize.FontSize_300,
			TextTransparency = v2.Color.Content.Muted.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			[React.Event.Activated] = v7
		})
	end

	children.DisclaimerText = disclaimerText
	return createElement(root, { onClose = onClose, hasBackdrop = true }, children)
end

return React.memo(TextFeedbackFormModal)
