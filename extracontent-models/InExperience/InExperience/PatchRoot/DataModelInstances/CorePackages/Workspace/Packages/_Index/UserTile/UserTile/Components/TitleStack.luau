local UserTile = script:FindFirstAncestor("UserTile")
local parent = UserTile.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local llama = LuaSocialLibrariesDeps.llama
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local VerifiedBadge = require(parent.VerifiedBadges.VerifiedBadge)

local Constants = require(UserTile.Constants)
local LayoutMode = require(script.Parent.Parent.Enums.LayoutMode)

local TextKeys = require(UserTile.TextKeys)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Icon = Foundation.Icon
local Skeleton = Foundation.Skeleton
local Enums = Foundation.Enums
local StateLayerAffordance = Enums.StateLayerAffordance
local Radius = Enums.Radius
local IconSize = Enums.IconSize
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagUserTileShowShimmerWhenLoading = require(UserTile.Flags.FFlagUserTileShowShimmerWhenLoading)
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserTileShowBadges = SharedFlags2.FFlagUserTileShowBadges
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags3.FFlagEnableBlackbirdCheck
local SharedFlags4 = require(parent.SharedFlags)
local FFlagHidePremiumIconography = SharedFlags4.FFlagHidePremiumIconography
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableMobileGameJoinCard = SharedFlags5.FFlagEnableMobileGameJoinCard
local SharedFlags6 = require(parent.SharedFlags)
local FFlagUserTileAddContextualInfoIcon = SharedFlags6.FFlagUserTileAddContextualInfoIcon
local defineFastFlag = game:DefineFastFlag("UserTileRemoveContextualInfoTag", false)
local SharedFlags7 = require(parent.SharedFlags)
local FFlagUserTileTitleStackAddExtraInfo = SharedFlags7.FFlagUserTileTitleStackAddExtraInfo
local SharedFlags8 = require(parent.SharedFlags)
local FFlagUserTileUnfilteredChatIndicator = SharedFlags8.FFlagUserTileUnfilteredChatIndicator
local SharedFlags9 = require(parent.SharedFlags)
local FFlagUnifyVerifiedBadgeComponent = SharedFlags9.FFlagUnifyVerifiedBadgeComponent
local SharedFlags10 = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTitleMarquee = SharedFlags10.FFlagSocialCarouselInGameTitleMarquee

local v = { layoutOrder = 2 }

local function TitleStack(options)
	local joined = llama.Dictionary.join(v, options or {})
	local v2 = useTokens()
	local v3 = joined.layoutMode == LayoutMode.compact and "align-x-center" or "align-x-left"
	local titleIcon

	if joined.titleIcon then
		titleIcon = React.createElement(Image, {
			Image = joined.titleIcon,
			tag = "size-300-300 radius-circle",
			LayoutOrder = 1
		})
	end

	local subtitle

	if typeof(joined.subtitle) == "string" then
		subtitle = joined.subtitle
	end

	local subtitle2

	if FFlagSocialCarouselInGameTitleMarquee and typeof(joined.subtitle) == "table" then
		subtitle2 = joined.subtitle
	end

	local v4

	if joined.contextualInfo and not subtitle then
		v4 = false
	else
		v4 = joined.layoutMode == LayoutMode.compact or subtitle ~= nil
	end

	local v5 = (joined.titleStyle or v2.Typography.TitleMedium).FontSize - v2.Padding.XSmall * 2
	local v6 = (joined.subtitleStyle or v2.Typography.BodyMedium).FontSize - v2.Padding.XSmall * 2
	local v7 = (joined.contextualInfoStyle or v2.Typography.BodySmall).FontSize - v2.Padding.XSmall * 2

	local v8 = not FFlagUserTileTitleStackAddExtraInfo and 0
		or (joined.extraInfoStyle or v2.Typography.BodySmall).FontSize - v2.Padding.XSmall * 2
	local v9

	if FFlagUserTileShowShimmerWhenLoading then
		v9 = joined.layoutMode == LayoutMode.compact
	end

	local v10, v11, v12, v13

	if FFlagUserTileShowShimmerWhenLoading then
		if v9 then
			v10 = Constants.TITLE_SHIMMER_WIDTH_SCALE_COMPACT
			v11 = Constants.SUBTITLE_SHIMMER_WIDTH_SCALE_COMPACT
			v12 = Constants.CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_COMPACT
			v13 = Constants.EXTRA_INFO_SHIMMER_WIDTH_SCALE_COMPACT
		else
			v10 = Constants.TITLE_SHIMMER_WIDTH_SCALE_WIDE
			v11 = Constants.SUBTITLE_SHIMMER_WIDTH_SCALE_WIDE
			v12 = Constants.CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_WIDE
			v13 = Constants.EXTRA_INFO_SHIMMER_WIDTH_SCALE_WIDE
		end
	end

	local v14 = FFlagUserTileShowShimmerWhenLoading and joined.layoutMode == LayoutMode.compact and "align-x-center"
		or "align-x-left"

	local v15 = joined.layoutMode == LayoutMode.compact and "size-full-0" or "grow"

	local customTextTruncation = joined.customTextTruncation or Enum.TextTruncate.AtEnd
	local v16

	if FFlagEnableBlackbirdCheck then
		v16 = joined.isRobloxSubscriber == true
	end

	local v17

	if FFlagHidePremiumIconography then
		v17 = false
	else
		v17 = joined.isPremium and not v16
	end

	local v18 = useLocalization({
		trustedLabel = TextKeys.trustedLabel,
		unfilteredChatLabel = TextKeys.unfilteredChatLabel
	})

	local v19 = FFlagUserTileUnfilteredChatIndicator and joined.shouldShowUnfilteredChatIndicator == true
	local v20 = (joined.trustedConnectionIndicatorEnabled and joined.isTrustedConnection) == true
	local v21

	if subtitle == nil then
		v21 = false
	else
		v21 = subtitle ~= ""
	end

	local createElement = React.createElement
	local v22 = { tag = `{v15} auto-y col`, LayoutOrder = joined.layoutOrder }
	local title

	if FFlagUserTileShowShimmerWhenLoading and joined.isTitleLoading then
		title = React.createElement(View, {
			tag = `size-full-0 auto-y padding-xsmall {v14}`,
			LayoutOrder = 1
		}, {
			TitleSkeleton = React.createElement(Skeleton, {
				Size = UDim2.new(v10, 0, 0, v5),
				radius = Radius.Small
			})
		})
	else
		local createElement2 = React.createElement
		local v23 = {
			tag = `size-full-0 row auto-y gap-xxsmall align-y-center {v3}`,
			LayoutOrder = 1
		}
		local titleText

		if FFlagProfilePlatformNewProfileHeader then
			titleText = joined.title

			if titleText then
				local createElement3 = React.createElement
				local v24 = {
					tag = {
						["row align-y-center gap-xsmall content-emphasis"] = true,
						["auto-xy text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
						["auto-y size-full-0 text-align-x-left"] = joined.layoutMode == LayoutMode.wide
					},
					LayoutOrder = 2
				}

				local v25 = {
					Title = React.createElement(Text, {
						tag = {
							["shrink content-default auto-xy"] = true,
							["text-align-x-left"] = joined.layoutMode == LayoutMode.wide,
							["text-align-x-center"] = joined.layoutMode == LayoutMode.compact
						},
						fontStyle = joined.titleStyle or v2.Typography.TitleMedium,
						Text = joined.title,
						LayoutOrder = 1,
						RichText = true,
						TextTruncate = customTextTruncation
					}),
					BadgesRow = 0
				}
				local badgesRow

				if FFlagUserTileShowBadges then
					local createElement4 = React.createElement
					local v26 = {
						tag = "row align-y-center auto-xy content-default gap-xxsmall",
						["text-align-x-left"] = joined.layoutMode == LayoutMode.wide,
						["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
						LayoutOrder = 2
					}

					local verifiedBadge = joined.isVerified

					if verifiedBadge then
						if FFlagUnifyVerifiedBadgeComponent then
							verifiedBadge = React.createElement(VerifiedBadge, {
								size = IconSize.Large,
								LayoutOrder = 2
							})
						else
							verifiedBadge = React.createElement(
								View,
								{ tag = "auto-xy content-default", LayoutOrder = 2 },
								{
									VerifiedBackplateIcon = React.createElement(Foundation.Icon, {
										name = Foundation.Enums.IconName.VerifiedBackplate,
										size = Foundation.Enums.IconSize.Large,
										style = v2.Color.System.Emphasis,
										AnchorPoint = Vector2.new(0, 0),
										Position = UDim2.fromScale(0, 0),
										ZIndex = 1
									}),
									VerifiedCheckIcon = React.createElement(Foundation.Icon, {
										name = Foundation.Enums.IconName.VerifiedCheck,
										size = Foundation.Enums.IconSize.Large,
										style = {
											Color3 = Color3.fromRGB(255, 255, 255),
											Transparency = 0
										},
										AnchorPoint = Vector2.new(0, 0),
										Position = UDim2.fromScale(0, 0),
										ZIndex = 2
									})
								}
							)
						end
					end

					local subscriptionBadge

					if v16 then
						subscriptionBadge = React.createElement(Foundation.Icon, {
							name = Foundation.Enums.IconName.RobloxPlus,
							size = Foundation.Enums.IconSize.Small,
							style = v2.Color.Content.Emphasis,
							LayoutOrder = 3
						})
					end

					local premiumBadge

					if v17 then
						premiumBadge = React.createElement(Foundation.Icon, {
							name = Foundation.Enums.IconName.Premium,
							size = Foundation.Enums.IconSize.Large,
							LayoutOrder = 4
						})
					end

					badgesRow = createElement4(View, v26, {
						VerifiedBadge = verifiedBadge,
						SubscriptionBadge = subscriptionBadge,
						PremiumBadge = premiumBadge,
						AdminBadge = joined.isRobloxAdmin and React.createElement(Foundation.Icon, {
							name = Foundation.Enums.IconName.Tilt,
							size = Foundation.Enums.IconSize.Large,
							LayoutOrder = 5
						})
					})
				end

				v25.BadgesRow = badgesRow
				titleText = createElement3(View, v24, v25)
			end
		elseif joined.title then
			titleText = React.createElement(Text, {
				tag = {
					["content-emphasis"] = true,
					["auto-xy text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["auto-y size-full-0 text-align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				fontStyle = joined.titleStyle or v2.Typography.TitleMedium,
				Text = joined.title,
				LayoutOrder = 2,
				RichText = true,
				TextTruncate = customTextTruncation
			}) or nil
		end

		title = createElement2(View, v23, { TitleIcon = titleIcon, TitleText = titleText })
	end

	if not subtitle2 then
		if FFlagUserTileShowShimmerWhenLoading and joined.isSubtitleLoading then
			subtitle2 = React.createElement(
				View,
				{
					tag = `size-full-0 auto-y padding-xsmall {v14}`,
					LayoutOrder = 2
				},
				{
					SubtitleSkeleton = React.createElement(Skeleton, {
						Size = UDim2.new(v11, 0, 0, v6),
						radius = Radius.Small
					})
				}
			)
		elseif v4 or v19 then
			local createElement2 = React.createElement
			local v23 = {
				tag = {
					["row auto-y size-full-0 align-y-center"] = true,
					["align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				LayoutOrder = 2,
				onActivated = (FFlagProfilePlatformNewProfileHeader or FFlagEnableMobileGameJoinCard) and joined.onSubtitleClicked and function()
					joined.onSubtitleClicked()
				end or nil,
				stateLayer = (FFlagProfilePlatformNewProfileHeader or FFlagEnableMobileGameJoinCard) and joined.onSubtitleClicked and {
					affordance = StateLayerAffordance.None
				} or nil
			}

			local v24 = {
				SubtitleText = React.createElement(Text, {
					tag = {
						["auto-xy shrink content-default"] = true,
						["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
						["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
					},
					fontStyle = joined.subtitleStyle or v2.Typography.BodyMedium,
					Text = subtitle or "",
					LayoutOrder = 1,
					RichText = true,
					TextTruncate = customTextTruncation
				}),
				TCTextLabel = 0,
				UnfilteredChatLabel = 0
			}
			local tcTextLabel

			if joined.trustedConnectionIndicatorEnabled and joined.isTrustedConnection then
				tcTextLabel = React.createElement(Text, {
					tag = {
						["auto-xy content-default"] = true,
						["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
						["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
					},
					fontStyle = joined.subtitleStyle or v2.Typography.BodyMedium,
					Text = (FFlagUserTileUnfilteredChatIndicator and not v21 and "" or " • ") .. v18.trustedLabel,
					LayoutOrder = 2,
					RichText = true,
					TextTruncate = customTextTruncation
				})
			end

			v24.TCTextLabel = tcTextLabel
			local unfilteredChatLabel

			if v19 then
				unfilteredChatLabel = React.createElement(Text, {
					tag = {
						["auto-xy content-default"] = true,
						["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
						["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
					},
					fontStyle = joined.subtitleStyle or v2.Typography.BodyMedium,
					Text = ((v21 or v20) and " • " or "") .. v18.unfilteredChatLabel,
					LayoutOrder = 3,
					RichText = true,
					TextTruncate = customTextTruncation
				})
			end

			v24.UnfilteredChatLabel = unfilteredChatLabel
			subtitle2 = createElement2(View, v23, v24)
		else
			subtitle2 = nil
		end
	end

	local contextualInfo

	if FFlagUserTileShowShimmerWhenLoading and joined.isContextualInfoLoading then
		contextualInfo = React.createElement(
			View,
			{
				tag = `size-full-0 auto-y padding-xsmall {v14}`,
				LayoutOrder = 3
			},
			{
				ContextualInfoSkeleton = React.createElement(Skeleton, {
					Size = UDim2.new(v12, 0, 0, v7),
					radius = Radius.Small
				})
			}
		)
	elseif joined.contextualInfo then
		local v23

		if FFlagUserTileAddContextualInfoIcon and joined.contextualInfoIcon then
			v23 = React.createElement(View, {
				tag = {
					["row align-y-center gap-xsmall size-full-0 auto-y"] = true,
					["align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				LayoutOrder = 3
			}, {
				ContextualInfoIcon = React.createElement(Icon, {
					name = joined.contextualInfoIcon,
					size = IconSize.XSmall,
					LayoutOrder = 1
				}),
				ContextualInfoText = React.createElement(Text, {
					tag = {
						["content-secondary shrink auto-xy"] = not defineFastFlag,
						["shrink auto-xy"] = defineFastFlag
					},
					fontStyle = joined.contextualInfoStyle or v2.Typography.BodySmall,
					TextTruncate = customTextTruncation,
					Text = joined.contextualInfo,
					LayoutOrder = 2,
					RichText = true
				})
			})
		else
			v23 = React.createElement(Text, {
				tag = {
					["auto-y size-full-0 content-secondary"] = not defineFastFlag,
					["size-full-0 auto-y"] = defineFastFlag,
					["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				fontStyle = joined.contextualInfoStyle or v2.Typography.BodySmall,
				TextTruncate = customTextTruncation,
				Text = joined.contextualInfo,
				LayoutOrder = 3,
				RichText = true
			})
		end

		contextualInfo = v23 or nil
	end

	local extraInfo

	if FFlagUserTileTitleStackAddExtraInfo and joined.isExtraInfoLoading then
		extraInfo = React.createElement(View, {
			tag = `size-full-0 auto-y padding-xsmall {v14}`,
			LayoutOrder = 4
		}, {
			ExtraInfoSkeleton = React.createElement(Skeleton, {
				Size = UDim2.new(v13, 0, 0, v8),
				radius = Radius.Small
			})
		})
	elseif FFlagUserTileTitleStackAddExtraInfo and joined.extraInfo then
		extraInfo = React.createElement(Text, {
			tag = {
				["size-full-0 auto-y"] = true,
				["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
				["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
			},
			fontStyle = joined.extraInfoStyle or v2.Typography.BodySmall,
			TextTruncate = customTextTruncation,
			Text = joined.extraInfo,
			LayoutOrder = 4,
			RichText = true,
			onActivated = joined.onExtraInfoClicked,
			stateLayer = joined.onExtraInfoClicked and { affordance = StateLayerAffordance.None } or nil
		})
	end

	return createElement(View, v22, {
		Title = title,
		Subtitle = subtitle2,
		ContextualInfo = contextualInfo,
		ExtraInfo = extraInfo
	})
end

return TitleStack
