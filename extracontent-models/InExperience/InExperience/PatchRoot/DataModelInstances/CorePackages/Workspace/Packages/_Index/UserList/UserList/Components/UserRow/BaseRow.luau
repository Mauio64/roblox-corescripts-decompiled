local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local Foundation = require(parent.Foundation)
require(UserList.Common.Types)
local Enums = require(UserList.Common.Enums)
local Constants = require(UserList.Common.Constants)
local TextKeys = require(UserList.Common.TextKeys)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local defineFastFlag = game:DefineFastFlag("UserListUseActionAddTranslation", false)
local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsPageViewBtnEnabled = SharedFlags.FFlagFriendsPageViewBtnEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags2.FFlagEnableBlackbirdCheck
local SharedFlags3 = require(parent.SharedFlags)
local FFlagUserListCtaIntegrationEnabled = SharedFlags3.FFlagUserListCtaIntegrationEnabled
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAddStatusIndicatorToBaseRow = SharedFlags4.FFlagAddStatusIndicatorToBaseRow
local SharedFlags5 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags5.FFlagUserListSurfaceExtensions
local SharedFlags6 = require(parent.SharedFlags)
local FFlagUserListInviteCta = SharedFlags6.FFlagUserListInviteCta

local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local useTokens = Foundation.Hooks.useTokens
local FillBehavior = Foundation.Enums.FillBehavior

local v = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Escape,
	SelectionBehaviorDown = Enum.SelectionBehavior.Escape
}

local function BaseRow(props)
	local v2 = useTokens()
	local v3 = FFlagUserListSurfaceExtensions and props.disableRowActivation == true
	local v4

	if defineFastFlag then
		local v5 = {
			["Accept"] = TextKeys.Accept,
			Add = TextKeys.Add,
			Chat = TextKeys.Chat,
			Join = TextKeys.Join,
			Pending = TextKeys.Pending
		}
		local invite = Enums.ButtonTypes.Invite
		local v6

		if FFlagUserListInviteCta then
			v6 = TextKeys.Invite
		end

		v5[invite] = v6
		local invited = Enums.ButtonTypes.Invited
		local v7

		if FFlagUserListInviteCta then
			v7 = TextKeys.Invited
		end

		v5[invited] = v7
		local view = Enums.ButtonTypes.View
		local v8

		if FFlagFriendsPageViewBtnEnabled or FFlagUserListCtaIntegrationEnabled then
			v8 = TextKeys.View
		end

		v5[view] = v8
		v4 = useLocalization(v5)
	end

	local createElement = React.createElement
	local v5 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["size-full-0 auto-y align-y-center"] = true,
			["row gap-medium padding-top-medium padding-bottom-medium padding-right-xsmall flex-x-between"] = props.layoutMode == Enums.RowLayoutMode.Wide,
			["col gap-small padding-medium bg-surface-100 radius-medium"] = props.layoutMode == Enums.RowLayoutMode.Compact
		}
	}

	local createElement2 = React.createElement
	local v6 = {
		tag = {
			fill = props.layoutMode == Enums.RowLayoutMode.Wide,
			["size-full-0 auto-y"] = props.layoutMode == Enums.RowLayoutMode.Compact
		},
		Size = 0,
		LayoutOrder = 1
	}
	local size

	if props.layoutMode == Enums.RowLayoutMode.Wide then
		size = UDim2.new(0, 0, 0, Constants.USER_ROW_HEIGHT)
	end

	v6.Size = size

	local createElement3 = React.createElement
	local v7 = {
		userId = props.userId or "",
		avatarThumbnailUrl = props.avatarThumbnailUrl,
		userPresenceType = props.userPresenceType or Foundation.Enums.UserPresence.None,
		title = props.title,
		subtitle = props.subtitle,
		layoutMode = props.layoutMode,
		onActivated = 0,
		selectable = 0,
		isTitleLoading = 0,
		isSubtitleLoading = 0,
		contextualInfo = 0,
		isContextualInfoLoading = 0,
		avatarSize = 0,
		trustedConnectionIndicatorEnabled = 0,
		isRobloxSubscriber = 0
	}
	local onActivated

	if not v3 then
		onActivated = props.onActivated
	end

	v7.onActivated = onActivated
	v7.selectable = not v3 and (props.selectable == nil or props.selectable)

	v7.isTitleLoading = props.isTitleLoading
	v7.isSubtitleLoading = props.isSubtitleLoading
	v7.contextualInfo = props.contextualInfo and props.contextualInfo.text
	v7.isContextualInfoLoading = props.isContextualInfoLoading
	local avatarSize

	if props.layoutMode == Enums.RowLayoutMode.Compact then
		avatarSize = UDim2.new(0, v2.Size.Size_1400, 0, v2.Size.Size_1400)
	end

	v7.avatarSize = avatarSize

	v7.trustedConnectionIndicatorEnabled = props.trustedConnectionIndicatorEnabled
	local isRobloxSubscriber

	if FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = props.isRobloxSubscriber
	end

	v7.isRobloxSubscriber = isRobloxSubscriber
	local children = {
		UserTileContainer = createElement2(View, v6, { UserTile = createElement3(userTile, v7) }),
		TrailingSection = 0
	}

	local createElement4 = React.createElement
	local v8 = {
		tag = {
			["gap-xsmall"] = true,
			["row align-y-center auto-xy"] = props.layoutMode == Enums.RowLayoutMode.Wide,
			["col size-full-0 auto-y align-x-center"] = props.layoutMode == Enums.RowLayoutMode.Compact
		},
		LayoutOrder = 2,
		selectionGroup = 0
	}
	local selectionGroup

	if v3 and props.layoutMode == Enums.RowLayoutMode.Wide then
		selectionGroup = v
	end

	v8.selectionGroup = selectionGroup
	local statusIndicatorContainer

	if FFlagAddStatusIndicatorToBaseRow and props.shouldShowNewIndicator then
		statusIndicatorContainer = React.createElement(View, {
			LayoutOrder = 1,
			tag = "auto-xy padding-right-small"
		}, {
			StatusIndicator = React.createElement(StatusIndicator, {
				variant = StatusIndicatorVariant.Emphasis
			})
		})
	end

	local primaryActionCta

	if props.primaryCta and props.primaryCta.onActivated then
		if props.layoutMode == Enums.RowLayoutMode.Wide then
			local createElement5 = React.createElement
			local v9 = {
				LayoutOrder = FFlagAddStatusIndicatorToBaseRow and 2 or 1,
				tag = "auto-xy",
				sizeConstraint = 0
			}
			local minSize

			if props.primaryCta.minWidth then
				minSize = Vector2.new(props.primaryCta.minWidth, 0)
			end

			local maxSize

			if props.primaryCta.maxWidth then
				maxSize = Vector2.new(props.primaryCta.maxWidth, 1e999)
			end

			v9.sizeConstraint = { MinSize = minSize, MaxSize = maxSize }

			local createElement6 = React.createElement
			local text

			if defineFastFlag then
				text = v4[props.primaryCta.type]
			else
				text = props.primaryCta.type
			end

			local v10 = {
				text = text,
				size = InputSize.Small,
				variant = 0,
				onActivated = 0,
				isDisabled = 0,
				isLoading = 0,
				fillBehavior = 0
			}
			local variant

			if FFlagFriendsPageViewBtnEnabled or FFlagUserListCtaIntegrationEnabled then
				variant = props.primaryCta.variant or ButtonVariant.SoftEmphasis
			else
				variant = ButtonVariant.SoftEmphasis
			end

			v10.variant = variant

			v10.onActivated = props.primaryCta.onActivated
			v10.isDisabled = props.primaryCta.isDisabled
			v10.isLoading = props.primaryCta.isLoading
			v10.fillBehavior = FillBehavior.Fill
			primaryActionCta = createElement5(View, v9, { Button = createElement6(Button, v10) })
		else
			local createElement5 = React.createElement
			local text

			if defineFastFlag then
				text = v4[props.primaryCta.type]
			else
				text = props.primaryCta.type
			end

			local v9 = {
				text = text,
				size = InputSize.Small,
				variant = 0,
				onActivated = 0,
				isDisabled = 0,
				isLoading = 0,
				LayoutOrder = 0,
				width = 0
			}
			local variant

			if FFlagFriendsPageViewBtnEnabled or FFlagUserListCtaIntegrationEnabled then
				variant = props.primaryCta.variant or ButtonVariant.SoftEmphasis
			else
				variant = ButtonVariant.SoftEmphasis
			end

			v9.variant = variant

			v9.onActivated = props.primaryCta.onActivated
			v9.isDisabled = props.primaryCta.isDisabled
			v9.isLoading = props.primaryCta.isLoading
			v9.LayoutOrder = FFlagAddStatusIndicatorToBaseRow and 2 or 1
			local width

			if props.layoutMode == Enums.RowLayoutMode.Compact then
				width = UDim.new(1, 0)
			end

			v9.width = width
			primaryActionCta = createElement5(Button, v9)
		end
	elseif FFlagUserListCtaIntegrationEnabled and props.ctaLoading and props.layoutMode == Enums.RowLayoutMode.Wide then
		primaryActionCta = React.createElement(Skeleton, {
			LayoutOrder = FFlagAddStatusIndicatorToBaseRow and 2 or 1,
			Size = UDim2.fromOffset(props.ctaLoading.minWidth or 0, v2.Size.Size_800),
			radius = Radius.Medium
		})
	end

	local secondaryActionCta

	if
		props.layoutMode == Enums.RowLayoutMode.Wide
		and props.secondaryCta
		and props.secondaryCta.icon
		and props.secondaryCta.onActivated
	then
		secondaryActionCta = React.createElement(IconButton, {
			icon = props.secondaryCta.icon,
			size = IconSize.Small,
			variant = ButtonVariant.Utility,
			onActivated = props.secondaryCta.onActivated,
			isDisabled = props.secondaryCta.isDisabled,
			isLoading = props.secondaryCta.isLoading,
			LayoutOrder = FFlagAddStatusIndicatorToBaseRow and 3 or 2
		})
	end

	local trailingContentWrapper

	if props.layoutMode == Enums.RowLayoutMode.Wide and props.trailingContent then
		trailingContentWrapper = React.createElement(View, {
			tag = "auto-xy",
			LayoutOrder = FFlagAddStatusIndicatorToBaseRow and 4 or 3
		}, { Content = props.trailingContent })
	end

	children.TrailingSection = createElement4(View, v8, {
		StatusIndicatorContainer = statusIndicatorContainer,
		PrimaryActionCta = primaryActionCta,
		SecondaryActionCta = secondaryActionCta,
		TrailingContentWrapper = trailingContentWrapper
	})
	return createElement(View, v5, children)
end

return React.memo(BaseRow)
