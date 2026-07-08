local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local Foundation = require(GameTileParent.Foundation)
local Responsive = require(GameTileParent.Responsive)
local IconButton = Foundation.IconButton
local FoundationImage = Foundation.Image
local ButtonSize = Foundation.Enums.ButtonSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local PlayButton = require(GameTileParent.GamePlayButton).PlayButton
local useLocalization = require(GameTileParent.Localization).Hooks.useLocalization
local OmniRecommendationsContentType = require(GameTileParent.DiscoveryTypes).OmniRecommendationsContentType
local useIsHoveredTile = require(GameTile.useIsHoveredTile)
local useValidTileBadges = require(GameTile.Overlays.useValidTileBadges)
local GameTileThumbnailBadges = require(GameTile.Overlays.GameTileThumbnailBadges)

require(GameTile.GameTileTypes)

local v19 = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentLandscape", 40)
local v20 = game:DefineFastInt("LuaAppOneByTwoTileLogoWidthPercentSquare", 25)
local v21 = v19 / 100
local v22 = v20 / 100

local function noop() -- line: 50
end
local function OneByTwoTile(t1: {[any]: any}) -- line: 52
	-- upvalues: useTokens (copy), Responsive (copy), React (copy), useIsHoveredTile (copy), useValidTileBadges (copy), useLocalization (copy), OmniRecommendationsContentType (copy), v21 (copy), v22 (copy), ButtonSize (copy), FoundationImage (copy), GameTileThumbnailBadges (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), noop (copy), PlayButton (copy)
	local v26 = useTokens()
	local v27 = Responsive.useResponsive({ Responsive.BreakpointConfig.sizes.Small }) == Responsive.Keys.Small
	local v28 = React.useRef(nil)
	local v29 = `OneByTwoTile_{ t1.layoutOrder or 0 }`
	local v30 = useIsHoveredTile(v28, v29, true)
	local v31 = useValidTileBadges(t1.universeId or "", t1.topicId, t1.badgeOverride)
	local v32 = useLocalization({
		joinButtonText = "Common.VisitGame.Label.Play",
		learnButtonText = "CommonUI.Features.Label.Learn"
	})
	local v33 = t1.contentType == OmniRecommendationsContentType.AdLink
	local v34 = if not v33 then v32.joinButtonText else v32.learnButtonText
	local num = tonumber(t1.logoAspectRatio)
	local v36 = (not num or not (num > 0)) and 1 or num
	local v37 = if v36 ~= 3 then v22 else v21
	local Medium, TitleLarge, BodySmall, XXSmall, Small, Size_800, TitleSmall

	if v27 then
		Medium = v26.Padding.Medium
		TitleLarge = v26.Typography.TitleLarge
		BodySmall = v26.Typography.BodySmall
		XXSmall = v26.Gap.XXSmall
		Small = ButtonSize.Small
		Size_800 = v26.Size.Size_800
		TitleSmall = v26.Typography.TitleSmall
	else
		Medium = v26.Padding.Large
		TitleLarge = v26.Typography.HeadingMedium
		BodySmall = v26.Typography.BodyMedium
		XXSmall = v26.Gap.XSmall
		Small = ButtonSize.Medium
		Size_800 = v26.Size.Size_1000
		TitleSmall = v26.Typography.TitleMedium
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		ZIndex = t1.zIndex
	}, {
		Container = React.createElement("Frame", {
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ref = v28,
			Size = t1.size or UDim2.fromScale(1, 1),
			BackgroundColor3 = v26.Color.Surface.Surface_100.Color3
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v26.Radius.Medium)
			}),
			Thumbnail = if not t1.primaryImageAssetId then nil else React.createElement(FoundationImage, {
				ZIndex = 1,
				Image = `rbxassetid://{ t1.primaryImageAssetId }`,
				Size = UDim2.fromScale(1, 1),
				ScaleType = Enum.ScaleType.Crop
			}),
			TileBadge = if not v31 then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromScale(1, 1)
			}, {
				Badge = React.createElement(GameTileThumbnailBadges, {
					tileBadgesByPosition = v31
				})
			}),
			Logo = if not t1.logoImageAssetId then nil else React.createElement(FoundationImage, {
				ZIndex = 2,
				Image = `rbxassetid://{ t1.logoImageAssetId }`,
				Position = UDim2.new(1, -v26.Padding.Medium, 0, v26.Padding.Medium),
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(v37, 0, 1, 0),
				aspectRatio = v36
			}),
			OverflowMenuButton = if not v30 then nil else React.createElement(IconButton, {
				isCircular = true,
				ZIndex = 4,
				icon = IconName.ThreeDotsHorizontal,
				size = InputSize.Small,
				variant = ButtonVariant.Utility,
				onActivated = noop,
				Position = UDim2.new(1, -v26.Padding.Medium, 0, v26.Padding.Medium),
				AnchorPoint = Vector2.new(1, 0)
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
						TextColor3 = v26.LightMode.ActionOverMedia.Foreground.Color3,
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
						TextColor3 = v26.LightMode.ActionOverMedia.Foreground.Color3,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top
					})
				}),
				CtaButton = if not v33 then if not t1.universeId then nil else React.createElement(PlayButton, {
					LayoutOrder = 2,
					eventContext = "OneByTwoTile",
					launchSource = "OneByTwoTile",
					hidePlayableIcon = true,
					universeId = t1.universeId,
					placeId = if not t1.placeIdOverride then t1.placeId else t1.placeIdOverride,
					referralSource = t1.referralSource,
					playableText = v34,
					buttonSize = Small,
					reportExperienceLaunched = t1.reportExperienceLaunched,
					experienceJoinData = if not t1.launchDataOverride then nil else {
						launchData = t1.launchDataOverride
					}
				}) else React.createElement("TextButton", {
					LayoutOrder = 2,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(0, Size_800),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = v26.Color.Extended.White.White_20.Color3,
					BackgroundTransparency = v26.Color.Extended.White.White_20.Transparency,
					Text = v34,
					TextColor3 = v26.LightMode.ActionOverMedia.Foreground.Color3,
					Font = TitleSmall.Font,
					TextSize = TitleSmall.FontSize
				}, {
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, v26.Radius.Medium)
					}),
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v26.Padding.Large),
						PaddingRight = UDim.new(0, v26.Padding.Large)
					})
				})
			})
		})
	})
end

return React.memo(OneByTwoTile)
