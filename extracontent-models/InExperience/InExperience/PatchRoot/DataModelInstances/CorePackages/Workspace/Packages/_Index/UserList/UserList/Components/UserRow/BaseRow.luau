local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local UserTile = require(UserListParent.UserTile).UserTile
local Foundation = require(UserListParent.Foundation)

require(UserList.Common.Types)

local Enums = require(UserList.Common.Enums)
local Constants = require(UserList.Common.Constants)
local TextKeys = require(UserList.Common.TextKeys)
local useLocalization = require(UserListParent.Localization).Hooks.useLocalization
local v10 = game:DefineFastFlag("UserListUseActionAddTranslation", false)
local FFlagFriendsPageViewBtnEnabled = require(UserListParent.SharedFlags).FFlagFriendsPageViewBtnEnabled
local FFlagEnableBlackbirdCheck = require(UserListParent.SharedFlags).FFlagEnableBlackbirdCheck
local FFlagUserListCtaIntegrationEnabled = require(UserListParent.SharedFlags).FFlagUserListCtaIntegrationEnabled
local FFlagAddStatusIndicatorToBaseRow = require(UserListParent.SharedFlags).FFlagAddStatusIndicatorToBaseRow
local View = Foundation.View
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local useTokens = Foundation.Hooks.useTokens
local FillBehavior = Foundation.Enums.FillBehavior

local function BaseRow(t1: {[any]: any}) -- line: 79
	-- upvalues: useTokens (copy), v10 (copy), useLocalization (copy), TextKeys (copy), Enums (copy), FFlagFriendsPageViewBtnEnabled (copy), React (copy), View (copy), Constants (copy), UserTile (copy), Foundation (copy), FFlagEnableBlackbirdCheck (copy), FFlagAddStatusIndicatorToBaseRow (copy), StatusIndicator (copy), StatusIndicatorVariant (copy), Button (copy), InputSize (copy), ButtonVariant (copy), FillBehavior (copy), FFlagUserListCtaIntegrationEnabled (copy), Skeleton (copy), EnumsRadius (copy), IconButton (copy), IconSize (copy)
	local v29 = useTokens()
	local v30 = if not v10 then nil else useLocalization({
		Accept = TextKeys.Accept,
		Add = TextKeys.Add,
		Chat = TextKeys.Chat,
		Join = TextKeys.Join,
		Pending = TextKeys.Pending,
		[Enums.ButtonTypes.View] = if not FFlagFriendsPageViewBtnEnabled then nil else TextKeys.View
	})

	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		tag = {
			["size-full-0 auto-y align-y-center"] = true,
			["row gap-medium padding-top-medium padding-bottom-medium padding-right-xsmall flex-x-between"] = t1.layoutMode == Enums.RowLayoutMode.Wide,
			["col gap-small padding-medium bg-surface-100 radius-medium"] = t1.layoutMode == Enums.RowLayoutMode.Compact
		}
	}, {
		UserTileContainer = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				fill = t1.layoutMode == Enums.RowLayoutMode.Wide,
				["size-full-0 auto-y"] = t1.layoutMode == Enums.RowLayoutMode.Compact
			},
			Size = if t1.layoutMode ~= Enums.RowLayoutMode.Wide then nil else UDim2.new(0, 0, 0, Constants.USER_ROW_HEIGHT)
		}, {
			UserTile = React.createElement(UserTile, {
				userId = t1.userId or "",
				avatarThumbnailUrl = t1.avatarThumbnailUrl,
				userPresenceType = t1.userPresenceType or Foundation.Enums.UserPresence.None,
				title = t1.title,
				subtitle = t1.subtitle,
				layoutMode = t1.layoutMode,
				onActivated = t1.onActivated,
				selectable = t1.selectable == nil or t1.selectable,
				isTitleLoading = t1.isTitleLoading,
				isSubtitleLoading = t1.isSubtitleLoading,
				contextualInfo = t1.contextualInfo and t1.contextualInfo.text,
				isContextualInfoLoading = t1.isContextualInfoLoading,
				avatarSize = if t1.layoutMode ~= Enums.RowLayoutMode.Compact then nil else UDim2.new(0, v29.Size.Size_1400, 0, v29.Size.Size_1400),
				trustedConnectionIndicatorEnabled = t1.trustedConnectionIndicatorEnabled,
				isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else t1.isRobloxSubscriber
			})
		}),
		TrailingSection = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["gap-xsmall"] = true,
				["row align-y-center auto-xy"] = t1.layoutMode == Enums.RowLayoutMode.Wide,
				["col size-full-0 auto-y align-x-center"] = t1.layoutMode == Enums.RowLayoutMode.Compact
			}
		}, {
			StatusIndicatorContainer = if not FFlagAddStatusIndicatorToBaseRow or not t1.shouldShowStatusIndicator then nil else React.createElement(View, {
				LayoutOrder = 1,
				tag = "auto-xy padding-right-small"
			}, {
				StatusIndicator = React.createElement(StatusIndicator, {
					variant = StatusIndicatorVariant.Emphasis
				})
			}),
			PrimaryActionCta = if not t1.primaryCta or not t1.primaryCta.onActivated then if not FFlagUserListCtaIntegrationEnabled or (not t1.ctaLoading or t1.layoutMode ~= Enums.RowLayoutMode.Wide) then nil else React.createElement(Skeleton, {
				LayoutOrder = not FFlagAddStatusIndicatorToBaseRow and 1 or 2,
				Size = UDim2.fromOffset(t1.ctaLoading.minWidth or 0, v29.Size.Size_800),
				radius = EnumsRadius.Medium
			}) else if t1.layoutMode ~= Enums.RowLayoutMode.Wide then React.createElement(Button, {
				text = if not v10 then t1.primaryCta.type else v30[t1.primaryCta.type],
				size = InputSize.Small,
				variant = if not FFlagFriendsPageViewBtnEnabled then ButtonVariant.SoftEmphasis else t1.primaryCta.variant or ButtonVariant.SoftEmphasis,
				onActivated = t1.primaryCta.onActivated,
				isDisabled = t1.primaryCta.isDisabled,
				isLoading = t1.primaryCta.isLoading,
				LayoutOrder = not FFlagAddStatusIndicatorToBaseRow and 1 or 2,
				width = if t1.layoutMode ~= Enums.RowLayoutMode.Compact then nil else UDim.new(1, 0)
			}) else React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = not FFlagAddStatusIndicatorToBaseRow and 1 or 2,
				sizeConstraint = {
					MinSize = if not t1.primaryCta.minWidth then nil else Vector2.new(t1.primaryCta.minWidth, 0),
					MaxSize = if not t1.primaryCta.maxWidth then nil else Vector2.new(t1.primaryCta.maxWidth, 1e999)
				}
			}, {
				Button = React.createElement(Button, {
					text = if not v10 then t1.primaryCta.type else v30[t1.primaryCta.type],
					size = InputSize.Small,
					variant = if not FFlagFriendsPageViewBtnEnabled then ButtonVariant.SoftEmphasis else t1.primaryCta.variant or ButtonVariant.SoftEmphasis,
					onActivated = t1.primaryCta.onActivated,
					isDisabled = t1.primaryCta.isDisabled,
					isLoading = t1.primaryCta.isLoading,
					fillBehavior = FillBehavior.Fill
				})
			}),
			SecondaryActionCta = if t1.layoutMode ~= Enums.RowLayoutMode.Wide or (not t1.secondaryCta or (not t1.secondaryCta.icon or not t1.secondaryCta.onActivated)) then nil else React.createElement(IconButton, {
				icon = t1.secondaryCta.icon,
				size = IconSize.Small,
				variant = ButtonVariant.Utility,
				onActivated = t1.secondaryCta.onActivated,
				isDisabled = t1.secondaryCta.isDisabled,
				isLoading = t1.secondaryCta.isLoading,
				LayoutOrder = not FFlagAddStatusIndicatorToBaseRow and 2 or 3
			}),
			TrailingContentWrapper = if t1.layoutMode ~= Enums.RowLayoutMode.Wide or not t1.trailingContent then nil else React.createElement(View, {
				tag = "auto-xy",
				LayoutOrder = not FFlagAddStatusIndicatorToBaseRow and 3 or 4
			}, {
				Content = t1.trailingContent
			})
		})
	})
end

return React.memo(BaseRow)
