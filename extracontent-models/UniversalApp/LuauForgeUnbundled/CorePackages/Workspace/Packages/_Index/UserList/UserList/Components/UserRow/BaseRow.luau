local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/UserTile").UserTile
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Constants")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/TextKeys")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Localization").Hooks.useLocalization

local fFlagFriendsPageViewBtnEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagFriendsPageViewBtnEnabled
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagUserListCtaIntegrationEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaIntegrationEnabled
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

	local v9 = {
		["Accept"] = TextKeys.Accept,
		Add = TextKeys.Add,
		Chat = TextKeys.Chat,
		Join = TextKeys.Join,
		Pending = TextKeys.Pending
	}
	local invite = Enums.ButtonTypes.Invite
	local v10 = if fFlagUserListInviteCta then TextKeys.Invite else nil
	v9[invite] = v10
	local invited = Enums.ButtonTypes.Invited
	local v11 = if fFlagUserListInviteCta then TextKeys.Invited else nil
	v9[invited] = v11
	local view2 = Enums.ButtonTypes.View
	local v12 = if fFlagFriendsPageViewBtnEnabled or fFlagUserListCtaIntegrationEnabled then TextKeys.View else nil
	v9[view2] = v12
	local v13 = useLocalization(v9)

	local createElement = React.createElement
	local v15 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["size-full-0 auto-y align-y-center"] = true,
			["row gap-medium padding-top-medium padding-bottom-medium padding-right-xsmall flex-x-between"] = props.layoutMode == Enums.RowLayoutMode.Wide,
			["col gap-small padding-medium bg-surface-100 radius-medium"] = props.layoutMode == Enums.RowLayoutMode.Compact
		}
	}

	local createElement2 = React.createElement
	local v17 = {
		tag = {
			fill = props.layoutMode == Enums.RowLayoutMode.Wide,
			["size-full-0 auto-y"] = props.layoutMode == Enums.RowLayoutMode.Compact
		},
		Size = 0,
		LayoutOrder = 1
	}

	local v18 = if props.layoutMode == Enums.RowLayoutMode.Wide then UDim2.new(0, 0, 0, Constants.USER_ROW_HEIGHT) else nil
	v17.Size = v18

	local createElement3 = React.createElement
	local v21 = {
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
	local v22 = if not v7 then props.onActivated else nil
	v21.onActivated = v22
	v21.selectable = not v7 and (props.selectable == nil or props.selectable)

	v21.isTitleLoading = props.isTitleLoading
	v21.isSubtitleLoading = props.isSubtitleLoading
	v21.contextualInfo = props.contextualInfo and props.contextualInfo.text
	v21.isContextualInfoLoading = props.isContextualInfoLoading
	local v24 = if props.layoutMode == Enums.RowLayoutMode.Compact then UDim2.new(0, v6.Size.Size_1400, 0, v6.Size.Size_1400) else nil
	v21.avatarSize = v24

	v21.trustedConnectionIndicatorEnabled = props.trustedConnectionIndicatorEnabled
	local v25 = if fFlagEnableBlackbirdCheck then props.isRobloxSubscriber else nil
	v21.isRobloxSubscriber = v25
	local children = {
		UserTileContainer = createElement2(view, v17, {
			UserTile = createElement3(userTile, v21)
		}),
		TrailingSection = 0
	}

	local createElement4 = React.createElement
	local v27 = {
		tag = {
			["gap-xsmall"] = true,
			["row align-y-center auto-xy"] = props.layoutMode == Enums.RowLayoutMode.Wide,
			["col size-full-0 auto-y align-x-center"] = props.layoutMode == Enums.RowLayoutMode.Compact
		},
		LayoutOrder = 2,
		selectionGroup = 0
	}

	local v28 = if v7 and props.layoutMode == Enums.RowLayoutMode.Wide then v5 else nil
	v27.selectionGroup = v28

	local v30 = if props.shouldShowNewIndicator then React.createElement(
		view,
		{ LayoutOrder = 1, tag = "auto-xy padding-right-small" },
		{
			StatusIndicator = React.createElement(statusIndicator, {
				variant = statusIndicatorVariant.Emphasis
			})
		}
	) else nil
	local v31

	if props.primaryCta and props.primaryCta.onActivated then
		if props.layoutMode == Enums.RowLayoutMode.Wide then
			local createElement5 = React.createElement

			local v35 = if props.primaryCta.minWidth then Vector2.new(props.primaryCta.minWidth, 0) else nil

			local v36 = if props.primaryCta.maxWidth then Vector2.new(props.primaryCta.maxWidth, 1e999) else nil

			local createElement6 = React.createElement
			local v39 = {
				text = v13[props.primaryCta.type],
				size = inputSize.Small,
				variant = 0,
				onActivated = 0,
				isDisabled = 0,
				isLoading = 0,
				fillBehavior = 0
			}

			local v40 = if fFlagFriendsPageViewBtnEnabled or fFlagUserListCtaIntegrationEnabled then props.primaryCta.variant or buttonVariant.SoftEmphasis else buttonVariant.SoftEmphasis
			v39.variant = v40

			v39.onActivated = props.primaryCta.onActivated
			v39.isDisabled = props.primaryCta.isDisabled
			v39.isLoading = props.primaryCta.isLoading
			v39.fillBehavior = fillBehavior.Fill
			v31 = createElement5(view, {
				LayoutOrder = 2,
				tag = "auto-xy",
				sizeConstraint = { MinSize = v35, MaxSize = v36 }
			}, { Button = createElement6(button, v39) })
		else
			local createElement5 = React.createElement
			local v33 = {
				text = v13[props.primaryCta.type],
				size = inputSize.Small,
				variant = 0,
				onActivated = 0,
				isDisabled = 0,
				isLoading = 0,
				LayoutOrder = 2,
				width = 0
			}

			local v34 = if fFlagFriendsPageViewBtnEnabled or fFlagUserListCtaIntegrationEnabled then props.primaryCta.variant or buttonVariant.SoftEmphasis else buttonVariant.SoftEmphasis
			v33.variant = v34

			v33.onActivated = props.primaryCta.onActivated
			v33.isDisabled = props.primaryCta.isDisabled
			v33.isLoading = props.primaryCta.isLoading

			local v35 = if props.layoutMode == Enums.RowLayoutMode.Compact then UDim.new(1, 0) else nil
			v33.width = v35
			v31 = createElement5(button, v33)
		end
	elseif
		fFlagUserListCtaIntegrationEnabled
		and props.ctaLoading
		and props.layoutMode == Enums.RowLayoutMode.Wide
	then
		v31 = React.createElement(skeleton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(props.ctaLoading.minWidth or 0, v6.Size.Size_800),
			radius = radius.Medium
		})
	end

	local v32 = if props.layoutMode == Enums.RowLayoutMode.Wide and props.secondaryCta and props.secondaryCta.icon and props.secondaryCta.onActivated then React.createElement(iconButton, {
		icon = props.secondaryCta.icon,
		size = iconSize.Small,
		variant = buttonVariant.Utility,
		onActivated = props.secondaryCta.onActivated,
		isDisabled = props.secondaryCta.isDisabled,
		isLoading = props.secondaryCta.isLoading,
		LayoutOrder = 3
	}) else nil

	local v33 = if props.layoutMode == Enums.RowLayoutMode.Wide and props.trailingContent then React.createElement(
		view,
		{ tag = "auto-xy", LayoutOrder = 4 },
		{ Content = props.trailingContent }
	) else nil
	children.TrailingSection = createElement4(view, v27, {
		StatusIndicatorContainer = v30,
		PrimaryActionCta = v31,
		SecondaryActionCta = v32,
		TrailingContentWrapper = v33
	})
	return createElement(view, v15, children)
end

return React.memo(BaseRow)
