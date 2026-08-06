local Parent = script:FindFirstAncestor("AppBlox").Parent
local CentralOverlay = require(Parent.CentralOverlay)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local NavigationRodux = require(Parent.NavigationRodux)
local React = require(Parent.React)
local RoactUtils = require(Parent.RoactUtils)
local RobloxAppEnums = require(Parent.RobloxAppEnums)
local SharedFlags = require(Parent.SharedFlags)
local UniversalAppPolicy = require(Parent.UniversalAppPolicy)
local UrlBuilder = require(Parent.UrlBuilder)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v19 = game:DefineFastFlag("LuaAppTextFeedbackFormModalStandardInput", false)
local v20 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AppPage = RobloxAppEnums.AppPage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local UrlBuilder2 = UrlBuilder.UrlBuilder

local function TextFeedbackFormModal(t1: {[any]: any}) -- line: 47
	-- upvalues: useDispatch (copy), useTokens (copy), useLocalization (copy), React (copy), CloseCentralOverlay (copy), useAppPolicy (copy), AppPage (copy), UrlBuilder2 (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), NavigateDown (copy), Dialog (copy), v19 (copy), ButtonVariant (copy)
	local v27 = useDispatch()
	local v28 = useTokens()
	local v29 = useLocalization({
		submitText = "CommonUI.Controls.Action.Submit",
		defaultPlaceholderText = "Feature.GameDetails.Label.TellUsMorePlaceholder",
		termsOfUseText = {
			"Feature.GameDetails.Message.AnonymousFeedbackTermsOfUse",
			underlineStart = "<u>",
			underlineEnd = "</u>"
		}
	})
	local v30 = React.useRef("")
	local v31, v32 = React.useState(false)
	local v33 = React.useCallback(function(b1: boolean?) -- line: 63
		-- upvalues: v27 (copy), CloseCentralOverlay (copy), t1 (copy)
		v27(CloseCentralOverlay())

		if t1.onClose then
			t1.onClose(b1)
		end
	end, {
		v27,
		t1.onClose
	})
	local v34 = React.useCallback(function(p1) -- line: 71
		-- upvalues: v30 (copy), v32 (copy)
		if not p1 then
			return
		end

		if p1.Text:len() > 500 then
			p1.Text = p1.Text:sub(1, 500)
		end

		v30.current = p1.Text
		v32(p1.Text:len() >= 10)
	end, {})
	local v35 = React.useCallback(function() -- line: 84
		-- upvalues: v31 (copy), v33 (copy), t1 (copy), v30 (copy)
		if not v31 then
			return
		end

		v33(true)
		t1.onSubmit(v30.current)
	end, {
		v31,
		t1.onSubmit,
		v33
	})
	local v36 = useAppPolicy(function(p2) -- line: 93
		return p2.getWebViewSupport()
	end)
	local v37 = React.useCallback(function() -- line: 98
		-- upvalues: AppPage (copy), UrlBuilder2 (copy), FFlagSignalsNavP3Dispatch (copy), v20 (copy), v27 (copy), NavigateDown (copy), v33 (copy)
		local t2 = {
			name = AppPage.GenericWebPage,
			detail = UrlBuilder2.static.about.terms(),
			extraProps = {
				title = ""
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v20.down(v20.fromLegacyPage(t2), nil)
		else
			v27(NavigateDown(t2, nil))
		end

		v33(false)
	end, {
		v27,
		v33
	})
	local v38 = React.useCallback(function() -- line: 121
		-- upvalues: v33 (copy)
		v33(false)
	end, { v33 })

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		onClose = v38
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = t1.dialogTitle
		}),
		DialogText = if not t1.dialogText then nil else React.createElement(Dialog.Text, {
			LayoutOrder = 2,
			Text = t1.dialogText
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 3
		}, {
			TextBoxContainer = React.createElement("Frame", {
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = if not v19 then v28.Color.Shift.Shift_200.Color3 else nil,
				BackgroundTransparency = if not v19 then v28.Color.Shift.Shift_200.Transparency else 1,
				Size = UDim2.fromScale(1, 0)
			}, {
				InputBox = React.createElement("TextBox", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = if not v19 then v28.Typography.CaptionMedium.Font else v28.Typography.BodyMedium.Font,
					LineHeight = if not v19 then v28.LineHeight.LineHeight_140 else v28.Typography.BodyMedium.LineHeight,
					MultiLine = true,
					PlaceholderColor3 = v28.Color.Content.Muted.Color3,
					PlaceholderText = t1.placeholderText or v29.defaultPlaceholderText,
					Size = UDim2.new(1, 0, 0, v28.Size.Size_1000),
					Text = v30.current,
					TextColor3 = if not v19 then v28.Color.Content.Default.Color3 else v28.Color.Content.Emphasis.Color3,
					TextSize = if not v19 then v28.Typography.CaptionMedium.FontSize else v28.Typography.BodyMedium.FontSize,
					TextTransparency = if not v19 then v28.Color.Content.Default.Transparency else v28.Color.Content.Emphasis.Transparency,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v34
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, v28.Size.Size_3000)
					})
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v28.Padding.Small),
					PaddingLeft = UDim.new(0, v28.Padding.Small),
					PaddingRight = UDim.new(0, v28.Padding.Small),
					PaddingTop = UDim.new(0, v28.Padding.Small)
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v28.Radius.Medium)
				}),
				UIStroke = if not v19 then nil else React.createElement("UIStroke", {
					Color = v28.Color.Stroke.Emphasis.Color3,
					Transparency = v28.Color.Stroke.Emphasis.Transparency,
					Thickness = v28.Stroke.Standard,
					BorderStrokePosition = Enum.BorderStrokePosition.Inner
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = {{
				isDisabled = not v31,
				onActivated = v35,
				text = v29.submitText,
				variant = t1.buttonVariant or ButtonVariant.Standard
			}}
		}),
		DisclaimerText = if not t1.showTermsOfUseDisclaimer or not v36 then nil else React.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansMedium,
			LayoutOrder = 5,
			LineHeight = v28.LineHeight.LineHeight_140,
			RichText = true,
			Size = UDim2.fromScale(1, 0),
			Text = v29.termsOfUseText,
			TextColor3 = v28.Color.Content.Muted.Color3,
			TextSize = v28.FontSize.FontSize_300,
			TextTransparency = v28.Color.Content.Muted.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			[React.Event.Activated] = v37
		})
	})
end

return React.memo(TextFeedbackFormModal)
