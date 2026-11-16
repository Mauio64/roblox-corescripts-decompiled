local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserTile").LayoutMode
local skeleton = Foundation.Skeleton

local useTokens = Foundation.Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local useFoundationPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useFoundationPresence")

local FFlagAppChatContextCardNameLoadingShimmer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatContextCardNameLoadingShimmer")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagAppChatDiscloseUpdateSecondVersion = SharedFlags.FFlagAppChatDiscloseUpdateSecondVersion

return React.memo(React.forwardRef(function(props, p2)
	local v5 = useTokens()
	local size = v5.Size
	local v6 = useFoundationPresence(props.userId)
	local v8 = {
		firstConversationWithThisUserHeadingText = fFlagAppChatDiscloseUpdateSecondVersion and "Feature.Chat.Heading.FirstConversationWithThisUser" or "Feature.Chat.Heading.SafeChattingWithThisUser",
		firstConversationWithHeadingText = 0,
		firstInteractionWithThisPersonHeadingText = "Feature.Chat.Heading.FirstInteractionWithThisPerson",
		firstInteractionWithHeadingText = 0,
		osaContextCardDescriptionText = 0,
		user = "Feature.Chat.Label.User"
	}

	local v9 = if fFlagAppChatDiscloseUpdateSecondVersion then {
		"Feature.Chat.Heading.FirstConversationWith",
		displayName = props.displayName
	} else {
		"Feature.Chat.Heading.SafeChattingWithUsername",
		displayName = props.displayName
	}
	v8.firstConversationWithHeadingText = v9

	v8.firstInteractionWithHeadingText = {
		"Feature.Chat.Heading.FirstInteractionWith",
		displayName = props.displayName
	}

	v8.osaContextCardDescriptionText = UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology()
		and "Feature.Chat.Description.InlineContextCardDescription"
		or "Feature.Chat.Description.OSAContextCardDescription"
	local v10 = useLocalization(v8)
	local v11

	if UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() then
		v11 = v10.firstConversationWithHeadingText
	else
		v11 = v10.firstInteractionWithHeadingText
	end

	local v12

	if UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() then
		v12 = v10.firstConversationWithThisUserHeadingText
	else
		v12 = v10.firstInteractionWithThisPersonHeadingText
	end

	if FFlagAppChatContextCardNameLoadingShimmer then
		local v13 = not (props.displayName or props.hasError)
		local v14 = not (props.username or props.hasError)
		local v15 = not (props.avatarThumbnail or props.hasError)

		local createElement = React.createElement
		local view = Foundation.View
		local v16 = {
			tag = "col align-x-center size-full-0 auto-y padding-xxlarge radius-large bg-shift-100 gap-xlarge",
			sizeConstraint = { MaxSize = Vector2.new(700, 500) }
		}

		local createElement2 = React.createElement
		local view2 = Foundation.View

		local v18 = if not (v13 or v14 or v15) then props.onAvatarActivated else nil
		local v20

		if v15 then
			v20 = React.createElement(skeleton, {
				Size = UDim2.new(0, size.Size_1200, 0, size.Size_1200),
				radius = Foundation.Enums.Radius.Circle,
				LayoutOrder = 1
			})
		else
			local createElement3 = React.createElement
			local view3 = Foundation.View

			local createElement4 = React.createElement
			local v24 = {
				userId = tostring(props.userId),
				layoutMode = layoutMode.compact,
				userPresenceType = v6.presence,
				dontTruncateTitle = true,
				onActivated = props.onAvatarActivated,
				isRobloxSubscriber = 0,
				selectable = 0
			}
			local v25 = if fFlagEnableBlackbirdCheck then props.isRobloxSubscriber else nil
			v24.isRobloxSubscriber = v25
			v24.selectable = if FFlagAppChatConsoleFocusFixes then false else nil
			v20 = createElement3(view3, { tag = "size-1200-1200", LayoutOrder = 1 }, {
				createElement4(userTile, v24)
			})
		end

		local createElement3 = React.createElement
		local view3 = Foundation.View
		local v23

		if v13 then
			v23 = React.createElement(skeleton, {
				Size = UDim2.new(0, size.Size_2500, 0, v5.Typography.TitleMedium.FontSize),
				radius = Foundation.Enums.Radius.Large,
				LayoutOrder = 1
			})
		elseif fFlagEnableBlackbirdCheck and props.isRobloxSubscriber and not props.hasError then
			v23 = React.createElement(
				Foundation.View,
				{ tag = "row auto-xy align-y-center gap-xsmall", LayoutOrder = 1 },
				{
					Name = React.createElement(Foundation.Text, {
						tag = "auto-xy",
						LayoutOrder = 1,
						Text = props.displayName,
						fontStyle = v5.Typography.TitleMedium,
						textStyle = v5.Color.Content.Emphasis
					}),
					Badge = React.createElement(Foundation.Icon, {
						LayoutOrder = 2,
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small,
						style = v5.Color.Content.Emphasis
					})
				}
			)
		else
			local createElement4 = React.createElement
			local text = Foundation.Text

			local v25 = if props.hasError then v10.user else props.displayName
			v23 = createElement4(text, {
				tag = "auto-xy",
				LayoutOrder = 1,
				Text = v25,
				fontStyle = v5.Typography.TitleMedium,
				textStyle = v5.Color.Content.Emphasis
			})
		end

		local v24

		if v14 then
			v24 = React.createElement(skeleton, {
				Size = UDim2.new(0, size.Size_2000, 0, v5.Typography.BodySmall.FontSize),
				radius = Foundation.Enums.Radius.Large,
				LayoutOrder = 2
			})
		else
			local createElement4 = React.createElement
			local text = Foundation.Text

			local v26 = if props.hasError then v10.user else props.username
			v24 = createElement4(text, {
				tag = "auto-xy",
				LayoutOrder = 2,
				Text = v26,
				fontStyle = v5.Typography.BodySmall,
				textStyle = v5.Color.Content.Muted
			})
		end

		local children = {
			AvatarContainer = createElement2(
				view2,
				{
					tag = "col auto-xy bg-action-subtle align-x-center gap-medium radius-large padding-small",
					LayoutOrder = 1,
					onActivated = v18
				},
				{
					AvatarCircle = v20,
					AvatarTextContainer = createElement3(
						view3,
						{
							tag = "col auto-xy align-x-center gap-xxsmall",
							LayoutOrder = 2
						},
						{ DisplayName = v23, Username = v24 }
					)
				}
			),
			TextContainer = 0
		}

		local createElement4 = React.createElement
		local view4 = Foundation.View
		local v27

		if v13 then
			v27 = React.createElement(skeleton, {
				Size = UDim2.new(0, size.Size_3000, 0, v5.Typography.TitleLarge.FontSize + v5.Gap.XXSmall),
				radius = Foundation.Enums.Radius.Large,
				LayoutOrder = 1
			})
		else
			local createElement5 = React.createElement
			local text = Foundation.Text

			if props.hasError then
				v11 = v12
			end

			v27 = createElement5(text, {
				tag = "auto-xy text-wrap",
				LayoutOrder = 1,
				Text = v11,
				fontStyle = v5.Typography.TitleLarge,
				textStyle = v5.Color.Content.Emphasis
			})
		end

		children.TextContainer = createElement4(
			view4,
			{ tag = "col align-x-center auto-xy", LayoutOrder = 2, ref = p2 },
			{
				HeadingText = v27,
				DescriptionText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-wrap",
					LayoutOrder = 2,
					Text = v10.osaContextCardDescriptionText,
					fontStyle = v5.Typography.BodyLarge,
					textStyle = v5.Color.Content.Default
				})
			}
		)
		return createElement(view, v16, children)
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
		local v13 = {
			tag = "col align-x-center size-full-0 auto-y padding-xxlarge radius-large bg-shift-100 gap-xlarge",
			sizeConstraint = { MaxSize = Vector2.new(700, 500) }
		}
		local v15

		if not props.hasError then
			local createElement2 = React.createElement
			local view2 = Foundation.View
			local v16 = {
				tag = "col auto-xy bg-action-subtle align-x-center gap-medium radius-large padding-small",
				LayoutOrder = 1,
				onActivated = props.onAvatarActivated
			}

			local createElement3 = React.createElement
			local view3 = Foundation.View

			local createElement4 = React.createElement
			local v20 = {
				userId = tostring(props.userId),
				layoutMode = layoutMode.compact,
				userPresenceType = v6.presence,
				dontTruncateTitle = true,
				onActivated = props.onAvatarActivated,
				isRobloxSubscriber = 0,
				selectable = 0
			}

			local v21 = if fFlagEnableBlackbirdCheck then props.isRobloxSubscriber else nil
			v20.isRobloxSubscriber = v21

			v20.selectable = if FFlagAppChatConsoleFocusFixes then false else nil
			local children = {
				AvatarCircle = createElement3(view3, {
					tag = "size-1200-1200",
					LayoutOrder = 1
				}, {
					createElement4(userTile, v20)
				}),
				AvatarTextContainer = 0
			}

			local createElement5 = React.createElement
			local view4 = Foundation.View
			local v25

			if fFlagEnableBlackbirdCheck and props.isRobloxSubscriber then
				v25 = React.createElement(
					Foundation.View,
					{ tag = "row auto-xy align-y-center gap-xsmall", LayoutOrder = 1 },
					{
						Name = React.createElement(Foundation.Text, {
							tag = "auto-xy",
							LayoutOrder = 1,
							Text = props.displayName,
							fontStyle = v5.Typography.TitleMedium,
							textStyle = v5.Color.Content.Emphasis
						}),
						Badge = React.createElement(Foundation.Icon, {
							LayoutOrder = 2,
							name = Foundation.Enums.IconName.RobloxPlus,
							size = Foundation.Enums.IconSize.Small,
							style = v5.Color.Content.Emphasis
						})
					}
				)
			else
				v25 = React.createElement(Foundation.Text, {
					tag = "auto-xy",
					LayoutOrder = 1,
					Text = props.displayName,
					fontStyle = v5.Typography.TitleMedium,
					textStyle = v5.Color.Content.Emphasis
				})
			end

			children.AvatarTextContainer = createElement5(
				view4,
				{ tag = "col auto-xy align-x-center", LayoutOrder = 2 },
				{
					DisplayName = v25,
					Username = React.createElement(Foundation.Text, {
						tag = "auto-xy",
						LayoutOrder = 2,
						Text = props.username,
						fontStyle = v5.Typography.BodySmall,
						textStyle = v5.Color.Content.Muted
					})
				}
			)
			v15 = createElement2(view2, v16, children)
		end

		local createElement2 = React.createElement
		local view2 = Foundation.View

		local createElement3 = React.createElement
		local text = Foundation.Text

		if props.hasError then
			v11 = v12
		end

		return createElement(view, v13, {
			AvatarContainer = v15,
			TextContainer = createElement2(
				view2,
				{ tag = "col align-x-center auto-xy", LayoutOrder = 2, ref = p2 },
				{
					HeadingText = createElement3(text, {
						tag = "auto-xy text-wrap",
						LayoutOrder = 1,
						Text = v11,
						fontStyle = v5.Typography.TitleLarge,
						textStyle = v5.Color.Content.Emphasis
					}),
					DescriptionText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-wrap",
						LayoutOrder = 2,
						Text = v10.osaContextCardDescriptionText,
						fontStyle = v5.Typography.BodyLarge,
						textStyle = v5.Color.Content.Default
					})
				}
			)
		})
	end
end))
