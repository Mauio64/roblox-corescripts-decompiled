local FlyoutSidePanel = script:FindFirstAncestor("FlyoutSidePanel")
local FlyoutSidePanelParent = FlyoutSidePanel.Parent
local React = require(FlyoutSidePanelParent.React)
local UIBlox = require(FlyoutSidePanelParent.UIBlox)
local Foundation = require(FlyoutSidePanelParent.Foundation)
local BuilderIcons = require(FlyoutSidePanelParent.BuilderIcons)
local getStandardSizeAvatarHeadShotRbxthumb = require(FlyoutSidePanelParent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local LoadableImage = UIBlox.App.Loading.LoadableImage
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local useRoactService = require(FlyoutSidePanelParent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(FlyoutSidePanelParent.RoactServiceTags).AppEventIngestService
local useAppPolicy = require(FlyoutSidePanelParent.UniversalAppPolicy).useAppPolicy
local useLocalization = require(FlyoutSidePanelParent.Localization).Hooks.useLocalization
local ChevronSmallDownButton = require(script.Parent.ChevronSmallDownButton)
local SharedFlags = require(FlyoutSidePanelParent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local FFlagEnableFlyoutUncheckedBadge = SharedFlags.FFlagEnableFlyoutUncheckedBadge
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local FFlagFlyoutSidePanelUseProfileFrameThumbnail = require(FlyoutSidePanel.Flags.FFlagFlyoutSidePanelUseProfileFrameThumbnail)

local function FlyoutProfileCard(t1: {[any]: any}) -- line: 43
	-- upvalues: useTokens (copy), FFlagEnableFlyoutUncheckedBadge (copy), useLocalization (copy), useAppPolicy (copy), useRoactService (copy), AppEventIngestService (copy), React (copy), FlyoutAnalytics (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FFlagFlyoutSidePanelUseProfileFrameThumbnail (copy), FFlagEnableBlackbirdCheck (copy), FFlagHidePremiumIconography (copy), Foundation (copy), FFlagEnableDrawerFocusNav (copy), LoadableImage (copy), FoundationText (copy), Icon (copy), BuilderIcons (copy), IconSize (copy), IconName (copy), Badge (copy), BadgeVariant (copy), ChevronSmallDownButton (copy)
	local v30 = useTokens()
	local v31 = if not FFlagEnableFlyoutUncheckedBadge then nil else useLocalization({
		Unchecked = "CommonUI.Features.Label.Unchecked"
	})
	local v32 = if not FFlagEnableFlyoutUncheckedBadge then nil else useAppPolicy(function(p1) -- line: 53
		return p1.getShowUncheckedBadge()
	end)
	local v33 = useRoactService(AppEventIngestService)
	local localUserModel = t1.localUserModel
	local v35 = React.useCallback(function() -- line: 60
		-- upvalues: t1 (copy), localUserModel (copy), FlyoutAnalytics (copy), v33 (copy)
		t1.closeDrawer()

		if t1.onProfileActivated then
			t1.onProfileActivated()

			local v44 = localUserModel and localUserModel.id or ""

			FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v33, "Profile", v44)
		end
	end, {
		localUserModel,
		t1.onProfileActivated,
		t1.closeDrawer,
		v33
	})
	local v36 = React.useCallback(function() -- line: 68
		-- upvalues: t1 (copy)
		t1.closeDrawer()

		if t1.onSwitchAccountActivated then
			t1.onSwitchAccountActivated()
		end
	end, {
		t1.onSwitchAccountActivated,
		t1.closeDrawer
	})
	local v37 = React.useMemo(function() -- line: 75
		-- upvalues: localUserModel (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), FFlagFlyoutSidePanelUseProfileFrameThumbnail (copy)
		if localUserModel and localUserModel.id then
			return getStandardSizeAvatarHeadShotRbxthumb(localUserModel.id, FFlagFlyoutSidePanelUseProfileFrameThumbnail)
		end

		return nil
	end, { localUserModel })
	local v38 = React.useMemo(function() -- line: 85
		-- upvalues: localUserModel (copy)
		return localUserModel and localUserModel.membership == Enum.MembershipType.Premium
	end, { localUserModel })
	local v39 = localUserModel and localUserModel.name or ""
	local v40 = localUserModel and localUserModel.displayName or ""
	local v41 = not not FFlagEnableBlackbirdCheck and t1.isRobloxSubscriber == true
	local v42 = not FFlagHidePremiumIconography and (v38 and not v41)

	return React.createElement(Foundation.View, {
		tag = {
			["auto-y size-full-0"] = true,
			["row align-y-center gap-small"] = FFlagEnableFlyoutUncheckedBadge
		},
		LayoutOrder = t1.layoutOrder
	}, {
		ProfileCardButton = React.createElement("TextButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Text = "",
			AutomaticSize = if not FFlagEnableFlyoutUncheckedBadge then Enum.AutomaticSize.XY else Enum.AutomaticSize.Y,
			LayoutOrder = if not FFlagEnableFlyoutUncheckedBadge then nil else 1,
			[React.Event.Activated] = v35
		}, {
			UIPadding = if not FFlagEnableDrawerFocusNav then nil else React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v30.Padding.Small)
			}),
			UIFlexItem = if not FFlagEnableFlyoutUncheckedBadge then nil else React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, v30.Gap.Medium)
			}),
			UserAvatar = React.createElement(LoadableImage, {
				useShimmerAnimationWhileLoading = true,
				shouldHandleReloads = true,
				LayoutOrder = 1,
				Size = UDim2.new(0, v30.Size.Size_1600, 0, v30.Size.Size_1600),
				BackgroundColor3 = v30.Color.Common.Shimmer.Color3,
				BackgroundTransparency = v30.Color.Common.Shimmer.Transparency,
				Image = v37,
				cornerRadius = UDim.new(0.5, 0)
			}),
			UserInfoContainer = React.createElement(Foundation.View, {
				LayoutOrder = 2,
				tag = {
					col = true,
					["fill auto-y"] = FFlagEnableFlyoutUncheckedBadge,
					["position-center-left anchor-center-left auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
				}
			}, {
				UsernameContainer = React.createElement(Foundation.View, {
					LayoutOrder = 1,
					tag = {
						["row gap-xsmall"] = true,
						["size-full-0 auto-y"] = FFlagEnableFlyoutUncheckedBadge,
						["position-center-left anchor-center-left auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
					}
				}, {
					DisplayNameText = React.createElement(FoundationText, {
						LayoutOrder = 1,
						tag = {
							["auto-xy text-title-medium content-emphasis text-align-x-left"] = true,
							["shrink text-truncate-split"] = FFlagEnableFlyoutUncheckedBadge
						},
						Text = v40
					}),
					PremiumIcon = if not v42 then nil else React.createElement(Icon, {
						LayoutOrder = 2,
						style = v30.Color.Content.Emphasis,
						name = BuilderIcons.Icon.Premium,
						size = IconSize.Small
					}),
					SubscriberBadge = if not v41 then nil else React.createElement(Icon, {
						LayoutOrder = 3,
						style = v30.Color.Content.Emphasis,
						name = IconName.RobloxPlus,
						size = IconSize.Small
					})
				}),
				UserName = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = {
						["text-body-medium content-default text-align-x-left"] = true,
						["size-full-0 auto-y text-truncate-split"] = FFlagEnableFlyoutUncheckedBadge,
						["auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
					},
					Text = "@" .. v39
				})
			})
		}),
		UncheckedBadge = if not FFlagEnableFlyoutUncheckedBadge or not v32 then nil else React.createElement(Badge, {
			LayoutOrder = 2,
			text = v31.Unchecked,
			variant = BadgeVariant.Neutral
		}),
		SwitchAccountButton = if not t1.onSwitchAccountActivated then nil else React.createElement(ChevronSmallDownButton, {
			onActivated = v36,
			layoutOrder = if not FFlagEnableFlyoutUncheckedBadge then nil else 3
		})
	})
end

return FlyoutProfileCard
