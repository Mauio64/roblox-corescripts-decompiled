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
local v19 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AppPage = RobloxAppEnums.AppPage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local UrlBuilder2 = UrlBuilder.UrlBuilder

local function TextFeedbackFormModal(t1: {[any]: any}) -- line: 45
	-- upvalues: useDispatch (copy), useTokens (copy), useLocalization (copy), React (copy), CloseCentralOverlay (copy), useAppPolicy (copy), AppPage (copy), UrlBuilder2 (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), NavigateDown (copy), Dialog (copy), ButtonVariant (copy)
	local v26 = useDispatch()
	local v27 = useTokens()
	local v28 = useLocalization({
		submitText = "CommonUI.Controls.Action.Submit",
		defaultPlaceholderText = "Feature.GameDetails.Label.TellUsMorePlaceholder",
		termsOfUseText = {
			"Feature.GameDetails.Message.AnonymousFeedbackTermsOfUse",
			underlineStart = "<u>",
			underlineEnd = "</u>"
		}
	})
	local v29 = React.useRef("")
	local v30, v31 = React.useState(false)
	local v32 = React.useCallback(function(b1: boolean?) -- line: 61
		-- upvalues: v26 (copy), CloseCentralOverlay (copy), t1 (copy)
		v26(CloseCentralOverlay())

		if t1.onClose then
			t1.onClose(b1)
		end
	end, {
		v26,
		t1.onClose
	})
	local v33 = React.useCallback(function(p1) -- line: 69
		-- upvalues: v29 (copy), v31 (copy)
		if not p1 then
			return
		end

		if p1.Text:len() > 500 then
			p1.Text = p1.Text:sub(1, 500)
		end

		v29.current = p1.Text
		v31(p1.Text:len() >= 10)
	end, {})
	local v34 = React.useCallback(function() -- line: 82
		-- upvalues: v30 (copy), v32 (copy), t1 (copy), v29 (copy)
		if not v30 then
			return
		end

		v32(true)
		t1.onSubmit(v29.current)
	end, {
		v30,
		t1.onSubmit,
		v32
	})
	local v35 = useAppPolicy(function(p2) -- line: 91
		return p2.getWebViewSupport()
	end)
	local v36 = React.useCallback(function() -- line: 96
		-- upvalues: AppPage (copy), UrlBuilder2 (copy), FFlagSignalsNavP3Dispatch (copy), v19 (copy), v26 (copy), NavigateDown (copy), v32 (copy)
		local t2 = {
			name = AppPage.GenericWebPage,
			detail = UrlBuilder2.static.about.terms(),
			extraProps = {
				title = ""
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v19.down(v19.fromLegacyPage(t2), nil)
		else
			v26(NavigateDown(t2, nil))
		end

		v32(false)
	end, {
		v26,
		v32
	})
	local v37 = React.useCallback(function() -- line: 119
		-- upvalues: v32 (copy)
		v32(false)
	end, { v32 })

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		onClose = v37
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
				BackgroundColor3 = v27.Color.Shift.Shift_200.Color3,
				BackgroundTransparency = v27.Color.Shift.Shift_200.Transparency,
				Size = UDim2.fromScale(1, 0)
			}, {
				InputBox = React.createElement("TextBox", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = v27.Typography.CaptionMedium.Font,
					LineHeight = v27.LineHeight.LineHeight_140,
					MultiLine = true,
					PlaceholderColor3 = v27.Color.Content.Muted.Color3,
					PlaceholderText = t1.placeholderText or v28.defaultPlaceholderText,
					Size = UDim2.new(1, 0, 0, v27.Size.Size_1000),
					Text = v29.current,
					TextColor3 = v27.Color.Content.Default.Color3,
					TextSize = v27.Typography.CaptionMedium.FontSize,
					TextTransparency = v27.Color.Content.Default.Transparency,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v33
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, v27.Size.Size_3000)
					})
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v27.Padding.Small),
					PaddingLeft = UDim.new(0, v27.Padding.Small),
					PaddingRight = UDim.new(0, v27.Padding.Small),
					PaddingTop = UDim.new(0, v27.Padding.Small)
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v27.Radius.Medium)
				})
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = {{
				isDisabled = not v30,
				onActivated = v34,
				text = v28.submitText,
				variant = t1.buttonVariant or ButtonVariant.Standard
			}}
		}),
		DisclaimerText = if not t1.showTermsOfUseDisclaimer or not v35 then nil else React.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansMedium,
			LayoutOrder = 5,
			LineHeight = v27.LineHeight.LineHeight_140,
			RichText = true,
			Size = UDim2.fromScale(1, 0),
			Text = v28.termsOfUseText,
			TextColor3 = v27.Color.Content.Muted.Color3,
			TextSize = v27.FontSize.FontSize_300,
			TextTransparency = v27.Color.Content.Muted.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			[React.Event.Activated] = v36
		})
	})
end

return React.memo(TextFeedbackFormModal)
