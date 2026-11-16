local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode
local Skeleton = Foundation.Skeleton

local useTokens = Foundation.Hooks.useTokens
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useFoundationPresence = require(AppChat.Hooks.useFoundationPresence)

local FFlagAppChatContextCardNameLoadingShimmer = require(AppChat.Flags.FFlagAppChatContextCardNameLoadingShimmer)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagAppChatDiscloseUpdateSecondVersion = SharedFlags.FFlagAppChatDiscloseUpdateSecondVersion

return React.memo(React.forwardRef(function(props, ref)
	local v = useTokens()
	local size = v.Size
	local v2 = useFoundationPresence(props.userId)
	local v3 = {
		firstConversationWithThisUserHeadingText = FFlagAppChatDiscloseUpdateSecondVersion and "Feature.Chat.Heading.FirstConversationWithThisUser" or "Feature.Chat.Heading.SafeChattingWithThisUser",
		firstConversationWithHeadingText = 0,
		firstInteractionWithThisPersonHeadingText = "Feature.Chat.Heading.FirstInteractionWithThisPerson",
		firstInteractionWithHeadingText = 0,
		osaContextCardDescriptionText = 0,
		user = "Feature.Chat.Label.User"
	}
	local firstConversationWithHeadingText

	if FFlagAppChatDiscloseUpdateSecondVersion then
		firstConversationWithHeadingText = {
			"Feature.Chat.Heading.FirstConversationWith",
			displayName = props.displayName
		}
	else
		firstConversationWithHeadingText = {
			"Feature.Chat.Heading.SafeChattingWithUsername",
			displayName = props.displayName
		}
	end

	v3.firstConversationWithHeadingText = firstConversationWithHeadingText

	v3.firstInteractionWithHeadingText = {
		"Feature.Chat.Heading.FirstInteractionWith",
		displayName = props.displayName
	}

	v3.osaContextCardDescriptionText = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
		and "Feature.Chat.Description.InlineContextCardDescription"
		or "Feature.Chat.Description.OSAContextCardDescription"
	local v4 = useLocalization(v3)
	local text2

	if UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() then
		text2 = v4.firstConversationWithHeadingText
	else
		text2 = v4.firstInteractionWithHeadingText
	end

	local v5

	if UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() then
		v5 = v4.firstConversationWithThisUserHeadingText
	else
		v5 = v4.firstInteractionWithThisPersonHeadingText
	end

	if FFlagAppChatContextCardNameLoadingShimmer then
		local v6 = not (props.displayName or props.hasError)
		local v7 = not (props.username or props.hasError)
		local v8 = not (props.avatarThumbnail or props.hasError)

		local createElement = React.createElement
		local view = Foundation.View
		local v9 = {
			tag = "col align-x-center size-full-0 auto-y padding-xxlarge radius-large bg-shift-100 gap-xlarge",
			sizeConstraint = { MaxSize = Vector2.new(700, 500) }
		}

		local createElement2 = React.createElement
		local view2 = Foundation.View
		local onActivated

		if not (v6 or v7 or v8) then
			onActivated = props.onAvatarActivated
		end

		local avatarCircle

		if v8 then
			avatarCircle = React.createElement(Skeleton, {
				Size = UDim2.new(0, size.Size_1200, 0, size.Size_1200),
				radius = Foundation.Enums.Radius.Circle,
				LayoutOrder = 1
			})
		else
			local createElement3 = React.createElement
			local view3 = Foundation.View

			local createElement4 = React.createElement
			local v10 = {
				userId = tostring(props.userId),
				layoutMode = LayoutMode.compact,
				userPresenceType = v2.presence,
				dontTruncateTitle = true,
				onActivated = props.onAvatarActivated,
				isRobloxSubscriber = 0,
				selectable = 0
			}
			local isRobloxSubscriber

			if FFlagEnableBlackbirdCheck then
				isRobloxSubscriber = props.isRobloxSubscriber
			end

			v10.isRobloxSubscriber = isRobloxSubscriber
			v10.selectable = not FFlagAppChatConsoleFocusFixes and nil
			avatarCircle = createElement3(view3, { tag = "size-1200-1200", LayoutOrder = 1 }, {
				createElement4(userTile, v10)
			})
		end

		local createElement3 = React.createElement
		local view3 = Foundation.View
		local displayName

		if v6 then
			displayName = React.createElement(Skeleton, {
				Size = UDim2.new(0, size.Size_2500, 0, v.Typography.TitleMedium.FontSize),
				radius = Foundation.Enums.Radius.Large,
				LayoutOrder = 1
			})
		elseif FFlagEnableBlackbirdCheck and props.isRobloxSubscriber and not props.hasError then
			displayName = React.createElement(
				Foundation.View,
				{ tag = "row auto-xy align-y-center gap-xsmall", LayoutOrder = 1 },
				{
					Name = React.createElement(Foundation.Text, {
						tag = "auto-xy",
						LayoutOrder = 1,
						Text = props.displayName,
						fontStyle = v.Typography.TitleMedium,
						textStyle = v.Color.Content.Emphasis
					}),
					Badge = React.createElement(Foundation.Icon, {
						LayoutOrder = 2,
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small,
						style = v.Color.Content.Emphasis
					})
				}
			)
		else
			local createElement4 = React.createElement
			local text = Foundation.Text
			local text3

			if props.hasError then
				text3 = v4.user
			else
				text3 = props.displayName
			end

			displayName = createElement4(text, {
				tag = "auto-xy",
				LayoutOrder = 1,
				Text = text3,
				fontStyle = v.Typography.TitleMedium,
				textStyle = v.Color.Content.Emphasis
			})
		end

		local username

		if v7 then
			username = React.createElement(Skeleton, {
				Size = UDim2.new(0, size.Size_2000, 0, v.Typography.BodySmall.FontSize),
				radius = Foundation.Enums.Radius.Large,
				LayoutOrder = 2
			})
		else
			local createElement4 = React.createElement
			local text = Foundation.Text
			local text3

			if props.hasError then
				text3 = v4.user
			else
				text3 = props.username
			end

			username = createElement4(text, {
				tag = "auto-xy",
				LayoutOrder = 2,
				Text = text3,
				fontStyle = v.Typography.BodySmall,
				textStyle = v.Color.Content.Muted
			})
		end

		local children = {
			AvatarContainer = createElement2(
				view2,
				{
					tag = "col auto-xy bg-action-subtle align-x-center gap-medium radius-large padding-small",
					LayoutOrder = 1,
					onActivated = onActivated
				},
				{
					AvatarCircle = avatarCircle,
					AvatarTextContainer = createElement3(
						view3,
						{ tag = "col auto-xy align-x-center gap-xxsmall", LayoutOrder = 2 },
						{ DisplayName = displayName, Username = username }
					)
				}
			),
			TextContainer = 0
		}

		local createElement4 = React.createElement
		local view4 = Foundation.View
		local headingText

		if v6 then
			headingText = React.createElement(Skeleton, {
				Size = UDim2.new(0, size.Size_3000, 0, v.Typography.TitleLarge.FontSize + v.Gap.XXSmall),
				radius = Foundation.Enums.Radius.Large,
				LayoutOrder = 1
			})
		else
			local createElement5 = React.createElement
			local text = Foundation.Text

			if props.hasError then
				text2 = v5
			end

			headingText = createElement5(text, {
				tag = "auto-xy text-wrap",
				LayoutOrder = 1,
				Text = text2,
				fontStyle = v.Typography.TitleLarge,
				textStyle = v.Color.Content.Emphasis
			})
		end

		children.TextContainer = createElement4(
			view4,
			{ tag = "col align-x-center auto-xy", LayoutOrder = 2, ref = ref },
			{
				HeadingText = headingText,
				DescriptionText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-wrap",
					LayoutOrder = 2,
					Text = v4.osaContextCardDescriptionText,
					fontStyle = v.Typography.BodyLarge,
					textStyle = v.Color.Content.Default
				})
			}
		)
		return createElement(view, v9, children)
	else
		if not (props.displayName and props.username and props.avatarThumbnail or props.hasError) then
			return React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				sizeConstraint = { MaxSize = Vector2.new(700, 500) }
			}, { React.createElement(Foundation.Skeleton, {
					Size = UDim2.new(1, 0, 0, 270),
					radius = Foundation.Enums.Radius.Large
				}) })
		end

		local createElement = React.createElement
		local view = Foundation.View
		local v6 = {
			tag = "col align-x-center size-full-0 auto-y padding-xxlarge radius-large bg-shift-100 gap-xlarge",
			sizeConstraint = { MaxSize = Vector2.new(700, 500) }
		}
		local avatarContainer

		if not props.hasError then
			local createElement2 = React.createElement
			local view2 = Foundation.View
			local v7 = {
				tag = "col auto-xy bg-action-subtle align-x-center gap-medium radius-large padding-small",
				LayoutOrder = 1,
				onActivated = props.onAvatarActivated
			}

			local createElement3 = React.createElement
			local view3 = Foundation.View

			local createElement4 = React.createElement
			local v8 = {
				userId = tostring(props.userId),
				layoutMode = LayoutMode.compact,
				userPresenceType = v2.presence,
				dontTruncateTitle = true,
				onActivated = props.onAvatarActivated,
				isRobloxSubscriber = 0,
				selectable = 0
			}
			local isRobloxSubscriber

			if FFlagEnableBlackbirdCheck then
				isRobloxSubscriber = props.isRobloxSubscriber
			end

			v8.isRobloxSubscriber = isRobloxSubscriber

			v8.selectable = not FFlagAppChatConsoleFocusFixes and nil
			local children = {
				AvatarCircle = createElement3(view3, { tag = "size-1200-1200", LayoutOrder = 1 }, {
					createElement4(userTile, v8)
				}),
				AvatarTextContainer = 0
			}

			local createElement5 = React.createElement
			local view4 = Foundation.View
			local displayName

			if FFlagEnableBlackbirdCheck and props.isRobloxSubscriber then
				displayName = React.createElement(
					Foundation.View,
					{ tag = "row auto-xy align-y-center gap-xsmall", LayoutOrder = 1 },
					{
						Name = React.createElement(Foundation.Text, {
							tag = "auto-xy",
							LayoutOrder = 1,
							Text = props.displayName,
							fontStyle = v.Typography.TitleMedium,
							textStyle = v.Color.Content.Emphasis
						}),
						Badge = React.createElement(Foundation.Icon, {
							LayoutOrder = 2,
							name = Foundation.Enums.IconName.RobloxPlus,
							size = Foundation.Enums.IconSize.Small,
							style = v.Color.Content.Emphasis
						})
					}
				)
			else
				displayName = React.createElement(Foundation.Text, {
					tag = "auto-xy",
					LayoutOrder = 1,
					Text = props.displayName,
					fontStyle = v.Typography.TitleMedium,
					textStyle = v.Color.Content.Emphasis
				})
			end

			children.AvatarTextContainer = createElement5(
				view4,
				{ tag = "col auto-xy align-x-center", LayoutOrder = 2 },
				{
					DisplayName = displayName,
					Username = React.createElement(Foundation.Text, {
						tag = "auto-xy",
						LayoutOrder = 2,
						Text = props.username,
						fontStyle = v.Typography.BodySmall,
						textStyle = v.Color.Content.Muted
					})
				}
			)
			avatarContainer = createElement2(view2, v7, children)
		end

		local createElement2 = React.createElement
		local view2 = Foundation.View

		local createElement3 = React.createElement
		local text = Foundation.Text

		if props.hasError then
			text2 = v5
		end

		return createElement(view, v6, {
			AvatarContainer = avatarContainer,
			TextContainer = createElement2(view2, {
				tag = "col align-x-center auto-xy",
				LayoutOrder = 2,
				ref = ref
			}, {
				HeadingText = createElement3(text, {
					tag = "auto-xy text-wrap",
					LayoutOrder = 1,
					Text = text2,
					fontStyle = v.Typography.TitleLarge,
					textStyle = v.Color.Content.Emphasis
				}),
				DescriptionText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-wrap",
					LayoutOrder = 2,
					Text = v4.osaContextCardDescriptionText,
					fontStyle = v.Typography.BodyLarge,
					textStyle = v.Color.Content.Default
				})
			})
		})
	end
end))
