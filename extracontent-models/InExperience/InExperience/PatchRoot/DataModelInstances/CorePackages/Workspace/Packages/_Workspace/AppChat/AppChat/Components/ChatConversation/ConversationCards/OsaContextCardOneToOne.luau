local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Foundation = require(AppChatParent.Foundation)
local UserTile = require(AppChatParent.UserTile).UserTile
local LayoutMode = require(AppChatParent.UserTile).LayoutMode
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useFoundationPresence = require(AppChat.Hooks.useFoundationPresence)
local FFlagAppChatContextCardNameLoadingShimmer = require(AppChat.Flags.FFlagAppChatContextCardNameLoadingShimmer)
local FFlagEnableBlackbirdCheck = require(AppChatParent.SharedFlags).FFlagEnableBlackbirdCheck

return React.memo(React.forwardRef(function(t1: {[any]: any}, p1) -- line: 35
	-- upvalues: useTokens (copy), useFoundationPresence (copy), useLocalization (copy), FFlagAppChatContextCardNameLoadingShimmer (copy), React (copy), Foundation (copy), Skeleton (copy), UserTile (copy), LayoutMode (copy), FFlagEnableBlackbirdCheck (copy)
	local v15 = useTokens()
	local Size = v15.Size
	local v17 = useFoundationPresence(t1.userId)
	local v18 = useLocalization({
		firstConversationWithThisUserHeadingText = "Feature.Chat.Heading.FirstConversationWithThisUser",
		firstInteractionWithThisPersonHeadingText = "Feature.Chat.Heading.FirstInteractionWithThisPerson",
		osaContextCardDescriptionText = "Feature.Chat.Description.OSAContextCardDescription",
		user = "Feature.Chat.Label.User",
		firstConversationWithHeadingText = {
			"Feature.Chat.Heading.FirstConversationWith",
			displayName = t1.displayName
		},
		firstInteractionWithHeadingText = {
			"Feature.Chat.Heading.FirstInteractionWith",
			displayName = t1.displayName
		}
	})
	local isChatUserMessagesEnabled = t1.isChatUserMessagesEnabled
	local v20 = if not isChatUserMessagesEnabled then v18.firstInteractionWithHeadingText else v18.firstConversationWithHeadingText
	local v21 = if not isChatUserMessagesEnabled then v18.firstInteractionWithThisPersonHeadingText else v18.firstConversationWithThisUserHeadingText

	if FFlagAppChatContextCardNameLoadingShimmer then
		local v22 = not t1.displayName and not t1.hasError
		local v23 = not t1.username and not t1.hasError
		local v24 = not t1.avatarThumbnail and not t1.hasError
		local v25 = not v22 and (not v23 and not v24)

		return React.createElement(Foundation.View, {
			tag = "col align-x-center size-full-0 auto-y padding-xxlarge radius-large bg-shift-100 gap-xlarge",
			sizeConstraint = {
				MaxSize = Vector2.new(700, 500)
			}
		}, {
			AvatarContainer = React.createElement(Foundation.View, {
				tag = "col auto-xy bg-action-subtle align-x-center gap-medium radius-large padding-small",
				LayoutOrder = 1,
				onActivated = if not v25 then nil else t1.onAvatarActivated
			}, {
				AvatarCircle = if not v24 then React.createElement(Foundation.View, {
					tag = "size-1200-1200",
					LayoutOrder = 1
				}, { React.createElement(UserTile, {
					dontTruncateTitle = true,
					userId = tostring(t1.userId),
					layoutMode = LayoutMode.compact,
					userPresenceType = v17.presence,
					onActivated = t1.onAvatarActivated,
					isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else t1.isRobloxSubscriber
				}) }) else React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0, Size.Size_1200, 0, Size.Size_1200),
					radius = Foundation.Enums.Radius.Circle
				}),
				AvatarTextContainer = React.createElement(Foundation.View, {
					tag = "col auto-xy align-x-center gap-xxsmall",
					LayoutOrder = 2
				}, {
					DisplayName = if not v22 then if not FFlagEnableBlackbirdCheck or (not t1.isRobloxSubscriber or t1.hasError) then React.createElement(Foundation.Text, {
						tag = "auto-xy",
						LayoutOrder = 1,
						Text = if not t1.hasError then t1.displayName else v18.user,
						fontStyle = v15.Typography.TitleMedium,
						textStyle = v15.Color.Content.Emphasis
					}) else React.createElement(Foundation.View, {
						tag = "row auto-xy align-y-center gap-xsmall",
						LayoutOrder = 1
					}, {
						Name = React.createElement(Foundation.Text, {
							tag = "auto-xy",
							LayoutOrder = 1,
							Text = t1.displayName,
							fontStyle = v15.Typography.TitleMedium,
							textStyle = v15.Color.Content.Emphasis
						}),
						Badge = React.createElement(Foundation.Icon, {
							LayoutOrder = 2,
							name = Foundation.Enums.IconName.RobloxPlus,
							size = Foundation.Enums.IconSize.Small,
							style = v15.Color.Content.Emphasis
						})
					}) else React.createElement(Skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(0, Size.Size_2500, 0, v15.Typography.TitleMedium.FontSize),
						radius = Foundation.Enums.Radius.Large
					}),
					Username = if not v23 then React.createElement(Foundation.Text, {
						tag = "auto-xy",
						LayoutOrder = 2,
						Text = if not t1.hasError then t1.username else v18.user,
						fontStyle = v15.Typography.BodySmall,
						textStyle = v15.Color.Content.Muted
					}) else React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(0, Size.Size_2000, 0, v15.Typography.BodySmall.FontSize),
						radius = Foundation.Enums.Radius.Large
					})
				})
			}),
			TextContainer = React.createElement(Foundation.View, {
				tag = "col align-x-center auto-xy",
				LayoutOrder = 2,
				ref = p1
			}, {
				HeadingText = if not v22 then React.createElement(Foundation.Text, {
					tag = "auto-xy text-wrap",
					LayoutOrder = 1,
					Text = if not t1.hasError then v20 else v21,
					fontStyle = v15.Typography.TitleLarge,
					textStyle = v15.Color.Content.Emphasis
				}) else React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0, Size.Size_3000, 0, v15.Typography.TitleLarge.FontSize + v15.Gap.XXSmall),
					radius = Foundation.Enums.Radius.Large
				}),
				DescriptionText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-wrap",
					LayoutOrder = 2,
					Text = v18.osaContextCardDescriptionText,
					fontStyle = v15.Typography.BodyLarge,
					textStyle = v15.Color.Content.Default
				})
			})
		})
	end

	if (not t1.displayName or (not t1.username or not t1.avatarThumbnail)) and not t1.hasError then
		return React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			sizeConstraint = {
				MaxSize = Vector2.new(700, 500)
			}
		}, { React.createElement(Foundation.Skeleton, {
			Size = UDim2.new(1, 0, 0, 270),
			radius = Foundation.Enums.Radius.Large
		}) })
	end

	return React.createElement(Foundation.View, {
		tag = "col align-x-center size-full-0 auto-y padding-xxlarge radius-large bg-shift-100 gap-xlarge",
		sizeConstraint = {
			MaxSize = Vector2.new(700, 500)
		}
	}, {
		AvatarContainer = if not t1.hasError then React.createElement(Foundation.View, {
			tag = "col auto-xy bg-action-subtle align-x-center gap-medium radius-large padding-small",
			LayoutOrder = 1,
			onActivated = t1.onAvatarActivated
		}, {
			AvatarCircle = React.createElement(Foundation.View, {
				tag = "size-1200-1200",
				LayoutOrder = 1
			}, { React.createElement(UserTile, {
				dontTruncateTitle = true,
				userId = tostring(t1.userId),
				layoutMode = LayoutMode.compact,
				userPresenceType = v17.presence,
				onActivated = t1.onAvatarActivated,
				isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else t1.isRobloxSubscriber
			}) }),
			AvatarTextContainer = React.createElement(Foundation.View, {
				tag = "col auto-xy align-x-center",
				LayoutOrder = 2
			}, {
				DisplayName = if not FFlagEnableBlackbirdCheck or not t1.isRobloxSubscriber then React.createElement(Foundation.Text, {
					tag = "auto-xy",
					LayoutOrder = 1,
					Text = t1.displayName,
					fontStyle = v15.Typography.TitleMedium,
					textStyle = v15.Color.Content.Emphasis
				}) else React.createElement(Foundation.View, {
					tag = "row auto-xy align-y-center gap-xsmall",
					LayoutOrder = 1
				}, {
					Name = React.createElement(Foundation.Text, {
						tag = "auto-xy",
						LayoutOrder = 1,
						Text = t1.displayName,
						fontStyle = v15.Typography.TitleMedium,
						textStyle = v15.Color.Content.Emphasis
					}),
					Badge = React.createElement(Foundation.Icon, {
						LayoutOrder = 2,
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small,
						style = v15.Color.Content.Emphasis
					})
				}),
				Username = React.createElement(Foundation.Text, {
					tag = "auto-xy",
					LayoutOrder = 2,
					Text = t1.username,
					fontStyle = v15.Typography.BodySmall,
					textStyle = v15.Color.Content.Muted
				})
			})
		}) else nil,
		TextContainer = React.createElement(Foundation.View, {
			tag = "col align-x-center auto-xy",
			LayoutOrder = 2,
			ref = p1
		}, {
			HeadingText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-wrap",
				LayoutOrder = 1,
				Text = if not t1.hasError then v20 else v21,
				fontStyle = v15.Typography.TitleLarge,
				textStyle = v15.Color.Content.Emphasis
			}),
			DescriptionText = React.createElement(Foundation.Text, {
				tag = "auto-xy text-wrap",
				LayoutOrder = 2,
				Text = v18.osaContextCardDescriptionText,
				fontStyle = v15.Typography.BodyLarge,
				textStyle = v15.Color.Content.Default
			})
		})
	})
end))
