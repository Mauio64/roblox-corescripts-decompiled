local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/CentralOverlay")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Localization")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/NavigationRodux")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RoactUtils")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppEnums")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UniversalAppPolicy")
local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UrlBuilder")

local closeCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local defineFastFlag = game:DefineFastFlag("LuaAppTextFeedbackFormModalStandardInput", false)

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppNavigation").NavigationCommands else nil

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local appPage = RobloxAppEnums.AppPage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local urlBuilder = UrlBuilder.UrlBuilder

local function TextFeedbackFormModal(props)
	local v5 = useDispatch()
	local v6 = useTokens()
	local v7 = useLocalization({
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

	local v8 = React.useCallback(function(p2)
		v5(closeCentralOverlay())

		if props.onClose then
			props.onClose(p2)
		end
	end, { v5, props.onClose })

	local v9 = React.useCallback(function(p2)
		if not p2 then
			return
		end

		if p2.Text:len() > 500 then
			p2.Text = p2.Text:sub(1, 500)
		end

		ref.current = p2.Text
		setState(p2.Text:len() >= 10)
	end, {})

	local v10 = React.useCallback(function()
		if not state then
			return
		end

		v8(true)
		props.onSubmit(ref.current)
	end, { state, props.onSubmit, v8 })

	local v11 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local v12 = React.useCallback(function()
		local v13 = {
			name = appPage.GenericWebPage,
			detail = urlBuilder.static.about.terms(),
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v13), nil)
		else
			v5(navigateDown(v13, nil))
		end

		v8(false)
	end, { v5, v8 })

	local v13 = React.useCallback(function()
		v8(false)
	end, { v8 })

	local createElement = React.createElement
	local root = dialog.Root

	local children = {
		DialogTitle = React.createElement(dialog.Title, { text = props.dialogTitle }),
		DialogText = 0,
		DialogContent = 0,
		DialogActions = 0,
		DisclaimerText = 0
	}

	local v15 = if props.dialogText then React.createElement(dialog.Text, {
		Text = props.dialogText,
		LayoutOrder = 2
	}) else nil
	children.DialogText = v15

	local createElement2 = React.createElement
	local content = dialog.Content

	local createElement3 = React.createElement
	local v19 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = 0
	}

	local v20 = if not defineFastFlag then v6.Color.Shift.Shift_200.Color3 else nil
	v19.BackgroundColor3 = v20

	v19.BackgroundTransparency = defineFastFlag and 1 or v6.Color.Shift.Shift_200.Transparency

	v19.Size = UDim2.fromScale(1, 0)

	local createElement4 = React.createElement
	local v22 = {}
	v22.AutomaticSize = Enum.AutomaticSize.Y
	v22.BackgroundTransparency = 1
	v22.ClearTextOnFocus = false
	local font

	if not foundationFontFaceMigration then
		font = if defineFastFlag then v6.Typography.BodyMedium.Font else v6.Typography.CaptionMedium.Font
	end

	v22.Font = font
	local v23

	if foundationFontFaceMigration then
		local v25 = if defineFastFlag then v6.Typography.BodyMedium.Font else v6.Typography.CaptionMedium.Font
		v23 = normalizeFontFace(v25)
	end

	v22.FontFace = v23

	local v24 = if defineFastFlag then v6.Typography.BodyMedium.LineHeight else v6.LineHeight.LineHeight_140
	v22.LineHeight = v24

	v22.MultiLine = true
	v22.PlaceholderColor3 = v6.Color.Content.Muted.Color3
	v22.PlaceholderText = props.placeholderText or v7.defaultPlaceholderText
	v22.Size = UDim2.new(1, 0, 0, v6.Size.Size_1000)
	v22.Text = ref.current

	local v25 = if defineFastFlag then v6.Color.Content.Emphasis.Color3 else v6.Color.Content.Default.Color3
	v22.TextColor3 = v25

	local v26 = if defineFastFlag then v6.Typography.BodyMedium.FontSize else v6.Typography.CaptionMedium.FontSize
	v22.TextSize = v26

	local v27 = if defineFastFlag then v6.Color.Content.Emphasis.Transparency else v6.Color.Content.Default.Transparency
	v22.TextTransparency = v27

	v22.TextTruncate = Enum.TextTruncate.SplitWord
	v22.TextWrapped = true
	v22.TextXAlignment = Enum.TextXAlignment.Left
	v22.TextYAlignment = Enum.TextYAlignment.Top
	v22[React.Change.Text] = v9
	local children2 = {
		InputBox = createElement4("TextBox", v22, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(1e999, v6.Size.Size_3000)
			})
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v6.Padding.Small),
			PaddingLeft = UDim.new(0, v6.Padding.Small),
			PaddingRight = UDim.new(0, v6.Padding.Small),
			PaddingTop = UDim.new(0, v6.Padding.Small)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v6.Radius.Medium)
		}),
		UIStroke = 0
	}

	local v28 = if defineFastFlag then React.createElement("UIStroke", {
		Color = v6.Color.Stroke.Emphasis.Color3,
		Transparency = v6.Color.Stroke.Emphasis.Transparency,
		Thickness = v6.Stroke.Standard,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner
	}) else nil
	children2.UIStroke = v28
	children.DialogContent = createElement2(content, { LayoutOrder = 3 }, {
		TextBoxContainer = createElement3("Frame", v19, children2)
	})

	children.DialogActions = React.createElement(dialog.Actions, {
		actions = {
			{
				isDisabled = not state,
				onActivated = v10,
				text = v7.submitText,
				variant = props.buttonVariant or buttonVariant.Standard
			}
		},
		LayoutOrder = 4
	})
	local v29

	if props.showTermsOfUseDisclaimer and v11 then
		v29 = React.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansMedium,
			LayoutOrder = 5,
			LineHeight = v6.LineHeight.LineHeight_140,
			RichText = true,
			Size = UDim2.fromScale(1, 0),
			Text = v7.termsOfUseText,
			TextColor3 = v6.Color.Content.Muted.Color3,
			TextSize = v6.FontSize.FontSize_300,
			TextTransparency = v6.Color.Content.Muted.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			[React.Event.Activated] = v12
		})
	end

	children.DisclaimerText = v29
	return createElement(root, { onClose = v13, hasBackdrop = true }, children)
end

return React.memo(TextFeedbackFormModal)
