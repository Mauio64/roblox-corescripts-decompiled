local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local React = dependencies.React
local useLocalization = require(FriendsLandingParent.Localization).Hooks.useLocalization
local llama = require(FriendsLandingParent.LuaSocialLibrariesDeps).llama
local VerifiedBadges = require(FriendsLandingParent.VerifiedBadges)
local UIBlox = dependencies.UIBlox
local useStyle = UIBlox.Core.Style.useStyle
local PlayerTile = UIBlox.App.Tile.PlayerTile
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local PlayerContext = UIBlox.App.Indicator.PlayerContext
local _ = dependencies.RoduxPresence.Enums.PresenceType
local Foundation = require(FriendsLandingParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FoundationText = Foundation.Text
local Skeleton = Foundation.Skeleton
local Enums = Foundation.Enums
local StateLayerAffordance = Enums.StateLayerAffordance
local GetFFlagLuaAppEnableOpenTypeSupport = require(FriendsLandingParent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local FFlagEnableBlackbirdCheck = require(FriendsLandingParent.SharedFlags).FFlagEnableBlackbirdCheck
local v23 = game:DefineFastFlag("FixFriendsLandingTileGamepadSelection", false)
local t1 = {
	userPresence = nil,
	index = 1,
	openPlayerProfile = nil,
	buttons = nil,
	trustedConnection = false,
	isVerified = false
}

local function FriendTileWithTrustedIndicator(t2: {[any]: any}) -- line: 89
	-- upvalues: llama (copy), t1 (copy), useStyle (copy), useTokens (copy), useLocalization (copy), React (copy), View (copy), StateLayerAffordance (copy), PlayerTile (copy), v23 (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), Skeleton (copy), FoundationText (copy), VerifiedBadges (copy), FFlagEnableBlackbirdCheck (copy), Foundation (copy), Enums (copy), PlayerContext (copy)
	local v27 = llama.Dictionary.join(t1, t2 or {})
	local v28 = useStyle()
	local v29 = useTokens()
	local v30 = useLocalization({
		trustedText = "Feature.Friends.TrustedConnection.Label.Trusted"
	})
	local icon = nil
	local iconColor = nil
	local iconTransparency = nil
	local TextDefault = v28.Theme.TextDefault

	if v27.relevancyInfo then
		iconColor = v27.relevancyInfo.iconColor
		icon = v27.relevancyInfo.icon
		iconTransparency = v27.relevancyInfo.iconTransparency
	end

	return React.createElement(View, {
		tag = "col auto-xy size-0-0 gap-small",
		onActivated = v27.openPlayerProfile,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		PlayerTile = React.createElement(View, {
			tag = "size-full-full aspect-1-1 bg-surface-100 clip",
			LayoutOrder = 1
		}, { React.createElement(PlayerTile, {
			title = "",
			subtitle = "",
			tileSize = UDim2.fromScale(1, 1),
			thumbnail = v27.user.thumbnail,
			onActivated = v27.openPlayerProfile,
			forwardedRef = v27.playerTileRef,
			buttons = v27.buttons,
			Selectable = not v23,
			openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative()
		}) }),
		TextColumn = React.createElement(View, {
			tag = "col size-full-0 auto-y gap-xxsmall",
			LayoutOrder = 2
		}, {
			Title = React.createElement(View, {
				tag = "auto-y size-full-0"
			}, {
				LoadingSkeleton = if v27.title then nil else React.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 0, v29.Typography.TitleLarge.FontSize)
				}),
				Title = v27.title and React.createElement(View, {
					tag = "row auto-y size-full-0 align-y-center ",
					LayoutOrder = 1
				}, {
					TitleText = React.createElement(FoundationText, {
						tag = "text-truncate-end text-align-x-left auto-xy shrink content-default",
						LayoutOrder = 1,
						RichText = true,
						fontStyle = v29.Typography.TitleLarge,
						Text = v27.title
					}),
					VerifiedBadge = v27.isVerified and React.createElement(FoundationText, {
						tag = "auto-xy content-default",
						LayoutOrder = 2,
						RichText = true,
						fontStyle = v29.Typography.TitleLarge,
						Text = VerifiedBadges.emoji.verified
					}),
					SubscriptionBadge = if not FFlagEnableBlackbirdCheck or v27.isRobloxSubscriber ~= true then nil else React.createElement(Foundation.Icon, {
						LayoutOrder = 3,
						name = Enums.IconName.RobloxPlus,
						size = Enums.IconSize.Small,
						style = v29.Color.Content.Emphasis
					})
				})
			}),
			Subtitle = React.createElement(View, {
				tag = "row auto-y size-full-0",
				LayoutOrder = 2
			}, {
				LoadingSkeleton = if not not v27.subtitle and v27.subtitle ~= "@" then nil else React.createElement(Skeleton, {
					Size = UDim2.new(0.4, 0, 0, v29.Typography.BodySmall.FontSize)
				}),
				SubtitleText = v27.subtitle and (v27.subtitle ~= "@" and React.createElement(FoundationText, {
					tag = "text-truncate-end auto-xy text-align-x-left shrink content-default",
					LayoutOrder = 1,
					RichText = true,
					fontStyle = v29.Typography.BodySmall,
					Text = v27.subtitle
				})),
				TCTextLabel = v27.isTrustedConnection and (v27.subtitle and (v27.subtitle ~= "@" and React.createElement(FoundationText, {
					tag = "content-default auto-xy text-align-x-left",
					LayoutOrder = 2,
					fontStyle = v29.Typography.BodySmall,
					Text = " • " .. v30.trustedText
				})))
			}),
			RelevancyContainer = React.createElement(View, {
				tag = "size-full-0 row auto-y gap-xsmall align-x-left align-y-center",
				LayoutOrder = 3
			}, {
				ContextualPresence = v27.relevancyInfo and (v27.relevancyInfo.text and React.createElement(PlayerContext, {
					layoutOrder = 2,
					fontStyle = v28.Font.CaptionBody,
					icon = icon,
					iconColor = iconColor,
					iconSize = UDim2.fromOffset(12, 12),
					iconTransparency = iconTransparency,
					text = if not v27.relevancyInfo then nil else v27.relevancyInfo.text,
					textColorStyle = TextDefault,
					onActivated = v27.openPlayerProfile,
					Selectable = not v23 and nil
				}))
			})
		})
	})
end

return FriendTileWithTrustedIndicator
