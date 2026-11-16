local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t

local Foundation = require(CorePackages.Packages.Foundation)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagCoreUiMigrateUIBloxToFoundation = SharedFlags.FFlagCoreUiMigrateUIBloxToFoundation
local v

if FFlagCoreUiMigrateUIBloxToFoundation then
	v = Foundation.UNSTABLE.withCursorMigration
else
	v = UIBlox.App.SelectionImage.withSelectionCursorProvider
end

local v2

if FFlagCoreUiMigrateUIBloxToFoundation then
	v2 = Foundation.Enums.CursorType
else
	v2 = UIBlox.App.SelectionImage.CursorKind
end

local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle
local Images = UIBlox.App.ImageSet.Images

local parent = script.Parent.Parent.Parent

local withLocalization = require(parent.Localization.withLocalization)

local flags = parent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(flags.GetFFlagIGMGamepadSelectionHistory)
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local VoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicator)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)

local PlayerLabelV2 = require(parent.Components.PlayerLabelV2)
local PlayerContextualMenu = require(parent.Components.PlayerContextualMenu)

local FFlagLuaMenuPerfImprovements = require(parent.Flags.FFlagLuaMenuPerfImprovements)

local PageNavigationWatcher = require(parent.Components.PageNavigationWatcher)
local Divider = require(parent.Components.Divider)

local BarOnTopScrollingFrame = require(parent.Components.BarOnTopScrollingFrame)
local Page = require(parent.Components.Page)

local CloseMenu = require(parent.Thunks.CloseMenu)

local Assets = require(parent.Resources.Assets)

local Constants2 = require(parent.Resources.Constants)
local SendAnalytics = require(parent.Utility.SendAnalytics)

local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local UnblockPlayer = require(RobloxGui.Modules.PlayerList.Thunks.UnblockPlayer)
local TrustAndSafety = require(RobloxGui.Modules.TrustAndSafety)
local onBlockButtonActivated = require(RobloxGui.Modules.Settings.onBlockButtonActivated)

local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v3 = CoreScriptsInitializer.CoreLogger:new(script.Name)

local v4 = settings():GetFVariable("InGameGlobalGuiInset") + 24

local extended = Roact.PureComponent:extend("PlayersPage")

extended.validateProps = t.strictInterface({
	isMenuOpen = t.boolean,
	voiceEnabled = t.optional(t.boolean),
	inspectMenuEnabled = t.boolean,
	friends = t.map(t.integer, t.enum(Enum.FriendStatus)),
	closeMenu = t.callback,
	unblockPlayer = t.callback,
	pageTitle = t.string,
	screenSize = t.Vector2,
	currentPage = t.optional(t.string),
	isRespawnDialogOpen = t.optional(t.boolean),
	isReportDialogOpen = t.optional(t.boolean),
	isGamepadLastInput = t.optional(t.boolean),
	isCurrentZoneActive = t.optional(t.boolean)
})

function extended:init()
	self:setState({
		players = Players:GetPlayers(),
		selectedPlayer = nil,
		selectedPlayerPosition = Vector2.new(0, 0),
		pageSizeY = 0,
		voiceChatEnabled = false,
		allMuted = false,
		selectedPlayerRef = nil,
		firstPlayerRef = nil
	})

	function self.setSelectedPlayerRef(selectedPlayerRef)
		if GetFFlagIGMGamepadSelectionHistory() then
			self:setState({ selectedPlayerRef = selectedPlayerRef })
		else
			self:setState({ selectedPlayerRef = selectedPlayerRef, firstPlayerRef = Roact.None })
		end
	end

	function self.setFirstPlayerRef(firstPlayerRef)
		self:setState({ firstPlayerRef = firstPlayerRef })
	end

	if FFlagLuaMenuPerfImprovements then
		function self.positionChanged(p)
			self:setState({ selectedPlayerPosition = p.AbsolutePosition })
		end
		function self.toggleMoreActions(p)
			local playerByUserId = Players:GetPlayerByUserId(p)

			if self.state.selectedPlayer == playerByUserId then
				self:setState({ selectedPlayer = Roact.None })
			else
				self:setState({ selectedPlayer = playerByUserId })
			end
		end
	end
end

local function sortPlayers(p, p2): boolean
	return p.Name:lower() < p2.Name:lower()
end

function extended:renderListEntries(p)
	local sorted = Cryo.List.sort(p, sortPlayers)

	local children = {
		ListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}
	local count = 0

	for k, selectedPlayer in pairs(sorted) do
		local v5

		if FFlagLuaMenuPerfImprovements then
			v5 = selectedPlayer.UserId or k
		else
			v5 = k
		end

		local positionChanged = FFlagLuaMenuPerfImprovements and self.positionChanged or function(p2)
			self:setState({ selectedPlayerPosition = p2.AbsolutePosition })
		end

		local toggleMoreActions = FFlagLuaMenuPerfImprovements and self.toggleMoreActions or function()
			if self.state.selectedPlayer == selectedPlayer then
				self:setState({ selectedPlayer = Roact.None })
			else
				self:setState({ selectedPlayer = selectedPlayer })
			end
		end

		local v6 = nil

		if k == 1 and not self.state.selectedPlayer then
			v6 = self.setFirstPlayerRef
		elseif self.state.selectedPlayer == selectedPlayer then
			v6 = self.setSelectedPlayerRef
		end

		local iconStyle = selectedPlayer == Players.LocalPlayer and "MicLight" or "SpeakerLight"

		local v7 = "player_" .. v5
		local createElement = Roact.createElement
		local v8 = {
			username = selectedPlayer.Name,
			displayName = selectedPlayer.DisplayName,
			userId = selectedPlayer.UserId,
			isOnline = true,
			isSelected = self.state.selectedPlayer == selectedPlayer,
			LayoutOrder = count,
			onActivated = toggleMoreActions,
			[Roact.Change.AbsolutePosition] = self.state.selectedPlayer == selectedPlayer and positionChanged or nil,
			[Roact.Ref] = v6
		}

		local icon = self.props.voiceEnabled

		if icon then
			if selectedPlayer == Players.LocalPlayer then
				icon = false
			else
				icon = Roact.createElement(VoiceIndicator, {
					userId = tostring(selectedPlayer.UserId),
					hideOnError = true,
					iconStyle = iconStyle,
					onClicked = toggleMoreActions
				})
			end
		end

		children[v7] = createElement(PlayerLabelV2, v8, { Icon = icon })

		count += 1

		if not (k < #sorted) then
			continue
		end

		children["divider_" .. v5] = Roact.createElement(Divider, {
			LayoutOrder = count,
			Size = UDim2.new(1, -104, 0, 1)
		})

		count += 1
	end

	return children
end

function extended:getMoreActions(data)
	local moreActions = {}

	if self.state.selectedPlayer == nil then
		return moreActions
	end

	if self.state.selectedPlayer ~= Players.LocalPlayer then
		local v5 = Enum.FriendStatus.Unknown

		if self.props.friends[self.state.selectedPlayer.UserId] then
			v5 = self.props.friends[self.state.selectedPlayer.UserId]
		end

		local text = data.addFriend
		local icon = Images["icons/actions/friends/friendAdd"]

		if v5 == Enum.FriendStatus.Friend then
			text = data.unfriend
			icon = Images["icons/actions/friends/friendRemove"]
		elseif v5 == Enum.FriendStatus.FriendRequestSent then
			text = data.cancelFriend
			icon = Images["icons/actions/friends/friendRemove"]
		elseif v5 == Enum.FriendStatus.FriendRequestReceived then
			text = data.acceptFriend
		end

		table.insert(moreActions, {
			text = text,
			icon = icon,
			onActivated = function()
				local selectedPlayer = self.state.selectedPlayer

				if v5 == Enum.FriendStatus.Friend or v5 == Enum.FriendStatus.FriendRequestSent then
					Players.LocalPlayer:RevokeFriendship(selectedPlayer)
				else
					Players.LocalPlayer:RequestFriendship(selectedPlayer)
					RbxAnalyticsService:ReportCounter("PlayersMenu-RequestFriendship")
					SendAnalytics(Constants2.AnalyticsMenuActionName, Constants2.AnalyticsRequestFriendName, {})
				end

				self:setState({ selectedPlayer = Roact.None })
			end
		})
	end

	table.insert(moreActions, {
		text = data.viewAvatar,
		icon = Assets.Images.ViewAvatar,
		onActivated = function()
			GuiService:InspectPlayerFromUserIdWithCtx(self.state.selectedPlayer.UserId, "escapeMenu")
			self:setState({ selectedPlayer = Roact.None })

			self.props.closeMenu()
			SendAnalytics(Constants2.AnalyticsMenuActionName, Constants2.AnalyticsExamineAvatarName, {})
		end
	})

	if self.state.selectedPlayer == Players.LocalPlayer then
		return moreActions
	end

	table.insert(moreActions, {
		text = data.reportAbuse,
		icon = Images["icons/actions/feedback"],
		onActivated = function()
			local selectedPlayer = self.state.selectedPlayer
			TrustAndSafety.openReportDialogForPlayer(selectedPlayer, Constants2.AnalyticsMenuActionName)
			self:setState({ selectedPlayer = Roact.None })
		end
	})

	local v5 = self.props.voiceEnabled and default.participants[tostring(self.state.selectedPlayer.UserId)]

	if v5 then
		local isMutedLocally = v5.isMutedLocally
		table.insert(moreActions, {
			text = isMutedLocally and "Unmute Player" or "Mute Player",
			icon = default:GetIcon(isMutedLocally and "Unmute" or "Mute", "Misc"),
			onActivated = function()
				local selectedPlayer = self.state.selectedPlayer
				v3:debug("Muting Player {}", selectedPlayer.UserId)
				default:ToggleMutePlayer(selectedPlayer.UserId, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

				self:setState({ selectedPlayer = Roact.None })
			end
		})
	end

	local selectedPlayer = self.state.selectedPlayer
	local isPlayerBlockedByUserId = BlockingUtility:IsPlayerBlockedByUserId(selectedPlayer.UserId)
	table.insert(moreActions, {
		text = isPlayerBlockedByUserId and data.unblockPlayer or data.blockPlayer,
		icon = Images["icons/actions/block"],
		onActivated = function()
			if isPlayerBlockedByUserId then
				self.props.unblockPlayer(selectedPlayer)
			else
				onBlockButtonActivated(selectedPlayer, nil, self.__componentName)
			end

			self:setState({ selectedPlayer = Roact.None })
		end
	})

	return moreActions
end

function extended:renderFocusHandler(isFocused)
	local shouldForgetPreviousSelection

	if GetFFlagIGMGamepadSelectionHistory() then
		shouldForgetPreviousSelection = self.props.currentPage == Constants2.MainPagePageKey
			or not self.props.isCurrentZoneActive
	end

	local createElement = Roact.createElement

	if isFocused then
		if self.props.currentPage == "Players" then
			isFocused = self.props.isMenuOpen
				and not self.props.isReportDialogOpen
				and not self.state.selectedPlayer
				and (self.state.selectedPlayerRef or self.state.firstPlayerRef) ~= nil
		else
			isFocused = false
		end
	end

	return createElement(FocusHandler, {
		isFocused = isFocused,
		shouldForgetPreviousSelection = shouldForgetPreviousSelection,
		didFocus = GetFFlagIGMGamepadSelectionHistory() and function(p)
			GuiService.SelectedCoreObject = p or self.state.firstPlayerRef
		end or function()
			GuiService.SelectedCoreObject = self.state.selectedPlayerRef or self.state.firstPlayerRef
		end
	})
end

function extended:renderWithLocalizedAndSelectionCursor(p, callback)
	local moreActions, xOffset, yOffset

	if self.state.selectedPlayer == nil then
		moreActions = {}
		xOffset = 0
		yOffset = 0
	else
		moreActions = self:getMoreActions(p)
		local v5 = #moreActions * 56
		local x = self.props.screenSize.X
		local y = self.props.screenSize.Y

		if self.state.selectedPlayerPosition.Y + v5 + v4 < y then
			yOffset = self.state.selectedPlayerPosition.Y
		else
			yOffset = y - v5 - v4
		end

		if self.state.selectedPlayerPosition.X + 400 + 20 + 352 + 24 <= x then
			xOffset = self.state.selectedPlayerPosition.X + 400 + 20
		else
			xOffset = x - 352 - 24
		end
	end

	local isCurrentZoneActive = self.props.isGamepadLastInput
		and not self.props.isRespawnDialogOpen
		and self.props.isCurrentZoneActive
	local moreActionsMenu

	if self.state.selectedPlayer then
		moreActionsMenu = Roact.createElement(PlayerContextualMenu, {
			moreActions = moreActions,
			actionWidth = 352,
			xOffset = xOffset,
			yOffset = yOffset,
			canCaptureFocus = isCurrentZoneActive,
			onClose = function()
				self:setState({ selectedPlayer = Roact.None })
			end
		}) or nil
	else
		moreActionsMenu = nil
	end

	local createElement = Roact.createElement
	local v5 = { pageTitle = self.props.pageTitle, titleChildren = 0 }
	local titleChildren = self.props.voiceEnabled

	if titleChildren then
		titleChildren = Roact.createElement("ImageButton", {
			Size = UDim2.fromOffset(36, 36),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			BorderSizePixel = 0,
			Position = UDim2.new(1, 4, 0.5, 0),
			Image = default:GetIcon(self.state.allMuted and "UnmuteAll" or "MuteAll", "Misc"),
			[Roact.Event.Activated] = function()
				default:MuteAll(not self.state.allMuted, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
				self:setState({
					allMuted = not self.state.allMuted
				})
			end,
			SelectionImageObject = callback(v2.RoundedRect)
		})
	end

	v5.titleChildren = titleChildren
	return createElement(Page, v5, {
		PlayerListContent = withFoundationOrUIBloxStyle(function(_)
			return {}
		end, function(_)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				[Roact.Change.AbsoluteSize] = function(p2)
					self:setState({ pageSizeY = p2.AbsoluteSize.Y })
				end
			}, {
				PlayerList = Roact.createElement(BarOnTopScrollingFrame, {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					CanvasSize = UDim2.new(1, 0, 0, #self.state.players * 72),
					ScrollingEnabled = self.state.selectedPlayer == nil
				}, self:renderListEntries(self.state.players)),
				MoreActionsMenu = moreActionsMenu
			})
		end),
		FocusHandler = self:renderFocusHandler(isCurrentZoneActive),
		Watcher = Roact.createElement(PageNavigationWatcher, {
			desiredPage = "Players",
			onNavigateTo = function()
				self:setState({ players = Players:GetPlayers() })
			end,
			onNavigateAway = function()
				self:setState({ selectedPlayer = Roact.None })
			end
		})
	})
end

function extended:renderWithLocalized(p)
	return v(function(p2)
		return self:renderWithLocalizedAndSelectionCursor(p, p2)
	end)
end

function extended:render()
	return withLocalization({
		addFriend = "CoreScripts.InGameMenu.Actions.AddFriend",
		acceptFriend = "CoreScripts.InGameMenu.Actions.AcceptFriend",
		unfriend = "CoreScripts.InGameMenu.Actions.Unfriend",
		cancelFriend = "CoreScripts.InGameMenu.Actions.CancelFriend",
		viewAvatar = "CoreScripts.InGameMenu.Actions.ViewAvatar",
		reportAbuse = "CoreScripts.InGameMenu.Actions.ReportAbuse",
		blockPlayer = "CoreScripts.InGameMenu.Actions.BlockPlayer",
		unblockPlayer = "CoreScripts.InGameMenu.Actions.UnblockPlayer"
	})(function(p)
		return self:renderWithLocalized(p)
	end)
end

function extended.didUpdate(object, p, _)
	if object.props.isMenuOpen and not p.isMenuOpen then
		object:setState({ players = Players:GetPlayers(), selectedPlayer = Roact.None })
	end

	local selectedPlayerRef = object.state.selectedPlayerRef

	if selectedPlayerRef and object.state.selectedPlayerPosition ~= selectedPlayerRef.AbsolutePosition then
		object:setState({ selectedPlayerPosition = selectedPlayerRef.AbsolutePosition })
	end
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return {
		isMenuOpen = data.isMenuOpen,
		voiceEnabled = data.voiceState.voiceEnabled,
		friends = data.friends,
		inspectMenuEnabled = data.displayOptions.inspectMenuEnabled,
		screenSize = data.screenSize,
		currentPage = data.menuPage,
		isRespawnDialogOpen = data.respawn.dialogOpen,
		isReportDialogOpen = data.report.dialogOpen or data.report.reportSentOpen,
		isGamepadLastInput = data.displayOptions.inputType == Constants2.InputType.Gamepad,
		isCurrentZoneActive = data.currentZone == 1
	}
end, function(callback)
	return {
		closeMenu = function()
			callback(CloseMenu)
		end,
		unblockPlayer = function(p)
			return callback(UnblockPlayer(p))
		end
	}
end)(extended)
