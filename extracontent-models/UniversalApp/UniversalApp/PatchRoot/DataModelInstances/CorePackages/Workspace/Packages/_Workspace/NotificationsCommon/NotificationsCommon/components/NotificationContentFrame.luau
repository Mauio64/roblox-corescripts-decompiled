local NotificationsCommon = script:FindFirstAncestor("NotificationsCommon")
local components = NotificationsCommon.components
local context = NotificationsCommon.context
local dependencies = require(NotificationsCommon.dependencies)
local NotificationStyledText = require(components.NotificationStyledText)
local NotificationThumbnail = require(components.NotificationThumbnail)

require(NotificationsCommon.type)

local React = dependencies.React
local UIBlox = dependencies.UIBlox
local useStyle = UIBlox.Core.Style.useStyle
local constants = require(NotificationsCommon.constants)
local useNotificationCardState = require(context.useNotificationCardState)
local useNotificationCardData = require(context.useNotificationCardData)
local NotificationActionsFrame = require(components.NotificationActionsFrame)
local IconButton = UIBlox.App.Button.IconButton
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local v17 = Images["icons/common/overflow"]
local DefaultContentPadding = constants.DefaultContentPadding
local DefaultTextContentPadding = constants.DefaultTextContentPadding
local MetaActionsWidth = constants.MetaActionsWidth
local TimestampWidth = constants.TimestampWidth
local TimestampHeight = constants.TimestampHeight

return function() -- line: 27
	-- upvalues: useStyle (copy), useNotificationCardData (copy), constants (copy), useNotificationCardState (copy), DefaultTextContentPadding (copy), MetaActionsWidth (copy), TimestampWidth (copy), TimestampHeight (copy), React (copy), DefaultContentPadding (copy), NotificationThumbnail (copy), NotificationStyledText (copy), IconButton (copy), IconSize (copy), v17 (copy), NotificationActionsFrame (copy)
	local v23 = useStyle()
	local v24 = v23.Font.BaseSize * v23.Font.CaptionHeader.RelativeSize
	local v25 = v23.Font.BaseSize * v23.Font.CaptionBody.RelativeSize
	local v26 = useNotificationCardData()
	local cardSize = v26.cardSize
	local readOnly = v26.readOnly
	local v29 = cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
	local openMetaActions = v26.openMetaActions
	local notificationPayload = v26.notificationPayload
	local handleActions = v26.handleActions
	local v33 = useNotificationCardState("textBody")
	local v34 = v33 and v33[1]
	local v35 = v34 and (v34.title and {
		LayoutOrder = 1,
		Text = v34.title,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextSize = v24,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = v23.Font.CaptionHeader.Font,
		TextColor3 = v23.Theme.TextEmphasis.Color
	})
	local v36 = v34 and (v34.label and {
		LayoutOrder = 2,
		Text = v34.label,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextSize = v25,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = v23.Font.CaptionBody.Font,
		TextColor3 = v23.Theme.TextEmphasis.Color
	})
	local v37 = if not readOnly then -(MetaActionsWidth + DefaultTextContentPadding) else -DefaultTextContentPadding
	local v38 = notificationPayload and (notificationPayload.timestamp and {
		LayoutOrder = 2,
		TextTransparency = 0,
		Text = {
			text = notificationPayload.timestamp
		},
		Size = UDim2.new(0, TimestampWidth + DefaultTextContentPadding, 0, TimestampHeight),
		TextSize = v24,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Right,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, v37, 0, 0),
		Font = v23.Font.CaptionHeader.Font,
		TextColor3 = v23.Theme.TextEmphasis.Color
	})

	return React.createElement("TextButton", {
		Selectable = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0,
		[React.Event.Activated] = function() -- line: 97
			-- upvalues: handleActions (copy), v34 (copy), notificationPayload (copy)
			if handleActions and (v34 and notificationPayload) then
				handleActions(v34, notificationPayload)
			end
		end
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, DefaultContentPadding)
		}),
		NotificationThumbnailFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(0, v29, 0, v29)
		}, {
			NotificationThumbnail = React.createElement(NotificationThumbnail)
		}),
		ContentFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -(v29 + DefaultContentPadding), 0, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				Padding = UDim.new(0, DefaultTextContentPadding)
			}),
			NotificationsBody = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, constants.MetaActionsHeight),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				NotificationsText = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, if not readOnly then -(MetaActionsWidth + TimestampWidth + DefaultTextContentPadding * 2) else -(TimestampWidth + DefaultTextContentPadding), 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, DefaultTextContentPadding)
					}),
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, DefaultTextContentPadding)
					}),
					Title = if not v35 then nil else React.createElement(NotificationStyledText, v35),
					Subtitle = if not v36 then nil else React.createElement(NotificationStyledText, v36)
				}),
				Timestamp = if not v38 then nil else React.createElement(NotificationStyledText, v38),
				MetaActionsButton = if not openMetaActions or readOnly then nil else React.createElement(IconButton, {
					layoutOrder = 3,
					anchorPoint = Vector2.new(1, 0),
					position = UDim2.new(1, 0, 0, 0),
					size = UDim2.fromOffset(0, 0),
					iconSize = IconSize.Medium,
					icon = v17,
					onActivated = function() -- line: 172
						-- upvalues: openMetaActions (copy), notificationPayload (copy)
						openMetaActions(notificationPayload)
					end
				})
			}),
			NotificationActionsFrame = if readOnly then nil else React.createElement(NotificationActionsFrame)
		})
	})
end
