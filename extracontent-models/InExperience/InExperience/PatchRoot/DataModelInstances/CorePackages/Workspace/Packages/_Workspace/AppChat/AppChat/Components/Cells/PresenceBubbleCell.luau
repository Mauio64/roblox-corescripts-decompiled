local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local BaseCell = require(script.Parent.BaseCell)

local ConversationFacePile = require(AppChat.Components.Cells.ConversationFacePile)
local AvatarCircle = require(script.Parent.AvatarCircle)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagAppChatFixPlusBadgeAlignment = require(AppChat.Flags.FFlagAppChatFixPlusBadgeAlignment)
local FFlagAppChatTimestampInSubtitle = require(AppChat.Flags.FFlagAppChatTimestampInSubtitle)

local v = {
	BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0,
	onPressedBackgroundColor3 = Color3.new(0, 0.2, 0.3),
	onPressedBackgroundTransparency = 1,
	testId = nil,
	avatarCircleCellWidth = 60,
	avatarCircleSize = 36,
	avatarCircleBackgroundColor3 = Color3.new(0.4, 0.4, 0.4),
	avatarCircleDividerColor3 = Color3.new(0.2, 0.2, 0.2),
	avatarCircleDividerTransparency = 0,
	avatarCirclePresenceImage = nil,
	subTitleText = nil,
	subTitleTextFont = Enum.Font.Gotham,
	subTitleTextTransparency = 0,
	subTitleTextColor3 = Color3.new(0.1, 0.1, 0.1),
	subTitleTextSize = 15,
	subTitlePadding = 2,
	subTitleIconColor3 = Color3.new(0.1, 0.1, 0.1),
	subTitleIconTransparency = 0,
	titleText = "titleText",
	titleFont = Enum.Font.Gotham,
	titleTextTransparency = 0,
	titleTextColor3 = Color3.new(0, 0, 0),
	titleTextSize = 20,
	secondaryTitleText = nil,
	secondaryTitleFont = Enum.Font.Gotham,
	secondaryTitleTextTransparency = 0,
	secondaryTitleTextColor3 = Color3.new(0.2, 0.2, 0.2),
	secondaryTitleTextSize = 16,
	showDivider = true,
	dividerTransparency = 0,
	dividerColor3 = Color3.fromRGB(227, 227, 227),
	thumbnails = {},
	conversationId = nil,
	childWidth = 0,
	onActivated = nil,
	onCircleActivated = nil,
	Size = UDim2.new(1, 0, 1, 0),
	isLoading = false,
	hideLeftAvatarPadding = false,
	paddingLeft = 0,
	paddingRight = 0
}

local function PresenceBubbleCell(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useTextSizeOffset()
	local v3 = joined.subTitleTextSize + v2
	local v4 = joined.titleTextSize + v2
	local v5 = joined.subTitleTextSize + v2
	local v6, v7, maxSize, text

	if FFlagAppChatTimestampInSubtitle then
		local v8
		v8, v6 = React.useBinding(1e999)
		local v9
		v9, v7 = React.useBinding(0)
		maxSize = React.joinBindings({ v8, v9 }):map(function(list)
			return Vector2.new(math.max(0, list[1] - list[2]), 1e999)
		end)

		text = React.useMemo(function()
			if not joined.subTitleTimestamp then
				return nil
			end

			local subTitleText = joined.subTitleText

			if subTitleText and subTitleText ~= "" then
				return joined.subTitleTimestamp:map(function(p2: string)
					if p2 == "" then
						return ""
					end

					return " · " .. p2
				end)
			end

			return joined.subTitleTimestamp
		end, { joined.subTitleTimestamp, joined.subTitleText })
	else
		v6 = nil
		v7 = nil
	end

	local v8 = joined.conversationId ~= nil
	local v9 = {
		layout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	local v10 = -(joined.paddingLeft + joined.paddingRight + joined.childWidth)
	local joined2 = Cryo.Dictionary.join(v9, joined.children or {})
	local createElement = React.createElement
	local v11 = {
		Size = joined.Size,
		BackgroundTransparency = joined.BackgroundTransparency,
		BackgroundColor3 = joined.BackgroundColor3,
		dividerColor3 = joined.dividerColor3,
		dividerTransparency = joined.dividerTransparency,
		avatarCircleCellWidth = joined.avatarCircleCellWidth,
		onPressedBackgroundColor3 = joined.onPressedBackgroundColor3,
		onPressedBackgroundTransparency = joined.onPressedBackgroundTransparency,
		testId = 0,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		LayoutOrder = 0,
		onActivated = 0,
		showDivider = 0
	}
	local testId

	if FFlagDebugAppChatEnableDomLocators then
		testId = joined.testId
	end

	v11.testId = testId

	v11.LayoutOrder = joined.LayoutOrder
	v11.onActivated = joined.onActivated
	v11.showDivider = joined.showDivider

	local createElement2 = React.createElement
	local v12 = { Size = UDim2.new(1, v10, 1, 0), BackgroundTransparency = 1 }

	local children = {
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, joined.paddingLeft)
		}),
		layout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		circleHolder = 0,
		conversationInfo = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		Size = UDim2.new(0, joined.avatarCircleCellWidth, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 0
	}

	local createElement4 = React.createElement
	local v14 = { VerticalAlignment = Enum.VerticalAlignment.Center, HorizontalAlignment = 0 }
	local horizontalAlignment

	if joined.hideLeftAvatarPadding then
		horizontalAlignment = Enum.HorizontalAlignment.Left
	else
		horizontalAlignment = Enum.HorizontalAlignment.Center
	end

	v14.HorizontalAlignment = horizontalAlignment
	local v15 = {
		layout = createElement4("UIListLayout", v14),
		circleSizeContainer = 0
	}
	local circleSizeContainer

	if joined.isLoading then
		circleSizeContainer = React.createElement(Skeleton, {
			Size = UDim2.new(0, joined.avatarCircleSize, 0, joined.avatarCircleSize),
			radius = Radius.Circle
		})
	else
		local createElement5 = React.createElement
		local v16 = {
			Size = UDim2.new(0, joined.avatarCircleSize, 0, joined.avatarCircleSize),
			BackgroundTransparency = 1
		}
		local conversationFacePile

		if v8 then
			conversationFacePile = React.createElement(ConversationFacePile, {
				conversationId = joined.conversationId,
				participants = joined.participants,
				onActivated = joined.onCircleActivated or joined.onActivated,
				selectable = joined.onCircleActivated ~= nil and nil
			})
		end

		local avatarCircle

		if not v8 then
			avatarCircle = React.createElement(AvatarCircle, {
				circleColor3 = joined.BackgroundColor3,
				circleTransparency = joined.BackgroundTransparency,
				circleInteriorBackgroundColor3 = joined.avatarCircleBackgroundColor3,
				circleDividerColor3 = joined.avatarCircleDividerColor3,
				circleDividerTransparency = joined.avatarCircleDividerTransparency,
				thumbnails = joined.thumbnails,
				presenceImage = joined.avatarCirclePresenceImage,
				presenceImageColor3 = joined.avatarCirclePresenceImageColor3,
				presenceImageTransparency = joined.avatarCirclePresenceImageTransparency,
				selectable = joined.onCircleActivated ~= nil and nil,
				showNewPresenceImage = joined.showNewPresenceImage,
				onActivated = joined.onCircleActivated or joined.onActivated
			})
		end

		circleSizeContainer = createElement5("Frame", v16, {
				conversationFacePile = conversationFacePile,
				avatarCircle = avatarCircle
			})
			or React.createElement(Skeleton, {
				Size = UDim2.new(0, joined.avatarCircleSize, 0, joined.avatarCircleSize),
				radius = Radius.Circle
			})
	end

	v15.circleSizeContainer = circleSizeContainer
	children.circleHolder = createElement3("Frame", v13, v15)

	local createElement5 = React.createElement
	local v16 = {
		Size = UDim2.new(1, -joined.avatarCircleCellWidth, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v17 = {
		layout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2)
		}),
		titleContainer = 0,
		userPresenceLabelWithIcon = 0
	}
	local titleContainer

	if joined.isLoading then
		titleContainer = React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, v4),
			radius = Radius.Small,
			LayoutOrder = 1
		})
	else
		local createElement6 = React.createElement
		local v18 = { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, v4), LayoutOrder = 1 }

		local createElement7 = React.createElement
		local verticalAlignment

		if FFlagAppChatFixPlusBadgeAlignment then
			verticalAlignment = Enum.VerticalAlignment.Center
		else
			verticalAlignment = Enum.VerticalAlignment.Bottom
		end

		local children2 = {
			layout = createElement7("UIListLayout", {
				VerticalAlignment = verticalAlignment,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			title = 0,
			subscriptionBadge = 0,
			secondaryTitle = 0
		}

		local createElement8 = React.createElement
		local v19 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, v4),
			TextSize = joined.titleTextSize,
			TextColor3 = joined.titleTextColor3,
			TextTransparency = joined.titleTextTransparency,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			LayoutOrder = 1
		}
		local font

		if not FoundationFontFaceMigration then
			font = joined.titleFont
		end

		v19.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(joined.titleFont)
		end

		v19.FontFace = fontFace
		v19.Text = joined.titleText or ""
		v19.TextTruncate = Enum.TextTruncate.SplitWord
		v19.TextXAlignment = Enum.TextXAlignment.Left
		children2.title = createElement8("TextLabel", v19, {
			flex = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Shrink })
		})
		local subscriptionBadge

		if FFlagAppChatFixPlusBadgeAlignment then
			if joined.isRobloxSubscriber then
				subscriptionBadge = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.RobloxPlus,
					size = Foundation.Enums.IconSize.Small,
					style = {
						Color3 = joined.titleTextColor3,
						Transparency = joined.titleTextTransparency
					},
					LayoutOrder = 2
				})
			end
		else
			subscriptionBadge = React.createElement(Foundation.View, {
				tag = "size-400-400",
				LayoutOrder = 2,
				Visible = joined.isRobloxSubscriber == true
			}, {
				Icon = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.RobloxPlus,
					size = Foundation.Enums.IconSize.Small,
					style = {
						Color3 = joined.titleTextColor3,
						Transparency = joined.titleTextTransparency
					}
				})
			})
		end

		children2.subscriptionBadge = subscriptionBadge

		local createElement9 = React.createElement
		local v20 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, joined.secondaryTitleTextSize),
			TextSize = joined.secondaryTitleTextSize,
			TextColor3 = joined.secondaryTitleTextColor3,
			TextTransparency = joined.secondaryTitleTextTransparency,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			LayoutOrder = 0
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = joined.secondaryTitleFont
		end

		v20.Font = font2
		local fontFace2

		if FoundationFontFaceMigration then
			fontFace2 = normalizeFontFace(joined.secondaryTitleFont)
		end

		v20.FontFace = fontFace2

		v20.Text = joined.secondaryTitleText or ""
		v20.TextTruncate = Enum.TextTruncate.AtEnd
		v20.TextXAlignment = Enum.TextXAlignment.Left
		v20.LayoutOrder = FFlagEnableBlackbirdCheck and 3 or 2
		children2.secondaryTitle = createElement9("TextLabel", v20, {
			flex = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
		})
		titleContainer = createElement6("Frame", v18, children2)
			or React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v4),
				radius = Radius.Small,
				LayoutOrder = 1
			})
	end

	v17.titleContainer = titleContainer
	local userPresenceLabelWithIcon

	if joined.subTitleText then
		local createElement6 = React.createElement
		local v18 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v3),
			LayoutOrder = 2,
			[React.Change.AbsoluteSize] = FFlagAppChatTimestampInSubtitle and function(p2)
				v6(p2.AbsoluteSize.X)
			end or nil
		}

		local v19 = {
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(
					0,
					FFlagAppChatTimestampInSubtitle and not joined.subTitleIcon and 0 or joined.subTitlePadding
				)
			}),
			subTitleIcon = 0,
			userPresenceLabel = 0,
			timestampLabel = 0
		}
		local subTitleIcon

		if joined.subTitleIcon and not joined.isLoading then
			subTitleIcon = React.createElement(ImageSetLabel, {
				Size = UDim2.new(0, v3, 0, v3),
				BackgroundTransparency = 1,
				Image = joined.subTitleIcon,
				ImageColor3 = joined.subTitleIconColor3,
				ImageTransparency = joined.subTitleIconTransparency,
				LayoutOrder = 1
			})
		end

		v19.subTitleIcon = subTitleIcon
		local userPresenceLabel

		if joined.isLoading then
			userPresenceLabel = React.createElement(Skeleton, {
				Size = UDim2.new(0.6, 0, 0, v5),
				radius = Radius.Small,
				LayoutOrder = 2
			})
		else
			local createElement7 = React.createElement
			local automaticSize

			if FFlagAppChatTimestampInSubtitle then
				automaticSize = Enum.AutomaticSize.X
			end

			local size

			if FFlagAppChatTimestampInSubtitle then
				size = UDim2.new(0, 0, 0, v5)
			else
				size = UDim2.new(1, not joined.subTitleIcon and 0 or -v3 - joined.subTitlePadding, 0, v5)
			end

			local v20 = {
				BackgroundTransparency = 1,
				AutomaticSize = automaticSize,
				Size = size,
				TextSize = joined.subTitleTextSize + 1,
				TextColor3 = joined.subTitleTextColor3,
				TextTransparency = joined.subTitleTextTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = joined.subTitleText,
				TextTruncate = 0,
				Font = 0,
				FontFace = 0,
				LayoutOrder = 2
			}
			local textTruncate

			if FFlagAppChatTimestampInSubtitle then
				textTruncate = Enum.TextTruncate.SplitWord
			else
				textTruncate = Enum.TextTruncate.AtEnd
			end

			v20.TextTruncate = textTruncate
			local font

			if not FoundationFontFaceMigration then
				font = joined.subTitleTextFont
			end

			v20.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(joined.subTitleTextFont)
			end

			v20.FontFace = fontFace
			userPresenceLabel = createElement7("TextLabel", v20, FFlagAppChatTimestampInSubtitle and {
				sizeConstraint = React.createElement("UISizeConstraint", { MaxSize = maxSize })
			} or nil)
		end

		v19.userPresenceLabel = userPresenceLabel
		local timestampLabel

		if FFlagAppChatTimestampInSubtitle and joined.subTitleTimestamp and not joined.isLoading then
			local createElement7 = React.createElement
			local v20 = {}
			v20.BackgroundTransparency = 1
			v20.AutomaticSize = Enum.AutomaticSize.X
			v20.Size = UDim2.new(0, 0, 0, v5)

			v20.TextSize = joined.subTitleTextSize + 1
			v20.TextColor3 = joined.subTitleTextColor3
			v20.TextTransparency = joined.subTitleTextTransparency
			v20.TextXAlignment = Enum.TextXAlignment.Left
			v20.Text = text
			local font

			if not FoundationFontFaceMigration then
				font = joined.subTitleTextFont
			end

			v20.Font = font
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(joined.subTitleTextFont)
			end

			v20.FontFace = fontFace

			v20.LayoutOrder = 3
			v20[React.Change.AbsoluteSize] = function(p2)
				v7(p2.AbsoluteSize.X)
			end

			timestampLabel = createElement7("TextLabel", v20)
		end

		v19.timestampLabel = timestampLabel
		userPresenceLabelWithIcon = createElement6("Frame", v18, v19)
	end

	v17.userPresenceLabelWithIcon = userPresenceLabelWithIcon
	children.conversationInfo = createElement5("Frame", v16, v17)
	return createElement(BaseCell, v11, {
		leftAlign = createElement2("Frame", v12, children),
		rightAlign = React.createElement("Frame", {
			Size = UDim2.new(0, joined.childWidth, 1, 0),
			Position = UDim2.new(1, -joined.childWidth, 0, 0),
			BackgroundTransparency = 1
		}, Cryo.Dictionary.join({
			uiPadding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, joined.paddingRight)
			}),
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}, joined2))
	})
end

return React.memo(PresenceBubbleCell)
