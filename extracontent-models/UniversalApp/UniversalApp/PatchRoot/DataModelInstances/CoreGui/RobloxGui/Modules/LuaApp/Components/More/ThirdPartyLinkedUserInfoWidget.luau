local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Badge = Foundation.Badge
local FoundationImage = Foundation.Image
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local BadgeVariant = Foundation.Enums.BadgeVariant
local useTokens = Foundation.Hooks.useTokens
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local getStandardSizeAvatarHeadShotRbxthumb = require(CorePackages.Workspace.Packages.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagEnableNonFlyoutUncheckedBadge = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNonFlyoutUncheckedBadge

local function ThirdPartyLinkedUserInfoWidget(t1: {[any]: any}) -- line: 38
	-- upvalues: useTokens (copy), FFlagEnableNonFlyoutUncheckedBadge (copy), useAppPolicy (copy), useLocalization (copy), React (copy), View (copy), FoundationImage (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FoundationText (copy), Icon (copy), IconName (copy), IconSize (copy), Badge (copy), BadgeVariant (copy)
	local v19 = useTokens()
	local v20 = if not FFlagEnableNonFlyoutUncheckedBadge then nil else useAppPolicy(function(p1) -- line: 42
		return p1.getShowUncheckedBadge()
	end)
	local v21 = if not FFlagEnableNonFlyoutUncheckedBadge then nil else useLocalization({
		Unchecked = "CommonUI.Features.Label.Unchecked"
	})

	return React.createElement(View, {
		tag = "size-full-0 gap-small auto-y align-x-left align-y-center row",
		LayoutOrder = t1.layoutOrder
	}, {
		UserIcon = React.createElement(FoundationImage, {
			tag = "radius-circle",
			LayoutOrder = 0,
			Image = getStandardSizeAvatarHeadShotRbxthumb(t1.userId),
			Size = UDim2.fromOffset(v19.Size.Size_900, v19.Size.Size_900),
			backgroundStyle = v19.Color.Common.Shimmer
		}),
		UserInfoView = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["gap-xsmall align-x-left align-y-center col"] = true,
				["size-full-0 auto-y"] = not FFlagEnableNonFlyoutUncheckedBadge,
				["auto-xy"] = FFlagEnableNonFlyoutUncheckedBadge
			}
		}, {
			UserNameAndBadge = React.createElement(View, {
				tag = "size-full-0 gap-xsmall auto-y align-x-left align-y-center row"
			}, {
				UserNameText = React.createElement(FoundationText, {
					tag = "auto-xy text-title-large text-align-y-center text-align-x-left",
					LayoutOrder = 0,
					Text = t1.userName
				}),
				BadgeText = React.createElement(FoundationText, {
					tag = "auto-xy text-align-y-center text-align-x-left",
					LayoutOrder = 1,
					Text = t1.userBadgeEmoji,
					textStyle = v19.Color.Content.Emphasis,
					fontStyle = v19.Typography.TitleLarge
				}),
				MembershipIcon = if not t1.showRobloxPlusBadge then nil else React.createElement(Icon, {
					LayoutOrder = 2,
					name = IconName.RobloxPlus,
					size = IconSize.Medium,
					style = v19.Color.Content.Emphasis
				})
			}),
			ThirdPartyUserInfo = if not t1.thirdPartyUserName or not t1.thirdPartyPlatformIcon then nil else React.createElement(View, {
				tag = "size-full-0 gap-xsmall auto-y align-x-left align-y-center row"
			}, {
				PlatformIcon = React.createElement(FoundationImage, {
					tag = "align-x-center align-x-left align-y-center",
					LayoutOrder = 0,
					Image = t1.thirdPartyPlatformIcon,
					Size = UDim2.fromOffset(v19.Size.Size_400, v19.Size.Size_400)
				}),
				ThirdPartyUserName = React.createElement(FoundationText, {
					tag = "auto-xy text-body-small text-align-y-center text-align-x-left",
					LayoutOrder = 1,
					Text = t1.thirdPartyUserName
				})
			})
		}),
		UncheckedBadge = if not FFlagEnableNonFlyoutUncheckedBadge or not v20 then nil else React.createElement(Badge, {
			LayoutOrder = 2,
			text = v21.Unchecked,
			variant = BadgeVariant.Neutral
		})
	})
end

return React.memo(ThirdPartyLinkedUserInfoWidget)
