local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local memoize = require(ParentParentParent.AppCommonLib).memoize
local Images = require(ParentParentParent.UIBlox).App.ImageSet.Images
local Foundation = require(ParentParentParent.Foundation)
local FFlagPlayerListFoundationSubscriptionIcon = require(ParentParent.Flags.FFlagPlayerListFoundationSubscriptionIcon)

return (memoize(function(p1, p2) -- line: 165
	-- upvalues: Images (copy), FFlagPlayerListFoundationSubscriptionIcon (copy), Foundation (copy)
	local t1 = {
		IsTenFoot = p1
	}

	if p1 then
		t1.ContainerPosition = UDim2.new(0.5, 0, 0.5, 0)
		t1.ContainerSize = UDim2.new(0, 350, 0, 720)
		t1.AnchorPoint = Vector2.new(0.5, 0.5)
		t1.PlayerDropDownSizeX = 0
		t1.PlayerScrollListPosition = UDim2.new(0, 0, 0, 105)
		t1.PlayerScrollListSize = UDim2.new(1, 19, 1, 0)
		t1.PlayerScrollListInnerFramePosition = UDim2.new(0, 0, 0, 0)
		t1.PlayerScrollListInnerFrameSize = UDim2.new(1, 0, 1, 0)
		t1.EntrySizeX = 350
		t1.PlayerEntrySizeY = 100
		t1.EntryPadding = 5
		t1.TeamEntrySizeY = 32
		t1.StatEntrySizeX = 250
		t1.EntryXOffset = -20
		t1.BackgroundStyle = {
			Selected = nil,
			Default = {
				Transparency = 0.25,
				Color = Color3.fromRGB(60, 60, 60)
			},
			Hovered = {
				Transparency = 0.25,
				Color = Color3.fromRGB(50, 181, 255)
			},
			HoveredTitle = {
				Transparency = 0,
				Color = Color3.fromRGB(50, 181, 255)
			},
			Title = {
				Transparency = 0,
				Color = Color3.fromRGB(25, 25, 25)
			}
		}
		t1.TeamEntryBackgroundTransparency = 0.25
		t1.DefaultTextStyle = {
			Transparency = 0,
			StrokeTransparency = 0.75,
			Color = Color3.fromRGB(255, 255, 243),
			StrokeColor = Color3.fromRGB(34, 34, 34)
		}
		t1.HoveredTextStyle = {
			Transparency = 0,
			StrokeTransparency = 0.75,
			Color = Color3.fromRGB(19, 19, 19),
			StrokeColor = Color3.fromRGB(34, 34, 34)
		}
		t1.PlayerIconSize = UDim2.new(0, 64, 0, 64)
		t1.InitalPlayerEntryPadding = 18
		t1.PlayerEntryPadding = 8
		t1.PlayerEntryNamePadding = 8
		t1.TeamEntryTextPadding = 5
		t1.StatTextPadding = 0
		t1.PlayerNameSize = UDim2.new(1, -88, 1, 0)
		t1.PlayerNameTextSize = 32
		t1.StatTextSize = 32
		t1.ScrollImageColor = Color3.fromRGB(31, 31, 31)
		t1.ScrollImageTransparency = 0.5
	else
		t1.ContainerPadding = 4
		t1.ContainerPosition = UDim2.new(1, -4, 0, 4)
		t1.ContainerSize = UDim2.new(0, 0, 0.5, 0)
		t1.ExtraContainerPadding = 16
		t1.AnchorPoint = Vector2.new(1, 0)
		t1.PlayerDropDownSizeX = 300
		t1.PlayerDropDownOffset = 4
		t1.PlayerScrollListPosition = UDim2.new(0, 0, 0, 0)
		t1.PlayerScrollListSize = UDim2.new(1, -1, 1, 0)
		t1.EntryBaseSizeX = 150
		t1.EntrySizeIncreasePerStat = 11
		t1.PlayerEntrySizeY = 40
		t1.EntryPadding = 0
		t1.TeamEntrySizeY = 24
		t1.StatEntrySizeX = 66
		t1.TitleBarSizeY = 20
		t1.EntryXOffset = 0
		t1.TeamEntryBackgroundTransparency = 0.5
		t1.IconButtonBackgroundTransparency = 0.3
		t1.DropDownHeaderBackgroundTransparency = 0.1
		t1.OverrideBackgroundTransparency = 0.3
		t1.FadedBackgroundTransparency = 0.65
		t1.FadedBackgroundScaleDelta = 0.05
		t1.PlayerIconSize = UDim2.new(0, 16, 0, 16)
		t1.InitalPlayerEntryPadding = 12
		t1.PlayerEntryPadding = 12
		t1.PlayerEntryNamePadding = 4
		t1.TeamEntryTextPadding = 15
		t1.StatTextPadding = 4
		t1.PlayerNameSize = UDim2.new(1, -34, 1, 0)
		t1.PlayerNameTextSize = 14
		t1.StatTextSize = 14
		t1.ScrollImageColor = Color3.fromRGB(216, 216, 216)
		t1.ScrollImageTransparency = 0.5
		t1.ScrollBarOffset = 4
		t1.ScrollBarSize = 8
	end

	t1.TopBarOffset = p2.TopBarHeight
	t1.PlayerDropDownSizeXMobile = 327
	t1.ScrollBarSizeMobile = 2
	t1.PlayerNameSizeXMobile = 194
	t1.PlayerIconSizeMobile = UDim2.fromOffset(20, 20)
	t1.PlayerNameTextSizeMobile = 16
	t1.StatTextSizeMobile = 16
	t1.PlayerNamePaddingXMobile = 14
	t1.TeamEntryTextPadding = 15
	t1.TeamEntryTextPaddingMobile = 14
	t1.RowHoverColor = Color3.fromRGB(0, 0, 0)
	t1.RowDefaultColor = Color3.fromRGB(84, 84, 84)
	t1.MaxLeaderstats = 4
	t1.MaxLeaderstatsSmallScreen = 1
	t1.PlayerEntryFont = Enum.Font.SourceSans
	t1.TitlePlayerEntryFont = Enum.Font.SourceSansBold
	t1.TeamEntryFont = Enum.Font.SourceSans
	t1.StatFont = Enum.Font.SourceSans
	t1.TitleStatFont = Enum.Font.SourceSansBold
	t1.TeamStatFont = Enum.Font.SourceSansBold
	t1.StatNameFont = Enum.Font.SourceSans
	t1.PlayerIconBackgroundSize = UDim2.new(0, 66, 0, 66)
	t1.PlayerBackgroundImage = "rbxasset://textures/ui/PlayerList/CharacterImageBackground.png"
	t1.RobloxIconImage = "rbxasset://textures/ui/Shell/Icons/RobloxIcon24.png"
	t1.IconSelectedColor = Color3.fromRGB(19, 19, 19)
	t1.IconUnSelectedColor = Color3.fromRGB(255, 255, 255)
	t1.SelectedEntryColor = Color3.fromRGB(0, 255, 255)
	t1.ShadowImage = "rbxasset://textures/ui/PlayerList/TileShadowMissingTop.png"
	t1.ShadowSize = 5
	t1.ShadowSliceRect = Rect.new(6, 6, 9, 9)
	t1.DefaultThumbnail = "rbxasset://textures/ui/Shell/Icons/DefaultProfileIcon.png"
	t1.BlockedIcon = Images["icons/status/unavailable_small"]
	t1.FriendIcons = {
		[Enum.FriendStatus.Friend] = Images["icons/status/player/friend"],
		[Enum.FriendStatus.FriendRequestReceived] = Images["icons/status/player/pending"]
	}
	t1.FollowingIcon = Images["icons/status/player/following"]
	t1.PlaceOwnerIcon = Images["icons/status/player/developer"]
	t1.MembershipIcons = {
		[Enum.MembershipType.Premium] = Images["icons/status/premium_small"]
	}

	if FFlagPlayerListFoundationSubscriptionIcon then
		t1.SubscriptionIcon = {
			isFoundationIcon = true,
			name = Foundation.Enums.IconName.RobloxPlus
		}
	else
		t1.SubscriptionIcon = Images["icons/menu/gem_small"]
	end

	t1.CustomPlayerIcons = {
		[7210880] = "rbxassetid://134032333",
		[13268404] = "rbxassetid://113059239",
		[261] = "rbxassetid://105897927"
	}
	t1.NeutralTeamColor = BrickColor.new("White")
	t1.NeutralTeamName = "Neutral"
	t1.DropDownButtonSizeY = 56
	t1.DropDownButtonPadding = 0
	t1.DropDownPadding = 10
	t1.DropDownRightOptionSize = 55
	t1.DropDownIconSize = 36
	t1.DropDownHeaderSizeY = 80
	t1.DropDownHeaderBackgroundSize = 65
	t1.DropDownScreenSidePadding = 4

	return t1
end))
