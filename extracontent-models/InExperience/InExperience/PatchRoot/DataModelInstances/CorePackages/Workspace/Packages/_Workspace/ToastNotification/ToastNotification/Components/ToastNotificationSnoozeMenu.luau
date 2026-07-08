local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local NotificationTypeEnum = require(ParentParent.type).NotificationTypeEnum
local ShowNotificationSnoozeMenuSignal = require(ParentParent.Signals).ShowNotificationSnoozeMenuSignal
local DismissNotificationSnoozeMenuSignal = require(ParentParent.Signals).DismissNotificationSnoozeMenuSignal
local NotificationSnoozeMenuVisibleSignal = require(ParentParent.Signals).NotificationSnoozeMenuVisibleSignal
local default = require(ParentParent.ToastNotificationSnoozeManager).default
local useTokens = require(ParentParentParent.Foundation).Hooks.useTokens
local Cryo = dependencies.Cryo
local Localization = dependencies.Localization
local React = dependencies.React
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local useLocalization = Localization.Hooks.useLocalization
local Colors = UIBlox.App.Style.Colors
local Interactable = UIBlox.Core.Control.Interactable
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useStyle = UIBlox.Core.Style.useStyle
local FocusNavigationUtils = require(ParentParentParent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local FocusRoot = FocusNavigationUtils.FocusRoot
local InputHandlers = require(ParentParentParent.InputHandlers)

require(ParentParentParent.ReactFocusNavigation)

local FFlagEnableAppChatSnoozeMenuFocus = require(ParentParentParent.SharedFlags).FFlagEnableAppChatSnoozeMenuFocus
local GetFFlagAppChatInExpToastSnoozeMenuDismissFix = require(ParentParentParent.SharedFlags).GetFFlagAppChatInExpToastSnoozeMenuDismissFix
local GetFFlagIsSquadEnabled = require(ParentParentParent.SharedFlags).GetFFlagIsSquadEnabled
local v28 = game:DefineFastFlag("SnoozeMenuTextXAlignment", false)
local ArgoPartyExperimentation = require(ParentParentParent.SocialExperiments).ArgoPartyExperimentation
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}
local UniversalAppPolicy = require(ParentParentParent.UniversalAppPolicy)
local t2 = {
	[NotificationTypeEnum.ChatNewMessage] = if not ArgoPartyExperimentation.getIsRenameEnabled() then not GetFFlagIsSquadEnabled() and "Feature.Chat.Action.StartChatWithFriends" or "Feature.Squads.Label.Party" else not UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Squads.Label.Party" or "CommonUI.Features.Label.Chat"
}
local t3 = {
	[1] = {
		textKey = "fifteenMinutes",
		durationMinutes = 15
	},
	[2] = {
		textKey = "fourHours",
		durationMinutes = 240
	},
	[3] = {
		textKey = "oneDay",
		durationMinutes = 1440
	},
	[4] = {
		textKey = "untilITurnItBackOn",
		durationMinutes = -1
	}
}

return function() -- line: 81
	-- upvalues: useStyle (copy), FFlagEnableAppChatSnoozeMenuFocus (copy), useTokens (copy), useLocalization (copy), Cryo (copy), t2 (copy), React (copy), ShowNotificationSnoozeMenuSignal (copy), GetFFlagAppChatInExpToastSnoozeMenuDismissFix (copy), DismissNotificationSnoozeMenuSignal (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), NotificationSnoozeMenuVisibleSignal (copy), useCursor (copy), t3 (ref), Colors (copy), default (copy), Interactable (copy), FocusRoot (copy), t1 (copy), FocusNavigableSurfaceIdentifierEnum (copy), v28 (copy), Roact (copy)
	local v34 = useStyle()
	local v35 = if not FFlagEnableAppChatSnoozeMenuFocus then nil else useTokens()
	local v36 = useLocalization((Cryo.Dictionary.union(t2, {
		fifteenMinutes = "Feature.Notifications.Action.SnoozeFifteenMinutes",
		fourHours = "Feature.Notifications.Action.SnoozeFourHours",
		oneDay = "Feature.Notifications.Action.SnoozeOneDay",
		oneHour = "Feature.Notifications.Action.SnoozeOneHour",
		untilITurnItBackOn = "Feature.Notifications.Action.UntilITurnItBackOn",
		snoozeFeedback = "Feature.Notifications.Heading.SnoozeFeedback"
	})))
	local v37, v38 = React.useState(false)
	local v39, v40 = React.useState({})
	local v41 = React.useCallback(function() -- line: 96
		-- upvalues: v38 (copy)
		v38(false)
	end, { v38 })

	React.useEffect(function() -- line: 100
		-- upvalues: ShowNotificationSnoozeMenuSignal (copy), v40 (copy), v38 (copy), GetFFlagAppChatInExpToastSnoozeMenuDismissFix (copy), DismissNotificationSnoozeMenuSignal (copy), v41 (copy)
		local u45 = ShowNotificationSnoozeMenuSignal:connect(function(t4: {[any]: any}) -- line: 102
			-- upvalues: v40 (copy), v38 (copy)
			v40(t4)
			v38(true)
		end)
		local u46 = nil

		if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
			u46 = DismissNotificationSnoozeMenuSignal:connect(function() -- line: 114
				-- upvalues: v41 (copy)
				v41()
			end)
		end

		return function() -- line: 119
			-- upvalues: u45 (ref), GetFFlagAppChatInExpToastSnoozeMenuDismissFix (copy), u46 (ref)
			u45:disconnect()

			if GetFFlagAppChatInExpToastSnoozeMenuDismissFix() then
				u46:disconnect()
			end
		end
	end, { v38 })

	local v42 = nil

	if FFlagEnableAppChatSnoozeMenuFocus then
		v42 = React.useMemo(function() -- line: 129
			-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v41 (copy)
			return {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = InputHandlers.onRelease(function(p1) -- line: 132
						-- upvalues: v41 (copy)
						v41()
						p1:cancel()
					end)
				}
			}
		end, { v41 })
		React.useEffect(function() -- line: 140
			-- upvalues: NotificationSnoozeMenuVisibleSignal (copy), v37 (copy)
			NotificationSnoozeMenuVisibleSignal:fire({
				visible = v37
			})
		end, { v37 })
	end

	local v43 = if not FFlagEnableAppChatSnoozeMenuFocus then nil else useCursor()
	local v44 = React.useMemo(function() -- line: 147
		-- upvalues: t3 (ref), React (copy), FFlagEnableAppChatSnoozeMenuFocus (copy), v35 (copy), v34 (copy), v43 (copy), v36 (copy), Colors (copy), v39 (copy), default (copy), v38 (copy)
		local t5 = {}

		for i, v in ipairs(t3) do
			local v50 = i

			table.insert(t5, React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0, not FFlagEnableAppChatSnoozeMenuFocus and 56 or v35.Size.Size_1400),
				BackgroundTransparency = 1,
				Font = v34.Font.Header2.Font,
				LayoutOrder = v50,
				SelectionImageObject = v43,
				Text = v36[v.textKey],
				TextSize = v34.Font.Header2.RelativeSize * v34.Font.BaseSize,
				TextColor3 = Colors.White,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				[React.Event.Activated] = function() -- line: 169
					-- upvalues: v39 (copy), default (copy), v (copy), v36 (copy), v38 (copy)
					if v39.notificationType then
						local notificationType = v39.notificationType

						if type(v39.notificationType) == "table" then
							notificationType = v39.notificationType[1]
						end

						default:snoozeNotification({
							context = v39.context,
							notificationType = v39.notificationType,
							durationMinutes = v.durationMinutes,
							modalMessage = v36.snoozeFeedback:gsub("{title}", v36[notificationType] or ""):gsub("{duration}", v36[v.textKey])
						})
					end

					v38(false)
				end
			}, {
				UIPadding = if not FFlagEnableAppChatSnoozeMenuFocus then nil else React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v35.Padding.XXLarge),
					PaddingRight = UDim.new(0, v35.Padding.XXLarge)
				}),
				Border = React.createElement("Frame", {
					BackgroundTransparency = 0.8,
					Size = if not FFlagEnableAppChatSnoozeMenuFocus then UDim2.new(1, 0, 0, 1) else UDim2.new(1, v35.Padding.XXLarge, 0, 1),
					BackgroundColor3 = Colors.White,
					LayoutOrder = v50
				})
			}))

			local _ = v50 + 1
		end

		return t5
	end, { v39 })

	if v37 then
		return (React.createElement(Interactable, {
			Size = UDim2.fromScale(1, 1),
			AutoButtonColor = false,
			BackgroundColor3 = Colors.Black,
			BackgroundTransparency = 0.6,
			onStateChanged = function() -- line: 218
			end,
			[React.Event.Activated] = v41
		}, {
			SnoozeMenu = React.createElement(if not FFlagEnableAppChatSnoozeMenuFocus then Interactable else FocusRoot, if not FFlagEnableAppChatSnoozeMenuFocus then {
				AutoButtonColor = false,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, -16, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = v34.Theme.BackgroundDefault.Color,
				BackgroundTransparency = v34.Theme.BackgroundDefault.Transparency,
				onStateChanged = function() -- line: 247
				end
			} else {
				isAutoFocusRoot = true,
				isIsolated = true,
				eventHandlers = v42,
				eventMap = t1,
				frameProps = {
					AnchorPoint = Vector2.new(0.5, 0.5),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = v34.Theme.BackgroundDefault.Color,
					BackgroundTransparency = v34.Theme.BackgroundDefault.Transparency,
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.new(1, -v35.Padding.Small * 2, 0, 0)
				},
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v34.Tokens.Radius.Large)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				UIPadding = if not FFlagEnableAppChatSnoozeMenuFocus then React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24)
				}) else nil,
				UISizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = Vector2.new(400, 1e999)
				}),
				TitleContainer = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, not FFlagEnableAppChatSnoozeMenuFocus and 20 or v35.Padding.XLarge),
						PaddingRight = UDim.new(0, not FFlagEnableAppChatSnoozeMenuFocus and 24 or v35.Padding.XXLarge),
						PaddingTop = UDim.new(0, not FFlagEnableAppChatSnoozeMenuFocus and 20 or v35.Padding.XLarge),
						PaddingLeft = if not FFlagEnableAppChatSnoozeMenuFocus then nil else UDim.new(0, v35.Padding.XXLarge)
					}),
					Title = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.XY,
						Font = v34.Font.Body.Font,
						Text = v39.title or "",
						TextSize = v34.Font.Body.RelativeSize * v34.Font.BaseSize,
						TextColor3 = Colors.White,
						TextXAlignment = if not v28 then nil else Enum.TextXAlignment.Left
					}),
					Description = if not v39 or (not v39.description or v39.description == "") then nil else React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.XY,
						Font = v34.Font.CaptionBody.Font,
						Text = v39.description or "",
						TextSize = v34.Font.CaptionBody.RelativeSize * v34.Font.BaseSize,
						TextColor3 = v34.Theme.TextDefault.Color
					})
				}),
				SnoozeOptions = React.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					SnoozeOptions = Roact.createFragment(v44)
				})
			})
		}))
	end

	return nil
end
