local TextService = game:GetService("TextService")

local FriendsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/FriendsMenu")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Style").GetTextSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/UniversalAppPolicy")
local deviceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").DeviceInfo
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/AppCommonLib").IsVRAppBuild

local friendsMenuSearch = FriendsMenu.FriendsMenuSearch
local friendsListContext = FriendsMenu.FriendsListContext
local inviteFriendContext = FriendsMenu.InviteFriendContext

local GameInviteAnalyticsManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteAnalyticsManager")
local GameInviteModalManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteModalManager")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/ShareGameInviteLink")
local isExperienceOlderThanOneWeek = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/isExperienceOlderThanOneWeek")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")
local localizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/NotificationsCommon").LocalizationHelper
local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")
local shouldShowJoinCta = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/shouldShowJoinCta")
local FFlagGameInviteInExpJoinCta = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FFlagGameInviteInExpJoinCta")

local GameInviteModalLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameInviteModalLayoutContext")
local GameDetailsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Context/GameDetailsContext")

local useStyle = UIBlox.Core.Style.useStyle
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = localizationHelper.getLocalizedStrings
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local getFFlagEnableGameInviteModalVRSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").GetFFlagEnableGameInviteModalVRSupport

local titleIconSize = GameInviteConstants.Layout.TitleIconSize
local sidePadding = GameInviteConstants.Layout.SidePadding

local iconsnavigationclose = images["icons/navigation/close"]
local iconsmenusearch = images["icons/menu/search"]

local v5 = {
	cancelText = "Feature.SettingsHub.Action.CancelSearch",
	inviteFriends = "CoreScripts.InGameMenu.PageTitle.InviteFriends",
	joinOrInviteFriends = FFlagGameInviteInExpJoinCta and "CoreScripts.InGameMenu.PageTitle.JoinOrInviteFriends" or nil,
	copyLink = "Feature.SocialShare.Action.CopyLink"
}

local function fn(data, console, p2)
	if getFFlagEnableGameInviteModalVRSupport() then
		local v6 = not isVRAppBuild() and p2 and not console and data and data.isCoreScript

		if v6 then
			v6 = data.serverType == "StandardServer" and isExperienceOlderThanOneWeek(data.gameDetails)
		end

		return v6
	else
		local v6 = not console and p2 and data and data.isCoreScript

		if v6 then
			v6 = data.serverType == "StandardServer" and isExperienceOlderThanOneWeek(data.gameDetails)
		end

		return v6
	end
end

return function(props)
	local v6 = useStyle()
	local v7 = React.useContext(GameInviteModalLayoutContext)
	local v8 = React.useContext(GameDetailsContext)
	local v9 = React.useContext(friendsListContext)
	local v10 = React.useContext(inviteFriendContext)

	local state, setState = React.useState(false)
	local localizedStrings = getLocalizedStrings(v5)
	local v11

	if FFlagGameInviteInExpJoinCta and shouldShowJoinCta(v8) then
		v11 = localizedStrings.joinOrInviteFriends
	else
		v11 = localizedStrings.inviteFriends
	end

	local searchFriends = v9.searchFriends

	local v12 = useAppPolicy(function(p2)
		return p2.getExperienceInviteShareLinkEnabled()
	end)

	local v13 = v7.modalMode == "compact"
	local isFullWidth = v7.isFullWidth
	local desktopDevice = deviceInfo.isDesktopDevice()
	local v14 = fn(v8, deviceInfo.isConsole(), v12)
	local v15 = desktopDevice and not isFullWidth
	local v16 = v6.Font.BaseSize * v6.Font.Header2.RelativeSize
	local v17 = v6.Font.BaseSize * v6.Font.Body.RelativeSize
	local v18

	if foundationFontFaceMigration then
		v18 = getTextSize(
			localizedStrings.copyLink,
			v16,
			v6.Tokens.Typography.TitleLarge.Font,
			Vector2.new(300 - titleIconSize, 1e999),
			{ addTemporaryPadding = false }
		)
	else
		v18 = TextService:GetTextSize(
			localizedStrings.copyLink,
			v16,
			v6.Font.Header2.Font,
			Vector2.new(300 - titleIconSize, 1e999)
		)
	end

	local total = 0
	local udim

	if v14 then
		if desktopDevice and v15 then
			local v19 = math.ceil(v18.X) + 10
			udim = UDim2.new(0, v19, 1, 0)
			total += v19
		else
			udim = UDim2.new(0, titleIconSize, 0, titleIconSize)
			total += titleIconSize
		end
	else
		udim = nil
	end

	if v13 then
		total += titleIconSize
	end

	if v13 and v14 then
		total += 4
	end

	local function fn2()
		GameInviteModalManager:closeModal(v10.getMaxRecipientRowNum())
	end

	local function fn3()
		setState(true)
	end

	local function fn4()
		setState(false)
		searchFriends("")
	end

	if not v13 and state then
		setState(false)
		searchFriends("")
	end

	local v19 = React.useMemo(function()
		local children = {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, sidePadding),
				PaddingRight = UDim.new(0, sidePadding)
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
		local v21 = {
			Size = UDim2.new(0, total, 1, 0),
			LayoutOrder = 0,
			BackgroundTransparency = 1
		}

		local v22 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 4)
			}),
			CloseButton = 0
		}
		local v23

		if not props.hideCloseButton then
			v23 = React.createElement(imageSetButton, {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, titleIconSize, 0, titleIconSize),
				[React.Event.Activated] = fn2,
				Image = iconsnavigationclose,
				ImageColor3 = v6.Theme.IconEmphasis.Color,
				ImageTransparency = v6.Theme.IconEmphasis.Transparency,
				BorderSizePixel = 0
			})
		end

		v22.CloseButton = v23
		children.LeftActionContainer = createElement("Frame", v21, v22)

		local createElement2 = React.createElement
		local v25 = {
			BackgroundTransparency = 1,
			Text = v11,
			TextSize = v16,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextColor3 = v6.Theme.TextEmphasis.Color,
			Font = 0,
			FontFace = 0,
			Size = 0,
			LayoutOrder = 1
		}
		local v26 = if not foundationFontFaceMigration then v6.Font.Header2.Font else nil
		v25.Font = v26

		local v27 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font) else nil
		v25.FontFace = v27

		v25.Size = UDim2.new(1, total * 2 * -1, 1, 0)
		children.Title = createElement2("TextLabel", v25)

		local createElement3 = React.createElement
		local v29 = {
			Size = UDim2.new(0, total, 1, 0),
			LayoutOrder = 2,
			BackgroundTransparency = 1
		}

		local v30 = {
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
		local v31

		if v13 then
			v31 = React.createElement(imageSetButton, {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(0, titleIconSize, 0, titleIconSize),
				[React.Event.Activated] = fn3,
				Image = iconsmenusearch,
				ImageColor3 = v6.Theme.IconEmphasis.Color,
				ImageTransparency = v6.Theme.IconEmphasis.Transparency,
				BorderSizePixel = 0
			}) or nil
		end

		v30.SearchButton = v31

		v30.ShareGameInviteLink = v14
			and React.createElement(module8, {
				layoutOrder = 1,
				isDesktop = desktopDevice,
				isFullSize = v15,
				size = udim
			})
			or nil
		children.RightActionContainer = createElement3("Frame", v29, v30)
		return children
	end, { state, v15, v13, v14, desktopDevice, v11 })

	local v20 = React.useMemo(function()
		local v21 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, 4)
			}),
			SearchBox = React.createElement(friendsMenuSearch, {
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
		local v23 = {}
		v23.LayoutOrder = 1
		v23.BackgroundTransparency = 1
		v23.AnchorPoint = Vector2.new(1, 0.5)
		v23.Position = UDim2.new(1, 0, 0.5, 0)
		v23.Size = UDim2.new(0, 100, 1, 0)
		v23.TextSize = v17
		v23.TextColor3 = v6.Theme.UIDefault.Color
		v23.Text = localizedStrings.cancelText
		local v24 = if not foundationFontFaceMigration then v6.Font.Body.Font else nil
		v23.Font = v24

		local v25 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
		v23.FontFace = v25

		v23[React.Event.Activated] = fn4
		v21.CancelButton = createElement("TextButton", v23)
		return v21
	end, { state })

	if state then
		v19 = v20
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		LayoutOrder = props.layoutOrder,
		Position = UDim2.new(0, 0, 1, 0),
		Size = props.size
	}, v19)
end
