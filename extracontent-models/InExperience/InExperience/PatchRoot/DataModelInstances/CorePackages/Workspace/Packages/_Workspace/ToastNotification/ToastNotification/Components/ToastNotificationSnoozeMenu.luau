local parent = script.Parent.Parent
local parent2 = parent.Parent

local dependencies = require(parent.dependencies)
local kind = require(parent.type)
local notificationTypeEnum = kind.NotificationTypeEnum
local Signals = require(parent.Signals)
local ShowNotificationSnoozeMenuSignal = Signals.ShowNotificationSnoozeMenuSignal
local Signals2 = require(parent.Signals)
local DismissNotificationSnoozeMenuSignal = Signals2.DismissNotificationSnoozeMenuSignal
local Signals3 = require(parent.Signals)
local NotificationSnoozeMenuVisibleSignal = Signals3.NotificationSnoozeMenuVisibleSignal
local ToastNotificationSnoozeManager = require(parent.ToastNotificationSnoozeManager)
local default = ToastNotificationSnoozeManager.default

local Foundation = require(parent2.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require(parent2.InputHandlers)
require(parent2.ReactFocusNavigation)

local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableAppChatSnoozeMenuFocus = SharedFlags.FFlagEnableAppChatSnoozeMenuFocus

local SharedFlags2 = require(parent2.SharedFlags)
local GetFFlagAppChatInExpToastSnoozeMenuDismissFix = SharedFlags2.GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local defineFastFlag = game:DefineFastFlag("SnoozeMenuTextXAlignment", false)

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local UniversalAppPolicy = require(parent2.UniversalAppPolicy)

local v = {
	[notificationTypeEnum.ChatNewMessage] = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "CommonUI.Features.Label.Chat" or "Feature.Squads.Label.Party"
}

local v2 = {
	{ textKey = "fifteenMinutes", durationMinutes = 15 },
	{ textKey = "fourHours", durationMinutes = 240 },
	{ textKey = "oneDay", durationMinutes = 1440 },
	{ textKey = "untilITurnItBackOn", durationMinutes = -1 }
}

return function()
	local v3 = useStyle()
	local v4

	if FFlagEnableAppChatSnoozeMenuFocus or FoundationFontFaceMigration then
		v4 = useTokens()
	else
		v4 = nil
	end

	local v5 = useLocalization((cryo.Dictionary.union(v, {
		fifteenMinutes = "Feature.Notifications.Action.SnoozeFifteenMinutes",
		fourHours = "Feature.Notifications.Action.SnoozeFourHours",
		oneDay = "Feature.Notifications.Action.SnoozeOneDay",
		oneHour = "Feature.Notifications.Action.SnoozeOneHour",
		untilITurnItBackOn = "Feature.Notifications.Action.UntilITurnItBackOn",
		snoozeFeedback = "Feature.Notifications.Heading.SnoozeFeedback"
	})))

	local state, setState = react.useState(false)
	local state2, setState2 = react.useState({})

	local v6 = react.useCallback(function()
		setState(false)
	end, { setState })

	react.useEffect(function()
		local connection = ShowNotificationSnoozeMenuSignal:connect(function(p)
			setState2(p)
			setState(true)
		end)
		local connection2

		if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
			connection2 = DismissNotificationSnoozeMenuSignal:connect(function()
				v6()
			end)
		else
			connection2 = nil
		end

		return function()
			connection:disconnect()

			if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
				connection2:disconnect()
			end
		end
	end, { setState })
	local eventHandlers

	if FFlagEnableAppChatSnoozeMenuFocus then
		eventHandlers = react.useMemo(function()
			local v7 = {}
			v7[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v6()
					object:cancel()
				end)
			}

			return v7
		end, { v6 })

		react.useEffect(function()
			NotificationSnoozeMenuVisibleSignal:fire({ visible = state })
		end, { state })
	end

	local selectionImageObject

	if FFlagEnableAppChatSnoozeMenuFocus then
		selectionImageObject = useCursor()
	else
		selectionImageObject = nil
	end

	local useMemo = react.useMemo
	local function fn()
		local children = {}

		for count, v7 in ipairs(v2) do
			local createElement = react.createElement
			local v8 = {}
			v8.Size = UDim2.new(1, 0, 0, not FFlagEnableAppChatSnoozeMenuFocus and 56 or v4.Size.Size_1400)
			v8.BackgroundTransparency = 1
			local font

			if not FoundationFontFaceMigration then
				font = v3.Font.Header2.Font
			end

			v8.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(v4.Typography.TitleLarge.Font)
			end

			v8.FontFace = fontFace

			v8.LayoutOrder = count
			v8.SelectionImageObject = selectionImageObject
			v8.Text = v5[v7.textKey]
			v8.TextSize = v3.Font.Header2.RelativeSize * v3.Font.BaseSize
			v8.TextColor3 = colors.White
			v8.TextXAlignment = Enum.TextXAlignment.Left
			v8.TextYAlignment = Enum.TextYAlignment.Center
			v8[react.Event.Activated] = function()
				if state2.notificationType then
					local v9 = state2.notificationType

					if type(state2.notificationType) == "table" then
						v9 = state2.notificationType[1]
					end

					default:snoozeNotification({
						context = state2.context,
						notificationType = state2.notificationType,
						durationMinutes = v7.durationMinutes,
						modalMessage = v5.snoozeFeedback:gsub("{title}", v5[v9] or ""):gsub(
							"{duration}",
							v5[v7.textKey]
						)
					})
				end

				setState(false)
			end

			local uiPadding

			if FFlagEnableAppChatSnoozeMenuFocus then
				uiPadding = react.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v4.Padding.XXLarge),
					PaddingRight = UDim.new(0, v4.Padding.XXLarge)
				})
			end

			local createElement2 = react.createElement
			local size

			if FFlagEnableAppChatSnoozeMenuFocus then
				size = UDim2.new(1, v4.Padding.XXLarge, 0, 1)
			else
				size = UDim2.new(1, 0, 0, 1)
			end

			local children2 = {
				UIPadding = uiPadding,
				Border = createElement2("Frame", {
					Size = size,
					BackgroundTransparency = 0.8,
					BackgroundColor3 = colors.White,
					LayoutOrder = count
				})
			}
			table.insert(children, createElement("TextButton", v8, children2))

			count += 1
		end

		return children
	end

	local v7

	if FoundationFontFaceMigration then
		v7 = v4.Typography.TitleLarge.Font
	end

	local v8 = useMemo(fn, { state2, v7 })

	if not state then
		return nil
	end

	local createElement = react.createElement
	local v9 = {
		Size = UDim2.fromScale(1, 1),
		AutoButtonColor = false,
		BackgroundColor3 = colors.Black,
		BackgroundTransparency = 0.6,
		onStateChanged = function() end,
		[react.Event.Activated] = v6
	}

	local createElement2 = react.createElement
	local v10

	if FFlagEnableAppChatSnoozeMenuFocus then
		v10 = FocusRoot
	else
		v10 = interactable
	end

	local v11

	if FFlagEnableAppChatSnoozeMenuFocus then
		v11 = {
			eventHandlers = eventHandlers,
			eventMap = navigateBacks,
			frameProps = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = v3.Theme.BackgroundDefault.Color,
				BackgroundTransparency = v3.Theme.BackgroundDefault.Transparency,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, -v4.Padding.Small * 2, 0, 0)
			},
			isAutoFocusRoot = true,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
		}
	else
		v11 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, -16, 0, 0),
			AutoButtonColor = false,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = v3.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v3.Theme.BackgroundDefault.Transparency,
			onStateChanged = function() end
		}
	end

	local children = {
		UICorner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, v3.Tokens.Radius.Large)
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
	local uiPadding

	if not FFlagEnableAppChatSnoozeMenuFocus then
		uiPadding = react.createElement("UIPadding", { PaddingLeft = UDim.new(0, 24) })
	end

	children.UIPadding = uiPadding

	children.UISizeConstraint = react.createElement("UISizeConstraint", {
		MaxSize = Vector2.new(400, 1e999)
	})

	local createElement3 = react.createElement
	local v12 = {
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
	local v13 = {
		PaddingBottom = UDim.new(0, not FFlagEnableAppChatSnoozeMenuFocus and 20 or v4.Padding.XLarge),
		PaddingRight = UDim.new(0, not FFlagEnableAppChatSnoozeMenuFocus and 24 or v4.Padding.XXLarge),
		PaddingTop = UDim.new(0, not FFlagEnableAppChatSnoozeMenuFocus and 20 or v4.Padding.XLarge),
		PaddingLeft = 0
	}
	local paddingLeft

	if FFlagEnableAppChatSnoozeMenuFocus then
		paddingLeft = UDim.new(0, v4.Padding.XXLarge)
	end

	v13.PaddingLeft = paddingLeft
	children2.UIPadding = createElement4("UIPadding", v13)

	local createElement5 = react.createElement
	local v14 = {
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
	local font

	if not FoundationFontFaceMigration then
		font = v3.Font.Body.Font
	end

	v14.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v4.Typography.BodyLarge.Font)
	end

	v14.FontFace = fontFace

	v14.Text = state2.title or ""
	v14.TextSize = v3.Font.Body.RelativeSize * v3.Font.BaseSize
	v14.TextColor3 = colors.White
	local textXAlignment

	if defineFastFlag then
		textXAlignment = Enum.TextXAlignment.Left
	end

	v14.TextXAlignment = textXAlignment
	children2.Title = createElement5("TextLabel", v14)
	local description

	if state2 and state2.description and state2.description ~= "" then
		local createElement6 = react.createElement
		local v15 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			LayoutOrder = 2,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = v3.Font.CaptionBody.Font
		end

		v15.Font = font2
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(v4.Typography.BodySmall.Font)
		end

		v15.FontFace = fontFace2

		v15.Text = state2.description or ""
		v15.TextSize = v3.Font.CaptionBody.RelativeSize * v3.Font.BaseSize
		v15.TextColor3 = v3.Theme.TextDefault.Color
		description = createElement6("TextLabel", v15)
	end

	children2.Description = description
	children.TitleContainer = createElement3("Frame", v12, children2)

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
			SnoozeOptions = roact.createFragment(v8)
		}
	)
	return (createElement(interactable, v9, {
		SnoozeMenu = createElement2(v10, v11, children)
	}))
end
