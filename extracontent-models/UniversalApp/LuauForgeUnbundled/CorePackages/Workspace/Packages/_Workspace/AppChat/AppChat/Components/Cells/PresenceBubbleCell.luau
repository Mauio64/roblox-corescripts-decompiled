local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local BaseCell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/BaseCell")

local ConversationFacePile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/ConversationFacePile")
local AvatarCircle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Cells/AvatarCircle")
local FFlagDebugAppChatEnableDomLocators = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatEnableDomLocators")
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableBlackbirdCheck
local FFlagAppChatFixPlusBadgeAlignment = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFixPlusBadgeAlignment")
local FFlagAppChatTimestampInSubtitle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatTimestampInSubtitle")

local v5 = {
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

local function PresenceBubbleCell(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useTextSizeOffset()
	local v7 = joined.subTitleTextSize + v6
	local v8 = joined.titleTextSize + v6
	local v9 = joined.subTitleTextSize + v6
	local v10, v11, v12, v13

	if FFlagAppChatTimestampInSubtitle then
		local v14
		v14, v10 = React.useBinding(1e999)
		local v15
		v15, v11 = React.useBinding(0)
		v12 = React.joinBindings({ v14, v15 }):map(function(list)
			return Vector2.new(math.max(0, list[1] - list[2]), 1e999)
		end)

		v13 = React.useMemo(function()
			if not joined.subTitleTimestamp then
				return nil
			end

			local subTitleText = joined.subTitleText

			if subTitleText and subTitleText ~= "" then
				return joined.subTitleTimestamp:map(function(p3)
					if p3 == "" then
						return ""
					end

					return " · " .. p3
				end)
			end

			return joined.subTitleTimestamp
		end, { joined.subTitleTimestamp, joined.subTitleText })
	else
		v10 = nil
		v11 = nil
	end

	local v14 = joined.conversationId ~= nil
	local v15 = {
		layout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	local v16 = -(joined.paddingLeft + joined.paddingRight + joined.childWidth)
	local joined2 = Cryo.Dictionary.join(v15, joined.children or {})
	local createElement = React.createElement
	local v18 = {
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
	local v19 = if FFlagDebugAppChatEnableDomLocators then joined.testId else nil
	v18.testId = v19

	v18.LayoutOrder = joined.LayoutOrder
	v18.onActivated = joined.onActivated
	v18.showDivider = joined.showDivider

	local createElement2 = React.createElement
	local v21 = { Size = UDim2.new(1, v16, 1, 0), BackgroundTransparency = 1 }

	local children2 = {
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
	local v23 = {
		Size = UDim2.new(0, joined.avatarCircleCellWidth, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 0
	}

	local createElement4 = React.createElement
	local v26 = {
		VerticalAlignment = Enum.VerticalAlignment.Center,
		HorizontalAlignment = 0
	}
	local v27 = if joined.hideLeftAvatarPadding then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center
	v26.HorizontalAlignment = v27
	local v24 = {
		layout = createElement4("UIListLayout", v26),
		circleSizeContainer = 0
	}
	local v28

	if joined.isLoading then
		v28 = React.createElement(skeleton, {
			Size = UDim2.new(0, joined.avatarCircleSize, 0, joined.avatarCircleSize),
			radius = radius.Circle
		})
	else
		local createElement5 = React.createElement
		local v30 = {
			Size = UDim2.new(0, joined.avatarCircleSize, 0, joined.avatarCircleSize),
			BackgroundTransparency = 1
		}
		local v32

		if v14 then
			local createElement6 = React.createElement
			local v34 = {
				conversationId = joined.conversationId,
				participants = joined.participants,
				onActivated = joined.onCircleActivated or joined.onActivated,
				selectable = 0
			}
			local v35 = if joined.onCircleActivated == nil then false else nil
			v34.selectable = v35
			v32 = createElement6(ConversationFacePile, v34)
		end

		local v33

		if not v14 then
			local createElement6 = React.createElement
			local v35 = {
				circleColor3 = joined.BackgroundColor3,
				circleTransparency = joined.BackgroundTransparency,
				circleInteriorBackgroundColor3 = joined.avatarCircleBackgroundColor3,
				circleDividerColor3 = joined.avatarCircleDividerColor3,
				circleDividerTransparency = joined.avatarCircleDividerTransparency,
				thumbnails = joined.thumbnails,
				presenceImage = joined.avatarCirclePresenceImage,
				presenceImageColor3 = joined.avatarCirclePresenceImageColor3,
				presenceImageTransparency = joined.avatarCirclePresenceImageTransparency,
				selectable = 0,
				showNewPresenceImage = 0,
				onActivated = 0
			}
			local v36 = if joined.onCircleActivated == nil then false else nil
			v35.selectable = v36
			v35.showNewPresenceImage = joined.showNewPresenceImage

			v35.onActivated = joined.onCircleActivated or joined.onActivated
			v33 = createElement6(AvatarCircle, v35)
		end

		v28 = createElement5("Frame", v30, {
				conversationFacePile = v32,
				avatarCircle = v33
			})
			or React.createElement(skeleton, {
				Size = UDim2.new(0, joined.avatarCircleSize, 0, joined.avatarCircleSize),
				radius = radius.Circle
			})
	end

	v24.circleSizeContainer = v28
	children2.circleHolder = createElement3("Frame", v23, v24)

	local createElement5 = React.createElement
	local v30 = {
		Size = UDim2.new(1, -joined.avatarCircleCellWidth, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}

	local v31 = {
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
	local v32

	if joined.isLoading then
		v32 = React.createElement(skeleton, {
			Size = UDim2.new(1, 0, 0, v8),
			radius = radius.Small,
			LayoutOrder = 1
		})
	else
		local createElement6 = React.createElement
		local v34 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v8),
			LayoutOrder = 1
		}

		local createElement7 = React.createElement

		local v37 = if FFlagAppChatFixPlusBadgeAlignment then Enum.VerticalAlignment.Center else Enum.VerticalAlignment.Bottom
		local children3 = {
			layout = createElement7("UIListLayout", {
				VerticalAlignment = v37,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 0, v8),
				TextSize = joined.titleTextSize,
				TextColor3 = joined.titleTextColor3,
				TextTransparency = joined.titleTextTransparency,
				FontFace = normalizeFontFace(joined.titleFont),
				Text = joined.titleText or "",
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1
			}, {
				flex = React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Shrink
				})
			}),
			subscriptionBadge = 0,
			secondaryTitle = 0
		}
		local v38

		if FFlagAppChatFixPlusBadgeAlignment then
			if joined.isRobloxSubscriber then
				v38 = React.createElement(Foundation.Icon, {
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
			v38 = React.createElement(Foundation.View, {
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

		children3.subscriptionBadge = v38

		children3.secondaryTitle = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, joined.secondaryTitleTextSize),
			TextSize = joined.secondaryTitleTextSize,
			TextColor3 = joined.secondaryTitleTextColor3,
			TextTransparency = joined.secondaryTitleTextTransparency,
			FontFace = normalizeFontFace(joined.secondaryTitleFont),
			Text = joined.secondaryTitleText or "",
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
			LayoutOrder = fFlagEnableBlackbirdCheck and 3 or 2
		}, {
			flex = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			})
		})
		v32 = createElement6("Frame", v34, children3)
			or React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, v8),
				radius = radius.Small,
				LayoutOrder = 1
			})
	end

	v31.titleContainer = v32
	local v33

	if joined.subTitleText then
		local createElement6 = React.createElement
		local v35 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, v7),
			LayoutOrder = 2,
			[React.Change.AbsoluteSize] = FFlagAppChatTimestampInSubtitle and function(p3)
				v10(p3.AbsoluteSize.X)
			end or nil
		}

		local v36 = {
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, FFlagAppChatTimestampInSubtitle and not joined.subTitleIcon and 0 or joined.subTitlePadding)
			}),
			subTitleIcon = 0,
			userPresenceLabel = 0,
			timestampLabel = 0
		}

		local v37 = if joined.subTitleIcon and not joined.isLoading then React.createElement(imageSetLabel, {
			Size = UDim2.new(0, v7, 0, v7),
			BackgroundTransparency = 1,
			Image = joined.subTitleIcon,
			ImageColor3 = joined.subTitleIconColor3,
			ImageTransparency = joined.subTitleIconTransparency,
			LayoutOrder = 1
		}) else nil
		v36.subTitleIcon = v37
		local v38

		if joined.isLoading then
			v38 = React.createElement(skeleton, {
				Size = UDim2.new(0.6, 0, 0, v9),
				radius = radius.Small,
				LayoutOrder = 2
			})
		else
			local createElement7 = React.createElement

			local v41 = if FFlagAppChatTimestampInSubtitle then Enum.AutomaticSize.X else nil

			local v42 = if FFlagAppChatTimestampInSubtitle then UDim2.new(0, 0, 0, v9) else UDim2.new(
				1,
				not joined.subTitleIcon and 0 or -v7 - joined.subTitlePadding,
				0,
				v9
			)
			local v40 = {
				BackgroundTransparency = 1,
				AutomaticSize = v41,
				Size = v42,
				TextSize = joined.subTitleTextSize + 1,
				TextColor3 = joined.subTitleTextColor3,
				TextTransparency = joined.subTitleTextTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = joined.subTitleText,
				TextTruncate = 0,
				FontFace = 0,
				LayoutOrder = 2
			}

			local v43 = if FFlagAppChatTimestampInSubtitle then Enum.TextTruncate.SplitWord else Enum.TextTruncate.AtEnd
			v40.TextTruncate = v43

			v40.FontFace = normalizeFontFace(joined.subTitleTextFont)
			v38 = createElement7("TextLabel", v40, FFlagAppChatTimestampInSubtitle and {
				sizeConstraint = React.createElement("UISizeConstraint", {
					MaxSize = v12
				})
			} or nil)
		end

		v36.userPresenceLabel = v38
		local v39

		if FFlagAppChatTimestampInSubtitle and joined.subTitleTimestamp and not joined.isLoading then
			v39 = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 0, v9),
				TextSize = joined.subTitleTextSize + 1,
				TextColor3 = joined.subTitleTextColor3,
				TextTransparency = joined.subTitleTextTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = v13,
				FontFace = normalizeFontFace(joined.subTitleTextFont),
				LayoutOrder = 3,
				[React.Change.AbsoluteSize] = function(p3)
					v11(p3.AbsoluteSize.X)
				end
			})
		end

		v36.timestampLabel = v39
		v33 = createElement6("Frame", v35, v36)
	end

	v31.userPresenceLabelWithIcon = v33
	children2.conversationInfo = createElement5("Frame", v30, v31)
	return createElement(BaseCell, v18, {
		leftAlign = createElement2("Frame", v21, children2),
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
