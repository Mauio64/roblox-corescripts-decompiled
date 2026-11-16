local parent = script:FindFirstAncestor("AppBlox").Parent

local CentralOverlay = require(parent.CentralOverlay)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
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
local Checkbox = Foundation.Checkbox
local Dialog = Foundation.Dialog
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useLocalization = Localization.Hooks.useLocalization
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
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

local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local defineFastFlag = game:DefineFastFlag("LuaAppCheckboxFeedbackFormTitleTextWrapping", false)

local function CheckboxFeedbackFormModal(props)
	local v = useDispatch()
	local v2 = useTokens()
	local v3 = useLocalization({
		submitText = "CommonUI.Controls.Action.Submit",
		otherPlaceholderText = "Feature.GameDetails.Label.TellUsMorePlaceholder",
		termsOfUseText = {
			"Feature.GameDetails.Message.AnonymousFeedbackTermsOfUse",
			underlineStart = "<u>",
			underlineEnd = "</u>"
		}
	})

	local v4 = React.useCallback(function(flag: boolean?)
		v(CloseCentralOverlay())

		if FFlagLuaAppNotInterestedFeedbackFormTelemetry and props.onClose then
			props.onClose(flag)
		end
	end, { v, props.onClose })

	local state, setState = React.useState({})

	local v5 = React.useMemo(function()
		return Cryo.List.map(props.checkboxItems, function(p, layoutOrder: number)
			local id = p.id
			return React.createElement(Checkbox, {
				label = p.text,
				isChecked = state[id] and true or false,
				LayoutOrder = layoutOrder,
				onActivated = function()
					local clone = table.clone(state)

					if clone[id] then
						clone[id] = false
					else
						clone[id] = true
					end

					setState(clone)
				end
			})
		end)
	end, { props.checkboxItems, state })

	local v6, v7 = React.useMemo(function()
		local v6 = false
		local v7 = false

		for _, checkboxItem in props.checkboxItems do
			if not state[checkboxItem.id] then
				continue
			end

			if checkboxItem.triggersOtherTextbox then
				v7 = true
			else
				v6 = true
			end
		end

		return v6, v7
	end, { props.checkboxItems, state })

	local ref = React.useRef("")
	local state2, setState2 = React.useState(false)
	local v8

	if v7 and not state2 then
		v8 = false
	else
		v8 = (v6 or v7 and state2) and true or false
	end

	local v9 = React.useCallback(function(p)
		if not p then
			return
		end

		if p.Text:len() > 500 then
			p.Text = p.Text:sub(1, 500)
		end

		ref.current = p.Text
		setState2(p.Text:len() >= 10)
	end, {})

	local onActivated = React.useCallback(function()
		if not v8 then
			return
		end

		v4(FFlagLuaAppNotInterestedFeedbackFormTelemetry and true or nil)
		props.onSubmit(state, ref.current)
	end, { v8, props.onSubmit, state, v4 })

	local v10 = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local v11 = React.useCallback(function()
		local v11 = {
			name = AppPage.GenericWebPage,
			detail = urlBuilder.static.about.terms(),
			extraProps = { title = "" }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v11), nil)
		else
			v(NavigateDown(v11, nil))
		end

		v4(not FFlagLuaAppNotInterestedFeedbackFormTelemetry and nil)
	end, { v, v4 })
	local onClose

	if FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		onClose = React.useCallback(function()
			v4(false)
		end, { v4 })
	end

	local createElement = React.createElement
	local root = Dialog.Root

	if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then
		onClose = v4
	end

	local dialogTitle

	if props.dialogTitle then
		dialogTitle = React.createElement(Dialog.Title, { text = props.dialogTitle })
	end

	local children = {
		DialogTitle = dialogTitle,
		DialogText = React.createElement(Dialog.Text, { Text = props.dialogText, LayoutOrder = 2 }),
		DialogContent = 0,
		DialogActions = 0,
		DisclaimerText = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content

	local v12 = {
		CheckboxListWrapper = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0)
		}, Cryo.Dictionary.union(v5, {
			Title = React.createElement(Text, {
				AutomaticSize = Enum.AutomaticSize.Y,
				fontStyle = v2.Typography.TitleLarge,
				LayoutOrder = 0,
				Size = UDim2.fromScale(1, 0),
				Text = props.checkboxListTitle,
				TextWrapped = defineFastFlag and true or nil,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v2.Padding.Medium),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
		})),
		OtherTextBoxContainer = 0,
		UIListLayout = 0
	}
	local otherTextBoxContainer

	if v7 then
		local createElement3 = React.createElement
		local v13 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = v2.Color.Shift.Shift_200.Color3,
			BackgroundTransparency = v2.Color.Shift.Shift_200.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0)
		}

		local createElement4 = React.createElement
		local v14 = {}
		v14.AutomaticSize = Enum.AutomaticSize.Y
		v14.BackgroundTransparency = 1
		v14.ClearTextOnFocus = false
		local font

		if not FoundationFontFaceMigration then
			font = v2.Typography.CaptionMedium.Font
		end

		v14.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Typography.CaptionMedium.Font)
		end

		v14.FontFace = fontFace

		v14.LineHeight = v2.LineHeight.LineHeight_140
		v14.MultiLine = true
		v14.PlaceholderColor3 = v2.Color.Content.Muted.Color3
		v14.PlaceholderText = v3.otherPlaceholderText
		v14.Size = UDim2.new(1, 0, 0, v2.Size.Size_1000)
		v14.Text = ref.current
		v14.TextColor3 = v2.Color.Content.Default.Color3
		v14.TextSize = v2.Typography.CaptionMedium.FontSize
		v14.TextTransparency = v2.Color.Content.Default.Transparency
		v14.TextTruncate = Enum.TextTruncate.SplitWord
		v14.TextWrapped = true
		v14.TextXAlignment = Enum.TextXAlignment.Left
		v14.TextYAlignment = Enum.TextYAlignment.Top
		v14[React.Change.Text] = v9
		otherTextBoxContainer = createElement3("Frame", v13, {
			InputBox = createElement4("TextBox", v14, {
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
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v2.Radius.Medium)
			})
		})
	end

	v12.OtherTextBoxContainer = otherTextBoxContainer

	v12.UIListLayout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, v2.Padding.XLarge),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top
	})
	children.DialogContent = createElement2(content, { LayoutOrder = 3 }, v12)

	children.DialogActions = React.createElement(Dialog.Actions, {
		actions = {
			{
				isDisabled = not v8,
				onActivated = onActivated,
				text = v3.submitText,
				variant = ButtonVariant.Standard
			}
		},
		LayoutOrder = 4
	})
	local disclaimerText

	if not (FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and not props.showTermsOfUseDisclaimer or not v10) then
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
			[React.Event.Activated] = v11
		})
	end

	children.DisclaimerText = disclaimerText
	return createElement(root, { onClose = onClose, hasBackdrop = true }, children)
end

return React.memo(CheckboxFeedbackFormModal)
