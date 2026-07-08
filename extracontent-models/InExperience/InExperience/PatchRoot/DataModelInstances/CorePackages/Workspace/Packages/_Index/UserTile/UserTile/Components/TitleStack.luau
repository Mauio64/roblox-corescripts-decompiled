local UserTile = script:FindFirstAncestor("UserTile")
local UserTileParent = UserTile.Parent
local React = require(UserTileParent.React)
local Foundation = require(UserTileParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local llama = require(UserTileParent.LuaSocialLibrariesDeps).llama
local useLocalization = require(UserTileParent.Localization).Hooks.useLocalization
local Constants = require(UserTile.Constants)
local LayoutMode = require(script.Parent.Parent.Enums.LayoutMode)
local TextKeys = require(UserTile.TextKeys)
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Enums = Foundation.Enums
local StateLayerAffordance = Enums.StateLayerAffordance
local EnumsRadius = Enums.Radius
local IconSize = Enums.IconSize
local FFlagProfilePlatformNewProfileHeader = require(UserTileParent.SharedFlags).FFlagProfilePlatformNewProfileHeader
local FFlagUserTileShowShimmerWhenLoading = require(UserTile.Flags.FFlagUserTileShowShimmerWhenLoading)
local FFlagUserTileTextTCIndicator = require(UserTileParent.SharedFlags).FFlagUserTileTextTCIndicator
local FFlagUserTileShowBadges = require(UserTileParent.SharedFlags).FFlagUserTileShowBadges
local FFlagEnableBlackbirdCheck = require(UserTileParent.SharedFlags).FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = require(UserTileParent.SharedFlags).FFlagHidePremiumIconography
local FFlagEnableMobileGameJoinCard = require(UserTileParent.SharedFlags).FFlagEnableMobileGameJoinCard
local FFlagUserTileAddContextualInfoIcon = require(UserTileParent.SharedFlags).FFlagUserTileAddContextualInfoIcon
local v28 = game:DefineFastFlag("UserTileRemoveContextualInfoTag", false)
local t1 = {
	layoutOrder = 2
}

local function TitleStack(t2: {[any]: any}) -- line: 63
	-- upvalues: llama (copy), t1 (copy), useTokens (copy), LayoutMode (copy), React (copy), FoundationImage (copy), FFlagUserTileShowShimmerWhenLoading (copy), Constants (copy), FFlagEnableBlackbirdCheck (copy), FFlagHidePremiumIconography (copy), FFlagUserTileTextTCIndicator (copy), useLocalization (copy), TextKeys (copy), View (copy), Skeleton (copy), EnumsRadius (copy), FFlagProfilePlatformNewProfileHeader (copy), FoundationText (copy), FFlagUserTileShowBadges (copy), Foundation (copy), FFlagEnableMobileGameJoinCard (copy), StateLayerAffordance (copy), FFlagUserTileAddContextualInfoIcon (copy), Icon (copy), IconSize (copy), v28 (copy)
	local u32 = llama.Dictionary.join(t1, t2 or {})
	local v33 = useTokens()
	local v34 = u32.layoutMode ~= LayoutMode.compact and "align-x-left" or "align-x-center"
	local v35 = if not u32.titleIcon then nil else React.createElement(FoundationImage, {
		tag = "size-300-300 radius-circle",
		LayoutOrder = 1,
		Image = u32.titleIcon
	})
	local v36 = if not u32.contextualInfo or u32.subtitle then u32.layoutMode == LayoutMode.compact or u32.subtitle ~= nil else false
	local v37 = (u32.titleStyle or v33.Typography.TitleMedium).FontSize - v33.Padding.XSmall * 2
	local v38 = (u32.subtitleStyle or v33.Typography.BodyMedium).FontSize - v33.Padding.XSmall * 2
	local v39 = (u32.contextualInfoStyle or v33.Typography.BodySmall).FontSize - v33.Padding.XSmall * 2
	local v40 = if not FFlagUserTileShowShimmerWhenLoading then nil else u32.layoutMode == LayoutMode.compact
	local TITLE_SHIMMER_WIDTH_SCALE_COMPACT = nil
	local SUBTITLE_SHIMMER_WIDTH_SCALE_COMPACT = nil
	local CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_COMPACT = nil

	if FFlagUserTileShowShimmerWhenLoading then
		if v40 then
			TITLE_SHIMMER_WIDTH_SCALE_COMPACT = Constants.TITLE_SHIMMER_WIDTH_SCALE_COMPACT
			SUBTITLE_SHIMMER_WIDTH_SCALE_COMPACT = Constants.SUBTITLE_SHIMMER_WIDTH_SCALE_COMPACT
			CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_COMPACT = Constants.CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_COMPACT
		else
			TITLE_SHIMMER_WIDTH_SCALE_COMPACT = Constants.TITLE_SHIMMER_WIDTH_SCALE_WIDE
			SUBTITLE_SHIMMER_WIDTH_SCALE_COMPACT = Constants.SUBTITLE_SHIMMER_WIDTH_SCALE_WIDE
			CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_COMPACT = Constants.CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_WIDE
		end
	end

	local v44 = (not FFlagUserTileShowShimmerWhenLoading or u32.layoutMode ~= LayoutMode.compact) and "align-x-left" or "align-x-center"
	local v45 = u32.layoutMode ~= LayoutMode.compact and "grow" or "size-full-0"
	local v46 = u32.customTextTruncation or Enum.TextTruncate.AtEnd
	local v47 = if not FFlagEnableBlackbirdCheck then nil else u32.isRobloxSubscriber == true
	local v48 = not FFlagHidePremiumIconography and (u32.isPremium and not v47)
	local v49 = nil

	if FFlagUserTileTextTCIndicator then
		v49 = useLocalization({
			trustedLabel = TextKeys.trustedLabel
		})
	end

	return React.createElement(View, {
		tag = `{ v45 } auto-y col`,
		LayoutOrder = u32.layoutOrder
	}, {
		Title = if not FFlagUserTileShowShimmerWhenLoading or not u32.isTitleLoading then React.createElement(View, {
			LayoutOrder = 1,
			tag = `size-full-0 row auto-y gap-xxsmall align-y-center { v34 }`
		}, {
			TitleIcon = v35,
			TitleText = if not FFlagProfilePlatformNewProfileHeader then u32.title and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				tag = {
					["content-emphasis"] = true,
					["auto-xy text-align-x-center"] = u32.layoutMode == LayoutMode.compact,
					["auto-y size-full-0 text-align-x-left"] = u32.layoutMode == LayoutMode.wide
				},
				fontStyle = u32.titleStyle or v33.Typography.TitleMedium,
				Text = u32.title,
				TextTruncate = v46
			}) or nil else u32.title and React.createElement(View, {
				LayoutOrder = 2,
				tag = {
					["row align-y-center gap-xsmall content-emphasis"] = true,
					["auto-xy text-align-x-center"] = u32.layoutMode == LayoutMode.compact,
					["auto-y size-full-0 text-align-x-left"] = u32.layoutMode == LayoutMode.wide
				}
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					RichText = true,
					tag = {
						["shrink content-default auto-xy"] = true,
						["text-align-x-left"] = u32.layoutMode == LayoutMode.wide,
						["text-align-x-center"] = u32.layoutMode == LayoutMode.compact
					},
					fontStyle = u32.titleStyle or v33.Typography.TitleMedium,
					Text = u32.title,
					TextTruncate = v46
				}),
				BadgesRow = if not FFlagUserTileShowBadges then nil else React.createElement(View, {
					tag = "row align-y-center auto-xy content-default gap-xxsmall",
					["text-align-x-left"] = u32.layoutMode == LayoutMode.wide,
					["text-align-x-center"] = u32.layoutMode == LayoutMode.compact,
					LayoutOrder = 2
				}, {
					VerifiedBadge = u32.isVerified and React.createElement(View, {
						tag = "auto-xy content-default",
						LayoutOrder = 2
					}, {
						VerifiedBackplateIcon = React.createElement(Foundation.Icon, {
							ZIndex = 1,
							name = Foundation.Enums.IconName.VerifiedBackplate,
							size = Foundation.Enums.IconSize.Large,
							style = v33.Color.System.Emphasis,
							AnchorPoint = Vector2.new(0, 0),
							Position = UDim2.fromScale(0, 0)
						}),
						VerifiedCheckIcon = React.createElement(Foundation.Icon, {
							ZIndex = 2,
							name = Foundation.Enums.IconName.VerifiedCheck,
							size = Foundation.Enums.IconSize.Large,
							style = {
								Transparency = 0,
								Color3 = Color3.fromRGB(255, 255, 255)
							},
							AnchorPoint = Vector2.new(0, 0),
							Position = UDim2.fromScale(0, 0)
						})
					}),
					SubscriptionBadge = if not v47 then nil else React.createElement(Foundation.Icon, {
						LayoutOrder = 3,
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small,
						style = v33.Color.Content.Emphasis
					}),
					PremiumBadge = if not v48 then nil else React.createElement(Foundation.Icon, {
						LayoutOrder = 4,
						name = Foundation.Enums.IconName.Premium,
						size = Foundation.Enums.IconSize.Large
					}),
					AdminBadge = u32.isRobloxAdmin and React.createElement(Foundation.Icon, {
						LayoutOrder = 5,
						name = Foundation.Enums.IconName.Tilt,
						size = Foundation.Enums.IconSize.Large
					})
				})
			})
		}) else React.createElement(View, {
			LayoutOrder = 1,
			tag = `size-full-0 auto-y padding-xsmall { v44 }`
		}, {
			TitleSkeleton = React.createElement(Skeleton, {
				Size = UDim2.new(TITLE_SHIMMER_WIDTH_SCALE_COMPACT, 0, 0, v37),
				radius = EnumsRadius.Small
			})
		}),
		Subtitle = if not FFlagUserTileShowShimmerWhenLoading or not u32.isSubtitleLoading then if FFlagUserTileTextTCIndicator or not v36 then if not FFlagUserTileTextTCIndicator or not v36 then nil else React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["row auto-y size-full-0 align-y-center"] = true,
				["align-x-center"] = u32.layoutMode == LayoutMode.compact,
				["align-x-left"] = u32.layoutMode == LayoutMode.wide
			},
			onActivated = if not FFlagProfilePlatformNewProfileHeader and not FFlagEnableMobileGameJoinCard or not u32.onSubtitleClicked then nil else function() -- line: 277
				-- upvalues: u32 (ref)
				u32.onSubtitleClicked()
			end,
			stateLayer = if not FFlagProfilePlatformNewProfileHeader and not FFlagEnableMobileGameJoinCard or not u32.onSubtitleClicked then nil else {
				affordance = StateLayerAffordance.None
			}
		}, {
			SubtitleText = React.createElement(FoundationText, {
				LayoutOrder = 1,
				RichText = true,
				tag = {
					["auto-xy shrink content-default"] = true,
					["text-align-x-center"] = u32.layoutMode == LayoutMode.compact,
					["text-align-x-left"] = u32.layoutMode == LayoutMode.wide
				},
				fontStyle = u32.subtitleStyle or v33.Typography.BodyMedium,
				Text = u32.subtitle or "",
				TextTruncate = v46
			}),
			TCTextLabel = if not u32.trustedConnectionIndicatorEnabled or not u32.isTrustedConnection then nil else React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				tag = {
					["auto-xy content-default"] = true,
					["text-align-x-center"] = u32.layoutMode == LayoutMode.compact,
					["text-align-x-left"] = u32.layoutMode == LayoutMode.wide
				},
				fontStyle = u32.subtitleStyle or v33.Typography.BodyMedium,
				Text = " • " .. v49.trustedLabel,
				TextTruncate = v46
			})
		}) else React.createElement(FoundationText, {
			LayoutOrder = 2,
			RichText = true,
			tag = {
				["auto-y size-full-0 content-default"] = true,
				["text-align-x-center"] = u32.layoutMode == LayoutMode.compact,
				["text-align-x-left"] = u32.layoutMode == LayoutMode.wide
			},
			fontStyle = u32.subtitleStyle or v33.Typography.BodyMedium,
			Text = u32.subtitle or "",
			TextTruncate = v46,
			onActivated = if not FFlagProfilePlatformNewProfileHeader and not FFlagEnableMobileGameJoinCard or not u32.onSubtitleClicked then nil else function() -- line: 256
				-- upvalues: u32 (ref)
				u32.onSubtitleClicked()
			end,
			stateLayer = if not FFlagProfilePlatformNewProfileHeader and not FFlagEnableMobileGameJoinCard or not u32.onSubtitleClicked then nil else {
				affordance = StateLayerAffordance.None
			}
		}) else React.createElement(View, {
			LayoutOrder = 2,
			tag = `size-full-0 auto-y padding-xsmall { v44 }`
		}, {
			SubtitleSkeleton = React.createElement(Skeleton, {
				Size = UDim2.new(SUBTITLE_SHIMMER_WIDTH_SCALE_COMPACT, 0, 0, v38),
				radius = EnumsRadius.Small
			})
		}),
		ContextualInfo = if not FFlagUserTileShowShimmerWhenLoading or not u32.isContextualInfoLoading then u32.contextualInfo and (if not FFlagUserTileAddContextualInfoIcon or not u32.contextualInfoIcon then React.createElement(FoundationText, {
			LayoutOrder = 3,
			RichText = true,
			tag = {
				["auto-y size-full-0 content-secondary"] = not v28,
				["size-full-0 auto-y"] = v28,
				["text-align-x-center"] = u32.layoutMode == LayoutMode.compact,
				["text-align-x-left"] = u32.layoutMode == LayoutMode.wide
			},
			fontStyle = u32.contextualInfoStyle or v33.Typography.BodySmall,
			TextTruncate = v46,
			Text = u32.contextualInfo
		}) else React.createElement(View, {
			LayoutOrder = 3,
			tag = {
				["row align-y-center gap-xsmall size-full-0 auto-y"] = true,
				["align-x-center"] = u32.layoutMode == LayoutMode.compact,
				["align-x-left"] = u32.layoutMode == LayoutMode.wide
			}
		}, {
			ContextualInfoIcon = React.createElement(Icon, {
				LayoutOrder = 1,
				name = u32.contextualInfoIcon,
				size = IconSize.XSmall
			}),
			ContextualInfoText = React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				tag = {
					["content-secondary shrink auto-xy"] = not v28,
					["shrink auto-xy"] = v28
				},
				fontStyle = u32.contextualInfoStyle or v33.Typography.BodySmall,
				TextTruncate = v46,
				Text = u32.contextualInfo
			})
		})) or nil else React.createElement(View, {
			LayoutOrder = 3,
			tag = `size-full-0 auto-y padding-xsmall { v44 }`
		}, {
			ContextualInfoSkeleton = React.createElement(Skeleton, {
				Size = UDim2.new(CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_COMPACT, 0, 0, v39),
				radius = EnumsRadius.Small
			})
		})
	})
end

return TitleStack
