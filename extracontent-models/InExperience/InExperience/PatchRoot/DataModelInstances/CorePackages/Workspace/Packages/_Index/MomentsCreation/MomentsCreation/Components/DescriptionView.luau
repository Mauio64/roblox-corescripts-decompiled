local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local FoundationText = Foundation.Text
local View = Foundation.View
local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens
local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local Constants = require(MomentsCreation.Constants)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
local EventNames = MomentsCommon.Analytics.EventNames

return function(t1: {[any]: any}) -- line: 42
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), GetCreationFlowStore (copy), React (copy), useSignalState (copy), useCallback (copy), fireAnalyticsEvent (copy), EventNames (copy), View (copy), Constants (copy), Button (copy), Foundation (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy)
	local v22 = useDeviceInsets()
	local v23 = useTokens()
	local v24 = useCreationFlowStrings()
	local v25 = GetCreationFlowStore(false)
	local v26 = React.useRef(nil)
	local PublishingCtaSecondary = v24.PublishingCtaSecondary
	local v28 = useSignalState(v25.getDescription)

	React.useEffect(function() -- line: 55
		-- upvalues: v26 (copy), v28 (copy)
		local current = v26.current

		if current ~= nil then
			current.Text = v28
		end
	end, { v28 })

	local v29 = useCallback(function() -- line: 62
		-- upvalues: v26 (copy), v25 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		local current = v26.current

		v25.updateDescription(current == nil and "" or current.Text)
		fireAnalyticsEvent(EventNames.EditingFlowDescriptionEdited)
	end, { v25.updateDescription })
	local v30 = useCallback(function(p1) -- line: 69
		local v34 = p1.Text:gsub("[\r\n]+", " ")
		local v35 = utf8.len(v34)

		if v35 ~= nil and v35 >= 140 then
			v34 = string.sub(v34, 1, utf8.offset(v34, 141) - 1)
		end

		if v34 ~= p1.Text then
			p1.Text = v34
		end
	end, {})

	return React.createElement(View, {
		tag = "align-x-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v23.Padding.Large),
			bottom = UDim.new(0, (math.max(v22.bottom, v23.Padding.Large))),
			left = UDim.new(0, (math.max(v22.left, v23.Padding.XLarge))),
			right = UDim.new(0, (math.max(v22.right, v23.Padding.XLarge)))
		}
	}, {
		SizeConstraint = React.createElement(View, {
			tag = "col align-x-center gap-large size-full-0 auto-y",
			sizeConstraint = {
				MaxSize = Constants.BottomBarSizeConstraint
			}
		}, {
			TextBoxContainer = React.createElement(View, {
				tag = "size-full-2100 padding-medium radius-medium bg-surface-100"
			}, {
				TextBox = React.createElement("TextBox", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					ClipsDescendants = true,
					Font = Enum.Font.BuilderSans,
					MaxVisibleGraphemes = 140,
					MultiLine = false,
					PlaceholderColor3 = v23.Color.Content.Muted.Color3,
					PlaceholderText = v24.PublishingDescription,
					ref = v26,
					ShowNativeInput = true,
					TextColor3 = v23.Color.ActionStandard.Foreground.Color3,
					TextSize = v23.FontSize.FontSize_400,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v30,
					[React.Event.FocusLost] = v29
				})
			}),
			CTAs = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-x-center align-y-bottom gap-small position-bottom-center anchor-bottom-center size-full-0 auto-y"
			}, {
				PostButton = React.createElement(Button, {
					LayoutOrder = 1,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					onActivated = t1.onPublish,
					size = InputSize.Medium,
					text = v24.PublishingCtaPrimary,
					variant = ButtonVariant.Emphasis,
					width = UDim.new(0.5, 0)
				}),
				ReturnToEditingButton = React.createElement(Button, {
					LayoutOrder = 2,
					fillBehavior = Foundation.Enums.FillBehavior.Fill,
					text = PublishingCtaSecondary,
					variant = ButtonVariant.Standard,
					width = UDim.new(0.5, 0),
					onActivated = t1.onReturnToEditing,
					size = InputSize.Medium
				})
			}),
			Disclaimer = React.createElement(FoundationText, {
				LayoutOrder = 3,
				tag = "auto-xy text-body-small text-align-x-center text-align-y-top content-neutral",
				Text = v24.CreationTooltip
			})
		})
	})
end
