local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/UserTile").UserTile
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Constants")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/TextKeys")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Localization").Hooks.useLocalization

local defineFastFlag = game:DefineFastFlag("UserListUseActionAddTranslation", false)
local fFlagFriendsPageViewBtnEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagFriendsPageViewBtnEnabled
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled
local fFlagAddStatusIndicatorToBaseRow = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagAddStatusIndicatorToBaseRow
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions
local fFlagUserListInviteCta = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListInviteCta

local view = Foundation.View
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local statusIndicator = Foundation.StatusIndicator
local statusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local useTokens = Foundation.Hooks.useTokens
local fillBehavior = Foundation.Enums.FillBehavior

local v5 = {
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
	SelectionBehaviorUp = Enum.SelectionBehavior.Escape,
	SelectionBehaviorDown = Enum.SelectionBehavior.Escape
}

local function BaseRow(props)
	local v6 = useTokens()
	local v7 = fFlagUserListSurfaceExtensions and props.disableRowActivation == true
	local v8

	if defineFastFlag then
		local v10 = {
			["Accept"] = TextKeys.Accept,
			Add = TextKeys.Add,
			Chat = TextKeys.Chat,
			Join = TextKeys.Join,
			Pending = TextKeys.Pending
		}
		local invite = Enums.ButtonTypes.Invite
		local v11 = if fFlagUserListInviteCta then TextKeys.Invite else nil
		v10[invite] = v11
		local invited = Enums.ButtonTypes.Invited
		local v12 = if fFlagUserListInviteCta then TextKeys.Invited else nil
		v10[invited] = v12
		local view2 = Enums.ButtonTypes.View
		local v13 = if fFlagFriendsPageViewBtnEnabled or fFlagUserListCtaIntegrationEnabled then TextKeys.View else nil
		v10[view2] = v13
		v8 = useLocalization(v10)
	end

	local createElement = React.createElement
	local v10 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["size-full-0 auto-y align-y-center"] = true,
			["row gap-medium padding-top-medium padding-bottom-medium padding-right-xsmall flex-x-between"] = props.layoutMode == Enums.RowLayoutMode.Wide,
			["col gap-small padding-medium bg-surface-100 radius-medium"] = props.layoutMode == Enums.RowLayoutMode.Compact
		}
	}

	local createElement2 = React.createElement
	local v12 = {
		tag = {
			fill = props.layoutMode == Enums.RowLayoutMode.Wide,
			["size-full-0 auto-y"] = props.layoutMode == Enums.RowLayoutMode.Compact
		},
		Size = 0,
		LayoutOrder = 1
	}

	local v13 = if props.layoutMode == Enums.RowLayoutMode.Wide then UDim2.new(0, 0, 0, Constants.USER_ROW_HEIGHT) else nil
	v12.Size = v13

	local createElement3 = React.createElement
	local v16 = {
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
	local v17 = if not v7 then props.onActivated else nil
	v16.onActivated = v17
	v16.selectable = not v7 and (props.selectable == nil or props.selectable)

	v16.isTitleLoading = props.isTitleLoading
	v16.isSubtitleLoading = props.isSubtitleLoading
	v16.contextualInfo = props.contextualInfo and props.contextualInfo.text
	v16.isContextualInfoLoading = props.isContextualInfoLoading
	local v19 = if props.layoutMode == Enums.RowLayoutMode.Compact then UDim2.new(0, v6.Size.Size_1400, 0, v6.Size.Size_1400) else nil
	v16.avatarSize = v19

	v16.trustedConnectionIndicatorEnabled = props.trustedConnectionIndicatorEnabled
	local v20 = if fFlagEnableBlackbirdCheck then props.isRobloxSubscriber else nil
	v16.isRobloxSubscriber = v20
	local children = {
		UserTileContainer = createElement2(view, v12, {
			UserTile = createElement3(userTile, v16)
		}),
		TrailingSection = 0
	}

	local createElement4 = React.createElement
	local v22 = {
		tag = {
			["gap-xsmall"] = true,
			["row align-y-center auto-xy"] = props.layoutMode == Enums.RowLayoutMode.Wide,
			["col size-full-0 auto-y align-x-center"] = props.layoutMode == Enums.RowLayoutMode.Compact
		},
		LayoutOrder = 2,
		selectionGroup = 0
	}

	local v23 = if v7 and props.layoutMode == Enums.RowLayoutMode.Wide then v5 else nil
	v22.selectionGroup = v23

	local v25 = if fFlagAddStatusIndicatorToBaseRow and props.shouldShowNewIndicator then React.createElement(
		view,
		{ LayoutOrder = 1, tag = "auto-xy padding-right-small" },
		{
			StatusIndicator = React.createElement(statusIndicator, {
				variant = statusIndicatorVariant.Emphasis
			})
		}
	) else nil
	local v26

	if props.primaryCta and props.primaryCta.onActivated then
		if props.layoutMode == Enums.RowLayoutMode.Wide then
			local createElement5 = React.createElement
			local v28 = {
				LayoutOrder = fFlagAddStatusIndicatorToBaseRow and 2 or 1,
				tag = "auto-xy",
				sizeConstraint = 0
			}

			local v30 = if props.primaryCta.minWidth then Vector2.new(props.primaryCta.minWidth, 0) else nil

			local v31 = if props.primaryCta.maxWidth then Vector2.new(props.primaryCta.maxWidth, 1e999) else nil
			v28.sizeConstraint = { MinSize = v30, MaxSize = v31 }

			local createElement6 = React.createElement

			local v35 = if defineFastFlag then v8[props.primaryCta.type] else props.primaryCta.type
			local v34 = {
				text = v35,
				size = inputSize.Small,
				variant = 0,
				onActivated = 0,
				isDisabled = 0,
				isLoading = 0,
				fillBehavior = 0
			}

			local v36 = if fFlagFriendsPageViewBtnEnabled or fFlagUserListCtaIntegrationEnabled then props.primaryCta.variant or buttonVariant.SoftEmphasis else buttonVariant.SoftEmphasis
			v34.variant = v36

			v34.onActivated = props.primaryCta.onActivated
			v34.isDisabled = props.primaryCta.isDisabled
			v34.isLoading = props.primaryCta.isLoading
			v34.fillBehavior = fillBehavior.Fill
			v26 = createElement5(view, v28, { Button = createElement6(button, v34) })
		else
			local createElement5 = React.createElement

			local v29 = if defineFastFlag then v8[props.primaryCta.type] else props.primaryCta.type
			local v28 = {
				text = v29,
				size = inputSize.Small,
				variant = 0,
				onActivated = 0,
				isDisabled = 0,
				isLoading = 0,
				LayoutOrder = 0,
				width = 0
			}

			local v30 = if fFlagFriendsPageViewBtnEnabled or fFlagUserListCtaIntegrationEnabled then props.primaryCta.variant or buttonVariant.SoftEmphasis else buttonVariant.SoftEmphasis
			v28.variant = v30

			v28.onActivated = props.primaryCta.onActivated
			v28.isDisabled = props.primaryCta.isDisabled
			v28.isLoading = props.primaryCta.isLoading
			v28.LayoutOrder = fFlagAddStatusIndicatorToBaseRow and 2 or 1
			local v31 = if props.layoutMode == Enums.RowLayoutMode.Compact then UDim.new(1, 0) else nil
			v28.width = v31
			v26 = createElement5(button, v28)
		end
	elseif
		fFlagUserListCtaIntegrationEnabled
		and props.ctaLoading
		and props.layoutMode == Enums.RowLayoutMode.Wide
	then
		v26 = React.createElement(skeleton, {
			LayoutOrder = fFlagAddStatusIndicatorToBaseRow and 2 or 1,
			Size = UDim2.fromOffset(props.ctaLoading.minWidth or 0, v6.Size.Size_800),
			radius = radius.Medium
		})
	end

	local v27 = if props.layoutMode == Enums.RowLayoutMode.Wide and props.secondaryCta and props.secondaryCta.icon and props.secondaryCta.onActivated then React.createElement(iconButton, {
		icon = props.secondaryCta.icon,
		size = iconSize.Small,
		variant = buttonVariant.Utility,
		onActivated = props.secondaryCta.onActivated,
		isDisabled = props.secondaryCta.isDisabled,
		isLoading = props.secondaryCta.isLoading,
		LayoutOrder = fFlagAddStatusIndicatorToBaseRow and 3 or 2
	}) else nil

	local v28 = if props.layoutMode == Enums.RowLayoutMode.Wide and props.trailingContent then React.createElement(view, {
		tag = "auto-xy",
		LayoutOrder = fFlagAddStatusIndicatorToBaseRow and 4 or 3
	}, { Content = props.trailingContent }) else nil
	children.TrailingSection = createElement4(view, v22, {
		StatusIndicatorContainer = v25,
		PrimaryActionCta = v26,
		SecondaryActionCta = v27,
		TrailingContentWrapper = v28
	})
	return createElement(view, v10, children)
end

return React.memo(BaseRow)
