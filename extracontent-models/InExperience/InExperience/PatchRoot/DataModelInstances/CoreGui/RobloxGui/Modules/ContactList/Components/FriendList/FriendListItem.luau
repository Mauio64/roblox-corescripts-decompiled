local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local React = require(CorePackages.Packages.React)
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

local function FriendListItem(t1: {[any]: any}) -- line: 61
	-- upvalues: useAnalytics (copy), useStyle (copy), useDispatch (copy), useLocalization (copy), React (copy), GetPresencesFromUserIds (copy), useSelector (copy), ControlState (copy), SoundManager (copy), Sounds (copy), random (copy), SoundGroups (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), useStartCallCallback (copy), Images (copy), PresenceType (copy), PlayerContext (copy), EventNamesEnum (copy), Pages (copy), OpenOrUpdateCFM (copy), Interactable (copy), vector2 (copy), UserProfiles (copy), ImageSetLabel (copy)
	local v33 = useAnalytics()
	local v34 = useStyle()
	local Theme = v34.Theme
	local Font = v34.Font
	local v37 = useDispatch()
	local t2 = {
		userId = t1.userId,
		userName = t1.userName,
		combinedName = t1.combinedName
	}
	local v39 = useLocalization({
		offlineStatusLabel = "InGame.Presence.Label.Offline",
		onlineStatusLabel = "InGame.Presence.Label.Online",
		studioStatusLabel = "InGame.Presence.Label.RobloxStudio"
	})

	React.useEffect(function() -- line: 81
		-- upvalues: t1 (copy), v37 (copy), GetPresencesFromUserIds (copy)
		if t1.userPresenceType == nil then
			v37(GetPresencesFromUserIds.API({ t1.userId }))
		end
	end, {
		t1.userId,
		t1.userPresenceType
	})

	local v40 = React.useCallback(function(p1) -- line: 87
		-- upvalues: t1 (copy)
		return p1.Presence.byUserId[tostring(t1.userId)]
	end, { t1.userId })
	local v41 = useSelector(v40)
	local v42 = React.useCallback(function(p2) -- line: 92
		return p2.Navigation.currentTag
	end, {})
	local v43 = useSelector(v42)
	local v44 = React.useCallback(function(p3) -- line: 97
		return p3.Navigation.currentPage
	end, {})
	local v45 = useSelector(v44)
	local v46, v47 = React.useState("BackgroundDefault")
	local v48 = React.useCallback(function(_, p5) -- line: 103
		-- upvalues: ControlState (copy), v47 (copy), SoundManager (copy), Sounds (copy), random (copy), SoundGroups (copy)
		if p5 == ControlState.Pressed then
			v47("BackgroundOnPress")

			return
		end

		if p5 == ControlState.Hover then
			v47("BackgroundOnHover")
			SoundManager:PlaySound(Sounds.Hover.Name, {
				Volume = 0.5 + random:NextNumber(-0.25, 0.25),
				PlaybackSpeed = 1 + random:NextNumber(-0.5, 0.5)
			}, SoundGroups.Iris)

			return
		end

		v47("BackgroundDefault")
	end, {})
	local v49 = getStandardSizeAvatarHeadShotRbxthumb((tostring(t1.userId)))
	local t3 = {
		searchQueryString = t1.searchQueryString,
		itemListIndex = t1.itemListIndex,
		isSuggestedUser = t1.isSuggestedUser,
		page = v45
	}
	local v51 = useStartCallCallback(v43, t1.userId, t1.combinedName, t1.dismissCallback, t3)
	local v52 = React.useMemo(function() -- line: 127
		-- upvalues: Images (copy), v34 (copy), v39 (copy), v41 (copy), t1 (copy), PresenceType (copy), Theme (copy), React (copy), PlayerContext (copy), v51 (copy)
		local v59 = Images["component_assets/circle_26_stroke_3"]
		local OfflineStatusColor = v34.Theme.OfflineStatus.Color
		local OfflineStatusTransparency = v34.Theme.OfflineStatus.Transparency
		local n1 = 12
		local offlineStatusLabel = v39.offlineStatusLabel
		local TextMuted = v34.Theme.TextMuted
		local userPresenceType, lastLocation

		if v41 then
			userPresenceType = v41.userPresenceType
			lastLocation = v41.lastLocation
		else
			userPresenceType = if not t1.userPresenceType then PresenceType.Offline else PresenceType[t1.userPresenceType]
			lastLocation = t1.lastLocation or ""
		end

		if userPresenceType == PresenceType.Online then
			v59 = Images["component_assets/circle_16"]
			OfflineStatusColor = v34.Theme.OnlineStatus.Color
			OfflineStatusTransparency = v34.Theme.OnlineStatus.Transparency
			offlineStatusLabel = v39.onlineStatusLabel
			TextMuted = v34.Theme.TextMuted
			n1 = 12
		elseif userPresenceType == PresenceType.InGame then
			v59 = Images["icons/menu/games_small"]
			OfflineStatusColor = v34.Theme.IconEmphasis.Color
			OfflineStatusTransparency = v34.Theme.IconEmphasis.Transparency
			offlineStatusLabel = lastLocation
			TextMuted = Theme.TextEmphasis
			n1 = 16
		elseif userPresenceType == PresenceType.InStudio then
			v59 = Images["icons/logo/studiologo_small"]
			OfflineStatusColor = v34.Theme.TextDefault.Color
			OfflineStatusTransparency = v34.Theme.TextDefault.Transparency
			offlineStatusLabel = v39.studioStatusLabel
			TextMuted = v34.Theme.TextMuted
			n1 = 16
		end

		return React.createElement(PlayerContext, {
			layoutOrder = 2,
			textHeight = 24,
			fontStyle = v34.Font.CaptionBody,
			icon = v59,
			iconColor = OfflineStatusColor,
			iconSize = UDim2.fromOffset(n1, n1),
			iconTransparency = OfflineStatusTransparency,
			onActivated = v51,
			text = offlineStatusLabel,
			textColorStyle = TextMuted
		})
	end, {
		v41,
		v34,
		v39.offlineStatusLabel,
		v39.onlineStatusLabel,
		v39.studioStatusLabel
	})
	local v53 = React.useCallback(function() -- line: 184
		-- upvalues: v33 (copy), EventNamesEnum (copy), t2 (copy), t1 (copy), Pages (copy), v37 (copy), OpenOrUpdateCFM (copy)
		v33.fireEvent(EventNamesEnum.PhoneBookPlayerMenuOpened, {
			eventTimestampMs = os.time() * 1000,
			friendUserId = t2.userId,
			searchQueryString = t1.searchQueryString,
			itemListIndex = t1.itemListIndex,
			isSuggestedUser = t1.isSuggestedUser,
			page = Pages.FriendList
		})
		v37(OpenOrUpdateCFM(t2))
	end, {
		t2.userId,
		t1.searchQueryString,
		t1.itemListIndex,
		t1.isSuggestedUser
	})

	return React.createElement(Interactable, {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 0, 0, 68 + vector2.Y * 2),
		BackgroundColor3 = Theme[v46].Color,
		BackgroundTransparency = Theme[v46].Transparency,
		BorderSizePixel = 0,
		LayoutOrder = t1.layoutOrder,
		onStateChanged = v48,
		AutoButtonColor = false,
		[React.Event.Activated] = v51
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, vector2.X),
			PaddingTop = UDim.new(0, vector2.Y)
		}),
		ProfileImage = React.createElement("ImageButton", {
			Size = UDim2.fromOffset(68, 68),
			Image = v49,
			[React.Event.MouseButton2Up] = v53,
			[React.Event.TouchTap] = v53,
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
					Text = t1.combinedName,
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
					Text = UserProfiles.Formatters.formatUsername(t1.userName),
					TextColor3 = Theme.TextDefault.Color,
					TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
					TextTransparency = Theme.TextDefault.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			PlayerContext = v52
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
		Divider = t1.showDivider and React.createElement("Frame", {
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, -1),
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = Theme.Divider.Color,
			BackgroundTransparency = Theme.Divider.Transparency
		}) or nil
	})
end

return FriendListItem
