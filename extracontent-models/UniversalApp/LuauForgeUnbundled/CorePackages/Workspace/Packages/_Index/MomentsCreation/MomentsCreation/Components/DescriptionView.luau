local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags")
local fFlagMomentsComments = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsComments

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputPlacement = Foundation.Enums.InputPlacement
local inputSize = Foundation.Enums.InputSize
local text = Foundation.Text
local toggle = Foundation.Toggle
local view = Foundation.View

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens

local GetCreationFlowStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetCreationFlowStore")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local GeneratedTextFeedbackContainer = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/GeneratedTextFeedback/GeneratedTextFeedbackContainer")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local fFlagMomentTextGenerationFilteredSignal = MomentsCommon.Flags.FFlagMomentTextGenerationFilteredSignal
local getFFlagMomentsUseUploadPostAsync = MomentsCommon.Flags.GetFFlagMomentsUseUploadPostAsync
local fFlagMomentsRenderCreatePostStatus = SharedFlags.FFlagMomentsRenderCreatePostStatus
local FFlagMomentsCommentsCreatorControl = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCommentsCreatorControl")

local function AllowCommentsToggle(p2)
	local v5 = useCreationFlowStrings()
	local v6 = GetCreationFlowStore(false)
	local v7 = useSignalState(v6.getCommentsEnabled)

	local v8 = useCallback(function(p3)
		v6.updateCommentsEnabled(p3)

		if fFlagMomentsComments then
			local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
			fireAnalyticsEvent(
				eventNames.MomentCommentsSettingToggled,
				Cryo.Dictionary.join(makeCreationEventFields.makeCreationBaseFields(sessionId), {
					commentsEnabled = tostring(p3)
				})
			)
		end
	end, { v6.updateCommentsEnabled })

	return React.createElement(toggle, {
		isChecked = v7,
		label = v5.PublishingAllowComments,
		LayoutOrder = p2.layoutOrder,
		onActivated = v8,
		placement = inputPlacement.End,
		size = inputSize.Medium,
		testId = "moments-allow-comments-toggle"
	})
end

return function(props)
	local v5 = useDeviceInsets()
	local v6 = useTokens()
	local v7 = useCreationFlowStrings()
	local v8 = GetCreationFlowStore(false)
	local ref = React.useRef(nil)

	local publishingCtaSecondary = v7.PublishingCtaSecondary

	local v9 = useSignalState(v8.getDescription)

	React.useEffect(function()
		local current = ref.current

		if current ~= nil then
			current.Text = v9
		end
	end, { v9 })

	local v10 = FFlagMomentsCommentsCreatorControl and getFFlagMomentsUseUploadPostAsync()

	local v11 = useCallback(function()
		local current = ref.current
		v8.updateDescription(current == nil and "" or current.Text)

		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
		fireAnalyticsEvent(
			eventNames.EditingFlowDescriptionEdited,
			Cryo.Dictionary.join(
				makeCreationEventFields.makeToolFieldFromKind("description"),
				makeCreationEventFields.makeCreationBaseFields(sessionId)
			)
		)
	end, { v8.updateDescription })

	local v12 = useCallback(function(p2)
		local v13 = p2.Text:gsub("[\r\n]+", " ")
		local v14 = utf8.len(v13)

		if v14 ~= nil and v14 >= 140 then
			v13 = string.sub(v13, 1, utf8.offset(v13, 141) - 1)
		end

		if v13 ~= p2.Text then
			p2.Text = v13
		end
	end, {})

	local createElement = React.createElement
	local v14 = {
		LayoutOrder = props.layoutOrder,
		tag = "align-x-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v6.Padding.Large),
			bottom = UDim.new(0, (math.max(v5.bottom, v6.Padding.Large))),
			left = UDim.new(0, (math.max(v5.left, v6.Padding.XLarge))),
			right = UDim.new(0, (math.max(v5.right, v6.Padding.XLarge)))
		}
	}

	local createElement2 = React.createElement
	local v17 = {
		sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
		tag = "col align-x-center gap-large size-full-0 auto-y"
	}

	local children = {
		TextBoxContainer = React.createElement(
			view,
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
					PlaceholderColor3 = v6.Color.Content.Muted.Color3,
					PlaceholderText = v7.PublishingDescription,
					ref = ref,
					ShowNativeInput = true,
					TextColor3 = v6.Color.ActionStandard.Foreground.Color3,
					TextSize = v6.FontSize.FontSize_400,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					[React.Change.Text] = v12,
					[React.Event.FocusLost] = v11
				})
			}
		),
		AllowComments = 0,
		GeneratedTextFeedback = 0,
		CTAs = 0,
		Disclaimer = 0
	}

	local v21 = if v10 then React.createElement(AllowCommentsToggle, {
		layoutOrder = 1
	}) else nil
	children.AllowComments = v21

	local v22 = if fFlagMomentTextGenerationFilteredSignal then React.createElement(GeneratedTextFeedbackContainer, {
		layoutOrder = v10 and 2 or 1
	}) else nil
	children.GeneratedTextFeedback = v22

	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local v26 = {
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
	local v27 = if fFlagMomentsRenderCreatePostStatus then props.isPublishing else nil
	v26.isDisabled = v27
	local v28 = if fFlagMomentsRenderCreatePostStatus then props.isPublishing else nil
	v26.isLoading = v28

	v26.onActivated = props.onPublish
	v26.size = inputSize.Medium
	v26.text = v7.PublishingCtaPrimary

	v26.variant = buttonVariant.Emphasis
	v26.width = UDim.new(0.5, 0)
	children.CTAs = createElement5(view, {
		LayoutOrder = v10 and 3 or 2,
		tag = "row align-x-center align-y-bottom gap-small position-bottom-center anchor-bottom-center size-full-0 auto-y"
	}, {
		PostButton = createElement6(button, v26),
		ReturnToEditingButton = React.createElement(button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 2,
			text = publishingCtaSecondary,
			variant = buttonVariant.Standard,
			width = UDim.new(0.5, 0),
			onActivated = props.onReturnToEditing,
			size = inputSize.Medium
		})
	})

	children.Disclaimer = React.createElement(text, {
		LayoutOrder = v10 and 4 or 3,
		tag = "auto-xy text-body-small text-align-x-center text-align-y-top content-neutral",
		Text = v7.CreationTooltip
	})
	return createElement(view, v14, {
		SizeConstraint = createElement2(view, v17, children)
	})
end
