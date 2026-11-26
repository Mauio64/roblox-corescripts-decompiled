local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)

local experienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local module = require("@luauforge/bundled/fyF")
local aspectRatioModeEnum = UIBlox.App.Tile.AspectRatioModeEnum
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local loadableImage = UIBlox.App.Loading.LoadableImage
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local module2 = require("@luauforge/bundled/ecr")
local appSessionService = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").AppSessionService
local setGamePlaySession = require("@luauforge/bundled/fwa").SetGamePlaySession
local module3 = require("@luauforge/bundled/eie")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local fFlagSignalsNavP3fGameDetails = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3fGameDetails
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local useImpressionsTagger = require("@luauforge/bundled/egA").useImpressionsTagger
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module4 = require("@luauforge/bundled/ehA")
local module5 = require("@luauforge/bundled/ehY")
local module6 = require("@luauforge/bundled/iqw")
local sessionType = require("@luauforge/bundled/fwa").SessionType
local gameTileConstants = require("@luauforge/bundled/gDC").GameTileConstants

local function reportProfilePeekOpen(p2, data, object)
	object:sendEventDeferred(p2, "joinYourFriendProfileViewOpen", {
		friendId = data.friendUserId,
		universeId = data.universeId,
		rootPlaceId = data.rootPlaceId
	})
end

local function createJoinButtonOverlay(friendUserId, joinButtonText, p2, rootPlaceId, p3, p4, size)
	local x = size.X

	return React.createElement(button, {
		buttonType = buttonType.PrimaryContextual,
		position = gameTileConstants.TileOverlay.BottomRightPosition,
		anchorPoint = Vector2.new(1, 1),
		text = joinButtonText,
		fontStyle = p2.Font.CaptionHeader,
		fitContent = true,
		standardSize = standardButtonSize.XSmall,
		maxWidth = x * 0.92,
		isDisabled = false,
		isLoading = false,
		onActivated = function()
			setGamePlaySession(p4, sessionType.StructuralIdentifier.GamePlayFromJoinYourFriends, true)

			module6(p3, friendUserId, rootPlaceId, tonumber(rootPlaceId), nil, nil, "JoinYourFriends")

			module5:ByUserAndPlaceId({ id = friendUserId }, rootPlaceId, "JoinYourFriends")
		end
	})
end

local function fn(p2, p3, p4)
	local createElement = React.createElement
	local v6 = {
		BackgroundTransparency = 1,
		ImageTransparency = p3,
		Image = p2,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Fit,
		cornerRadius = 0
	}
	local v7 = if p4 then p4.CornerRadius else nil
	v6.cornerRadius = v7
	return createElement(loadableImage, v6)
end

local function getAvatarForUser(p2)
	if p2 then
		return "rbxthumb://type=AvatarBust&id=" .. p2 .. "&w=150&h=150"
	end

	return ""
end

local function getThumbnailAsset(p2)
	if p2 then
		return "rbxthumb://type=Asset&id=" .. p2 .. "&w=420&h=420"
	end

	return ""
end

local function getTextForBottomContent(p2, p3, p4, p5, p6, p7)
	local v5 = p7.X - p6.Leading - p6.Trailing

	return React.createElement(styledTextLabel, {
		text = p2,
		size = UDim2.new(0, v5, 0, 20),
		automaticSize = Enum.AutomaticSize.X,
		fontStyle = p3,
		colorStyle = p4,
		textTruncate = Enum.TextTruncate.AtEnd,
		lineHeight = 1,
		fluidSizing = false,
		layoutOrder = p5,
		richText = false
	})
end

local function getUsernameWithPresenceIcon(p2, props, size)
	local v5 = {
		Top = props.Tokens.Padding.Small,
		Bottom = props.Tokens.Padding.Small,
		Leading = props.Tokens.Padding.Small,
		Trailing = props.Tokens.Padding.Small
	}

	return React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			LayoutOrder = 1
		},
		{
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			PresenceIcon = React.createElement(imageSetLabel, {
				LayoutOrder = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = images["component_assets/circle_25"],
				ImageColor3 = props.Theme.OnlineStatus.Color,
				ImageTransparency = props.Theme.OnlineStatus.Transparency,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(0, 12, 0, 12),
				BackgroundTransparency = 1,
				ScaleType = Enum.ScaleType.Slice,
				Visible = true
			}),
			FriendName = getTextForBottomContent(
				p2,
				props.Font.Header2,
				props.Theme.TextEmphasis,
				2,
				v5,
				size
			)
		}
	)
end

local function getStyleProps(data)
	local v5 = {
		Top = data.Tokens.Padding.None,
		Bottom = data.Tokens.Padding.None,
		Leading = data.Tokens.Padding.None,
		Trailing = data.Tokens.Padding.None
	}

	local v6 = {
		Top = data.Tokens.Padding.Small,
		Bottom = data.Tokens.Padding.Small,
		Leading = data.Tokens.Padding.Small,
		Trailing = data.Tokens.Padding.Small
	}

	return {
		backgroundColor = {
			Color = data.Theme.BackgroundUIDefault.Color,
			Transparency = 0
		},
		dropShadow = {},
		overlayColors = {},
		contentTitleFont = data.Font.Header2,
		border = {
			BorderColor = {
				Color = data.Tokens.Color.Stroke.Emphasis.Color3,
				Transparency = data.Tokens.Color.Stroke.Emphasis.Transparency
			},
			CornerRadius = UDim.new(0, 12),
			Width = data.Tokens.Stroke.Standard
		},
		topContentPadding = {
			Left = v5.Leading,
			Right = v5.Trailing,
			Top = v5.Top,
			Bottom = v5.Bottom
		},
		bottomContentPadding = {
			Left = 0,
			Right = v6.Trailing,
			Top = 3,
			Bottom = v6.Bottom
		},
		selectionCursorPadding = { Left = 0, Right = 0, Top = 0, Bottom = 0 },
		contentTitlePadding = 8
	}
end

local function JoinYourFriendsTile(props)
	local friendUserId = props.friendUserId
	local thumbnailAssetId = props.thumbnailAssetId
	local experienceName = props.experienceName

	local v5 = useSelector(function(p2)
		return p2.Users[friendUserId]
	end)
	local v6 = useDispatch()
	local v7

	if fFlagSignalsNavP3fGameDetails then
		v7 = nil
	else
		v7 = useSelector(function(p2)
			return module(p2)
		end)
	end

	local v8 = module3(module2)
	local v9 = module3(appSessionService)

	local v10 = useStyle()
	local v11 = {
		Top = v10.Tokens.Padding.Small,
		Bottom = v10.Tokens.Padding.Small,
		Leading = v10.Tokens.Padding.Small,
		Trailing = v10.Tokens.Padding.Small
	}

	local size = props.size or Vector2.new(0, 0)

	local function fn2()
		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1
			},
			{
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 2)
				}),
				Title = getUsernameWithPresenceIcon(not v5 and "" or v5.displayName, v10, size),
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 4)
				}),
				SubTitle = getTextForBottomContent(
					experienceName,
					v10.Font.CaptionHeader,
					v10.Theme.TextDefault,
					2,
					v11,
					size
				)
			}
		)
	end

	local v12 = useLocalization({ joinButtonText = "Feature.Home.Button.Join" })

	local ref = React.createRef()
	useImpressionsTagger(ref, props.impressionsTag, props.LayoutOrder)
	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(0, size.X, 0, size.Y),
			BackgroundTransparency = 1,
			LayoutOrder = props.LayoutOrder,
			ref = ref
		},
		{
			Tile = React.createElement(experienceTileV3, {
				tileWidth = size.X,
				hasBackground = false,
				hasOutline = false,
				isActive = true,
				isHoverEnabled = false,
				isExperienceActionRowEnabled = true,
				thumbnailAspectRatioOverride = aspectRatioModeEnum.Wide,
				contentTextLineCount = 1,
				contentTitlePadding = 0,
				renderTopContentOverlay = function(p2, p3)
					local topContentOverlay = {
						gradient = fn("rbxassetid://13074142871", 0.3, p3),
						avatar = 0,
						joinButton = 0
					}
					topContentOverlay.avatar = fn(
						not friendUserId and "" or "rbxthumb://type=AvatarBust&id=" .. friendUserId .. "&w=150&h=150",
						0,
						p3
					)
					topContentOverlay.joinButton = createJoinButtonOverlay(
						friendUserId,
						v12.joinButtonText,
						v10,
						props.rootPlaceId,
						v8,
						v9,
						size
					)
					return topContentOverlay
				end,
				onActivated = function()
					local v13

					if fFlagSignalsNavP3fGameDetails then
						v13 = getLegacyNavigationStore(false).getCurrentPageName(false)
					else
						v13 = v7
					end

					local v14 = props
					v8:sendEventDeferred(v13, "joinYourFriendProfileViewOpen", {
						friendId = v14.friendUserId,
						universeId = v14.universeId,
						rootPlaceId = v14.rootPlaceId
					})

					v6(module4(friendUserId, { source = "JoinYourFriends" }))
				end,
				wideThumbnail = not thumbnailAssetId and "" or "rbxthumb://type=Asset&id=" .. thumbnailAssetId .. "&w=420&h=420",
				renderBottomContent = fn2,
				styleProps = getStyleProps(v10)
			})
		}
	)
end

return JoinYourFriendsTile
