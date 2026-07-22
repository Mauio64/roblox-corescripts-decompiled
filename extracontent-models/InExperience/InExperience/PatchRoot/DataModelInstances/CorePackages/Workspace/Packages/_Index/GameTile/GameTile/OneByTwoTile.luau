local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local Foundation = require(GameTileParent.Foundation)
local Responsive = require(GameTileParent.Responsive)
local IconButton = Foundation.IconButton
local FoundationImage = Foundation.Image
local View = Foundation.View
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local PlayButton = require(GameTileParent.GamePlayButton).PlayButton
local useLocalization = require(GameTileParent.Localization).Hooks.useLocalization
local OmniRecommendationsContentType = require(GameTileParent.DiscoveryTypes).OmniRecommendationsContentType
local useNavigation = require(GameTileParent.Navigation).useNavigation
local AppPage = require(GameTileParent.RobloxAppEnums).AppPage
local FFlagLuaAppDemoModePlayButton = require(GameTileParent.SharedFlags).FFlagLuaAppDemoModePlayButton

require(GameTileParent.VideoUtils)

local useIsHoveredTile = require(GameTile.useIsHoveredTile)
local useValidTileBadges = require(GameTile.Overlays.useValidTileBadges)
local GameTileThumbnailBadges = require(GameTile.Overlays.GameTileThumbnailBadges)

require(GameTile.GameTileTypes)

local v23 = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentLandscape", 40)
local v24 = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentSquare", 25)
local v25 = v23 / 100
local v26 = v24 / 100

local function noop() -- line: 59
end
local function OneByTwoTile(t1: {[any]: any}) -- line: 61
	-- upvalues: useTokens (copy), Responsive (copy), React (copy), useIsHoveredTile (copy), useNavigation (copy), AppPage (copy), useValidTileBadges (copy), useLocalization (copy), OmniRecommendationsContentType (copy), v25 (copy), v26 (copy), ButtonSize (copy), FoundationImage (copy), GameTileThumbnailBadges (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), noop (copy), PlayButton (copy), FFlagLuaAppDemoModePlayButton (copy)
	local v30 = useTokens()
	local v31 = Responsive.useResponsive({ Responsive.BreakpointConfig.sizes.Small }) == Responsive.Keys.Small
	local v32 = React.useRef(nil)
	local v33 = `OneByTwoTile_{ t1.layoutOrder or 0 }`
	local v34 = useIsHoveredTile(v32, v33, true)
	local v35 = useNavigation()
	local v36 = React.useCallback(function() -- line: 74
		-- upvalues: v35 (copy), AppPage (copy), t1 (copy)
		v35.navigate(AppPage.FeatureTileAdPlayer, {
			extraProps = {
				videoAssetId = t1.primaryVideoAssetId,
				imageAssetId = t1.primaryImageAssetId,
				videoPlaybackContext = t1.videoPlaybackContext
			}
		})
	end, {
		v35,
		t1.primaryVideoAssetId,
		t1.primaryImageAssetId,
		t1.videoPlaybackContext
	})
	local v37 = useValidTileBadges(t1.universeId or "", t1.topicId, t1.badgeOverride)
	local v38 = useLocalization({
		joinButtonText = "Common.VisitGame.Label.Play",
		learnButtonText = "CommonUI.Features.Label.Learn"
	})
	local v39 = t1.contentType == OmniRecommendationsContentType.AdLink
	local v40 = if not v39 then v38.joinButtonText else v38.learnButtonText
	local num = tonumber(t1.logoAspectRatio)
	local v42 = (not num or not (num > 0)) and 1 or num
	local v43 = if v42 ~= 3 then v26 else v25
	local Medium, TitleLarge, BodySmall, XXSmall, Small, Size_800, TitleSmall

	if v31 then
		Medium = v30.Padding.Medium
		TitleLarge = v30.Typography.TitleLarge
		BodySmall = v30.Typography.BodySmall
		XXSmall = v30.Gap.XXSmall
		Small = ButtonSize.Small
		Size_800 = v30.Size.Size_800
		TitleSmall = v30.Typography.TitleSmall
	else
		Medium = v30.Padding.Large
		TitleLarge = v30.Typography.HeadingMedium
		BodySmall = v30.Typography.BodyMedium
		XXSmall = v30.Gap.XSmall
		Small = ButtonSize.Medium
		Size_800 = v30.Size.Size_1000
		TitleSmall = v30.Typography.TitleMedium
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		ZIndex = t1.zIndex
	}, {
		Container = React.createElement("TextButton", {
			ref = v32,
			Size = t1.size or UDim2.fromScale(1, 1),
			BackgroundColor3 = v30.Color.Surface.Surface_100.Color3,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Text = "",
			AutoButtonColor = false,
			[React.Event.Activated] = v36
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v30.Radius.Medium)
			}),
			Thumbnail = React.createElement(FoundationImage, {
				ZIndex = 1,
				Image = `rbxassetid://{ t1.primaryImageAssetId }`,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop,
				cornerRadius = UDim.new(0, v30.Radius.Medium)
			}),
			TileBadge = if not v37 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = v37
				})
			}),
			Logo = if not t1.logoImageAssetId then nil else React.createElement(FoundationImage, {
				ZIndex = 2,
				Image = `rbxassetid://{ t1.logoImageAssetId }`,
				Position = UDim2.new(1, -v30.Padding.Medium, 0, v30.Padding.Medium),
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(v43, 0, 1, 0),
				aspectRatio = v42
			}),
			OverflowMenuButton = if not v34 then nil else React.createElement(View, {
				tag = "auto-xy bg-over-media-0 radius-circle",
				ZIndex = 4,
				Position = UDim2.new(1, -v30.Padding.Medium, 0, v30.Padding.Medium),
				AnchorPoint = Vector2.new(1, 0)
			}, {
				Button = React.createElement(IconButton, {
					isCircular = true,
					icon = IconName.ThreeDotsHorizontal,
					size = InputSize.Small,
					variant = ButtonVariant.Utility,
					onActivated = noop
				})
			}),
			BottomStack = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 2,
				Size = UDim2.new(1, -2 * Medium, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = UDim2.new(0, Medium, 1, -Medium),
				AnchorPoint = Vector2.new(0, 1)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, Medium)
				}),
				TextStack = React.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						Padding = UDim.new(0, XXSmall)
					}),
					Headline = if not t1.headline then nil else React.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = t1.headline,
						Font = TitleLarge.Font,
						TextSize = TitleLarge.FontSize,
						TextColor3 = v30.LightMode.ActionOverMedia.Foreground.Color3,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					}),
					Subtitle = if not t1.subtitle then nil else React.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Text = t1.subtitle,
						Font = BodySmall.Font,
						TextSize = BodySmall.FontSize,
						TextColor3 = v30.LightMode.ActionOverMedia.Foreground.Color3,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					})
				}),
				CtaButton = if not v39 then if not t1.universeId then nil else React.createElement(PlayButton, {
					LayoutOrder = 2,
					eventContext = "OneByTwoTile",
					launchSource = "OneByTwoTile",
					hidePlayableIcon = true,
					universeId = t1.universeId,
					placeId = if not t1.placeIdOverride then t1.placeId else t1.placeIdOverride,
					referralSource = t1.referralSource,
					playableText = v40,
					buttonSize = Small,
					preferSecondaryPlayButton = not not FFlagLuaAppDemoModePlayButton or nil,
					reportExperienceLaunched = t1.reportExperienceLaunched,
					experienceJoinData = if not t1.launchDataOverride then nil else {
						launchData = t1.launchDataOverride
					}
				}) else React.createElement("TextButton", {
					LayoutOrder = 2,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(0, Size_800),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = v30.Color.Extended.White.White_20.Color3,
					BackgroundTransparency = v30.Color.Extended.White.White_20.Transparency,
					Text = v40,
					TextColor3 = v30.LightMode.ActionOverMedia.Foreground.Color3,
					Font = TitleSmall.Font,
					TextSize = TitleSmall.FontSize
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v30.Radius.Medium)
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v30.Padding.Large),
						PaddingRight = UDim.new(0, v30.Padding.Large)
					})
				})
			})
		})
	})
end

return React.memo(OneByTwoTile)
