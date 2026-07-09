local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ExperienceTileV3 = UIBlox.App.Tile.ExperienceTileV3
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getCurrentPage = require(Modules.LuaApp.getCurrentPage)
local AspectRatioModeEnum = UIBlox.App.Tile.AspectRatioModeEnum
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local LoadableImage = UIBlox.App.Loading.LoadableImage
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local AppSessionService = require(CorePackages.Workspace.Packages.RoactServiceTags).AppSessionService
local SetGamePlaySession = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SetGamePlaySession
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagSignalsNavP3hMisc = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3hMisc
local v25 = if not FFlagSignalsNavP3hMisc then nil else require(CorePackages.Workspace.Packages.NavigationRodux).GetLegacyNavigationStore
local useImpressionsTagger = require(CorePackages.Workspace.Packages.Impressions).useImpressionsTagger
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local joinGame = require(Modules.LuaApp.Util.joinGame)
local joinGameInPlacesList = require(Modules.LuaApp.Analytics.Events.joinGameInPlacesList)
local SessionType = require(CorePackages.Workspace.Packages.RobloxAppSessionization).SessionType
local GameTileConstants = require(CorePackages.Workspace.Packages.GameTile).GameTileConstants

local function reportProfilePeekOpen(p1, p2, p3) -- line: 52
	p3:sendEventDeferred(p1, "joinYourFriendProfileViewOpen", {
		friendId = p2.friendUserId,
		universeId = p2.universeId,
		rootPlaceId = p2.rootPlaceId
	})
end
local function createJoinButtonOverlay(p4, p5, p6, p7, p8, p9, p10) -- line: 63
	-- upvalues: React (copy), Button (copy), ButtonType (copy), GameTileConstants (copy), StandardButtonSize (copy), SetGamePlaySession (copy), SessionType (copy), joinGameInPlacesList (copy), joinGame (copy)
	local p10X = p10.X

	return React.createElement(Button, {
		fitContent = true,
		isDisabled = false,
		isLoading = false,
		buttonType = ButtonType.PrimaryContextual,
		position = GameTileConstants.TileOverlay.BottomRightPosition,
		anchorPoint = Vector2.new(1, 1),
		text = p5,
		fontStyle = p6.Font.CaptionHeader,
		standardSize = StandardButtonSize.XSmall,
		maxWidth = p10X * 0.92,
		onActivated = function() -- line: 77
			-- upvalues: SetGamePlaySession (copy), p9 (copy), SessionType (copy), joinGameInPlacesList (copy), p8 (copy), p4 (copy), p7 (copy), joinGame (copy)
			SetGamePlaySession(p9, SessionType.StructuralIdentifier.GamePlayFromJoinYourFriends, true)
			joinGameInPlacesList(p8, p4, p7, tonumber(p7), nil, nil, "JoinYourFriends")
			joinGame:ByUserAndPlaceId({
				id = p4
			}, p7, "JoinYourFriends")
		end
	})
end
local function v35(p11, p12, p13) -- line: 97
	-- upvalues: React (copy), LoadableImage (copy)
	return React.createElement(LoadableImage, {
		BackgroundTransparency = 1,
		ImageTransparency = p12,
		Image = p11,
		Position = UDim2.fromScale(0, 0),
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Fit,
		cornerRadius = if not p13 then nil else p13.CornerRadius
	})
end
local function getAvatarForUser(s1: string) -- line: 109
	if s1 then
		return "rbxthumb://type=AvatarBust&id=" .. s1 .. "&w=150&h=150"
	end

	return ""
end
local function getThumbnailAsset(s2: string) -- line: 117
	if s2 then
		return "rbxthumb://type=Asset&id=" .. s2 .. "&w=420&h=420"
	end

	return ""
end
local function getTextForBottomContent(p14, p15, p16, p17, p18, vector2: Vector2) -- line: 125
	-- upvalues: React (copy), StyledTextLabel (copy)
	local v64 = vector2.X - p18.Leading - p18.Trailing

	return React.createElement(StyledTextLabel, {
		lineHeight = 1,
		fluidSizing = false,
		richText = false,
		text = p14,
		size = UDim2.new(0, v64, 0, 20),
		automaticSize = Enum.AutomaticSize.X,
		fontStyle = p15,
		colorStyle = p16,
		textTruncate = Enum.TextTruncate.AtEnd,
		layoutOrder = p17
	})
end
local function getUsernameWithPresenceIcon(p19, p20, p21) -- line: 142
	-- upvalues: React (copy), ImageSetLabel (copy), Images (copy), getTextForBottomContent (copy)
	local Spacing = p20.Tokens.Component.VerticalTile.Base.ContentBottom.Spacing

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		PresenceIcon = React.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Visible = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = Images["component_assets/circle_25"],
			ImageColor3 = p20.Theme.OnlineStatus.Color,
			ImageTransparency = p20.Theme.OnlineStatus.Transparency,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(0, 12, 0, 12),
			ScaleType = Enum.ScaleType.Slice
		}),
		FriendName = getTextForBottomContent(p19, p20.Font.Header2, p20.Theme.TextEmphasis, 2, Spacing, p21)
	})
end
local function getStyleProps(p22) -- line: 180
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	local Spacing = p22.Tokens.Component.VerticalTile.Base.ContentTop.Spacing
	local Spacing2 = p22.Tokens.Component.VerticalTile.Base.ContentBottom.Spacing

	return {
		contentTitlePadding = 8,
		backgroundColor = {
			Transparency = 0,
			Color = p22.Theme.BackgroundUIDefault.Color
		},
		dropShadow = {},
		overlayColors = {},
		contentTitleFont = p22.Font.Header2,
		border = {
			BorderColor = {
				Color = ((if not FFlagRenameDeprecatedUIBloxTokens then p22.Tokens.Component.VerticalTile.Base.Container.BorderColor else p22.Tokens.Color.Stroke.Emphasis)).Color3,
				Transparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p22.Tokens.Component.VerticalTile.Base.Container.BorderColor else p22.Tokens.Color.Stroke.Emphasis)).Transparency
			},
			CornerRadius = UDim.new(0, 12),
			Width = if not FFlagRenameDeprecatedUIBloxTokens then p22.Tokens.Component.VerticalTile.Base.Container.BorderWidth else p22.Tokens.Stroke.Standard
		},
		topContentPadding = {
			Left = Spacing.Leading,
			Right = Spacing.Trailing,
			Top = Spacing.Top,
			Bottom = Spacing.Bottom
		},
		bottomContentPadding = {
			Left = 0,
			Top = 3,
			Right = Spacing2.Trailing,
			Bottom = Spacing2.Bottom
		},
		selectionCursorPadding = {
			Left = 0,
			Right = 0,
			Top = 0,
			Bottom = 0
		}
	}
end
local function JoinYourFriendsTile(t1: {[any]: any}) -- line: 228
	-- upvalues: useSelector (copy), useDispatch (copy), FFlagSignalsNavP3hMisc (copy), v25 (copy), useSignalState (copy), getCurrentPage (copy), useRoactService (copy), AppEventIngestService (copy), AppSessionService (copy), useStyle (copy), React (copy), getUsernameWithPresenceIcon (copy), getTextForBottomContent (copy), useLocalization (copy), useImpressionsTagger (copy), ExperienceTileV3 (copy), AspectRatioModeEnum (copy), v35 (copy), createJoinButtonOverlay (copy), OpenProfilePeekView (copy), getStyleProps (copy)
	local friendUserId = t1.friendUserId
	local thumbnailAssetId = t1.thumbnailAssetId
	local experienceName = t1.experienceName
	local v76 = useSelector(function(p23) -- line: 233
		-- upvalues: friendUserId (copy)
		return p23.Users[friendUserId]
	end)
	local v77 = useDispatch()
	local name

	if FFlagSignalsNavP3hMisc then
		local v78 = v25(false)

		name = useSignalState(v78.getCurrentPage).name
	else
		name = useSelector(function(p24) -- line: 244
			-- upvalues: getCurrentPage (copy)
			return getCurrentPage(p24)
		end)
	end

	local v80 = useRoactService(AppEventIngestService)
	local v81 = useRoactService(AppSessionService)
	local v82 = useStyle()
	local Spacing = v82.Tokens.Component.VerticalTile.Base.ContentBottom.Spacing
	local v84 = t1.size or Vector2.new(0, 0)
	local v85 = useLocalization({
		joinButtonText = "Feature.Home.Button.Join"
	})
	local v86 = React.createRef()

	useImpressionsTagger(v86, t1.impressionsTag, t1.LayoutOrder)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, v84.X, 0, v84.Y),
		LayoutOrder = t1.LayoutOrder,
		ref = v86
	}, {
		Tile = React.createElement(ExperienceTileV3, {
			hasBackground = false,
			hasOutline = false,
			isActive = true,
			isHoverEnabled = false,
			isExperienceActionRowEnabled = true,
			contentTextLineCount = 1,
			contentTitlePadding = 0,
			tileWidth = v84.X,
			thumbnailAspectRatioOverride = AspectRatioModeEnum.Wide,
			renderTopContentOverlay = function(_, p26) -- line: 307
				-- upvalues: v35 (copy), friendUserId (copy), createJoinButtonOverlay (copy), v85 (copy), v82 (copy), t1 (copy), v80 (copy), v81 (copy), v84 (copy)
				local t2 = {
					gradient = v35("rbxassetid://13074142871", 0.3, p26)
				}
				local v92 = v35
				local v93 = friendUserId

				t2.avatar = v92(not v93 and "" or "rbxthumb://type=AvatarBust&id=" .. v93 .. "&w=150&h=150", 0, p26)
				t2.joinButton = createJoinButtonOverlay(friendUserId, v85.joinButtonText, v82, t1.rootPlaceId, v80, v81, v84)

				return t2
			end,
			onActivated = function() -- line: 322
				-- upvalues: name (ref), t1 (copy), v80 (copy), v77 (copy), OpenProfilePeekView (copy), friendUserId (copy)
				local v94 = name
				local v95 = t1

				v80:sendEventDeferred(v94, "joinYourFriendProfileViewOpen", {
					friendId = v95.friendUserId,
					universeId = v95.universeId,
					rootPlaceId = v95.rootPlaceId
				})
				v77(OpenProfilePeekView(friendUserId, {
					source = "JoinYourFriends"
				}))
			end,
			wideThumbnail = not thumbnailAssetId and "" or "rbxthumb://type=Asset&id=" .. thumbnailAssetId .. "&w=420&h=420",
			renderBottomContent = function() -- line: 257
				-- upvalues: React (copy), getUsernameWithPresenceIcon (copy), v76 (copy), v82 (copy), v84 (copy), getTextForBottomContent (copy), experienceName (copy), Spacing (copy)
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0)
				}, {
					ListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 2)
					}),
					Title = getUsernameWithPresenceIcon(not v76 and "" or v76.displayName, v82, v84),
					Padding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 4)
					}),
					SubTitle = getTextForBottomContent(experienceName, v82.Font.CaptionHeader, v82.Theme.TextDefault, 2, Spacing, v84)
				})
			end,
			styleProps = getStyleProps(v82)
		})
	})
end

return JoinYourFriendsTile
