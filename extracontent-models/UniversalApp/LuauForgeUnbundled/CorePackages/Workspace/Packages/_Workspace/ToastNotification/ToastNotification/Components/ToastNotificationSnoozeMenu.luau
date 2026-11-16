local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local notificationTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type").NotificationTypeEnum
local showNotificationSnoozeMenuSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Signals").ShowNotificationSnoozeMenuSignal
local dismissNotificationSnoozeMenuSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Signals").DismissNotificationSnoozeMenuSignal
local notificationSnoozeMenuVisibleSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Signals").NotificationSnoozeMenuVisibleSignal
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/ToastNotificationSnoozeManager").default

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local cryo = dependencies.Cryo
local localization = dependencies.Localization
local react = dependencies.React
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox

local useLocalization = localization.Hooks.useLocalization

local colors = uiBlox.App.Style.Colors
local interactable = uiBlox.Core.Control.Interactable
local useCursor = uiBlox.App.SelectionCursor.useCursor
local useStyle = uiBlox.Core.Style.useStyle

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local focusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ReactFocusNavigation")

local fFlagEnableAppChatSnoozeMenuFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/SharedFlags").FFlagEnableAppChatSnoozeMenuFocus

local getFFlagAppChatInExpToastSnoozeMenuDismissFix = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/SharedFlags").GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local defineFastFlag = game:DefineFastFlag("SnoozeMenuTextXAlignment", false)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/UniversalAppPolicy")

local v5 = {
	[notificationTypeEnum.ChatNewMessage] = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party"
}

local v6 = {
	{ textKey = "fifteenMinutes", durationMinutes = 15 },
	{ textKey = "fourHours", durationMinutes = 240 },
	{ textKey = "oneDay", durationMinutes = 1440 },
	{ textKey = "untilITurnItBackOn", durationMinutes = -1 }
}

return function()
	local v7 = useStyle()
	local v8

	if fFlagEnableAppChatSnoozeMenuFocus or foundationFontFaceMigration then
		v8 = useTokens()
	else
		v8 = nil
	end

	local v9 = useLocalization(cryo.Dictionary.union(v5, {
		fifteenMinutes = "Feature.Notifications.Action.SnoozeFifteenMinutes",
		fourHours = "Feature.Notifications.Action.SnoozeFourHours",
		oneDay = "Feature.Notifications.Action.SnoozeOneDay",
		oneHour = "Feature.Notifications.Action.SnoozeOneHour",
		untilITurnItBackOn = "Feature.Notifications.Action.UntilITurnItBackOn",
		snoozeFeedback = "Feature.Notifications.Heading.SnoozeFeedback"
	}))

	local state, setState = react.useState(false)
	local state2, setState2 = react.useState({})

	local v10 = react.useCallback(function()
		setState(false)
	end, { setState })

	react.useEffect(function()
		local connection = showNotificationSnoozeMenuSignal:connect(function(p2)
			setState2(p2)
			setState(true)
		end)
		local connection2

		if getFFlagAppChatInExpToastSnoozeMenuDismissFix() then
			connection2 = dismissNotificationSnoozeMenuSignal:connect(function()
				v10()
			end)
		else
			connection2 = nil
		end

		return function()
			connection:disconnect()

			if getFFlagAppChatInExpToastSnoozeMenuDismissFix() then
				connection2:disconnect()
			end
		end
	end, { setState })
	local v11

	if fFlagEnableAppChatSnoozeMenuFocus then
		v11 = react.useMemo(function()
			local v12 = {}
			v12[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v10()
					object:cancel()
				end)
			}

			return v12
		end, { v10 })

		react.useEffect(function()
			notificationSnoozeMenuVisibleSignal:fire({ visible = state })
		end, { state })
	end

	local v12 = if fFlagEnableAppChatSnoozeMenuFocus then useCursor() else nil

	local useMemo = react.useMemo
	local function fn()
		local children = {}

		for count, v13 in ipairs(v6) do
			local createElement = react.createElement
			local v15 = {}
			v15.Size = UDim2.new(1, 0, 0, not fFlagEnableAppChatSnoozeMenuFocus and 56 or v8.Size.Size_1400)
			v15.BackgroundTransparency = 1
			local v16 = if not foundationFontFaceMigration then v7.Font.Header2.Font else nil
			v15.Font = v16

			local v17 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.TitleLarge.Font) else nil
			v15.FontFace = v17

			v15.LayoutOrder = count
			v15.SelectionImageObject = v12
			v15.Text = v9[v13.textKey]
			v15.TextSize = v7.Font.Header2.RelativeSize * v7.Font.BaseSize
			v15.TextColor3 = colors.White
			v15.TextXAlignment = Enum.TextXAlignment.Left
			v15.TextYAlignment = Enum.TextYAlignment.Center
			v15[react.Event.Activated] = function()
				if state2.notificationType then
					local v18 = state2.notificationType

					if type(state2.notificationType) == "table" then
						v18 = state2.notificationType[1]
					end

					default:snoozeNotification({
						context = state2.context,
						notificationType = state2.notificationType,
						durationMinutes = v13.durationMinutes,
						modalMessage = v9.snoozeFeedback:gsub("{title}", v9[v18] or ""):gsub(
							"{duration}",
							v9[v13.textKey]
						)
					})
				end

				setState(false)
			end

			local v18 = if fFlagEnableAppChatSnoozeMenuFocus then react.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v8.Padding.XXLarge),
				PaddingRight = UDim.new(0, v8.Padding.XXLarge)
			}) else nil

			local createElement2 = react.createElement

			local v21 = if fFlagEnableAppChatSnoozeMenuFocus then UDim2.new(1, v8.Padding.XXLarge, 0, 1) else UDim2.new(1, 0, 0, 1)
			local children2 = {
				UIPadding = v18,
				Border = createElement2("Frame", {
					Size = v21,
					BackgroundTransparency = 0.8,
					BackgroundColor3 = colors.White,
					LayoutOrder = count
				})
			}
			table.insert(children, createElement("TextButton", v15, children2))

			count += 1
		end

		return children
	end

	local v14 = if foundationFontFaceMigration then v8.Typography.TitleLarge.Font else nil
	local v15 = useMemo(fn, { state2, v14 })

	if not state then
		return nil
	end

	local createElement = react.createElement
	local v17 = {
		Size = UDim2.fromScale(1, 1),
		AutoButtonColor = false,
		BackgroundColor3 = colors.Black,
		BackgroundTransparency = 0.6,
		onStateChanged = function() end,
		[react.Event.Activated] = v10
	}

	local createElement2 = react.createElement
	local v19 = if fFlagEnableAppChatSnoozeMenuFocus then focusRoot else interactable
	local v20

	if fFlagEnableAppChatSnoozeMenuFocus then
		v20 = {
			eventHandlers = v11,
			eventMap = navigateBacks,
			frameProps = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
				BackgroundTransparency = v7.Theme.BackgroundDefault.Transparency,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, -v8.Padding.Small * 2, 0, 0)
			},
			isAutoFocusRoot = true,
			isIsolated = true,
			surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp
		}
	else
		v20 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -16, 0, 0),
			AutoButtonColor = false,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v7.Theme.BackgroundDefault.Transparency,
			onStateChanged = function() end
		}
	end

	local children = {
		UICorner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, v7.Tokens.Radius.Large)
		}),
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = 0,
		UISizeConstraint = 0,
		TitleContainer = 0,
		SnoozeOptions = 0
	}

	local v21 = if not fFlagEnableAppChatSnoozeMenuFocus then react.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 24)
	}) else nil
	children.UIPadding = v21

	children.UISizeConstraint = react.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(400, 1e999)
	})

	local createElement3 = react.createElement
	local v23 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local children2 = {
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		UIPadding = 0,
		Title = 0,
		Description = 0
	}

	local createElement4 = react.createElement
	local v25 = {
		PaddingBottom = UDim.new(0, not fFlagEnableAppChatSnoozeMenuFocus and 20 or v8.Padding.XLarge),
		PaddingRight = UDim.new(0, not fFlagEnableAppChatSnoozeMenuFocus and 24 or v8.Padding.XXLarge),
		PaddingTop = UDim.new(0, not fFlagEnableAppChatSnoozeMenuFocus and 20 or v8.Padding.XLarge),
		PaddingLeft = 0
	}

	local v26 = if fFlagEnableAppChatSnoozeMenuFocus then UDim.new(0, v8.Padding.XXLarge) else nil
	v25.PaddingLeft = v26
	children2.UIPadding = createElement4("UIPadding", v25)

	local createElement5 = react.createElement
	local v28 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		Text = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextWrapped = true,
		TextXAlignment = 0
	}

	local v29 = if not foundationFontFaceMigration then v7.Font.Body.Font else nil
	v28.Font = v29

	local v30 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else nil
	v28.FontFace = v30

	v28.Text = state2.title or ""
	v28.TextSize = v7.Font.Body.RelativeSize * v7.Font.BaseSize
	v28.TextColor3 = colors.White

	local v31 = if defineFastFlag then Enum.TextXAlignment.Left else nil
	v28.TextXAlignment = v31
	children2.Title = createElement5("TextLabel", v28)
	local v32

	if state2 and state2.description and state2.description ~= "" then
		local createElement6 = react.createElement
		local v34 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			LayoutOrder = 2,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0
		}

		local v35 = if not foundationFontFaceMigration then v7.Font.CaptionBody.Font else nil
		v34.Font = v35

		local v36 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodySmall.Font) else nil
		v34.FontFace = v36

		v34.Text = state2.description or ""
		v34.TextSize = v7.Font.CaptionBody.RelativeSize * v7.Font.BaseSize
		v34.TextColor3 = v7.Theme.TextDefault.Color
		v32 = createElement6("TextLabel", v34)
	end

	children2.Description = v32
	children.TitleContainer = createElement3("Frame", v23, children2)

	children.SnoozeOptions = react.createElement(
		"Frame",
		{
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		},
		{
			UIListLayout = react.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			SnoozeOptions = roact.createFragment(v15)
		}
	)
	return (createElement(interactable, v17, {
		SnoozeMenu = createElement2(v19, v20, children)
	}))
end
