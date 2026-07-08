local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local UIBlox = require(AppChatParent.UIBlox)
local Foundation = require(AppChatParent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local BaseCell = require(script.Parent.BaseCell)
local ConversationFacePile = require(AppChat.Components.Cells.ConversationFacePile)
local AvatarCircle = require(script.Parent.AvatarCircle)
local FFlagDebugAppChatEnableDomLocators = require(AppChat.Flags.FFlagDebugAppChatEnableDomLocators)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck
local FFlagAppChatFixPlusBadgeAlignment = require(AppChat.Flags.FFlagAppChatFixPlusBadgeAlignment)
local FFlagAppChatTimestampInSubtitle = require(AppChat.Flags.FFlagAppChatTimestampInSubtitle)
local t1 = {
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

local function PresenceBubbleCell(t2: {[any]: any}) -- line: 142
	-- upvalues: Cryo (copy), t1 (copy), useTextSizeOffset (copy), FFlagAppChatTimestampInSubtitle (copy), React (copy), BaseCell (copy), FFlagDebugAppChatEnableDomLocators (copy), ConversationFacePile (copy), AvatarCircle (copy), Skeleton (copy), EnumsRadius (copy), FFlagAppChatFixPlusBadgeAlignment (copy), Foundation (copy), FFlagEnableBlackbirdCheck (copy), ImageSetLabel (copy)
	local v21 = Cryo.Dictionary.join(t1, t2)
	local v22 = useTextSizeOffset()
	local v23 = v21.subTitleTextSize + v22
	local v24 = v21.titleTextSize + v22
	local v25 = v21.subTitleTextSize + v22
	local u26 = nil
	local u27 = nil
	local v28 = nil
	local v29 = nil

	if FFlagAppChatTimestampInSubtitle then
		local v30, v31 = React.useBinding(1e999)

		u26 = v31

		local v32, v33 = React.useBinding(0)

		u27 = v33
		v28 = React.joinBindings({
			v30,
			v32
		}):map(function(t3: {[any]: any}) -- line: 157
			return Vector2.new(math.max(0, t3[1] - t3[2]), 1e999)
		end)
		v29 = React.useMemo(function() -- line: 160
			-- upvalues: v21 (copy)
			if not v21.subTitleTimestamp then
				return nil
			end

			local subTitleText = v21.subTitleText

			if subTitleText and subTitleText ~= "" then
				return v21.subTitleTimestamp:map(function(s1: string) -- line: 166
					if s1 == "" then
						return ""
					end

					return " · " .. s1
				end)
			end

			return v21.subTitleTimestamp
		end, {
			v21.subTitleTimestamp,
			v21.subTitleText
		})
	end

	local v34 = v21.conversationId ~= nil
	local t4 = {
		layout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}
	local v36 = -(v21.paddingLeft + v21.paddingRight + v21.childWidth)
	local v37 = Cryo.Dictionary.join(t4, v21.children or {})

	return React.createElement(BaseCell, {
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Size = v21.Size,
		BackgroundTransparency = v21.BackgroundTransparency,
		BackgroundColor3 = v21.BackgroundColor3,
		dividerColor3 = v21.dividerColor3,
		dividerTransparency = v21.dividerTransparency,
		avatarCircleCellWidth = v21.avatarCircleCellWidth,
		onPressedBackgroundColor3 = v21.onPressedBackgroundColor3,
		onPressedBackgroundTransparency = v21.onPressedBackgroundTransparency,
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else v21.testId,
		LayoutOrder = v21.LayoutOrder,
		onActivated = v21.onActivated,
		showDivider = v21.showDivider
	}, {
		leftAlign = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, v36, 1, 0)
		}, {
			uiPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v21.paddingLeft)
			}),
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			circleHolder = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(0, v21.avatarCircleCellWidth, 1, 0)
			}, {
				layout = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = if not v21.hideLeftAvatarPadding then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left
				}),
				circleSizeContainer = not v21.isLoading and React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, v21.avatarCircleSize, 0, v21.avatarCircleSize)
				}, {
					conversationFacePile = if not v34 then nil else React.createElement(ConversationFacePile, {
						conversationId = v21.conversationId,
						onActivated = v21.onCircleActivated or v21.onActivated,
						selectable = v21.onCircleActivated ~= nil and nil
					}),
					avatarCircle = if v34 then nil else React.createElement(AvatarCircle, {
						circleColor3 = v21.BackgroundColor3,
						circleTransparency = v21.BackgroundTransparency,
						circleInteriorBackgroundColor3 = v21.avatarCircleBackgroundColor3,
						circleDividerColor3 = v21.avatarCircleDividerColor3,
						circleDividerTransparency = v21.avatarCircleDividerTransparency,
						thumbnails = v21.thumbnails,
						presenceImage = v21.avatarCirclePresenceImage,
						presenceImageColor3 = v21.avatarCirclePresenceImageColor3,
						presenceImageTransparency = v21.avatarCirclePresenceImageTransparency,
						selectable = v21.onCircleActivated ~= nil and nil,
						showNewPresenceImage = v21.showNewPresenceImage,
						onActivated = v21.onCircleActivated or v21.onActivated
					})
				}) or React.createElement(Skeleton, {
					Size = UDim2.new(0, v21.avatarCircleSize, 0, v21.avatarCircleSize),
					radius = EnumsRadius.Circle
				})
			}),
			conversationInfo = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, -v21.avatarCircleCellWidth, 1, 0)
			}, {
				layout = React.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 2)
				}),
				titleContainer = not v21.isLoading and React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v24)
				}, {
					layout = React.createElement("UIListLayout", {
						VerticalAlignment = if not FFlagAppChatFixPlusBadgeAlignment then Enum.VerticalAlignment.Bottom else Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 4)
					}),
					title = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.new(0, 0, 0, v24),
						TextSize = v21.titleTextSize,
						TextColor3 = v21.titleTextColor3,
						TextTransparency = v21.titleTextTransparency,
						Font = v21.titleFont,
						Text = v21.titleText or "",
						TextTruncate = Enum.TextTruncate.SplitWord,
						TextXAlignment = Enum.TextXAlignment.Left
					}, {
						flex = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Shrink
						})
					}),
					subscriptionBadge = if not FFlagAppChatFixPlusBadgeAlignment then React.createElement(Foundation.View, {
						tag = "size-400-400",
						LayoutOrder = 2,
						Visible = v21.isRobloxSubscriber == true
					}, {
						Icon = React.createElement(Foundation.Icon, {
							name = Foundation.Enums.IconName.RobloxPlus,
							size = Foundation.Enums.IconSize.Small,
							style = {
								Color3 = v21.titleTextColor3,
								Transparency = v21.titleTextTransparency
							}
						})
					}) else if not v21.isRobloxSubscriber then nil else React.createElement(Foundation.Icon, {
						LayoutOrder = 2,
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small,
						style = {
							Color3 = v21.titleTextColor3,
							Transparency = v21.titleTextTransparency
						}
					}),
					secondaryTitle = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 0, 0, v21.secondaryTitleTextSize),
						TextSize = v21.secondaryTitleTextSize,
						TextColor3 = v21.secondaryTitleTextColor3,
						TextTransparency = v21.secondaryTitleTextTransparency,
						Font = v21.secondaryTitleFont,
						Text = v21.secondaryTitleText or "",
						TextTruncate = Enum.TextTruncate.AtEnd,
						TextXAlignment = Enum.TextXAlignment.Left,
						LayoutOrder = not FFlagEnableBlackbirdCheck and 2 or 3
					}, {
						flex = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Fill
						})
					})
				}) or React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v24),
					radius = EnumsRadius.Small
				}),
				userPresenceLabelWithIcon = if not v21.subTitleText then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, v23),
					LayoutOrder = 2,
					[React.Change.AbsoluteSize] = if not FFlagAppChatTimestampInSubtitle then nil else function(p1) -- line: 371
						-- upvalues: u26 (ref)
						u26(p1.AbsoluteSize.X)
					end
				}, {
					layout = React.createElement("UIListLayout", {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						FillDirection = Enum.FillDirection.Horizontal,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, if not FFlagAppChatTimestampInSubtitle or v21.subTitleIcon then v21.subTitlePadding else 0)
					}),
					subTitleIcon = if not v21.subTitleIcon or v21.isLoading then nil else React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(0, v23, 0, v23),
						Image = v21.subTitleIcon,
						ImageColor3 = v21.subTitleIconColor3,
						ImageTransparency = v21.subTitleIconTransparency
					}),
					userPresenceLabel = if not v21.isLoading then React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AutomaticSize = if not FFlagAppChatTimestampInSubtitle then nil else Enum.AutomaticSize.X,
						Size = if not FFlagAppChatTimestampInSubtitle then UDim2.new(1, not v21.subTitleIcon and 0 or -v23 - v21.subTitlePadding, 0, v25) else UDim2.new(0, 0, 0, v25),
						TextSize = v21.subTitleTextSize + 1,
						TextColor3 = v21.subTitleTextColor3,
						TextTransparency = v21.subTitleTextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						Text = v21.subTitleText,
						TextTruncate = if not FFlagAppChatTimestampInSubtitle then Enum.TextTruncate.AtEnd else Enum.TextTruncate.SplitWord,
						Font = v21.subTitleTextFont
					}, if not FFlagAppChatTimestampInSubtitle then nil else {
						sizeConstraint = React.createElement("UISizeConstraint", {
							MaxSize = v28
						})
					}) else React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(0.6, 0, 0, v25),
						radius = EnumsRadius.Small
					}),
					timestampLabel = if not FFlagAppChatTimestampInSubtitle or (not v21.subTitleTimestamp or v21.isLoading) then nil else React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = UDim2.new(0, 0, 0, v25),
						TextSize = v21.subTitleTextSize + 1,
						TextColor3 = v21.subTitleTextColor3,
						TextTransparency = v21.subTitleTextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						Text = v29,
						Font = v21.subTitleTextFont,
						LayoutOrder = 3,
						[React.Change.AbsoluteSize] = function(p2) -- line: 454
							-- upvalues: u27 (ref)
							u27(p2.AbsoluteSize.X)
						end
					})
				})
			})
		}),
		rightAlign = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, v21.childWidth, 1, 0),
			Position = UDim2.new(1, -v21.childWidth, 0, 0)
		}, Cryo.Dictionary.join({
			uiPadding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v21.paddingRight)
			}),
			layout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		}, v37))
	})
end

return React.memo(PresenceBubbleCell)
