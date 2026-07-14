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
local FFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local FFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry
local v29 = game:DefineFastFlag("LuaAppCheckboxFeedbackFormTitleTextWrapping", false)

local function CheckboxFeedbackFormModal(t1: {[any]: any}) -- line: 57
	-- upvalues: useDispatch (copy), useTokens (copy), useLocalization (copy), React (copy), CloseCentralOverlay (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), Cryo (copy), Checkbox (copy), useAppPolicy (copy), AppPage (copy), UrlBuilder2 (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateDown (copy), Dialog (copy), FoundationText (copy), v29 (copy), ButtonVariant (copy), FFlagLuaAppMakeDisclaimerOptInForFeedbackForm (copy)
	local v32 = useDispatch()
	local v33 = useTokens()
	local v34 = useLocalization({
		submitText = "CommonUI.Controls.Action.Submit",
		otherPlaceholderText = "Feature.GameDetails.Label.TellUsMorePlaceholder",
		termsOfUseText = {
			"Feature.GameDetails.Message.AnonymousFeedbackTermsOfUse",
			underlineStart = "<u>",
			underlineEnd = "</u>"
		}
	})
	local v35 = React.useCallback(function(b1: boolean?) -- line: 70
		-- upvalues: v32 (copy), CloseCentralOverlay (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), t1 (copy)
		v32(CloseCentralOverlay())

		if FFlagLuaAppNotInterestedFeedbackFormTelemetry and t1.onClose then
			t1.onClose(b1)
		end
	end, {
		v32,
		t1.onClose
	})
	local v36, v37 = React.useState({})
	local v38 = React.useMemo(function() -- line: 79
		-- upvalues: Cryo (copy), t1 (copy), React (copy), Checkbox (copy), v36 (copy), v37 (copy)
		return Cryo.List.map(t1.checkboxItems, function(t2: {[any]: any}, n1: number) -- line: 80
			-- upvalues: React (copy), Checkbox (copy), v36 (copy), v37 (copy)
			local id = t2.id

			return React.createElement(Checkbox, {
				label = t2.text,
				isChecked = not not v36[id],
				LayoutOrder = n1,
				onActivated = function() -- line: 86
					-- upvalues: v36 (copy), id (copy), v37 (copy)
					local v61 = table.clone(v36)

					if v61[id] then
						v61[id] = false
						v37(v61)

						return
					end

					v61[id] = true
					v37(v61)
				end
			})
		end)
	end, {
		t1.checkboxItems,
		v36
	})
	local v39, v40 = React.useMemo(function() -- line: 100
		-- upvalues: t1 (copy), v36 (copy)
		local v51 = false
		local v52 = false

		for _, v54 in t1.checkboxItems do
			if v36[v54.id] then
				if v54.triggersOtherTextbox then
					v52 = true
				else
					v51 = true
				end
			end
		end

		return v51, v52
	end, {
		t1.checkboxItems,
		v36
	})
	local v41 = React.useRef("")
	local v42, v43 = React.useState(false)
	local v44 = if not v40 or v42 then v39 and true or not not v40 and not not v42 else false
	local v45 = React.useCallback(function(p1) -- line: 122
		-- upvalues: v41 (copy), v43 (copy)
		if not p1 then
			return
		end

		if p1.Text:len() > 500 then
			p1.Text = p1.Text:sub(1, 500)
		end

		v41.current = p1.Text
		v43(p1.Text:len() >= 10)
	end, {})
	local v46 = React.useCallback(function() -- line: 133
		-- upvalues: v44 (copy), v35 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy), t1 (copy), v36 (copy), v41 (copy)
		if not v44 then
			return
		end

		v35(not not FFlagLuaAppNotInterestedFeedbackFormTelemetry or nil)
		t1.onSubmit(v36, v41.current)
	end, {
		v44,
		t1.onSubmit,
		v36,
		v35
	})
	local v47 = useAppPolicy(function(p2) -- line: 141
		return p2.getWebViewSupport()
	end)
	local v48 = React.useCallback(function() -- line: 146
		-- upvalues: AppPage (copy), UrlBuilder2 (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), v32 (copy), NavigateDown (copy), v35 (copy), FFlagLuaAppNotInterestedFeedbackFormTelemetry (copy)
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
			v32(NavigateDown(t3, nil))
		end

		v35(not FFlagLuaAppNotInterestedFeedbackFormTelemetry and nil)
	end, {
		v32,
		v35
	})
	local v49 = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then nil else React.useCallback(function() -- line: 168
		-- upvalues: v35 (copy)
		v35(false)
	end, { v35 })

	return React.createElement(Dialog.Root, {
		hasBackdrop = true,
		onClose = if not FFlagLuaAppNotInterestedFeedbackFormTelemetry then v35 else v49
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
			}, Cryo.Dictionary.union(v38, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					fontStyle = v33.Typography.TitleLarge,
					Size = UDim2.fromScale(1, 0),
					Text = t1.checkboxListTitle,
					TextWrapped = not not v29 or nil,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, v33.Padding.Medium),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
				})
			})),
			OtherTextBoxContainer = if not v40 then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = v33.Color.Shift.Shift_200.Color3,
				BackgroundTransparency = v33.Color.Shift.Shift_200.Transparency,
				Size = UDim2.fromScale(1, 0)
			}, {
				InputBox = React.createElement("TextBox", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = v33.Typography.CaptionMedium.Font,
					LineHeight = v33.LineHeight.LineHeight_140,
					MultiLine = true,
					PlaceholderColor3 = v33.Color.Content.Muted.Color3,
					PlaceholderText = v34.otherPlaceholderText,
					Size = UDim2.new(1, 0, 0, v33.Size.Size_1000),
					Text = v41.current,
					TextColor3 = v33.Color.Content.Default.Color3,
					TextSize = v33.Typography.CaptionMedium.FontSize,
					TextTransparency = v33.Color.Content.Default.Transparency,
					TextTruncate = Enum.TextTruncate.SplitWord,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v45
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, v33.Size.Size_3000)
					})
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v33.Padding.Small),
					PaddingLeft = UDim.new(0, v33.Padding.Small),
					PaddingRight = UDim.new(0, v33.Padding.Small),
					PaddingTop = UDim.new(0, v33.Padding.Small)
				}),
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v33.Radius.Medium)
				})
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v33.Padding.XLarge),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			actions = {{
				isDisabled = not v44,
				onActivated = v46,
				text = v34.submitText,
				variant = ButtonVariant.Standard
			}}
		}),
		DisclaimerText = if FFlagLuaAppMakeDisclaimerOptInForFeedbackForm and not t1.showTermsOfUseDisclaimer or not v47 then nil else React.createElement("TextButton", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansMedium,
			LayoutOrder = 5,
			LineHeight = v33.LineHeight.LineHeight_140,
			RichText = true,
			Size = UDim2.fromScale(1, 0),
			Text = v34.termsOfUseText,
			TextColor3 = v33.Color.Content.Muted.Color3,
			TextSize = v33.FontSize.FontSize_300,
			TextTransparency = v33.Color.Content.Muted.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			[React.Event.Activated] = v48
		})
	})
end

return React.memo(CheckboxFeedbackFormModal)
