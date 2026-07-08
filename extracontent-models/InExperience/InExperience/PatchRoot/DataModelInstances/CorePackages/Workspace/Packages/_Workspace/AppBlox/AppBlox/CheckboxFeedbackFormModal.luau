local Parent = script:FindFirstAncestor("AppBlox").Parent
local CentralOverlay = require(Parent.CentralOverlay)
local Cryo = require(Parent.Cryo)
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
local Checkbox = Foundation.Checkbox
local Dialog = Foundation.Dialog
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useLocalization = Localization.Hooks.useLocalization
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v22 = if not FFlagSignalsNavP3Dispatch then nil else require(Parent.RobloxAppNavigation).NavigationCommands
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AppPage = RobloxAppEnums.AppPage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local UrlBuilder2 = UrlBuilder.UrlBuilder
local v27 = game:DefineFastFlag("FixCheckboxFeedbackFormModalTermsOfUseWebView", false)
local v28 = game:DefineFastFlag("LuaAppSupportNewDefaultDialogBehavior", false)
local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local v31 = game:DefineFastFlag("LuaAppCheckboxFeedbackFormTitleTextWrapping", false)

local function CheckboxFeedbackFormModal(t1: {[any]: any}) -- line: 60
	-- upvalues: useDispatch (copy), useTokens (copy), useLocalization (copy), React (copy), CloseCentralOverlay (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), Cryo (copy), Checkbox (copy), v27 (copy), useAppPolicy (copy), AppPage (copy), UrlBuilder2 (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateDown (copy), Dialog (copy), v28 (copy), FoundationText (copy), v31 (copy), ButtonVariant (copy), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy)
	local v34 = useDispatch()
	local v35 = useTokens()
	local v36 = useLocalization({
		submitText = "CommonUI.Controls.Action.Submit",
		otherPlaceholderText = "Feature.GameDetails.Label.TellUsMorePlaceholder",
		termsOfUseText = {
			"Feature.GameDetails.Message.AnonymousFeedbackTermsOfUse",
			underlineStart = "<u>",
			underlineEnd = "</u>"
		}
	})
	local v37 = React.useCallback(function(b1: boolean?) -- line: 73
		-- upvalues: v34 (copy), CloseCentralOverlay (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), t1 (copy)
		v34(CloseCentralOverlay())

		if FFlagLuaAppNotInterestedFeedbackFormTelemetry and t1.onClose then
			t1.onClose(b1)
		end
	end, {
		v34,
		t1.onClose
	})
	local v38, v39 = React.useState({})
	local v40 = React.useMemo(function() -- line: 82
		-- upvalues: Cryo (copy), t1 (copy), React (copy), Checkbox (copy), v38 (copy), v39 (copy)
		return Cryo.List.map(t1.checkboxItems, function(t2: {[any]: any}, n1: number) -- line: 83
			-- upvalues: React (copy), Checkbox (copy), v38 (copy), v39 (copy)
			local id = t2.id

			return React.createElement(Checkbox, {
				label = t2.text,
				isChecked = not not v38[id],
				LayoutOrder = n1,
				onActivated = function() -- line: 89
					-- upvalues: v38 (copy), id (copy), v39 (copy)
					local v64 = table.clone(v38)

					if v64[id] then
						v64[id] = false
						v39(v64)

						return
					end

					v64[id] = true
					v39(v64)
				end
			})
		end)
	end, {
		t1.checkboxItems,
		v38
	})
	local v41, v42 = React.useMemo(function() -- line: 103
		-- upvalues: t1 (copy), v38 (copy)
		local v53 = false
		local v54 = false

		for _, v56 in t1.checkboxItems do
			if v38[v56.id] then
				if v56.triggersOtherTextbox then
					v54 = true
				else
					v53 = true
				end
			end
		end

		return v53, v54
	end, {
		t1.checkboxItems,
		v38
	})
	local v43 = React.useRef("")
	local v44, v45 = React.useState(false)
	local v46 = if not v42 or v44 then v41 and true or not not v42 and not not v44 else false
	local v47 = React.useCallback(function(p1) -- line: 125
		-- upvalues: v43 (copy), v45 (copy)
		if not p1 then
			return
		end

		if p1.Text:len() > 500 then
			p1.Text = p1.Text:sub(1, 500)
		end

		v43.current = p1.Text
		v45(p1.Text:len() >= 10)
	end, {})
	local v48 = React.useCallback(function() -- line: 136
		-- upvalues: v46 (copy), v37 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), t1 (copy), v38 (copy), v43 (copy)
		if not v46 then
			return
		end

		v37(not not FFlagLuaAppNotInterestedFeedbackFormTelemetry or nil)
		t1.onSubmit(v38, v43.current)
	end, {
		v46,
		t1.onSubmit,
		v38,
		v37
	})
	local v49 = nil

	if v27 then
		v49 = useAppPolicy(function(p2) -- line: 146
			return p2.getWebViewSupport()
		end)
	end

	local v50 = React.useCallback(function() -- line: 152
		-- upvalues: v27 (copy), AppPage (copy), UrlBuilder2 (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), v34 (copy), NavigateDown (copy), v37 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy)
		if v27 then
			local t3 = {
				name = AppPage.GenericWebPage,
				detail = UrlBuilder2.static.about.terms(),
				extraProps = {
					title = ""
				}
			}

			if FFlagSignalsNavP3Dispatch then
				v22.down(v22.fromLegacyPage(t3), nil)
			else
				v34(NavigateDown(t3, nil))
			end
		else
			local t4 = {
				name = AppPage.GenericWebPage,
				detail = UrlBuilder2.static.about.terms()
			}

			if FFlagSignalsNavP3Dispatch then
				v22.down(v22.fromLegacyPage(t4))
			else
				v34(NavigateDown(t4))
			end
		end

		v37(not FFlagLuaAppNotInterestedFeedbackFormTelemetry and nil)
	end, {
		v34,
		v37
	})
	local v51 = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else React.useCallback(function() -- line: 186
		-- upvalues: v37 (copy)
		v37(false)
	end, { v37 })

	return React.createElement(Dialog.Root, {
		onClose = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then v37 else v51,
		hasBackdrop = not not v28 or nil
	}, {
		DialogTitle = if not t1.dialogTitle then nil else React.createElement(Dialog.Title, {
			text = t1.dialogTitle
		}),
		DialogText = React.createElement(Dialog.Text, {
			LayoutOrder = 2,
			Text = t1.dialogText
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 3
		}, {
			CheckboxListWrapper = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, Cryo.Dictionary.union(v40, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					fontStyle = v35.Typography.TitleLarge,
					Size = UDim2.fromScale(1, 0),
					Text = t1.checkboxListTitle,
					TextWrapped = not not v31 or nil,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, v35.Padding.Medium),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
				})
			})),
			OtherTextBoxContainer = if not v42 then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = v35.Color.Shift.Shift_200.Color3,
				BackgroundTransparency = v35.Color.Shift.Shift_200.Transparency,
				Size = UDim2.fromScale(1, 0)
			}, {
				InputBox = React.createElement("TextBox", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = v35.Typography.CaptionMedium.Font,
					LineHeight = v35.LineHeight.LineHeight_140,
					MultiLine = true,
					PlaceholderColor3 = v35.Color.Content.Muted.Color3,
					PlaceholderText = v36.otherPlaceholderText,
					Size = UDim2.new(1, 0, 0, v35.Size.Size_1000),
					Text = v43.current,
					TextColor3 = v35.Color.Content.Default.Color3,
					TextSize = v35.Typography.CaptionMedium.FontSize,
					TextTransparency = v35.Color.Content.Default.Transparency,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v47
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, v35.Size.Size_3000)
					})
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v35.Padding.Small),
					PaddingLeft = UDim.new(0, v35.Padding.Small),
					PaddingRight = UDim.new(0, v35.Padding.Small),
					PaddingTop = UDim.new(0, v35.Padding.Small)
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v35.Radius.Medium)
				})
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v35.Padding.XLarge),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = {{
				isDisabled = not v46,
				onActivated = v48,
				text = v36.submitText,
				variant = ButtonVariant.Standard
			}}
		}),
		DisclaimerText = if FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and not t1.showTermsOfUseDisclaimer or not not v27 and not v49 then nil else React.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansMedium,
			LayoutOrder = 5,
			LineHeight = v35.LineHeight.LineHeight_140,
			RichText = true,
			Size = UDim2.fromScale(1, 0),
			Text = v36.termsOfUseText,
			TextColor3 = v35.Color.Content.Muted.Color3,
			TextSize = v35.FontSize.FontSize_300,
			TextTransparency = v35.Color.Content.Muted.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			[React.Event.Activated] = v50
		})
	})
end

return React.memo(CheckboxFeedbackFormModal)
