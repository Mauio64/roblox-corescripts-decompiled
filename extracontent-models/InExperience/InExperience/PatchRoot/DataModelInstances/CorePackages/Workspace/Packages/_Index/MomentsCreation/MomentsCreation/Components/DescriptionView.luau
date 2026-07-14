local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Cryo = require(MomentsCreationParent.Cryo)
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
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local Constants = require(MomentsCreation.Constants)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames

return function(t1: {[any]: any}) -- line: 46
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), GetCreationFlowStore (copy), React (copy), useSignalState (copy), useCallback (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy), Cryo (copy), makeCreationEventFields (copy), View (copy), Constants (copy), Button (copy), Foundation (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy)
	local v26 = useDeviceInsets()
	local v27 = useTokens()
	local v28 = useCreationFlowStrings()
	local v29 = GetCreationFlowStore(false)
	local v30 = React.useRef(nil)
	local PublishingCtaSecondary = v28.PublishingCtaSecondary
	local v32 = useSignalState(v29.getDescription)

	React.useEffect(function() -- line: 59
		-- upvalues: v30 (copy), v32 (copy)
		local current = v30.current

		if current ~= nil then
			current.Text = v32
		end
	end, { v32 })

	local v33 = useCallback(function() -- line: 66
		-- upvalues: v30 (copy), v29 (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy), Cryo (copy), makeCreationEventFields (copy)
		local current = v30.current

		v29.updateDescription(current == nil and "" or current.Text)

		local v37 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		fireAnalyticsEvent(EventNames.EditingFlowDescriptionEdited, Cryo.Dictionary.join(makeCreationEventFields.makeToolFieldFromKind("description"), makeCreationEventFields.makeCreationBaseFields(v37)))
	end, { v29.updateDescription })
	local v34 = useCallback(function(p1) -- line: 82
		local v39 = p1.Text:gsub("[\r\n]+", " ")
		local v40 = utf8.len(v39)

		if v40 ~= nil and v40 >= 140 then
			v39 = string.sub(v39, 1, utf8.offset(v39, 141) - 1)
		end

		if v39 ~= p1.Text then
			p1.Text = v39
		end
	end, {})

	return React.createElement(View, {
		tag = "align-x-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v27.Padding.Large),
			bottom = UDim.new(0, (math.max(v26.bottom, v27.Padding.Large))),
			left = UDim.new(0, (math.max(v26.left, v27.Padding.XLarge))),
			right = UDim.new(0, (math.max(v26.right, v27.Padding.XLarge)))
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
					PlaceholderColor3 = v27.Color.Content.Muted.Color3,
					PlaceholderText = v28.PublishingDescription,
					ref = v30,
					ShowNativeInput = true,
					TextColor3 = v27.Color.ActionStandard.Foreground.Color3,
					TextSize = v27.FontSize.FontSize_400,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v34,
					[React.Event.FocusLost] = v33
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
					text = v28.PublishingCtaPrimary,
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
				Text = v28.CreationTooltip
			})
		})
	})
end
