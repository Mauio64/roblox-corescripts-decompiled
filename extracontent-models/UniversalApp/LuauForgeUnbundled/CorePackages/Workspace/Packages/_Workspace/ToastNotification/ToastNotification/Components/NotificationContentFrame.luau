local dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies")
local NotificationStyledText = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/NotificationStyledText")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/NotificationThumbnail")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/Components/ToastHoldButton")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local uiBlox = dependencies.UIBlox
local useStyle = uiBlox.Core.Style.useStyle
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local interactable = uiBlox.Core.Control.Interactable
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/constants")
local useNotificationCardState = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/useNotificationCardState")
local useNotificationCardData = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/useNotificationCardData")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local defaultContentPadding = constants.DefaultContentPadding
local defaultTextContentPadding = constants.DefaultTextContentPadding
local vector2 = Vector2.new(36, 36)

local isUserThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/toastNotificationHelper").isUserThumbnail

return function(props)
	local v5 = useStyle()
	local v6 = useTokens()
	local fontSize = v6.Typography.CaptionLarge.FontSize
	local fontSize2 = v6.Typography.BodySmall.FontSize
	local cardSize = useNotificationCardData().cardSize
	local v7

	if isUserThumbnail then
		local v8 = useNotificationCardState("thumbnail")

		v7 = React.useMemo(function()
			local flag = false

			if v8 then
				for k, v10 in v8 do
					if not isUserThumbnail(v10) then
						flag = true
						break
					end
				end
			end

			if flag then
				return cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
			end

			return v5.Tokens.Size.Size_1000
		end, { v8, v5.Tokens.Size.Size_1000, cardSize })
	else
		v7 = cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
	end

	local size_700 = v5.Tokens.Size.Size_700
	local v8 = useNotificationCardState("textBody")

	local v9 = v8 and v8[1]

	local v10 = v9 and v9.title and {
		Text = v9.title,
		MaxSize = Vector2.new(1e999, fontSize * 2),
		Size = UDim2.new(1, 0, 0, 0),
		TextSize = fontSize,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 1,
		FontFace = normalizeFontFace(v6.Typography.CaptionLarge.Font),
		TextColor3 = v5.Theme.TextEmphasis.Color
	}

	local v11 = v9 and v9.label and {
		Text = v9.label,
		MaxSize = Vector2.new(1e999, fontSize2 * 2),
		Size = UDim2.new(1, 0, 0, 0),
		TextSize = fontSize2,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = 2,
		FontFace = normalizeFontFace(v6.Typography.BodySmall.Font)
	}

	local v12 = useNotificationCardData()
	cardSize = v12.cardSize
	local handleActions = v12.handleActions
	local v13 = useNotificationCardState("singleMetaAction")
	local v14 = v13 and v13[1]

	local createElement = React.createElement
	local v16 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v17 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, defaultContentPadding)
		}),
		ThumbnailTextContainer = 0,
		SingleMetaAction = 0
	}

	local createElement2 = React.createElement
	local v19 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = 0
	}

	local v20 = if v14 then UDim2.new(1, -(defaultContentPadding + vector2.X), 0, 0) else UDim2.new(1, 0, 0, 0)
	v19.Size = v20

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, defaultContentPadding)
		}),
		NotificationThumbnailFrame = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, v7, 0, v7)
			},
			{ NotificationThumbnail = React.createElement(module3) }
		),
		ToastTextFrame = 0,
		ToastHoldButton = 0
	}

	local createElement3 = React.createElement
	local v22 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = 0
	}
	local v23 = if props.showHoldButton then UDim2.new(
		1,
		-(v7 + defaultContentPadding * 2 + size_700),
		0,
		0
	) else UDim2.new(1, -(v7 + defaultContentPadding), 0, 0)
	v22.Size = v23
	children.ToastTextFrame = createElement3("Frame", v22, {
		UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 2) }),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, defaultTextContentPadding)
		}),
		ToastTitle = v10 and React.createElement(NotificationStyledText, v10),
		ToastSubtitle = v11 and React.createElement(NotificationStyledText, v11)
	})

	children.ToastHoldButton = React.createElement(module4, {
		iconSize = size_700,
		visible = props.showHoldButton,
		layoutOrder = 3,
		iconTransparency = props.shouldAutoFocus and 0.5 or 0,
		progress = props.holdProgress
	})
	v17.ThumbnailTextContainer = createElement2("Frame", v19, children)
	local v24

	if v14 then
		v24 = React.createElement(interactable, {
			AutoButtonColor = false,
			BackgroundColor3 = v5.Theme.UIMuted.Color,
			BackgroundTransparency = 0.9,
			LayoutOrder = 2,
			onStateChanged = function() end,
			[React.Event.Activated] = function()
				if handleActions then
					handleActions(v14)
				end
			end,
			Size = UDim2.fromOffset(vector2.X, vector2.Y)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			Icon = React.createElement(imageSetLabel, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = module5.MetaActionIcons[v14.actionIcon],
				ImageColor3 = v5.Theme.IconEmphasis.Color,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(28, 28)
			})
		})
	end

	v17.SingleMetaAction = v24
	return createElement("Frame", v16, v17)
end
