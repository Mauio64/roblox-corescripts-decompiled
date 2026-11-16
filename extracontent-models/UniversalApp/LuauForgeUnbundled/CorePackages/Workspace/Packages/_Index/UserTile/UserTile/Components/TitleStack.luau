local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/Foundation")
local useTokens = Foundation.Hooks.useTokens
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/LuaSocialLibrariesDeps").llama
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/Localization").Hooks.useLocalization
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/VerifiedBadges/VerifiedBadge")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Constants")
local LayoutMode = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Enums/LayoutMode")

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/TextKeys")

local view = Foundation.View
local text = Foundation.Text
local image = Foundation.Image
local icon = Foundation.Icon
local skeleton = Foundation.Skeleton
local enums = Foundation.Enums
local stateLayerAffordance = enums.StateLayerAffordance
local radius = enums.Radius
local iconSize = enums.IconSize
local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagProfilePlatformNewProfileHeader
local FFlagUserTileShowShimmerWhenLoading = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Flags/FFlagUserTileShowShimmerWhenLoading")
local fFlagUserTileShowBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileShowBadges
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagHidePremiumIconography = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagHidePremiumIconography
local fFlagEnableMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagEnableMobileGameJoinCard
local fFlagUserTileAddContextualInfoIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileAddContextualInfoIcon
local defineFastFlag = game:DefineFastFlag("UserTileRemoveContextualInfoTag", false)
local fFlagUserTileTitleStackAddExtraInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileTitleStackAddExtraInfo
local fFlagUserTileUnfilteredChatIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUserTileUnfilteredChatIndicator
local fFlagUnifyVerifiedBadgeComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagUnifyVerifiedBadgeComponent
local fFlagSocialCarouselInGameTitleMarquee = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SharedFlags").FFlagSocialCarouselInGameTitleMarquee

local v5 = { layoutOrder = 2 }

local function TitleStack(options)
	local joined = llama.Dictionary.join(v5, options or {})
	local v6 = useTokens()
	local v7 = joined.layoutMode == LayoutMode.compact and "align-x-center" or "align-x-left"
	local v8

	if joined.titleIcon then
		v8 = React.createElement(image, {
			Image = joined.titleIcon,
			tag = "size-300-300 radius-circle",
			LayoutOrder = 1
		})
	end

	local subtitle = if typeof(joined.subtitle) == "string" then joined.subtitle else nil
	local v9

	if fFlagSocialCarouselInGameTitleMarquee and typeof(joined.subtitle) == "table" then
		v9 = joined.subtitle
	end

	local v10

	if joined.contextualInfo and not subtitle then
		v10 = false
	else
		v10 = joined.layoutMode == LayoutMode.compact or subtitle ~= nil
	end

	local v11 = (joined.titleStyle or v6.Typography.TitleMedium).FontSize - v6.Padding.XSmall * 2
	local v12 = (joined.subtitleStyle or v6.Typography.BodyMedium).FontSize - v6.Padding.XSmall * 2
	local v13 = (joined.contextualInfoStyle or v6.Typography.BodySmall).FontSize - v6.Padding.XSmall * 2

	local v14 = not fFlagUserTileTitleStackAddExtraInfo and 0
		or (joined.extraInfoStyle or v6.Typography.BodySmall).FontSize - v6.Padding.XSmall * 2

	local v15 = if FFlagUserTileShowShimmerWhenLoading then joined.layoutMode == LayoutMode.compact else nil
	local v16, v17, v18, v19

	if FFlagUserTileShowShimmerWhenLoading then
		if v15 then
			v16 = Constants.TITLE_SHIMMER_WIDTH_SCALE_COMPACT
			v17 = Constants.SUBTITLE_SHIMMER_WIDTH_SCALE_COMPACT
			v18 = Constants.CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_COMPACT
			v19 = Constants.EXTRA_INFO_SHIMMER_WIDTH_SCALE_COMPACT
		else
			v16 = Constants.TITLE_SHIMMER_WIDTH_SCALE_WIDE
			v17 = Constants.SUBTITLE_SHIMMER_WIDTH_SCALE_WIDE
			v18 = Constants.CONTEXTUAL_INFO_SHIMMER_WIDTH_SCALE_WIDE
			v19 = Constants.EXTRA_INFO_SHIMMER_WIDTH_SCALE_WIDE
		end
	end

	local v20 = FFlagUserTileShowShimmerWhenLoading and joined.layoutMode == LayoutMode.compact and "align-x-center" or "align-x-left"

	local v21 = joined.layoutMode == LayoutMode.compact and "size-full-0" or "grow"

	local customTextTruncation = joined.customTextTruncation or Enum.TextTruncate.AtEnd
	local v22 = if fFlagEnableBlackbirdCheck then joined.isRobloxSubscriber == true else nil

	local v23 = not fFlagHidePremiumIconography and (joined.isPremium and not v22)

	local v24 = useLocalization({
		trustedLabel = TextKeys.trustedLabel,
		unfilteredChatLabel = TextKeys.unfilteredChatLabel
	})

	local v25 = fFlagUserTileUnfilteredChatIndicator and joined.shouldShowUnfilteredChatIndicator == true
	local v26 = (joined.trustedConnectionIndicatorEnabled and joined.isTrustedConnection) == true
	local v27 = not (subtitle == nil) and subtitle ~= ""

	local createElement = React.createElement
	local v29 = { tag = `{v21} auto-y col`, LayoutOrder = joined.layoutOrder }
	local v31

	if FFlagUserTileShowShimmerWhenLoading and joined.isTitleLoading then
		v31 = React.createElement(
			view,
			{
				tag = `size-full-0 auto-y padding-xsmall {v20}`,
				LayoutOrder = 1
			},
			{
				TitleSkeleton = React.createElement(skeleton, {
					Size = UDim2.new(v16, 0, 0, v11),
					radius = radius.Small
				})
			}
		)
	else
		local createElement2 = React.createElement
		local v33 = {
			tag = `size-full-0 row auto-y gap-xxsmall align-y-center {v7}`,
			LayoutOrder = 1
		}
		local v35

		if fFlagProfilePlatformNewProfileHeader then
			v35 = joined.title

			if v35 then
				local createElement3 = React.createElement
				local v37 = {
					tag = {
						["row align-y-center gap-xsmall content-emphasis"] = true,
						["auto-xy text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
						["auto-y size-full-0 text-align-x-left"] = joined.layoutMode == LayoutMode.wide
					},
					LayoutOrder = 2
				}

				local v38 = {
					Title = React.createElement(text, {
						tag = {
							["shrink content-default auto-xy"] = true,
							["text-align-x-left"] = joined.layoutMode == LayoutMode.wide,
							["text-align-x-center"] = joined.layoutMode == LayoutMode.compact
						},
						fontStyle = joined.titleStyle or v6.Typography.TitleMedium,
						Text = joined.title,
						LayoutOrder = 1,
						RichText = true,
						TextTruncate = customTextTruncation
					}),
					BadgesRow = 0
				}
				local v39

				if fFlagUserTileShowBadges then
					local createElement4 = React.createElement
					local v41 = {
						tag = "row align-y-center auto-xy content-default gap-xxsmall",
						["text-align-x-left"] = joined.layoutMode == LayoutMode.wide,
						["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
						LayoutOrder = 2
					}

					local v43 = joined.isVerified

					if v43 then
						if fFlagUnifyVerifiedBadgeComponent then
							v43 = React.createElement(module3, {
								size = iconSize.Large,
								LayoutOrder = 2
							})
						else
							v43 = React.createElement(
								view,
								{ tag = "auto-xy content-default", LayoutOrder = 2 },
								{
									VerifiedBackplateIcon = React.createElement(Foundation.Icon, {
										name = Foundation.Enums.IconName.VerifiedBackplate,
										size = Foundation.Enums.IconSize.Large,
										style = v6.Color.System.Emphasis,
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

					local v44 = if v22 then React.createElement(Foundation.Icon, {
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small,
						style = v6.Color.Content.Emphasis,
						LayoutOrder = 3
					}) else nil

					local v45 = if v23 then React.createElement(Foundation.Icon, {
						name = Foundation.Enums.IconName.Premium,
						size = Foundation.Enums.IconSize.Large,
						LayoutOrder = 4
					}) else nil
					v39 = createElement4(view, v41, {
						VerifiedBadge = v43,
						SubscriptionBadge = v44,
						PremiumBadge = v45,
						AdminBadge = joined.isRobloxAdmin and React.createElement(Foundation.Icon, {
							name = Foundation.Enums.IconName.Tilt,
							size = Foundation.Enums.IconSize.Large,
							LayoutOrder = 5
						})
					})
				end

				v38.BadgesRow = v39
				v35 = createElement3(view, v37, v38)
			end
		elseif joined.title then
			v35 = React.createElement(text, {
				tag = {
					["content-emphasis"] = true,
					["auto-xy text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["auto-y size-full-0 text-align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				fontStyle = joined.titleStyle or v6.Typography.TitleMedium,
				Text = joined.title,
				LayoutOrder = 2,
				RichText = true,
				TextTruncate = customTextTruncation
			}) or nil
		end

		v31 = createElement2(view, v33, { TitleIcon = v8, TitleText = v35 })
	end

	if not v9 then
		if FFlagUserTileShowShimmerWhenLoading and joined.isSubtitleLoading then
			v9 = React.createElement(
				view,
				{
					tag = `size-full-0 auto-y padding-xsmall {v20}`,
					LayoutOrder = 2
				},
				{
					SubtitleSkeleton = React.createElement(skeleton, {
						Size = UDim2.new(v17, 0, 0, v12),
						radius = radius.Small
					})
				}
			)
		elseif v10 or v25 then
			local createElement2 = React.createElement
			local v33 = {
				tag = {
					["row auto-y size-full-0 align-y-center"] = true,
					["align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				LayoutOrder = 2,
				onActivated = (fFlagProfilePlatformNewProfileHeader or fFlagEnableMobileGameJoinCard) and joined.onSubtitleClicked and function()
					joined.onSubtitleClicked()
				end or nil,
				stateLayer = (fFlagProfilePlatformNewProfileHeader or fFlagEnableMobileGameJoinCard) and joined.onSubtitleClicked and {
					affordance = stateLayerAffordance.None
				} or nil
			}

			local v34 = {
				SubtitleText = React.createElement(text, {
					tag = {
						["auto-xy shrink content-default"] = true,
						["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
						["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
					},
					fontStyle = joined.subtitleStyle or v6.Typography.BodyMedium,
					Text = subtitle or "",
					LayoutOrder = 1,
					RichText = true,
					TextTruncate = customTextTruncation
				}),
				TCTextLabel = 0,
				UnfilteredChatLabel = 0
			}

			local v35 = if joined.trustedConnectionIndicatorEnabled and joined.isTrustedConnection then React.createElement(text, {
				tag = {
					["auto-xy content-default"] = true,
					["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				fontStyle = joined.subtitleStyle or v6.Typography.BodyMedium,
				Text = (fFlagUserTileUnfilteredChatIndicator and not v27 and "" or " • ") .. v24.trustedLabel,
				LayoutOrder = 2,
				RichText = true,
				TextTruncate = customTextTruncation
			}) else nil
			v34.TCTextLabel = v35

			local v36 = if v25 then React.createElement(text, {
				tag = {
					["auto-xy content-default"] = true,
					["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				fontStyle = joined.subtitleStyle or v6.Typography.BodyMedium,
				Text = ((v27 or v26) and " • " or "") .. v24.unfilteredChatLabel,
				LayoutOrder = 3,
				RichText = true,
				TextTruncate = customTextTruncation
			}) else nil
			v34.UnfilteredChatLabel = v36
			v9 = createElement2(view, v33, v34)
		else
			v9 = nil
		end
	end

	local v32

	if FFlagUserTileShowShimmerWhenLoading and joined.isContextualInfoLoading then
		v32 = React.createElement(
			view,
			{
				tag = `size-full-0 auto-y padding-xsmall {v20}`,
				LayoutOrder = 3
			},
			{
				ContextualInfoSkeleton = React.createElement(skeleton, {
					Size = UDim2.new(v18, 0, 0, v13),
					radius = radius.Small
				})
			}
		)
	elseif joined.contextualInfo then
		local v33

		if fFlagUserTileAddContextualInfoIcon and joined.contextualInfoIcon then
			v33 = React.createElement(view, {
				tag = {
					["row align-y-center gap-xsmall size-full-0 auto-y"] = true,
					["align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				LayoutOrder = 3
			}, {
				ContextualInfoIcon = React.createElement(icon, {
					name = joined.contextualInfoIcon,
					size = iconSize.XSmall,
					LayoutOrder = 1
				}),
				ContextualInfoText = React.createElement(text, {
					tag = {
						["content-secondary shrink auto-xy"] = not defineFastFlag,
						["shrink auto-xy"] = defineFastFlag
					},
					fontStyle = joined.contextualInfoStyle or v6.Typography.BodySmall,
					TextTruncate = customTextTruncation,
					Text = joined.contextualInfo,
					LayoutOrder = 2,
					RichText = true
				})
			})
		else
			v33 = React.createElement(text, {
				tag = {
					["auto-y size-full-0 content-secondary"] = not defineFastFlag,
					["size-full-0 auto-y"] = defineFastFlag,
					["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
					["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
				},
				fontStyle = joined.contextualInfoStyle or v6.Typography.BodySmall,
				TextTruncate = customTextTruncation,
				Text = joined.contextualInfo,
				LayoutOrder = 3,
				RichText = true
			})
		end

		v32 = v33 or nil
	end

	local v33

	if fFlagUserTileTitleStackAddExtraInfo and joined.isExtraInfoLoading then
		v33 = React.createElement(
			view,
			{
				tag = `size-full-0 auto-y padding-xsmall {v20}`,
				LayoutOrder = 4
			},
			{
				ExtraInfoSkeleton = React.createElement(skeleton, {
					Size = UDim2.new(v19, 0, 0, v14),
					radius = radius.Small
				})
			}
		)
	elseif fFlagUserTileTitleStackAddExtraInfo and joined.extraInfo then
		v33 = React.createElement(text, {
			tag = {
				["size-full-0 auto-y"] = true,
				["text-align-x-center"] = joined.layoutMode == LayoutMode.compact,
				["text-align-x-left"] = joined.layoutMode == LayoutMode.wide
			},
			fontStyle = joined.extraInfoStyle or v6.Typography.BodySmall,
			TextTruncate = customTextTruncation,
			Text = joined.extraInfo,
			LayoutOrder = 4,
			RichText = true,
			onActivated = joined.onExtraInfoClicked,
			stateLayer = joined.onExtraInfoClicked and {
				affordance = stateLayerAffordance.None
			} or nil
		})
	end

	return createElement(view, v29, {
		Title = v31,
		Subtitle = v9,
		ContextualInfo = v32,
		ExtraInfo = v33
	})
end

return TitleStack
