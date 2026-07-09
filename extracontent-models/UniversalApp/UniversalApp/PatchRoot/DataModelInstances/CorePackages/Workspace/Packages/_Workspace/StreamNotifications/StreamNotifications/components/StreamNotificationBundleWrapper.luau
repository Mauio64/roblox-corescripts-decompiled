local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local components = StreamNotifications.components
local StreamNotificationsParent = StreamNotifications.Parent
local React = require(StreamNotificationsParent.React)
local constants = require(StreamNotifications.constants)
local ReactOtter = require(StreamNotificationsParent.ReactOtter)
local NotificationsCommon = require(StreamNotificationsParent.NotificationsCommon)
local StreamNotificationAnimationWrapper = require(components.StreamNotificationAnimationWrapper)
local useLocalization = require(StreamNotificationsParent.Localization).Hooks.useLocalization
local NotificationHelper = NotificationsCommon.NotificationHelper
local UIBlox = require(StreamNotificationsParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v15 = Images["icons/actions/truncationExpand"]
local v16 = Images["icons/actions/truncationCollapse"]
local uDim = UDim.new(0, 12)
local uDim2 = UDim.new(0, 24)
local v19 = constants.DefaultPadding * 4
local uDim2_2 = UDim2.fromOffset(24, 24)
local EventStream = require(StreamNotifications.analytics.analyticsService).EventStream
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local t1 = {
	stiffness = 207,
	damping = 24,
	mass = 1
}

return function(t2: {[any]: any}) -- line: 54
	-- upvalues: useStyle (copy), React (copy), ReactOtter (copy), useLocalization (copy), constants (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), t1 (copy), StreamNotificationAnimationWrapper (copy), uDim (copy), uDim2 (copy), ImageSetLabel (copy), uDim2_2 (copy), v16 (copy), v19 (copy), v15 (copy)
	local v25 = useStyle()
	local Font = v25.Font
	local Header1Font = Font.Header1.Font
	local v28 = Font.BaseSize * Font.CaptionHeader.RelativeSize
	local v29, v30 = React.useState(true)
	local v31, v32 = React.useState(74)
	local v33, v34 = React.useState(true)
	local v35, v36 = ReactOtter.useAnimatedBinding({
		shadowHeight = 0,
		shadowWidth = 1
	})
	local v37 = useLocalization({
		moreText = constants.Text.ShowMoreKey,
		lessText = constants.Text.ShowLessKey
	})
	local v38 = React.useCallback(function(n1: number, n2: number) -- line: 77
		-- upvalues: v29 (copy), v32 (copy)
		if n1 == 1 and v29 then
			v32(n2)
		end
	end)

	local function v39(p1) -- line: 83
		local t3 = {}

		for _, v46 in p1 do
			if v46.id then
				table.insert(t3, v46.id)
			end
		end

		return t3
	end
	local function v40() -- line: 93
		-- upvalues: v30 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), t2 (copy), v39 (copy)
		v30(function(p2) -- line: 94
			-- upvalues: NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), t2 (copy), v39 (copy)
			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, if not p2 then analyticsConstants.EventNames.bundleClosed else analyticsConstants.EventNames.bundleOpened, {
				bundleKey = t2.notifications[1].content.bundleKey or nil,
				totalNotifications = #t2.notifications or nil,
				notificationIds = v39(t2.notifications) or nil
			})

			if p2 then
				for v53, v54 in t2.notifications do
					NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.seen, analyticsConstants.EventNames.notificationViewed, {
						notificationId = v54.id or nil,
						notificationType = v54.content.notificationType or nil,
						bundlePosition = v53,
						bundleKey = v54.content.bundleKey or nil,
						clientEventsPayload = v54.content.clientEventsPayload or nil
					})
				end
			end

			return not p2
		end)
	end

	React.useEffect(function() -- line: 132
		-- upvalues: v36 (copy), ReactOtter (copy), v29 (copy), t1 (copy)
		v36({
			shadowHeight = ReactOtter.spring(not v29 and 1 or 0, t1),
			shadowWidth = ReactOtter.spring(not v29 and 0 or 1, t1)
		})
	end, { v29 })
	React.useEffect(function() -- line: 140
		-- upvalues: v34 (copy), t2 (copy)
		v34(#t2.notifications > 1)
	end, { t2.notifications })

	return (React.useMemo(function() -- line: 145
		-- upvalues: t2 (copy), v29 (copy), v33 (copy), React (copy), StreamNotificationAnimationWrapper (copy), v38 (copy), v35 (copy), v31 (copy), constants (copy), v25 (copy), uDim (copy), Header1Font (copy), v28 (copy), v40 (copy), uDim2 (copy), v37 (copy), ImageSetLabel (copy), uDim2_2 (copy), v16 (copy), v19 (copy), v15 (copy)
		local t4 = {}

		for i, v in ipairs(t2.notifications) do
			local v50 = false
			local v51 = if not t2.impressionMetadataByNotificationId then nil else t2.impressionMetadataByNotificationId[v.id]

			if v29 and v33 then
				v50 = true
			end

			t4[v.id] = React.createElement(StreamNotificationAnimationWrapper, {
				layoutOrder = i,
				notification = v,
				finishDismissNotification = t2.finishDismissNotification,
				handleActions = t2.handleActions,
				openMetaActions = t2.openMetaActions,
				onHeightChange = v38,
				collapsed = v50,
				impressionsTag = t2.impressionsTag,
				impressionIndex = v51 and v51.impressionIndex or nil
			})
		end

		t4.UIPadding = React.createElement("UIPadding", {
			PaddingTop = if v29 or not v33 then UDim.new(0, 0) else UDim.new(0, 40)
		})
		t4.UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		})
		t4.Shadow1 = if not v29 or not v33 then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v35:map(function(t5: {[any]: any}) -- line: 185
				-- upvalues: v31 (copy), constants (copy)
				return UDim2.new(1, 0, 0, t5.shadowHeight * v31 + constants.DefaultPadding)
			end),
			LayoutOrder = #t2.notifications + 1,
			ZIndex = -(#t2.notifications + 1)
		}, { React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = v35:map(function(t6: {[any]: any}) -- line: 194
				-- upvalues: constants (copy), v31 (copy)
				return UDim2.new(1, -(constants.DefaultPadding * 4 * t6.shadowWidth), 0, v31 - constants.DefaultPadding)
			end),
			BackgroundColor3 = v25.Theme.BackgroundDefault.Color,
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = uDim
			})
		}) })
		t4.Shadow2 = if not v29 or not v33 then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v35:map(function(t7: {[any]: any}) -- line: 219
				-- upvalues: v31 (copy), constants (copy)
				return UDim2.new(1, 0, 0, t7.shadowHeight * v31 + constants.DefaultPadding * 2)
			end),
			LayoutOrder = #t2.notifications + 2,
			ZIndex = -(#t2.notifications + 2)
		}, { React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = v35:map(function(t8: {[any]: any}) -- line: 228
				-- upvalues: constants (copy), v31 (copy)
				return UDim2.new(1, -(constants.DefaultPadding * 6 * t8.shadowWidth), 0, v31 - constants.DefaultPadding)
			end),
			BackgroundColor3 = v25.Theme.BackgroundContrast.Color,
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = uDim
			})
		}) })

		return React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = t2.layoutOrder
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = if not v29 or not v33 then UDim.new(0, 0) else UDim.new(0, constants.DefaultPadding)
			}),
			ShowLessButton = if v29 or not v33 then nil else React.createElement("TextButton", {
				Size = UDim2.new(0, 160, 0, 40),
				Text = "",
				Font = Header1Font,
				TextSize = v28,
				[React.Event.Activated] = v40,
				BackgroundTransparency = 1,
				BackgroundColor3 = v25.Theme.BackgroundMuted.Color,
				AutoButtonColor = false,
				LayoutOrder = 1,
				ZIndex = 4,
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
				BackgroundTransparency = 0,
				ZIndex = 10,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -constants.DefaultPadding, 1, -constants.DefaultPadding),
				BackgroundColor3 = v25.Theme.BackgroundContrast.Color,
				Position = UDim2.new(1, -constants.DefaultPadding, 0, 0),
				AnchorPoint = Vector2.new(1, 0)
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim2
				}),
				ShowLessTextAndIconFrame = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					ShowLessText = React.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Text = v37 and v37.lessText,
						Font = Header1Font,
						TextSize = v28,
						TextColor3 = v25.Theme.TextMuted.Color,
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.X
					}, { React.createElement("UIPadding", {
						PaddingRight = UDim.new(0, constants.DefaultPadding)
					}) }),
					CollapseIcon = React.createElement(ImageSetLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = uDim2_2,
						Image = v16,
						ImageColor3 = v25.Theme.UIEmphasis.Color
					})
				})
			}) }),
			InvisibleExpandButton = React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 0, (not v29 or not v33) and 0 or v31 + constants.DefaultPadding * 2),
				BackgroundTransparency = 1,
				Text = "",
				[React.Event.Activated] = v40,
				ZIndex = 5,
				BorderSizePixel = 0,
				AutoButtonColor = false
			}),
			NumberMoreButton = if v31 == 0 or (not v29 or not (#t2.notifications > 1)) then nil else React.createElement("Frame", {
				ZIndex = 10,
				BackgroundTransparency = 0,
				Size = UDim2.new(0, 125, 0, v19),
				AutomaticSize = Enum.AutomaticSize.X,
				Position = UDim2.new(0.5, 0, 1, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundColor3 = v25.Theme.BackgroundContrast.Color
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = uDim2
				}),
				NumberedMoreTextAndIconFrame = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5)
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					NumberMoreText = React.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						Text = v37 and (v37.moreText and string.gsub(v37.moreText, "{notificationCount}", (tostring(#t2.notifications - 1)))),
						Font = Header1Font,
						TextSize = v28,
						TextColor3 = v25.Theme.TextMuted.Color,
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.X
					}, { React.createElement("UIPadding", {
						PaddingRight = UDim.new(0, constants.DefaultPadding)
					}) }),
					ExpandIcon = React.createElement(ImageSetLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = uDim2_2,
						Image = v15,
						ImageColor3 = v25.Theme.UIEmphasis.Color
					})
				})
			}),
			ListOfNotifications = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 3,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, t4)
		})
	end, {
		t2.notifications,
		v29,
		v31,
		v33,
		t2.impressionsTag,
		t2.impressionMetadataByNotificationId
	}))
end
