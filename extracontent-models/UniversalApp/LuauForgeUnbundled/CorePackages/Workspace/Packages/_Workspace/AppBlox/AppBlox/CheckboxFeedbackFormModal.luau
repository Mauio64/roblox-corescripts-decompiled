local CentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/CentralOverlay")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
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
local checkbox = Foundation.Checkbox
local dialog = Foundation.Dialog
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useLocalization = Localization.Hooks.useLocalization
local navigateDown = NavigationRodux.Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppNavigation").NavigationCommands else nil

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local appPage = RobloxAppEnums.AppPage
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local urlBuilder = UrlBuilder.UrlBuilder

local fFlagLuaAppMakeDisclaimerOptInForFeedbackForm = SharedFlags.FFlagLuaAppMakeDisclaimerOptInForFeedbackForm
local fFlagLuaAppNotInterestedFeedbackFormTelemetry = SharedFlags.FFlagLuaAppNotInterestedFeedbackFormTelemetry

local defineFastFlag = game:DefineFastFlag("LuaAppCheckboxFeedbackFormTitleTextWrapping", false)

local function CheckboxFeedbackFormModal(props)
	local v5 = useDispatch()
	local v6 = useTokens()
	local v7 = useLocalization({
		submitText = "CommonUI.Controls.Action.Submit",
		otherPlaceholderText = "Feature.GameDetails.Label.TellUsMorePlaceholder",
		termsOfUseText = {
			"Feature.GameDetails.Message.AnonymousFeedbackTermsOfUse",
			underlineStart = "<u>",
			underlineEnd = "</u>"
		}
	})

	local v8 = React.useCallback(function(p2)
		v5(closeCentralOverlay())

		if fFlagLuaAppNotInterestedFeedbackFormTelemetry and props.onClose then
			props.onClose(p2)
		end
	end, { v5, props.onClose })

	local state, setState = React.useState({})

	local v9 = React.useMemo(function()
		return Cryo.List.map(props.checkboxItems, function(p2, p3)
			local id = p2.id
			return React.createElement(checkbox, {
				label = p2.text,
				isChecked = state[id] and true or false,
				LayoutOrder = p3,
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

	local v10, v11 = React.useMemo(function()
		local v12 = false
		local v13 = false

		for k, checkboxItem in props.checkboxItems do
			if not state[checkboxItem.id] then
				continue
			end

			if checkboxItem.triggersOtherTextbox then
				v13 = true
			else
				v12 = true
			end
		end

		return v12, v13
	end, { props.checkboxItems, state })

	local ref = React.useRef("")
	local state2, setState2 = React.useState(false)
	local v12 = not (v11 and not state2) and ((v10 or v11 and state2) and true or false)
	local v13 = React.useCallback(function(p2)
		if not p2 then
			return
		end

		if p2.Text:len() > 500 then
			p2.Text = p2.Text:sub(1, 500)
		end

		ref.current = p2.Text
		setState2(p2.Text:len() >= 10)
	end, {})

	local v14 = React.useCallback(function()
		if not v12 then
			return
		end

		v8(fFlagLuaAppNotInterestedFeedbackFormTelemetry and true or nil)
		props.onSubmit(state, ref.current)
	end, { v12, props.onSubmit, state, v8 })

	local v15 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local v16 = React.useCallback(function()
		local v17 = {
			name = appPage.GenericWebPage,
			detail = urlBuilder.static.about.terms(),
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v17), nil)
		else
			v5(navigateDown(v17, nil))
		end

		v8(if fFlagLuaAppNotInterestedFeedbackFormTelemetry then false else nil)
	end, { v5, v8 })
	local v17

	if fFlagLuaAppNotInterestedFeedbackFormTelemetry then
		v17 = React.useCallback(function()
			v8(false)
		end, { v8 })
	end

	local createElement = React.createElement
	local root = dialog.Root

	if not fFlagLuaAppNotInterestedFeedbackFormTelemetry then
		v17 = v8
	end

	local v19 = if props.dialogTitle then React.createElement(dialog.Title, {
		text = props.dialogTitle
	}) else nil
	local children = {
		DialogTitle = v19,
		DialogText = React.createElement(dialog.Text, {
			Text = props.dialogText,
			LayoutOrder = 2
		}),
		DialogContent = 0,
		DialogActions = 0,
		DisclaimerText = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	local v21 = {
		CheckboxListWrapper = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0)
		}, Cryo.Dictionary.union(v9, {
			Title = React.createElement(text, {
				AutomaticSize = Enum.AutomaticSize.Y,
				fontStyle = v6.Typography.TitleLarge,
				LayoutOrder = 0,
				Size = UDim2.fromScale(1, 0),
				Text = props.checkboxListTitle,
				TextWrapped = defineFastFlag and true or nil,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v6.Padding.Medium),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			})
		})),
		OtherTextBoxContainer = 0,
		UIListLayout = 0
	}
	local v22

	if v11 then
		v22 = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = v6.Color.Shift.Shift_200.Color3,
			BackgroundTransparency = v6.Color.Shift.Shift_200.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.fromScale(1, 0)
		}, {
			InputBox = React.createElement("TextBox", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ClearTextOnFocus = false,
				FontFace = normalizeFontFace(v6.Typography.CaptionMedium.Font),
				LineHeight = v6.LineHeight.LineHeight_140,
				MultiLine = true,
				PlaceholderColor3 = v6.Color.Content.Muted.Color3,
				PlaceholderText = v7.otherPlaceholderText,
				Size = UDim2.new(1, 0, 0, v6.Size.Size_1000),
				Text = ref.current,
				TextColor3 = v6.Color.Content.Default.Color3,
				TextSize = v6.Typography.CaptionMedium.FontSize,
				TextTransparency = v6.Color.Content.Default.Transparency,
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				[React.Change.Text] = v13
			}, {
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
			})
		})
	end

	v21.OtherTextBoxContainer = v22

	v21.UIListLayout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0, v6.Padding.XLarge),
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Top
	})
	children.DialogContent = createElement2(content, { LayoutOrder = 3 }, v21)

	children.DialogActions = React.createElement(dialog.Actions, {
		actions = {
			{
				isDisabled = not v12,
				onActivated = v14,
				text = v7.submitText,
				variant = buttonVariant.Standard
			}
		},
		LayoutOrder = 4
	})
	local v23

	if not (fFlagLuaAppMakeDisclaimerOptInForFeedbackForm and not props.showTermsOfUseDisclaimer or not v15) then
		v23 = React.createElement("TextButton", {
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
			[React.Event.Activated] = v16
		})
	end

	children.DisclaimerText = v23
	return createElement(root, { onClose = v17, hasBackdrop = true }, children)
end

return React.memo(CheckboxFeedbackFormModal)
