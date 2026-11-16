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
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local defaultContentPadding = constants.DefaultContentPadding
local defaultTextContentPadding = constants.DefaultTextContentPadding
local vector2 = Vector2.new(36, 36)

local isUserThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/toastNotificationHelper").isUserThumbnail

return function(props)
	local v5 = useStyle()
	local v6 = if foundationFontFaceMigration then useTokens() else nil
	local v7

	if foundationFontFaceMigration then
		v7 = v6.Typography.CaptionLarge.FontSize
	else
		v7 = v5.Font.BaseSize * v5.Font.CaptionHeader.RelativeSize
	end

	local v8

	if foundationFontFaceMigration then
		v8 = v6.Typography.BodySmall.FontSize
	else
		v8 = v5.Font.BaseSize * v5.Font.CaptionBody.RelativeSize
	end

	local cardSize = useNotificationCardData().cardSize
	local v9

	if isUserThumbnail then
		local v10 = useNotificationCardState("thumbnail")

		v9 = React.useMemo(function()
			local flag = false

			if v10 then
				for k, v12 in v10 do
					if not isUserThumbnail(v12) then
						flag = true
						break
					end
				end
			end

			if flag then
				return cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
			end

			return v5.Tokens.Size.Size_1000
		end, { v10, v5.Tokens.Size.Size_1000, cardSize })
	else
		v9 = cardSize and cardSize.thumbnail or constants.CardSizeDefault.thumbnail
	end

	local size_700 = v5.Tokens.Size.Size_700
	local v10 = useNotificationCardState("textBody")

	local v11 = v10 and v10[1]

	local v12 = v11 and v11.title

	if v12 then
		v12 = {
			Text = v11.title,
			MaxSize = Vector2.new(1e999, v7 * 2),
			Size = UDim2.new(1, 0, 0, 0),
			TextSize = v7,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 1,
			Font = 0,
			FontFace = 0,
			TextColor3 = 0
		}

		local v13 = if not foundationFontFaceMigration then v5.Font.CaptionHeader.Font else nil
		v12.Font = v13

		local v14 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.CaptionLarge.Font) else nil
		v12.FontFace = v14

		v12.TextColor3 = v5.Theme.TextEmphasis.Color
	end

	local v13 = v11 and v11.label

	if v13 then
		v13 = {
			Text = v11.label,
			MaxSize = Vector2.new(1e999, v8 * 2),
			Size = UDim2.new(1, 0, 0, 0),
			TextSize = v8,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = 2,
			Font = 0,
			FontFace = 0
		}

		local v14 = if not foundationFontFaceMigration then v5.Font.CaptionBody.Font else nil
		v13.Font = v14

		local v15 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodySmall.Font) else nil
		v13.FontFace = v15
	end

	local v14 = useNotificationCardData()
	cardSize = v14.cardSize
	local handleActions = v14.handleActions
	local v15 = useNotificationCardState("singleMetaAction")
	local v16 = v15 and v15[1]

	local createElement = React.createElement
	local v18 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local v19 = {
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
	local v21 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Size = 0
	}

	local v22 = if v16 then UDim2.new(1, -(defaultContentPadding + vector2.X), 0, 0) else UDim2.new(1, 0, 0, 0)
	v21.Size = v22

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
				Size = UDim2.new(0, v9, 0, v9)
			},
			{ NotificationThumbnail = React.createElement(module3) }
		),
		ToastTextFrame = 0,
		ToastHoldButton = 0
	}

	local createElement3 = React.createElement
	local v24 = {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = 0
	}
	local v25 = if props.showHoldButton then UDim2.new(
		1,
		-(v9 + defaultContentPadding * 2 + size_700),
		0,
		0
	) else UDim2.new(1, -(v9 + defaultContentPadding), 0, 0)
	v24.Size = v25
	children.ToastTextFrame = createElement3("Frame", v24, {
		UIPadding = React.createElement("UIPadding", { PaddingTop = UDim.new(0, 2) }),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, defaultTextContentPadding)
		}),
		ToastTitle = v12 and React.createElement(NotificationStyledText, v12),
		ToastSubtitle = v13 and React.createElement(NotificationStyledText, v13)
	})

	children.ToastHoldButton = React.createElement(module4, {
		iconSize = size_700,
		visible = props.showHoldButton,
		layoutOrder = 3,
		iconTransparency = props.shouldAutoFocus and 0.5 or 0,
		progress = props.holdProgress
	})
	v19.ThumbnailTextContainer = createElement2("Frame", v21, children)
	local v26

	if v16 then
		v26 = React.createElement(interactable, {
			AutoButtonColor = false,
			BackgroundColor3 = v5.Theme.UIMuted.Color,
			BackgroundTransparency = 0.9,
			LayoutOrder = 2,
			onStateChanged = function() end,
			[React.Event.Activated] = function()
				if handleActions then
					handleActions(v16)
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
				Image = module5.MetaActionIcons[v16.actionIcon],
				ImageColor3 = v5.Theme.IconEmphasis.Color,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(28, 28)
			})
		})
	end

	v19.SingleMetaAction = v26
	return createElement("Frame", v18, v19)
end
