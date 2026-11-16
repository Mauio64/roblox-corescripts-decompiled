local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsComments = SharedFlags2.FFlagMomentsComments

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputPlacement = Foundation.Enums.InputPlacement
local InputSize = Foundation.Enums.InputSize
local Text = Foundation.Text
local Toggle = Foundation.Toggle
local View = Foundation.View

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens

local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local GeneratedTextFeedbackContainer = require(MomentsCreation.Components.GeneratedTextFeedback.GeneratedTextFeedbackContainer)

local Constants = require(MomentsCreation.Constants)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local FFlagMomentTextGenerationFilteredSignal = MomentsCommon.Flags.FFlagMomentTextGenerationFilteredSignal
local GetFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
local FFlagMomentsRenderCreatePostStatus = SharedFlags.FFlagMomentsRenderCreatePostStatus
local FFlagMomentsCommentsCreatorControl = require(MomentsCreation.Flags.FFlagMomentsCommentsCreatorControl)

local function AllowCommentsToggle(p)
	local v = useCreationFlowStrings()
	local creationFlowStore = GetCreationFlowStore(false)
	local isChecked = useSignalState(creationFlowStore.getCommentsEnabled)

	local onActivated = useCallback(function(flag: boolean)
		creationFlowStore.updateCommentsEnabled(flag)

		if FFlagMomentsComments then
			local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
			fireAnalyticsEvent(
				EventNames.MomentCommentsSettingToggled,
				Cryo.Dictionary.join(makeCreationEventFields.makeCreationBaseFields(sessionId), {
					commentsEnabled = tostring(flag)
				})
			)
		end
	end, { creationFlowStore.updateCommentsEnabled })

	return React.createElement(Toggle, {
		isChecked = isChecked,
		label = v.PublishingAllowComments,
		LayoutOrder = p.layoutOrder,
		onActivated = onActivated,
		placement = InputPlacement.End,
		size = InputSize.Medium,
		testId = "moments-allow-comments-toggle"
	})
end

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = useCreationFlowStrings()
	local creationFlowStore = GetCreationFlowStore(false)
	local ref = React.useRef(nil)

	local publishingCtaSecondary = v3.PublishingCtaSecondary

	local text = useSignalState(creationFlowStore.getDescription)

	React.useEffect(function()
		local current = ref.current

		if current ~= nil then
			current.Text = text
		end
	end, { text })

	local v4 = FFlagMomentsCommentsCreatorControl and GetFFlagMomentsUseUploadPostAsync()

	local v5 = useCallback(function()
		local current = ref.current
		creationFlowStore.updateDescription(current == nil and "" or current.Text)

		local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
		fireAnalyticsEvent(
			EventNames.EditingFlowDescriptionEdited,
			Cryo.Dictionary.join(
				makeCreationEventFields.makeToolFieldFromKind("description"),
				makeCreationEventFields.makeCreationBaseFields(sessionId)
			)
		)
	end, { creationFlowStore.updateDescription })

	local v6 = useCallback(function(p)
		local text2 = p.Text:gsub("[\r\n]+", " ")
		local v6 = utf8.len(text2)

		if v6 ~= nil and v6 >= 140 then
			text2 = string.sub(text2, 1, utf8.offset(text2, 141) - 1)
		end

		if text2 ~= p.Text then
			p.Text = text2
		end
	end, {})

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "align-x-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v2.Padding.Large),
			bottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Large))),
			left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}
	}

	local createElement2 = React.createElement
	local v8 = {
		sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
		tag = "col align-x-center gap-large size-full-0 auto-y"
	}

	local children = {
		TextBoxContainer = React.createElement(
			View,
			{ tag = "size-full-2100 padding-medium radius-medium bg-surface-100" },
			{
				TextBox = React.createElement("TextBox", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					ClipsDescendants = true,
					Font = Enum.Font.BuilderSans,
					MaxVisibleGraphemes = 140,
					MultiLine = false,
					PlaceholderColor3 = v2.Color.Content.Muted.Color3,
					PlaceholderText = v3.PublishingDescription,
					ref = ref,
					ShowNativeInput = true,
					TextColor3 = v2.Color.ActionStandard.Foreground.Color3,
					TextSize = v2.FontSize.FontSize_400,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v6,
					[React.Event.FocusLost] = v5
				})
			}
		),
		AllowComments = 0,
		GeneratedTextFeedback = 0,
		CTAs = 0,
		Disclaimer = 0
	}
	local allowComments

	if v4 then
		allowComments = React.createElement(AllowCommentsToggle, { layoutOrder = 1 })
	end

	children.AllowComments = allowComments
	local generatedTextFeedback

	if FFlagMomentTextGenerationFilteredSignal then
		generatedTextFeedback = React.createElement(GeneratedTextFeedbackContainer, {
			layoutOrder = v4 and 2 or 1
		})
	end

	children.GeneratedTextFeedback = generatedTextFeedback

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v9 = {
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		isDisabled = 0,
		isLoading = 0,
		LayoutOrder = 1,
		onActivated = 0,
		size = 0,
		text = 0,
		testId = "moments-publish-button",
		variant = 0,
		width = 0
	}
	local isDisabled

	if FFlagMomentsRenderCreatePostStatus then
		isDisabled = props.isPublishing
	end

	v9.isDisabled = isDisabled
	local isLoading

	if FFlagMomentsRenderCreatePostStatus then
		isLoading = props.isPublishing
	end

	v9.isLoading = isLoading

	v9.onActivated = props.onPublish
	v9.size = InputSize.Medium
	v9.text = v3.PublishingCtaPrimary

	v9.variant = ButtonVariant.Emphasis
	v9.width = UDim.new(0.5, 0)
	children.CTAs = createElement3(View, {
		LayoutOrder = v4 and 3 or 2,
		tag = "row align-x-center align-y-bottom gap-small position-bottom-center anchor-bottom-center size-full-0 auto-y"
	}, {
		PostButton = createElement4(Button, v9),
		ReturnToEditingButton = React.createElement(Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 2,
			text = publishingCtaSecondary,
			variant = ButtonVariant.Standard,
			width = UDim.new(0.5, 0),
			onActivated = props.onReturnToEditing,
			size = InputSize.Medium
		})
	})

	children.Disclaimer = React.createElement(Text, {
		LayoutOrder = v4 and 4 or 3,
		tag = "auto-xy text-body-small text-align-x-center text-align-y-top content-neutral",
		Text = v3.CreationTooltip
	})
	return createElement(View, v7, {
		SizeConstraint = createElement2(View, v8, children)
	})
end
