local GameInvite = script:FindFirstAncestor("GameInvite")
local TextService = game:GetService("TextService")
local Components = GameInvite.Components
local Context = GameInvite.Context
local GameInviteParent = GameInvite.Parent
local utils = GameInvite.utils
local FriendsMenu = require(GameInviteParent.FriendsMenu)
local React = require(GameInviteParent.React)
local UIBlox = require(GameInviteParent.UIBlox)
local UniversalAppPolicy = require(GameInviteParent.UniversalAppPolicy)
local DeviceInfo = require(GameInviteParent.NotificationsCommon).DeviceInfo
local IsVRAppBuild = require(GameInviteParent.AppCommonLib).IsVRAppBuild
local FriendsMenuSearch = FriendsMenu.FriendsMenuSearch
local FriendsListContext = FriendsMenu.FriendsListContext
local InviteFriendContext = FriendsMenu.InviteFriendContext
local GameInviteAnalyticsManager = require(GameInvite.analytics.GameInviteAnalyticsManager)
local GameInviteModalManager = require(GameInvite.GameInviteModalManager)
local ShareGameInviteLink = require(Components.ShareGameInviteLink)
local isExperienceOlderThanOneWeek = require(utils.isExperienceOlderThanOneWeek)

require(GameInvite.gameInviteModalType)

local LocalizationHelper = require(GameInviteParent.NotificationsCommon).LocalizationHelper
local GameInviteConstants = require(GameInvite.GameInviteConstants)
local GameInviteModalLayoutContext = require(Context.GameInviteModalLayoutContext)
local GameDetailsContext = require(Context.GameDetailsContext)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Images = UIBlox.App.ImageSet.Images
local getLocalizedStrings = LocalizationHelper.getLocalizedStrings
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local SharedFlags = require(GameInviteParent.SharedFlags)
local GetFFlagEnableGameInviteModalVRSupport = SharedFlags.GetFFlagEnableGameInviteModalVRSupport
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local TitleIconSize = GameInviteConstants.Layout.TitleIconSize
local SidePadding = GameInviteConstants.Layout.SidePadding
local v34 = Images["icons/navigation/close"]
local v35 = Images["icons/menu/search"]
local t1 = {
	cancelText = "Feature.SettingsHub.Action.CancelSearch",
	copyLink = "Feature.SocialShare.Action.CopyLink",
	inviteFriends = if not FFlagConnectionsToFriendsRename then nil else "CoreScripts.InGameMenu.PageTitle.InviteFriends",
	inviteConnections = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.InviteConnections" or nil
}

local function v37(p1, b1: boolean, b2: boolean) -- line: 61
	-- upvalues: GetFFlagEnableGameInviteModalVRSupport (copy), IsVRAppBuild (copy), isExperienceOlderThanOneWeek (copy)
	if GetFFlagEnableGameInviteModalVRSupport() then
		return not IsVRAppBuild() and (b2 and (not b1 and (p1 and (p1.isCoreScript and (p1.serverType == "StandardServer" and isExperienceOlderThanOneWeek(p1.gameDetails))))))
	end

	return not b1 and (b2 and (p1 and (p1.isCoreScript and (p1.serverType == "StandardServer" and isExperienceOlderThanOneWeek(p1.gameDetails)))))
end

return function(t2: {[any]: any}) -- line: 90
	-- upvalues: useStyle (copy), React (copy), GameInviteModalLayoutContext (copy), GameDetailsContext (copy), FriendsListContext (copy), InviteFriendContext (copy), getLocalizedStrings (copy), t1 (copy), useAppPolicy (copy), DeviceInfo (copy), v37 (copy), TextService (copy), TitleIconSize (copy), GameInviteModalManager (copy), SidePadding (copy), ImageSetButton (copy), v34 (copy), FFlagConnectionsToFriendsRename (copy), v35 (copy), ShareGameInviteLink (copy), FriendsMenuSearch (copy), GameInviteAnalyticsManager (copy)
	local v42 = useStyle()
	local v43 = React.useContext(GameInviteModalLayoutContext)
	local v44 = React.useContext(GameDetailsContext)
	local v45 = React.useContext(FriendsListContext)
	local v46 = React.useContext(InviteFriendContext)
	local v47, v48 = React.useState(false)
	local v49 = getLocalizedStrings(t1)
	local searchFriends = v45.searchFriends
	local v51 = useAppPolicy(function(p2) -- line: 102
		return p2.getExperienceInviteShareLinkEnabled()
	end)
	local v52 = v43.modalMode == "compact"
	local isFullWidth = v43.isFullWidth
	local v54 = DeviceInfo.isDesktopDevice()
	local v55 = DeviceInfo.isConsole()
	local v56 = v37(v44, v55, v51)
	local v57 = v54 and not isFullWidth
	local v58 = v42.Font.BaseSize * v42.Font.Header2.RelativeSize
	local v59 = v42.Font.BaseSize * v42.Font.Body.RelativeSize
	local TextSize = TextService:GetTextSize(v49.copyLink, v58, v42.Font.Header2.Font, Vector2.new(300 - TitleIconSize, 1e999))
	local uDim2 = nil
	local n1 = 0

	if v56 then
		if v54 and v57 then
			local v63 = math.ceil(TextSize.X) + 10

			uDim2 = UDim2.new(0, v63, 1, 0)
			n1 += v63
		else
			uDim2 = UDim2.new(0, TitleIconSize, 0, TitleIconSize)
			n1 += TitleIconSize
		end
	end

	if v52 then
		n1 += TitleIconSize
	end

	if v52 and v56 then
		n1 += 4
	end

	local function v64() -- line: 143
		-- upvalues: GameInviteModalManager (copy), v46 (copy)
		GameInviteModalManager:closeModal(v46.getMaxRecipientRowNum())
	end
	local function v65() -- line: 147
		-- upvalues: v48 (copy)
		v48(true)
	end
	local function v66() -- line: 151
		-- upvalues: v48 (copy), searchFriends (copy)
		v48(false)
		searchFriends("")
	end

	if not v52 and v47 then
		v48(false)
		searchFriends("")
	end

	local v67 = React.useMemo(function() -- line: 162
		-- upvalues: React (copy), SidePadding (copy), n1 (ref), t2 (copy), ImageSetButton (copy), TitleIconSize (copy), v64 (copy), v34 (copy), v42 (copy), FFlagConnectionsToFriendsRename (copy), v49 (copy), v58 (copy), v52 (copy), v65 (copy), v35 (copy), v56 (copy), ShareGameInviteLink (copy), v54 (copy), v57 (copy), uDim2 (ref)
		return {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, SidePadding),
				PaddingRight = UDim.new(0, SidePadding)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			LeftActionContainer = React.createElement("Frame", {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, n1, 1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, 4)
				}),
				CloseButton = if t2.hideCloseButton then nil else React.createElement(ImageSetButton, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, TitleIconSize, 0, TitleIconSize),
					[React.Event.Activated] = v64,
					Image = v34,
					ImageColor3 = v42.Theme.IconEmphasis.Color,
					ImageTransparency = v42.Theme.IconEmphasis.Transparency,
					BorderSizePixel = 0
				})
			}),
			Title = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				LayoutOrder = 1,
				Text = if not FFlagConnectionsToFriendsRename then v49.inviteConnections else v49.inviteFriends,
				TextSize = v58,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextColor3 = v42.Theme.TextEmphasis.Color,
				Font = v42.Font.Header2.Font,
				Size = UDim2.new(1, n1 * 2 * -1, 1, 0)
			}),
			RightActionContainer = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, n1, 1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = UDim.new(0, 4)
				}),
				SearchButton = v52 and React.createElement(ImageSetButton, {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.new(0, TitleIconSize, 0, TitleIconSize),
					[React.Event.Activated] = v65,
					Image = v35,
					ImageColor3 = v42.Theme.IconEmphasis.Color,
					ImageTransparency = v42.Theme.IconEmphasis.Transparency,
					BorderSizePixel = 0
				}) or nil,
				ShareGameInviteLink = v56 and React.createElement(ShareGameInviteLink, {
					layoutOrder = 1,
					isDesktop = v54,
					isFullSize = v57,
					size = uDim2
				}) or nil
			})
		}
	end, {
		v47,
		v57,
		v52,
		v56,
		v54
	})
	local v68 = React.useMemo(function() -- line: 243
		-- upvalues: React (copy), FriendsMenuSearch (copy), GameInviteAnalyticsManager (copy), v59 (copy), v42 (copy), v49 (copy), v66 (copy)
		return {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = UDim.new(0, 4)
			}),
			SearchBox = React.createElement(FriendsMenuSearch, {
				layoutOrder = 0,
				focusElement = true,
				size = UDim2.new(1, -120, 1, -20),
				onFocus = function() -- line: 256
					-- upvalues: GameInviteAnalyticsManager (copy)
					GameInviteAnalyticsManager:onSearchFocused()
				end
			}),
			CancelButton = React.createElement("TextButton", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, 100, 1, 0),
				TextSize = v59,
				TextColor3 = v42.Theme.UIDefault.Color,
				Text = v49.cancelText,
				Font = v42.Font.Body.Font,
				[React.Event.Activated] = v66
			})
		}
	end, { v47 })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0, 1),
		LayoutOrder = t2.layoutOrder,
		Position = UDim2.new(0, 0, 1, 0),
		Size = t2.size
	}, if not v47 then v67 else v68)
end
