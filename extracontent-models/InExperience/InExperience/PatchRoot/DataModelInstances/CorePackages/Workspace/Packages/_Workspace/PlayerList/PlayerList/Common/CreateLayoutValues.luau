local parent = script.Parent.Parent
local parent2 = parent.Parent

local AppCommonLib = require(parent2.AppCommonLib)
local memoize = AppCommonLib.memoize
local UIBlox = require(parent2.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local Foundation = require(parent2.Foundation)

local FFlagPlayerListFoundationSubscriptionIcon = require(parent.Flags.FFlagPlayerListFoundationSubscriptionIcon)

return (memoize(function(isTenFoot, p)
	local v = {}
	v.IsTenFoot = isTenFoot

	if isTenFoot then
		v.ContainerPosition = UDim2.new(0.5, 0, 0.5, 0)
		v.ContainerSize = UDim2.new(0, 350, 0, 720)
		v.AnchorPoint = Vector2.new(0.5, 0.5)

		v.PlayerDropDownSizeX = 0

		v.PlayerScrollListPosition = UDim2.new(0, 0, 0, 105)
		v.PlayerScrollListSize = UDim2.new(1, 19, 1, 0)
		v.PlayerScrollListInnerFramePosition = UDim2.new(0, 0, 0, 0)
		v.PlayerScrollListInnerFrameSize = UDim2.new(1, 0, 1, 0)

		v.EntrySizeX = 350
		v.PlayerEntrySizeY = 100
		v.EntryPadding = 5
		v.TeamEntrySizeY = 32
		v.StatEntrySizeX = 250
		v.EntryXOffset = -20

		v.BackgroundStyle = {
			Default = { Color = Color3.fromRGB(60, 60, 60), Transparency = 0.25 },
			Hovered = { Color = Color3.fromRGB(50, 181, 255), Transparency = 0.25 },
			HoveredTitle = { Color = Color3.fromRGB(50, 181, 255), Transparency = 0 },
			Title = { Color = Color3.fromRGB(25, 25, 25), Transparency = 0 },
			Selected = nil
		}

		v.TeamEntryBackgroundTransparency = 0.25

		v.DefaultTextStyle = {
			Color = Color3.fromRGB(255, 255, 243),
			Transparency = 0,
			StrokeTransparency = 0.75,
			StrokeColor = Color3.fromRGB(34, 34, 34)
		}

		v.HoveredTextStyle = {
			Color = Color3.fromRGB(19, 19, 19),
			Transparency = 0,
			StrokeTransparency = 0.75,
			StrokeColor = Color3.fromRGB(34, 34, 34)
		}

		v.PlayerIconSize = UDim2.new(0, 64, 0, 64)
		v.InitalPlayerEntryPadding = 18
		v.PlayerEntryPadding = 8
		v.PlayerEntryNamePadding = 8
		v.TeamEntryTextPadding = 5
		v.StatTextPadding = 0

		v.PlayerNameSize = UDim2.new(1, -88, 1, 0)
		v.PlayerNameTextSize = 32
		v.StatTextSize = 32

		v.ScrollImageColor = Color3.fromRGB(31, 31, 31)
		v.ScrollImageTransparency = 0.5
	else
		v.ContainerPadding = 4
		v.ContainerPosition = UDim2.new(1, -4, 0, 4)
		v.ContainerSize = UDim2.new(0, 0, 0.5, 0)
		v.ExtraContainerPadding = 16
		v.AnchorPoint = Vector2.new(1, 0)

		v.PlayerDropDownSizeX = 300
		v.PlayerDropDownOffset = 4

		v.PlayerScrollListPosition = UDim2.new(0, 0, 0, 0)
		v.PlayerScrollListSize = UDim2.new(1, -1, 1, 0)

		v.EntryBaseSizeX = 150
		v.EntrySizeIncreasePerStat = 11
		v.PlayerEntrySizeY = 40
		v.EntryPadding = 0
		v.TeamEntrySizeY = 24
		v.StatEntrySizeX = 66
		v.TitleBarSizeY = 20
		v.EntryXOffset = 0

		v.TeamEntryBackgroundTransparency = 0.5
		v.IconButtonBackgroundTransparency = 0.3
		v.DropDownHeaderBackgroundTransparency = 0.1
		v.OverrideBackgroundTransparency = 0.3
		v.FadedBackgroundTransparency = 0.65
		v.FadedBackgroundScaleDelta = 0.05

		v.PlayerIconSize = UDim2.new(0, 16, 0, 16)
		v.InitalPlayerEntryPadding = 12
		v.PlayerEntryPadding = 12
		v.PlayerEntryNamePadding = 4
		v.TeamEntryTextPadding = 15
		v.StatTextPadding = 4

		v.PlayerNameSize = UDim2.new(1, -34, 1, 0)
		v.PlayerNameTextSize = 14
		v.StatTextSize = 14

		v.ScrollImageColor = Color3.fromRGB(216, 216, 216)
		v.ScrollImageTransparency = 0.5
		v.ScrollBarOffset = 4
		v.ScrollBarSize = 8
	end

	v.TopBarOffset = p.TopBarHeight

	v.PlayerDropDownSizeXMobile = 327
	v.ScrollBarSizeMobile = 2
	v.PlayerNameSizeXMobile = 194
	v.PlayerIconSizeMobile = UDim2.fromOffset(20, 20)
	v.PlayerNameTextSizeMobile = 16
	v.StatTextSizeMobile = 16
	v.PlayerNamePaddingXMobile = 14
	v.TeamEntryTextPadding = 15
	v.TeamEntryTextPaddingMobile = 14
	v.RowHoverColor = Color3.fromRGB(0, 0, 0)
	v.RowDefaultColor = Color3.fromRGB(84, 84, 84)

	v.MaxLeaderstats = 4
	v.MaxLeaderstatsSmallScreen = 1

	v.PlayerEntryFont = Enum.Font.SourceSans
	v.TitlePlayerEntryFont = Enum.Font.SourceSansBold
	v.TeamEntryFont = Enum.Font.SourceSans

	v.StatFont = Enum.Font.SourceSans
	v.TitleStatFont = Enum.Font.SourceSansBold
	v.TeamStatFont = Enum.Font.SourceSansBold
	v.StatNameFont = Enum.Font.SourceSans

	v.PlayerIconBackgroundSize = UDim2.new(0, 66, 0, 66)
	v.PlayerBackgroundImage = "rbxasset://textures/ui/PlayerList/CharacterImageBackground.png"

	v.RobloxIconImage = "rbxasset://textures/ui/Shell/Icons/RobloxIcon24.png"
	v.IconSelectedColor = Color3.fromRGB(19, 19, 19)
	v.IconUnSelectedColor = Color3.fromRGB(255, 255, 255)

	v.SelectedEntryColor = Color3.fromRGB(0, 255, 255)

	v.ShadowImage = "rbxasset://textures/ui/PlayerList/TileShadowMissingTop.png"
	v.ShadowSize = 5
	v.ShadowSliceRect = Rect.new(6, 6, 9, 9)

	v.DefaultThumbnail = "rbxasset://textures/ui/Shell/Icons/DefaultProfileIcon.png"

	v.BlockedIcon = Images["icons/status/unavailable_small"]

	v.FriendIcons = {
		[Enum.FriendStatus.Friend] = Images["icons/status/player/friend"],
		[Enum.FriendStatus.FriendRequestReceived] = Images["icons/status/player/pending"]
	}

	v.FollowingIcon = Images["icons/status/player/following"]
	v.PlaceOwnerIcon = Images["icons/status/player/developer"]

	local iconsstatuspremium_smallsByPremium = {
		[Enum.MembershipType.Premium] = Images["icons/status/premium_small"]
	}
	v.MembershipIcons = iconsstatuspremium_smallsByPremium

	if FFlagPlayerListFoundationSubscriptionIcon then
		v.SubscriptionIcon = {
			isFoundationIcon = true,
			name = Foundation.Enums.IconName.RobloxPlus
		}
	else
		v.SubscriptionIcon = Images["icons/menu/gem_small"]
	end

	v.CustomPlayerIcons = {
		[7210880] = "rbxassetid://134032333",
		[13268404] = "rbxassetid://113059239",
		[261] = "rbxassetid://105897927"
	}

	v.NeutralTeamColor = BrickColor.new("White")
	v.NeutralTeamName = "Neutral"

	v.DropDownButtonSizeY = 56
	v.DropDownButtonPadding = 0
	v.DropDownPadding = 10
	v.DropDownRightOptionSize = 55
	v.DropDownIconSize = 36
	v.DropDownHeaderSizeY = 80
	v.DropDownHeaderBackgroundSize = 65
	v.DropDownScreenSidePadding = 4

	return v
end))
