local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local notificationTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type").NotificationTypeEnum
local showNotificationSnoozeMenuSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Signals").ShowNotificationSnoozeMenuSignal
local dismissNotificationSnoozeMenuSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Signals").DismissNotificationSnoozeMenuSignal
local notificationSnoozeMenuVisibleSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Signals").NotificationSnoozeMenuVisibleSignal
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/ToastNotificationSnoozeManager").default

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

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
	local v8 = useTokens()
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

	local v13 = react.useMemo(function()
		local children = {}

		for count, v14 in ipairs(v6) do
			local createElement = react.createElement
			local v16 = {
				Size = UDim2.new(1, 0, 0, not fFlagEnableAppChatSnoozeMenuFocus and 56 or v8.Size.Size_1400),
				BackgroundTransparency = 1,
				FontFace = normalizeFontFace(v8.Typography.TitleLarge.Font),
				LayoutOrder = count,
				SelectionImageObject = v12,
				Text = v9[v14.textKey],
				TextSize = v7.Font.Header2.RelativeSize * v7.Font.BaseSize,
				TextColor3 = colors.White,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				[react.Event.Activated] = function()
					if state2.notificationType then
						local v17 = state2.notificationType

						if type(state2.notificationType) == "table" then
							v17 = state2.notificationType[1]
						end

						default:snoozeNotification({
							context = state2.context,
							notificationType = state2.notificationType,
							durationMinutes = v14.durationMinutes,
							modalMessage = v9.snoozeFeedback:gsub("{title}", v9[v17] or ""):gsub(
								"{duration}",
								v9[v14.textKey]
							)
						})
					end

					setState(false)
				end
			}

			local v17 = if fFlagEnableAppChatSnoozeMenuFocus then react.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v8.Padding.XXLarge),
				PaddingRight = UDim.new(0, v8.Padding.XXLarge)
			}) else nil

			local createElement2 = react.createElement

			local v20 = if fFlagEnableAppChatSnoozeMenuFocus then UDim2.new(1, v8.Padding.XXLarge, 0, 1) else UDim2.new(1, 0, 0, 1)
			local children2 = {
				UIPadding = v17,
				Border = createElement2("Frame", {
					Size = v20,
					BackgroundTransparency = 0.8,
					BackgroundColor3 = colors.White,
					LayoutOrder = count
				})
			}
			table.insert(children, createElement("TextButton", v16, children2))

			count += 1
		end

		return children
	end, { state2, v8.Typography.TitleLarge.Font })

	if not state then
		return nil
	end

	local createElement = react.createElement
	local v15 = {
		Size = UDim2.fromScale(1, 1),
		AutoButtonColor = false,
		BackgroundColor3 = colors.Black,
		BackgroundTransparency = 0.6,
		onStateChanged = function() end,
		[react.Event.Activated] = v10
	}

	local createElement2 = react.createElement
	local v17 = if fFlagEnableAppChatSnoozeMenuFocus then focusRoot else interactable
	local v18

	if fFlagEnableAppChatSnoozeMenuFocus then
		v18 = {
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
		v18 = {
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

	local v19 = if not fFlagEnableAppChatSnoozeMenuFocus then react.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 24)
	}) else nil
	children.UIPadding = v19

	children.UISizeConstraint = react.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(400, 1e999)
	})

	local createElement3 = react.createElement
	local v21 = {
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
	local v23 = {
		PaddingBottom = UDim.new(0, not fFlagEnableAppChatSnoozeMenuFocus and 20 or v8.Padding.XLarge),
		PaddingRight = UDim.new(0, not fFlagEnableAppChatSnoozeMenuFocus and 24 or v8.Padding.XXLarge),
		PaddingTop = UDim.new(0, not fFlagEnableAppChatSnoozeMenuFocus and 20 or v8.Padding.XLarge),
		PaddingLeft = 0
	}

	local v24 = if fFlagEnableAppChatSnoozeMenuFocus then UDim.new(0, v8.Padding.XXLarge) else nil
	v23.PaddingLeft = v24
	children2.UIPadding = createElement4("UIPadding", v23)

	local createElement5 = react.createElement
	local v26 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(v8.Typography.BodyLarge.Font),
		LayoutOrder = 1,
		Text = state2.title or "",
		TextSize = v7.Font.Body.RelativeSize * v7.Font.BaseSize,
		TextColor3 = colors.White,
		TextWrapped = true,
		TextXAlignment = 0
	}

	local v27 = if defineFastFlag then Enum.TextXAlignment.Left else nil
	v26.TextXAlignment = v27
	children2.Title = createElement5("TextLabel", v26)

	local v28 = if state2 and state2.description and state2.description ~= "" then react.createElement("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(v8.Typography.BodySmall.Font),
		LayoutOrder = 2,
		Text = state2.description or "",
		TextSize = v7.Font.CaptionBody.RelativeSize * v7.Font.BaseSize,
		TextColor3 = v7.Theme.TextDefault.Color
	}) else nil
	children2.Description = v28
	children.TitleContainer = createElement3("Frame", v21, children2)

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
			SnoozeOptions = roact.createFragment(v13)
		}
	)
	return (createElement(interactable, v15, {
		SnoozeMenu = createElement2(v17, v18, children)
	}))
end
