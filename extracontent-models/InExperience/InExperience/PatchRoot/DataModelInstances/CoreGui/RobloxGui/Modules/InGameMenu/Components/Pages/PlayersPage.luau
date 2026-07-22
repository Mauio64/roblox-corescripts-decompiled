local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local Cryo = InGameMenuDependencies.Cryo
local RoactRodux = InGameMenuDependencies.RoactRodux
local t = InGameMenuDependencies.t
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagCoreUiMigrateUIBloxToFoundation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagCoreUiMigrateUIBloxToFoundation
local v14 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.withSelectionCursorProvider else Foundation.UNSTABLE.withCursorMigration
local v15 = if not FFlagCoreUiMigrateUIBloxToFoundation then UIBlox.App.SelectionImage.CursorKind else Foundation.Enums.CursorType
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local Images = UIBlox.App.ImageSet.Images
local ParentParent = script.Parent.Parent.Parent
local withLocalization = require(ParentParent.Localization.withLocalization)
local Flags = ParentParent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(Flags.GetFFlagIGMGamepadSelectionHistory)
local FocusHandler = require(script.Parent.Parent.Connection.FocusHandler)
local VoiceIndicator = require(RobloxGui.Modules.VoiceChat.Components.VoiceIndicator)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local PlayerLabelV2 = require(ParentParent.Components.PlayerLabelV2)
local PlayerContextualMenu = require(ParentParent.Components.PlayerContextualMenu)
local FFlagLuaMenuPerfImprovements = require(ParentParent.Flags.FFlagLuaMenuPerfImprovements)
local PageNavigationWatcher = require(ParentParent.Components.PageNavigationWatcher)
local Divider = require(ParentParent.Components.Divider)
local BarOnTopScrollingFrame = require(ParentParent.Components.BarOnTopScrollingFrame)
local Page = require(ParentParent.Components.Page)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local Assets = require(ParentParent.Resources.Assets)
local Constants2 = require(ParentParent.Resources.Constants)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local UnblockPlayer = require(RobloxGui.Modules.PlayerList.Thunks.UnblockPlayer)
local TrustAndSafety = require(RobloxGui.Modules.TrustAndSafety)
local onBlockButtonActivated = require(RobloxGui.Modules.Settings.onBlockButtonActivated)
local v41 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local v42 = settings():GetFVariable("InGameGlobalGuiInset") + 24
local v43 = Roact.PureComponent:extend("PlayersPage")

v43.validateProps = t.strictInterface({
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

function v43.init(p1) -- line: 96
	-- upvalues: Players (copy), GetFFlagIGMGamepadSelectionHistory (copy), Roact (copy), FFlagLuaMenuPerfImprovements (copy)
	p1:setState({
		selectedPlayer = nil,
		pageSizeY = 0,
		voiceChatEnabled = false,
		allMuted = false,
		selectedPlayerRef = nil,
		firstPlayerRef = nil,
		players = Players:GetPlayers(),
		selectedPlayerPosition = Vector2.new(0, 0)
	})

	function p1.setSelectedPlayerRef(p2) -- line: 108
		-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), p1 (copy), Roact (copy)
		if GetFFlagIGMGamepadSelectionHistory() then
			p1:setState({
				selectedPlayerRef = p2
			})

			return
		end

		p1:setState({
			selectedPlayerRef = p2,
			firstPlayerRef = Roact.None
		})
	end
	function p1.setFirstPlayerRef(p3) -- line: 121
		-- upvalues: p1 (copy)
		p1:setState({
			firstPlayerRef = p3
		})
	end

	if FFlagLuaMenuPerfImprovements then
		function p1.positionChanged(p4) -- line: 128
			-- upvalues: p1 (copy)
			p1:setState({
				selectedPlayerPosition = p4.AbsolutePosition
			})
		end
		function p1.toggleMoreActions(p5) -- line: 133
			-- upvalues: Players (copy), p1 (copy), Roact (copy)
			local PlayerByUserId = Players:GetPlayerByUserId(p5)

			if PlayerByUserId == p1.state.selectedPlayer then
				p1:setState({
					selectedPlayer = Roact.None
				})

				return
			end

			p1:setState({
				selectedPlayer = PlayerByUserId
			})
		end
	end
end

local function sortPlayers(p6, p7) -- line: 148
	return p6.Name:lower() < p7.Name:lower()
end

function v43.renderListEntries(p8, p9) -- line: 152
	-- upvalues: Cryo (copy), sortPlayers (copy), Roact (copy), FFlagLuaMenuPerfImprovements (copy), Players (copy), PlayerLabelV2 (copy), VoiceIndicator (copy), Divider (copy)
	local v50 = Cryo.List.sort(p9, sortPlayers)
	local n1 = 0
	local t1 = {
		ListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right
		})
	}

	for k, v in pairs(v50) do
		local v55 = FFlagLuaMenuPerfImprovements and v.UserId or k
		local v56 = FFlagLuaMenuPerfImprovements and p8.positionChanged or function(p10) -- line: 167
			-- upvalues: p8 (copy)
			p8:setState({
				selectedPlayerPosition = p10.AbsolutePosition
			})
		end
		local v57 = FFlagLuaMenuPerfImprovements and p8.toggleMoreActions or function() -- line: 174
			-- upvalues: p8 (copy), v (copy), Roact (copy)
			if p8.state.selectedPlayer == v then
				p8:setState({
					selectedPlayer = Roact.None
				})

				return
			end

			p8:setState({
				selectedPlayer = v
			})
		end
		local setFirstPlayerRef = nil

		if k == 1 and not p8.state.selectedPlayer then
			setFirstPlayerRef = p8.setFirstPlayerRef
		elseif v == p8.state.selectedPlayer then
			setFirstPlayerRef = p8.setSelectedPlayerRef
		end

		local v59 = v == Players.LocalPlayer and "MicLight" or "SpeakerLight"

		t1["player_" .. v55] = Roact.createElement(PlayerLabelV2, {
			username = v.Name,
			displayName = v.DisplayName,
			userId = v.UserId,
			isOnline = true,
			isSelected = v == p8.state.selectedPlayer,
			LayoutOrder = n1,
			onActivated = v57,
			[Roact.Change.AbsolutePosition] = v == p8.state.selectedPlayer and v56 or nil,
			[Roact.Ref] = setFirstPlayerRef
		}, {
			Icon = p8.props.voiceEnabled and (v ~= Players.LocalPlayer and Roact.createElement(VoiceIndicator, {
				hideOnError = true,
				userId = tostring(v.UserId),
				iconStyle = v59,
				onClicked = v57
			}))
		})
		n1 += 1

		if k < #v50 then
			t1["divider_" .. v55] = Roact.createElement(Divider, {
				LayoutOrder = n1,
				Size = UDim2.new(1, -104, 0, 1)
			})
			n1 += 1
		end
	end

	return t1
end
function v43.getMoreActions(p11, p12) -- line: 231
	-- upvalues: Players (copy), Images (copy), RbxAnalyticsService (copy), SendAnalytics (copy), Constants2 (copy), Roact (copy), Assets (copy), GuiService (copy), TrustAndSafety (copy), default (copy), v41 (copy), Constants (copy), BlockingUtility (copy), onBlockButtonActivated (copy)
	local t2 = {}

	if p11.state.selectedPlayer ~= nil then
		if p11.state.selectedPlayer ~= Players.LocalPlayer then
			local Unknown = Enum.FriendStatus.Unknown

			if p11.props.friends[p11.state.selectedPlayer.UserId] then
				Unknown = p11.props.friends[p11.state.selectedPlayer.UserId]
			end

			local addFriend = p12.addFriend
			local v65 = Images["icons/actions/friends/friendAdd"]

			if Unknown == Enum.FriendStatus.Friend then
				addFriend = p12.unfriend
				v65 = Images["icons/actions/friends/friendRemove"]
			elseif Unknown == Enum.FriendStatus.FriendRequestSent then
				addFriend = p12.cancelFriend
				v65 = Images["icons/actions/friends/friendRemove"]
			elseif Unknown == Enum.FriendStatus.FriendRequestReceived then
				addFriend = p12.acceptFriend
			end

			table.insert(t2, {
				text = addFriend,
				icon = v65,
				onActivated = function() -- line: 256
					-- upvalues: p11 (copy), Unknown (ref), Players (copy), RbxAnalyticsService (copy), SendAnalytics (copy), Constants2 (copy), Roact (copy)
					local selectedPlayer = p11.state.selectedPlayer

					if Unknown == Enum.FriendStatus.Friend or Unknown == Enum.FriendStatus.FriendRequestSent then
						Players.LocalPlayer:RevokeFriendship(selectedPlayer)
					else
						Players.LocalPlayer:RequestFriendship(selectedPlayer)
						RbxAnalyticsService:ReportCounter("PlayersMenu-RequestFriendship")
						SendAnalytics(Constants2.AnalyticsMenuActionName, Constants2.AnalyticsRequestFriendName, {})
					end

					p11:setState({
						selectedPlayer = Roact.None
					})
				end
			})
		end

		table.insert(t2, {
			text = p12.viewAvatar,
			icon = Assets.Images.ViewAvatar,
			onActivated = function() -- line: 278
				-- upvalues: GuiService (copy), p11 (copy), Roact (copy), SendAnalytics (copy), Constants2 (copy)
				GuiService:InspectPlayerFromUserIdWithCtx(p11.state.selectedPlayer.UserId, "escapeMenu")
				p11:setState({
					selectedPlayer = Roact.None
				})
				p11.props.closeMenu()
				SendAnalytics(Constants2.AnalyticsMenuActionName, Constants2.AnalyticsExamineAvatarName, {})
			end
		})

		if p11.state.selectedPlayer ~= Players.LocalPlayer then
			table.insert(t2, {
				text = p12.reportAbuse,
				icon = Images["icons/actions/feedback"],
				onActivated = function() -- line: 292
					-- upvalues: p11 (copy), TrustAndSafety (copy), Constants2 (copy), Roact (copy)
					local selectedPlayer = p11.state.selectedPlayer

					TrustAndSafety.openReportDialogForPlayer(selectedPlayer, Constants2.AnalyticsMenuActionName)
					p11:setState({
						selectedPlayer = Roact.None
					})
				end
			})

			if p11.props.voiceEnabled then
				local v66 = default.participants[tostring(p11.state.selectedPlayer.UserId)]

				if v66 then
					local isMutedLocally = v66.isMutedLocally

					table.insert(t2, {
						text = not isMutedLocally and "Mute Player" or "Unmute Player",
						icon = default:GetIcon(not isMutedLocally and "Mute" or "Unmute", "Misc"),
						onActivated = function() -- line: 309
							-- upvalues: p11 (copy), v41 (copy), default (copy), Constants (copy), Roact (copy)
							local selectedPlayer = p11.state.selectedPlayer

							v41:debug("Muting Player {}", selectedPlayer.UserId)
							default:ToggleMutePlayer(selectedPlayer.UserId, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
							p11:setState({
								selectedPlayer = Roact.None
							})
						end
					})
				end
			end

			local selectedPlayer = p11.state.selectedPlayer
			local v69 = BlockingUtility:IsPlayerBlockedByUserId(selectedPlayer.UserId)

			table.insert(t2, {
				text = v69 and p12.unblockPlayer or p12.blockPlayer,
				icon = Images["icons/actions/block"],
				onActivated = function() -- line: 329
					-- upvalues: v69 (copy), p11 (copy), selectedPlayer (copy), onBlockButtonActivated (copy), Roact (copy)
					if v69 then
						p11.props.unblockPlayer(selectedPlayer)
					else
						onBlockButtonActivated(selectedPlayer, nil, p11.__componentName)
					end

					p11:setState({
						selectedPlayer = Roact.None
					})
				end
			})
		end
	end

	return t2
end
function v43.renderFocusHandler(p13, p14) -- line: 347
	-- upvalues: GetFFlagIGMGamepadSelectionHistory (copy), Constants2 (copy), Roact (copy), FocusHandler (copy), GuiService (copy)
	local v72 = nil

	if GetFFlagIGMGamepadSelectionHistory() then
		v72 = p13.props.currentPage == Constants2.MainPagePageKey or not p13.props.isCurrentZoneActive
	end

	return Roact.createElement(FocusHandler, {
		isFocused = p14 and (p13.props.currentPage == "Players" and (p13.props.isMenuOpen and (not p13.props.isReportDialogOpen and (not p13.state.selectedPlayer and (p13.state.selectedPlayerRef or p13.state.firstPlayerRef) ~= nil)))),
		shouldForgetPreviousSelection = v72,
		didFocus = GetFFlagIGMGamepadSelectionHistory() and function(p15) -- line: 363
			-- upvalues: GuiService (copy), p13 (copy)
			GuiService.SelectedCoreObject = p15 or p13.state.firstPlayerRef
		end or function() -- line: 367
			-- upvalues: GuiService (copy), p13 (copy)
			GuiService.SelectedCoreObject = p13.state.selectedPlayerRef or p13.state.firstPlayerRef
		end
	})
end
function v43.renderWithLocalizedAndSelectionCursor(p16, p17, p18) -- line: 374
	-- upvalues: v42 (copy), Roact (copy), PlayerContextualMenu (copy), Page (copy), default (copy), Constants (copy), v15 (copy), withFoundationOrUIBloxStyle (copy), BarOnTopScrollingFrame (copy), PageNavigationWatcher (copy), Players (copy)
	local n2 = 0
	local n3 = 0
	local t3 = {}

	if p16.state.selectedPlayer ~= nil then
		t3 = p16:getMoreActions(p17)

		local v79 = #t3 * 56
		local screenSizeX = p16.props.screenSize.X
		local screenSizeY = p16.props.screenSize.Y

		n2 = if not (screenSizeY > p16.state.selectedPlayerPosition.Y + v79 + v42) then screenSizeY - v79 - v42 else p16.state.selectedPlayerPosition.Y
		n3 = if not (screenSizeX >= p16.state.selectedPlayerPosition.X + 400 + 20 + 352 + 24) then screenSizeX - 352 - 24 else p16.state.selectedPlayerPosition.X + 400 + 20
	end

	local v82 = p16.props.isGamepadLastInput and (not p16.props.isRespawnDialogOpen and p16.props.isCurrentZoneActive)
	local u83 = p16.state.selectedPlayer and Roact.createElement(PlayerContextualMenu, {
		actionWidth = 352,
		moreActions = t3,
		xOffset = n3,
		yOffset = n2,
		canCaptureFocus = v82,
		onClose = function() -- line: 418
			-- upvalues: p16 (copy), Roact (copy)
			p16:setState({
				selectedPlayer = Roact.None
			})
		end
	}) or nil

	return Roact.createElement(Page, {
		pageTitle = p16.props.pageTitle,
		titleChildren = p16.props.voiceEnabled and Roact.createElement("ImageButton", {
			Size = UDim2.fromOffset(36, 36),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			BorderSizePixel = 0,
			Position = UDim2.new(1, 4, 0.5, 0),
			Image = default:GetIcon(not p16.state.allMuted and "MuteAll" or "UnmuteAll", "Misc"),
			[Roact.Event.Activated] = function() -- line: 433
				-- upvalues: default (copy), p16 (copy), Constants (copy)
				default:MuteAll(not p16.state.allMuted, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
				p16:setState({
					allMuted = not p16.state.allMuted
				})
			end,
			SelectionImageObject = p18(v15.RoundedRect)
		})
	}, {
		PlayerListContent = withFoundationOrUIBloxStyle(function(_) -- line: 442
			return {}
		end, function(_) -- line: 444
			-- upvalues: Roact (copy), p16 (copy), BarOnTopScrollingFrame (copy), u83 (ref)
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				[Roact.Change.AbsoluteSize] = function(p21) -- line: 449
					-- upvalues: p16 (copy)
					p16:setState({
						pageSizeY = p21.AbsoluteSize.Y
					})
				end
			}, {
				PlayerList = Roact.createElement(BarOnTopScrollingFrame, {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
					CanvasSize = UDim2.new(1, 0, 0, #p16.state.players * 72),
					ScrollingEnabled = p16.state.selectedPlayer == nil
				}, p16:renderListEntries(p16.state.players)),
				MoreActionsMenu = u83
			})
		end),
		FocusHandler = p16:renderFocusHandler(v82),
		Watcher = Roact.createElement(PageNavigationWatcher, {
			desiredPage = "Players",
			onNavigateTo = function() -- line: 468
				-- upvalues: p16 (copy), Players (copy)
				p16:setState({
					players = Players:GetPlayers()
				})
			end,
			onNavigateAway = function() -- line: 473
				-- upvalues: p16 (copy), Roact (copy)
				p16:setState({
					selectedPlayer = Roact.None
				})
			end
		})
	})
end
function v43.renderWithLocalized(p22, p23) -- line: 482
	-- upvalues: v14 (copy)
	return v14(function(p24) -- line: 483
		-- upvalues: p22 (copy), p23 (copy)
		return p22:renderWithLocalizedAndSelectionCursor(p23, p24)
	end)
end
function v43.render(p25) -- line: 488
	-- upvalues: withLocalization (copy)
	return withLocalization({
		addFriend = "CoreScripts.InGameMenu.Actions.AddFriend",
		acceptFriend = "CoreScripts.InGameMenu.Actions.AcceptFriend",
		unfriend = "CoreScripts.InGameMenu.Actions.Unfriend",
		cancelFriend = "CoreScripts.InGameMenu.Actions.CancelFriend",
		viewAvatar = "CoreScripts.InGameMenu.Actions.ViewAvatar",
		reportAbuse = "CoreScripts.InGameMenu.Actions.ReportAbuse",
		blockPlayer = "CoreScripts.InGameMenu.Actions.BlockPlayer",
		unblockPlayer = "CoreScripts.InGameMenu.Actions.UnblockPlayer"
	})(function(p26) -- line: 498
		-- upvalues: p25 (copy)
		return p25:renderWithLocalized(p26)
	end)
end
function v43.didUpdate(p27, p28, _) -- line: 503
	-- upvalues: Players (copy), Roact (copy)
	if p27.props.isMenuOpen and not p28.isMenuOpen then
		p27:setState({
			players = Players:GetPlayers(),
			selectedPlayer = Roact.None
		})
	end

	local selectedPlayerRef = p27.state.selectedPlayerRef

	if selectedPlayerRef and p27.state.selectedPlayerPosition ~= selectedPlayerRef.AbsolutePosition then
		p27:setState({
			selectedPlayerPosition = selectedPlayerRef.AbsolutePosition
		})
	end
end

return RoactRodux.UNSTABLE_connect2(function(p30, _) -- line: 521
	-- upvalues: Constants2 (copy)
	return {
		isMenuOpen = p30.isMenuOpen,
		voiceEnabled = p30.voiceState.voiceEnabled,
		friends = p30.friends,
		inspectMenuEnabled = p30.displayOptions.inspectMenuEnabled,
		screenSize = p30.screenSize,
		currentPage = p30.menuPage,
		isRespawnDialogOpen = p30.respawn.dialogOpen,
		isReportDialogOpen = p30.report.dialogOpen or p30.report.reportSentOpen,
		isGamepadLastInput = p30.displayOptions.inputType == Constants2.InputType.Gamepad,
		isCurrentZoneActive = p30.currentZone == 1
	}
end, function(p32) -- line: 534
	-- upvalues: CloseMenu (copy), UnblockPlayer (copy)
	return {
		closeMenu = function() -- line: 536
			-- upvalues: p32 (copy), CloseMenu (copy)
			p32(CloseMenu)
		end,
		unblockPlayer = function(p33) -- line: 540
			-- upvalues: p32 (copy), UnblockPlayer (copy)
			return p32(UnblockPlayer(p33))
		end
	}
end)(v43)
