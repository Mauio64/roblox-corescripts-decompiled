local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local UserTile = require(Parent.UserTile)
local UserTile2 = UserTile.UserTile
local LayoutMode = UserTile.LayoutMode
local OverlayProvider = Foundation.OverlayProvider
local Sheet = Foundation.Sheet
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local useTokens = Foundation.Hooks.useTokens
local GuiService = game:GetService("GuiService")
local AnalyticsConstants = require(script.Parent.Parent.Parent.Analytics.AnalyticsConstants)
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local CtaType = AnalyticsConstants.CtaType
local useJoinCardCtaLoadTime = require(script.Parent.Parent.Parent.Analytics.useJoinCardCtaLoadTime)
local FFlagJoinCardAgeCheckUpsell = require(Parent.SharedFlags).FFlagJoinCardAgeCheckUpsell
local AgeCheckUpsellCTA = require(script.Parent.Parent.AgeCheckUpsellCTA)
local GameJoinCardTTI = require(script.Parent.Parent.Parent.Telemetry.GameJoinCardTTI)
local v26 = game:DefineFastFlag("MobileGameJoinCardHideUserAvatar", false)
local v27 = game:DefineFastFlag("MobileGameJoinCardShowExperienceNameOnly", false)

local function MobileGameJoinCard(t1: {[any]: any}) -- line: 67
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), GuiService (copy), GameJoinCardTTI (copy), viewProfileSourceValues (copy), FFlagJoinCardAgeCheckUpsell (copy), useJoinCardCtaLoadTime (copy), CtaType (copy), useLocalization (copy), OverlayProvider (copy), Sheet (copy), View (copy), v26 (copy), FoundationImage (copy), Skeleton (copy), v27 (copy), FoundationText (copy), UserTile2 (copy), LayoutMode (copy), AgeCheckUpsellCTA (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v30 = useTokens()
	local v31, v32 = React.useState(false)
	local v33, v34 = React.useState(nil)
	local v35 = Foundation.Hooks.useOverlay()
	local v36 = not v35 or v35.AbsoluteSize.X > v35.AbsoluteSize.Y
	local v37 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small and not v36
	local v38 = React.useCallback(function(p1) -- line: 75
		-- upvalues: v32 (copy), GameJoinCardTTI (copy)
		if p1 == Enum.AssetFetchStatus.Success then
			v32(true)
			GameJoinCardTTI.trackBannerLoaded()
		end
	end, {})

	React.useEffect(function() -- line: 82
		-- upvalues: GameJoinCardTTI (copy)
		GameJoinCardTTI.trackCardMounted()
	end, {})

	local v39 = React.useCallback(function() -- line: 86
		-- upvalues: t1 (copy), viewProfileSourceValues (copy)
		t1.onViewProfile(viewProfileSourceValues.UserTile)
	end, { t1 })
	local v40 = React.useCallback(function() -- line: 90
		-- upvalues: t1 (copy), viewProfileSourceValues (copy)
		t1.onViewProfile(viewProfileSourceValues.ViewProfileButton)
	end, { t1 })
	local v41 = v30.Typography.TitleMedium.FontSize * v30.Typography.TitleMedium.LineHeight
	local v42 = v41 + v30.Typography.BodyMedium.FontSize * v30.Typography.BodyMedium.LineHeight + v30.Padding.Small
	local v43 = 88 + v42
	local v44 = FFlagJoinCardAgeCheckUpsell and t1.ageCheckRequired == true

	if FFlagJoinCardAgeCheckUpsell then
		useJoinCardCtaLoadTime({
			isLoading = t1.isLoading,
			ctaType = if not v44 then CtaType.Join else CtaType.AgeCheckUnlock,
			wasCached = t1.wasPlayabilityCached
		})
	end

	local v45 = useLocalization({
		join = "Feature.Profile.Action.JoinGame",
		viewProfile = "Feature.Profile.Action.ViewProfile",
		chat = "Feature.Profile.Action.Chat",
		playingExperience = {
			"Feature.Profile.Label.PlayingExperience",
			experienceName = t1.experienceName
		},
		userIsPlayingExperience = {
			"Feature.Profile.Label.UserIsPlayingExperience",
			userName = t1.playerName,
			experienceName = t1.experienceName
		},
		chatWithName = {
			"Feature.Home.PeopleList.ChatWith",
			username = t1.playerName
		}
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = v34
	}, {
		SheetProvider = v33 and React.createElement(OverlayProvider, {
			gui = v33
		}, {
			SheetRoot = React.createElement(Sheet.Root, {
				preferCenterSheet = true,
				onClose = t1.onClose
			}, {
				Content = React.createElement(Sheet.Content, nil, {
					BottomPadding = if not not v37 then nil else React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, v30.Padding.Medium)
					}),
					Layout = React.createElement(View, {
						tag = "col gap-medium size-full-0 auto-y"
					}, {
						BannerImageContainer = React.createElement(View, {
							tag = "size-full-0",
							LayoutOrder = 1,
							Size = if not v26 then UDim2.new(1, 0, 0, 111) else UDim2.new(1, 0, 0, 187 - v30.Padding.XLarge)
						}, {
							BannerImageClipper = React.createElement(View, {
								tag = "clip",
								Position = UDim2.new(0, -v30.Padding.XLarge, 0, -v30.Padding.XLarge),
								Size = UDim2.new(1, 40, 0, 187)
							}, {
								BannerImageCanvas = React.createElement("CanvasGroup", {
									BackgroundTransparency = 1,
									GroupTransparency = 0,
									Size = UDim2.new(1, 0, 0, 202)
								}, {
									Corner = React.createElement("UICorner", {
										CornerRadius = UDim.new(0, 15)
									}),
									BannerImage = React.createElement(FoundationImage, {
										BackgroundTransparency = 1,
										ZIndex = 2,
										Image = t1.bannerImageUrl,
										Size = UDim2.fromScale(1, 1),
										ScaleType = Enum.ScaleType.Crop,
										onLoaded = v38
									}),
									BannerSkeleton = if v31 then nil else React.createElement(Skeleton, {
										ZIndex = 1,
										Size = UDim2.fromScale(1, 1)
									})
								})
							})
						}),
						UserTileWrapper = if not t1.userId then nil else React.createElement(View, {
							ZIndex = 2,
							LayoutOrder = 2,
							Size = if not v27 then if not v26 then UDim2.new(1, 0, 0, v43) else UDim2.new(1, 0, 0, v42) else UDim2.new(1, 0, 0, v41)
						}, {
							Tile = if not v27 then if not v26 then React.createElement(UserTile2, {
								userId = t1.userId,
								title = t1.playerName,
								subtitle = v45.playingExperience,
								layoutMode = LayoutMode.compact,
								avatarSize = UDim2.fromOffset(88, 88),
								backplateStyle = v30.Color.Surface.Surface_100,
								onActivated = v39
							}) else React.createElement(View, {
								tag = "col align-x-center align-y-center size-full"
							}, {
								CombinedText = React.createElement(FoundationText, {
									tag = "shrink auto-xy text-wrap text-align-x-center content-default",
									LayoutOrder = 1,
									RichText = true,
									fontStyle = v30.Typography.BodyMedium,
									Text = v45.userIsPlayingExperience
								})
							}) else React.createElement(View, {
								tag = "row align-x-center align-y-center size-full"
							}, {
								ExperienceText = React.createElement(FoundationText, {
									tag = "shrink auto-xy text-align-x-center content-emphasis",
									LayoutOrder = 1,
									RichText = true,
									fontStyle = v30.Typography.TitleMedium,
									Text = t1.experienceName,
									TextTruncate = Enum.TextTruncate.AtEnd
								})
							})
						}),
						Buttons = React.createElement(View, {
							tag = "col gap-small size-full-0 auto-y",
							LayoutOrder = 3
						}, {
							PrimaryButton = if not v44 then React.createElement(Button, {
								LayoutOrder = 1,
								text = v45.join,
								onActivated = t1.onJoin,
								variant = ButtonVariant.Emphasis,
								inputSize = InputSize.Medium,
								isLoading = t1.isLoading,
								isDisabled = not t1.isInExperience,
								width = UDim.new(1, 0)
							}) else React.createElement(AgeCheckUpsellCTA, {
								LayoutOrder = 1,
								onUnlockPressed = t1.onAgeCheckPressed or function() -- line: 242
								end
							}),
							ChatButton = if not t1.canUsePlatformChat then nil else React.createElement(Button, {
								LayoutOrder = 2,
								text = if not v27 then v45.chat else v45.chatWithName,
								onActivated = t1.onChat,
								variant = ButtonVariant.Standard,
								inputSize = InputSize.Medium,
								width = UDim.new(1, 0)
							}),
							SecondaryButton = React.createElement(Button, {
								LayoutOrder = 3,
								text = v45.viewProfile,
								onActivated = v40,
								variant = ButtonVariant.Utility,
								inputSize = InputSize.Medium,
								width = UDim.new(1, 0)
							})
						})
					})
				})
			})
		})
	})
end

return MobileGameJoinCard
