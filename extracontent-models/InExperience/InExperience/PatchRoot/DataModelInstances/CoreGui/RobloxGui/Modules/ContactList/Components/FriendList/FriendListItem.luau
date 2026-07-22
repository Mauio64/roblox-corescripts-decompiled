local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Sounds = require(CorePackages.Workspace.Packages.SoundManager).Sounds
local SoundGroups = require(CorePackages.Workspace.Packages.SoundManager).SoundGroups
local SoundManager = require(CorePackages.Workspace.Packages.SoundManager).SoundManager
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local ContactList = RobloxGui.Modules.ContactList
local dependencies = require(ContactList.dependencies)
local useDispatch = dependencies.Hooks.useDispatch
local useSelector = dependencies.Hooks.useSelector
local getStandardSizeAvatarHeadShotRbxthumb = dependencies.getStandardSizeAvatarHeadShotRbxthumb
local GetPresencesFromUserIds = dependencies.NetworkingPresence.GetPresencesFromUserIds
local useLocalization = dependencies.Hooks.useLocalization
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local v18 = game:DefineFastFlag("ContactListPresenceStoreMigration", false) and SharedFlags.FFlagFriendSortedByPresenceSignalsImplementation
local v19 = if not v18 then nil else require(CorePackages.Workspace.Packages.FriendsCommon).Hooks.useGetPresenceByUserId
local t1 = {
	Online = PresenceType.Online,
	InGame = PresenceType.InGame,
	InStudio = PresenceType.InStudio,
	Offline = PresenceType.Offline
}
local UIBlox = dependencies.UIBlox
local ControlState = UIBlox.Core.Control.Enum.ControlState
local PlayerContext = UIBlox.App.Indicator.PlayerContext
local Images = UIBlox.App.ImageSet.Images
local Interactable = UIBlox.Core.Control.Interactable
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local OpenOrUpdateCFM = require(ContactList.Actions.OpenOrUpdateCFM)
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local useStartCallCallback = require(ContactList.Hooks.useStartCallCallback)
local Pages = require(ContactList.Enums.Pages)
local random = Random.new()
local vector2 = Vector2.new(24, 12)

local function FriendListItem(t2: {[any]: any}) -- line: 75
	-- upvalues: useAnalytics (copy), useStyle (copy), useDispatch (copy), useLocalization (copy), React (copy), v18 (copy), GetPresencesFromUserIds (copy), v19 (copy), useSelector (copy), ControlState (copy), SoundManager (copy), Sounds (copy), random (copy), SoundGroups (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), useStartCallCallback (copy), Images (copy), t1 (copy), PresenceType (copy), PlayerContext (copy), EventNamesEnum (copy), Pages (copy), OpenOrUpdateCFM (copy), Interactable (copy), vector2 (copy), UserProfiles (copy), ImageSetLabel (copy)
	local v37 = useAnalytics()
	local v38 = useStyle()
	local Theme = v38.Theme
	local Font = v38.Font
	local v41 = useDispatch()
	local t3 = {
		userId = t2.userId,
		userName = t2.userName,
		combinedName = t2.combinedName
	}
	local v43 = useLocalization({
		offlineStatusLabel = "InGame.Presence.Label.Offline",
		onlineStatusLabel = "InGame.Presence.Label.Online",
		studioStatusLabel = "InGame.Presence.Label.RobloxStudio"
	})

	React.useEffect(function() -- line: 95
		-- upvalues: v18 (copy), t2 (copy), v41 (copy), GetPresencesFromUserIds (copy)
		if not v18 and t2.userPresenceType == nil then
			v41(GetPresencesFromUserIds.API({ t2.userId }))
		end
	end, {
		t2.userId,
		t2.userPresenceType
	})

	local u44

	if v18 then
		u44 = v19(t2.userId, {
			skipFetch = not not t2.userPresenceType or nil
		})
	else
		local v45 = React.useCallback(function(p1) -- line: 108
			-- upvalues: t2 (copy)
			return p1.Presence.byUserId[tostring(t2.userId)]
		end, { t2.userId })

		u44 = useSelector(v45)
	end

	local v46 = React.useCallback(function(p2) -- line: 114
		return p2.Navigation.currentTag
	end, {})
	local v47 = useSelector(v46)
	local v48 = React.useCallback(function(p3) -- line: 119
		return p3.Navigation.currentPage
	end, {})
	local v49 = useSelector(v48)
	local v50, v51 = React.useState("BackgroundDefault")
	local v52 = React.useCallback(function(_, p5) -- line: 125
		-- upvalues: ControlState (copy), v51 (copy), SoundManager (copy), Sounds (copy), random (copy), SoundGroups (copy)
		if p5 == ControlState.Pressed then
			v51("BackgroundOnPress")

			return
		end

		if p5 == ControlState.Hover then
			v51("BackgroundOnHover")
			SoundManager:PlaySound(Sounds.Hover.Name, {
				Volume = 0.5 + random:NextNumber(-0.25, 0.25),
				PlaybackSpeed = 1 + random:NextNumber(-0.5, 0.5)
			}, SoundGroups.Iris)

			return
		end

		v51("BackgroundDefault")
	end, {})
	local v53 = getStandardSizeAvatarHeadShotRbxthumb((tostring(t2.userId)))
	local t4 = {
		searchQueryString = t2.searchQueryString,
		itemListIndex = t2.itemListIndex,
		isSuggestedUser = t2.isSuggestedUser,
		page = v49
	}
	local v55 = useStartCallCallback(v47, t2.userId, t2.combinedName, t2.dismissCallback, t4)
	local v56 = React.useMemo(function() -- line: 149
		-- upvalues: Images (copy), v38 (copy), v43 (copy), u44 (ref), v18 (copy), t1 (copy), PresenceType (copy), t2 (copy), Theme (copy), React (copy), PlayerContext (copy), v55 (copy)
		local v63 = Images["component_assets/circle_26_stroke_3"]
		local OfflineStatusColor = v38.Theme.OfflineStatus.Color
		local OfflineStatusTransparency = v38.Theme.OfflineStatus.Transparency
		local n1 = 12
		local offlineStatusLabel = v43.offlineStatusLabel
		local TextMuted = v38.Theme.TextMuted
		local v69, lastLocation

		if u44 then
			v69 = if not v18 then u44.userPresenceType else t1[u44.userPresenceType] or PresenceType.Offline
			lastLocation = u44.lastLocation
		else
			v69 = if not t2.userPresenceType then PresenceType.Offline else PresenceType[t2.userPresenceType]
			lastLocation = t2.lastLocation or ""
		end

		if v69 == PresenceType.Online then
			v63 = Images["component_assets/circle_16"]
			OfflineStatusColor = v38.Theme.OnlineStatus.Color
			OfflineStatusTransparency = v38.Theme.OnlineStatus.Transparency
			offlineStatusLabel = v43.onlineStatusLabel
			TextMuted = v38.Theme.TextMuted
			n1 = 12
		elseif v69 == PresenceType.InGame then
			v63 = Images["icons/menu/games_small"]
			OfflineStatusColor = v38.Theme.IconEmphasis.Color
			OfflineStatusTransparency = v38.Theme.IconEmphasis.Transparency
			offlineStatusLabel = lastLocation
			TextMuted = Theme.TextEmphasis
			n1 = 16
		elseif v69 == PresenceType.InStudio then
			v63 = Images["icons/logo/studiologo_small"]
			OfflineStatusColor = v38.Theme.TextDefault.Color
			OfflineStatusTransparency = v38.Theme.TextDefault.Transparency
			offlineStatusLabel = v43.studioStatusLabel
			TextMuted = v38.Theme.TextMuted
			n1 = 16
		end

		return React.createElement(PlayerContext, {
			layoutOrder = 2,
			textHeight = 24,
			fontStyle = v38.Font.CaptionBody,
			icon = v63,
			iconColor = OfflineStatusColor,
			iconSize = UDim2.fromOffset(n1, n1),
			iconTransparency = OfflineStatusTransparency,
			onActivated = v55,
			text = offlineStatusLabel,
			textColorStyle = TextMuted
		})
	end, {
		u44,
		v38,
		v43.offlineStatusLabel,
		v43.onlineStatusLabel,
		v43.studioStatusLabel
	})
	local v57 = React.useCallback(function() -- line: 210
		-- upvalues: v37 (copy), EventNamesEnum (copy), t3 (copy), t2 (copy), Pages (copy), v41 (copy), OpenOrUpdateCFM (copy)
		v37.fireEvent(EventNamesEnum.PhoneBookPlayerMenuOpened, {
			eventTimestampMs = os.time() * 1000,
			friendUserId = t3.userId,
			searchQueryString = t2.searchQueryString,
			itemListIndex = t2.itemListIndex,
			isSuggestedUser = t2.isSuggestedUser,
			page = Pages.FriendList
		})
		v41(OpenOrUpdateCFM(t3))
	end, {
		t3.userId,
		t2.searchQueryString,
		t2.itemListIndex,
		t2.isSuggestedUser
	})

	return React.createElement(Interactable, {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 0, 0, 68 + vector2.Y * 2),
		BackgroundColor3 = Theme[v50].Color,
		BackgroundTransparency = Theme[v50].Transparency,
		BorderSizePixel = 0,
		LayoutOrder = t2.layoutOrder,
		onStateChanged = v52,
		AutoButtonColor = false,
		[React.Event.Activated] = v55
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, vector2.X),
			PaddingTop = UDim.new(0, vector2.Y)
		}),
		ProfileImage = React.createElement("ImageButton", {
			Size = UDim2.fromOffset(68, 68),
			Image = v53,
			[React.Event.MouseButton2Up] = v57,
			[React.Event.TouchTap] = v57,
			AutoButtonColor = false
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 80, 0, 0),
			Size = UDim2.new(1, -(116 + vector2.X), 1, -vector2.Y)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			NameContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 6)
				}),
				CombinedName = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 20),
					Font = Font.Header2.Font,
					Text = t2.combinedName,
					TextColor3 = Theme.TextEmphasis.Color,
					TextSize = Font.BaseSize * Font.Header2.RelativeSize,
					TextTransparency = Theme.TextEmphasis.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				Username = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 14),
					Font = Font.CaptionBody.Font,
					Text = UserProfiles.Formatters.formatUsername(t2.userName),
					TextColor3 = Theme.TextDefault.Color,
					TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
					TextTransparency = Theme.TextDefault.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			PlayerContext = v56
		}),
		CallIcon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Image = "rbxassetid://15239343417",
			Position = UDim2.new(1, -vector2.X - 4, 0.5, -vector2.Y / 2),
			Size = UDim2.fromOffset(24, 24),
			AnchorPoint = Vector2.new(1, 0.5),
			ImageColor3 = Theme.ContextualPrimaryDefault.Color,
			ImageTransparency = Theme.ContextualPrimaryDefault.Transparency
		}),
		Divider = t2.showDivider and React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency
		}) or nil
	})
end

return FriendListItem
