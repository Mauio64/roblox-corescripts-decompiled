local GameInvite = script:FindFirstAncestor("GameInvite")
local TextService = game:GetService("TextService")
local Components = GameInvite.Components
local Context = GameInvite.Context
local parent = GameInvite.Parent
local utils = GameInvite.utils

local FriendsMenu = require(parent.FriendsMenu)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local NotificationsCommon = require(parent.NotificationsCommon)
local DeviceInfo = NotificationsCommon.DeviceInfo
local AppCommonLib = require(parent.AppCommonLib)
local IsVRAppBuild = AppCommonLib.IsVRAppBuild

local FriendsMenuSearch = FriendsMenu.FriendsMenuSearch
local FriendsListContext = FriendsMenu.FriendsListContext
local InviteFriendContext = FriendsMenu.InviteFriendContext

local GameInviteAnalyticsManager = require(GameInvite.analytics.GameInviteAnalyticsManager)
local GameInviteModalManager = require(GameInvite.GameInviteModalManager)
local ShareGameInviteLink = require(Components.ShareGameInviteLink)
local isExperienceOlderThanOneWeek = require(utils.isExperienceOlderThanOneWeek)
require(GameInvite.gameInviteModalType)
local NotificationsCommon2 = require(parent.NotificationsCommon)
local LocalizationHelper = NotificationsCommon2.LocalizationHelper
local GameInviteConstants = require(GameInvite.GameInviteConstants)
local shouldShowJoinCta = require(utils.shouldShowJoinCta)
local FFlagGameInviteInExpJoinCta = require(GameInvite.Flags.FFlagGameInviteInExpJoinCta)

local GameInviteModalLayoutContext = require(Context.GameInviteModalLayoutContext)
local GameDetailsContext = require(Context.GameDetailsContext)

local useStyle = UIBlox.Core.Style.useStyle
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableGameInviteModalVRSupport = SharedFlags.GetFFlagEnableGameInviteModalVRSupport

local TitleIconSize = GameInviteConstants.Layout.TitleIconSize
local SidePadding = GameInviteConstants.Layout.SidePadding

local iconsnavigationclose = Images["icons/navigation/close"]
local iconsmenusearch = Images["icons/menu/search"]

local v = {
	cancelText = "Feature.SettingsHub.Action.CancelSearch",
	inviteFriends = "CoreScripts.InGameMenu.PageTitle.InviteFriends",
	joinOrInviteFriends = FFlagGameInviteInExpJoinCta and "CoreScripts.InGameMenu.PageTitle.JoinOrInviteFriends" or nil,
	copyLink = "Feature.SocialShare.Action.CopyLink"
}

local function fn(data, flag: boolean, flag2: boolean)
	if GetFFlagEnableGameInviteModalVRSupport() then
		local v2 = not IsVRAppBuild() and flag2 and not flag and data and data.isCoreScript

		if v2 then
			if data.serverType == "StandardServer" then
				return (isExperienceOlderThanOneWeek(data.gameDetails))
			end

			return false
		end

		return v2
	else
		local v2 = not flag and flag2 and data and data.isCoreScript

		if v2 then
			if data.serverType == "StandardServer" then
				return (isExperienceOlderThanOneWeek(data.gameDetails))
			end

			return false
		end

		return v2
	end
end

return function(props)
	local v2 = useStyle()
	local v3 = React.useContext(GameInviteModalLayoutContext)
	local v4 = React.useContext(GameDetailsContext)
	local v5 = React.useContext(FriendsListContext)
	local v6 = React.useContext(InviteFriendContext)

	local state, setState = React.useState(false)
	local localizedStrings = getLocalizedStrings(v)
	local text

	if FFlagGameInviteInExpJoinCta and shouldShowJoinCta(v4) then
		text = localizedStrings.joinOrInviteFriends
	else
		text = localizedStrings.inviteFriends
	end

	local searchFriends = v5.searchFriends

	local v7 = useAppPolicy(function(p)
		return p.getExperienceInviteShareLinkEnabled()
	end)

	local v8 = v3.modalMode == "compact"
	local isFullWidth = v3.isFullWidth
	local desktopDevice = DeviceInfo.isDesktopDevice()
	local v9 = fn(v4, DeviceInfo.isConsole(), v7)
	local isFullSize = desktopDevice and not isFullWidth
	local textSize = v2.Font.BaseSize * v2.Font.Header2.RelativeSize
	local textSize2 = v2.Font.BaseSize * v2.Font.Body.RelativeSize
	local v10

	if FoundationFontFaceMigration then
		v10 = GetTextSize(
			localizedStrings.copyLink,
			textSize,
			v2.Tokens.Typography.TitleLarge.Font,
			Vector2.new(300 - TitleIconSize, 1e999),
			{ addTemporaryPadding = false }
		)
	else
		v10 = TextService:GetTextSize(
			localizedStrings.copyLink,
			textSize,
			v2.Font.Header2.Font,
			Vector2.new(300 - TitleIconSize, 1e999)
		)
	end

	local total = 0
	local udim

	if v9 then
		if desktopDevice and isFullSize then
			local v11 = math.ceil(v10.X) + 10
			udim = UDim2.new(0, v11, 1, 0)
			total += v11
		else
			udim = UDim2.new(0, TitleIconSize, 0, TitleIconSize)
			total += TitleIconSize
		end
	else
		udim = nil
	end

	if v8 then
		total += TitleIconSize
	end

	if v8 and v9 then
		total += 4
	end

	local function fn2()
		GameInviteModalManager:closeModal(v6.getMaxRecipientRowNum())
	end

	local function fn3()
		setState(true)
	end

	local function fn4() -- 1 equivalent call inferred from this helper
		setState(false)
		searchFriends("")
	end

	if not v8 and state then
		fn4() -- inferred equivalent call
	end

	local v11 = React.useMemo(function()
		local children = {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, SidePadding),
				PaddingRight = UDim.new(0, SidePadding)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			LeftActionContainer = 0,
			Title = 0,
			RightActionContainer = 0
		}

		local createElement = React.createElement
		local v11 = {
			Size = UDim2.new(0, total, 1, 0),
			LayoutOrder = 0,
			BackgroundTransparency = 1
		}

		local v12 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 4)
			}),
			CloseButton = 0
		}
		local closeButton

		if not props.hideCloseButton then
			closeButton = React.createElement(ImageSetButton, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, TitleIconSize, 0, TitleIconSize),
				[React.Event.Activated] = fn2,
				Image = iconsnavigationclose,
				ImageColor3 = v2.Theme.IconEmphasis.Color,
				ImageTransparency = v2.Theme.IconEmphasis.Transparency,
				BorderSizePixel = 0
			})
		end

		v12.CloseButton = closeButton
		children.LeftActionContainer = createElement("Frame", v11, v12)

		local createElement2 = React.createElement
		local v13 = {
			BackgroundTransparency = 1,
			Text = text,
			TextSize = textSize,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextColor3 = v2.Theme.TextEmphasis.Color,
			Font = 0,
			FontFace = 0,
			Size = 0,
			LayoutOrder = 1
		}
		local font

		if not FoundationFontFaceMigration then
			font = v2.Font.Header2.Font
		end

		v13.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Tokens.Typography.TitleLarge.Font)
		end

		v13.FontFace = fontFace

		v13.Size = UDim2.new(1, total * 2 * -1, 1, 0)
		children.Title = createElement2("TextLabel", v13)

		local createElement3 = React.createElement
		local v14 = {
			Size = UDim2.new(0, total, 1, 0),
			LayoutOrder = 2,
			BackgroundTransparency = 1
		}

		local v15 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, 4)
			}),
			SearchButton = 0,
			ShareGameInviteLink = 0
		}
		local searchButton

		if v8 then
			searchButton = React.createElement(ImageSetButton, {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, TitleIconSize, 0, TitleIconSize),
				[React.Event.Activated] = fn3,
				Image = iconsmenusearch,
				ImageColor3 = v2.Theme.IconEmphasis.Color,
				ImageTransparency = v2.Theme.IconEmphasis.Transparency,
				BorderSizePixel = 0
			}) or nil
		end

		v15.SearchButton = searchButton

		v15.ShareGameInviteLink = v9
			and React.createElement(ShareGameInviteLink, {
				layoutOrder = 1,
				isDesktop = desktopDevice,
				isFullSize = isFullSize,
				size = udim
			})
			or nil
		children.RightActionContainer = createElement3("Frame", v14, v15)
		return children
	end, { state, isFullSize, v8, v9, desktopDevice, text })

	local v12 = React.useMemo(function()
		local v12 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, 4)
			}),
			SearchBox = React.createElement(FriendsMenuSearch, {
				layoutOrder = 0,
				size = UDim2.new(1, -120, 1, -20),
				focusElement = true,
				onFocus = function()
					GameInviteAnalyticsManager:onSearchFocused()
				end
			}),
			CancelButton = 0
		}

		local createElement = React.createElement
		local v13 = {}
		v13.LayoutOrder = 1
		v13.BackgroundTransparency = 1
		v13.AnchorPoint = Vector2.new(1, 0.5)
		v13.Position = UDim2.new(1, 0, 0.5, 0)
		v13.Size = UDim2.new(0, 100, 1, 0)
		v13.TextSize = textSize2
		v13.TextColor3 = v2.Theme.UIDefault.Color
		v13.Text = localizedStrings.cancelText
		local font

		if not FoundationFontFaceMigration then
			font = v2.Font.Body.Font
		end

		v13.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v2.Tokens.Typography.BodyLarge.Font)
		end

		v13.FontFace = fontFace

		v13[React.Event.Activated] = fn4
		v12.CancelButton = createElement("TextButton", v13)
		return v12
	end, { state })

	if state then
		v11 = v12
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		LayoutOrder = props.layoutOrder,
		Position = UDim2.new(0, 0, 1, 0),
		Size = props.size
	}, v11)
end
