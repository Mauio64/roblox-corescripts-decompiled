local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")
local default = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager).default

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")

local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local formatUsername = UserProfiles.Formatters.formatUsername
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local OpenTypeSupport = require(CorePackages.Packages.UIBlox).Utility.OpenTypeSupport
local Localization = require(CorePackages.Workspace.Packages.InExperienceLocales).Localization
local Utility = require(RobloxGui.Modules.Settings.Utility)
local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local ReportAbuseMenuNewContainerPage = require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuNewContainerPage)
local SocialUtil = require(RobloxGui.Modules:WaitForChild("SocialUtil"))
local Diag = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.Diag
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local GameInviteAnalytics = require(CorePackages.Workspace.Packages.GameInvite).GameInviteAnalytics
local onBlockButtonActivated = require(script:FindFirstAncestor("Settings").onBlockButtonActivated)
local VoiceAnalytics = require(script:FindFirstAncestor("Settings").Analytics.VoiceAnalytics)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local BlockingAnalytics = require(script:FindFirstAncestor("Settings").Analytics.BlockingAnalytics)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local v31 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)
local MenuButtonsContainer = require(RobloxGui.Modules.Settings.Components.MenuButtons.MenuButtonsContainer)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox
local GetFFlagLuaInExperienceCoreScriptsGameInviteUnification = require(RobloxGui.Modules.Flags.GetFFlagLuaInExperienceCoreScriptsGameInviteUnification)
local GameInviteAnalyticsManager = nil

if GetFFlagLuaInExperienceCoreScriptsGameInviteUnification() then
	GameInviteAnalyticsManager = require(CorePackages.Workspace.Packages.GameInvite).GameInviteAnalyticsManager
end

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport
local FFlagIEMFocusNavToButtons = SharedFlags.FFlagIEMFocusNavToButtons
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav
local FFlagEnableSideSheet = SharedFlags.FFlagEnableSideSheet
local FFlagRelocateMobileMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRelocateMobileMenuButtons)
local FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
local FFlagMenuButtonsMountWithIEM = require(RobloxGui.Modules.Settings.Flags.FFlagMenuButtonsMountWithIEM)
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagHidePeoplePageInviteFriends = SharedFlags.FFlagHidePeoplePageInviteFriends
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration
local UserProfileStore = UserProfiles.Stores.UserProfileStore
local _, result = pcall(function() -- line: 75
	return game:GetService("PlatformFriendsService")
end)
local Theme = require(script.Parent.Parent.Theme)
local Constants2 = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))
local uDim2 = UDim2.new(0.5, -10, 0, 52)
local LocalPlayer = Players.LocalPlayer

while not LocalPlayer do
	Players.ChildAdded:wait()
	LocalPlayer = Players.LocalPlayer
end

local GetFFlagVoiceChatUILogging = require(RobloxGui.Modules.Flags.GetFFlagVoiceChatUILogging)
local GetFFlagDefaultFriendingLabelTextNonEmpty = require(RobloxGui.Modules.Settings.Flags.GetFFlagDefaultFriendingLabelTextNonEmpty)
local GetFFlagEnableLeaveGameUpsellEntrypoint = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableLeaveGameUpsellEntrypoint)
local GetFFlagDestroyPlayerCardOnLeave = require(RobloxGui.Modules.Settings.Flags.GetFFlagDestroyPlayerCardOnLeave)
local GetFFlagEnableConsoleJoinVoice = require(RobloxGui.Modules.Settings.Flags.GetFFlagEnableConsoleJoinVoice)
local v61 = game:DefineFastFlag("EnableConsoleJoinVoiceTranslation", false)
local v62 = game:DefineFastFlag("CheckButtonFrameBeforeDestroy", false)
local isEngineTruncationEnabledForIngameSettings = require(RobloxGui.Modules.Flags.isEngineTruncationEnabledForIngameSettings)
local EngineFeature2 = game:GetEngineFeature("VoiceChatMultistreamSubscriptionsEnabled")
local v65 = game:DefineFastFlag("LuaFlagVoiceChatDisableSubscribeRetryForMultistream", true)
local v66 = game:DefineFastFlag("PlayerListRefactorUsernameFormatting", false)
local v67 = game:DefineFastFlag("CorrectlyPositionMuteButton", false)
local v68 = game:DefineFastFlag("OnlyCaptureFocusIfOnPlayerPage", false)
local v69 = game:DefineFastInt("SettingsHubPlayersButtonsResponsiveThreshold", 200)
local GetFFlagCleanupMuteSelfButton = require(RobloxGui.Modules.Settings.Flags.GetFFlagCleanupMuteSelfButton)
local v71 = game:DefineFastFlag("CheckForNilUserIdOnPlayerList", false)
local v72 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local MuteStatusIcons = default.MuteStatusIcons
local PlayerMuteStatusIcons = default.PlayerMuteStatusIcons

local function Initialize() -- line: 151
	-- upvalues: RobloxGui (copy), EngineFeature (copy), RbxAnalyticsService (copy), LocalizationService (copy), Localization (copy), uiblox (copy), BuilderIcons (copy), LocalPlayer (ref), Utility (copy), BlockingUtility (copy), Theme (copy), FFlagConnectionsToFriendsRename (copy), Constants2 (copy), GetFFlagDefaultFriendingLabelTextNonEmpty (copy), VoiceAnalytics (copy), v69 (copy), GetFFlagEnableConsoleJoinVoice (copy), GetFFlagCleanupMuteSelfButton (copy), v62 (copy), GuiService (copy), BlockingAnalytics (copy), onBlockButtonActivated (copy), RobloxTranslator (copy), MuteStatusIcons (copy), v65 (copy), EngineFeature2 (copy), default (copy), Constants (copy), Create (copy), FFlagEnableSideSheet (copy), FFlagRelocateMobileMenuButtons (copy), FIntRelocateMobileMenuButtonsVariant (copy), GetFFlagEnableLeaveGameUpsellEntrypoint (copy), FFlagIEMTabFocusNav (copy), PlayerMuteStatusIcons (copy), ReportAbuseMenuNewContainerPage (copy), v72 (copy), uDim2 (copy), v61 (copy), result (copy), FFlagIEMFocusNavToButtons (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), v71 (copy), UserProfileStore (copy), isEngineTruncationEnabledForIngameSettings (copy), v66 (copy), formatUsername (copy), Players (copy), UserInputService (copy), FFlagHidePeoplePageInviteFriends (copy), FFlagAddInviteFriendsIntegration (copy), RunService (copy), GetFFlagLuaInExperienceCoreScriptsGameInviteUnification (copy), GameInviteAnalyticsManager (ref), GameInviteAnalytics (copy), EventStream (copy), Diag (copy), SocialUtil (copy), GetFFlagVoiceChatUILogging (copy), v31 (copy), v67 (copy), Cryo (copy), v68 (copy), GetFFlagDestroyPlayerCardOnLeave (copy), ReactRoblox (copy), React (copy), MenuButtonsContainer (copy), FFlagMenuButtonsMountWithIEM (copy)
	local v76 = require(RobloxGui.Modules.Settings.SettingsPageFactory):CreateNewPage()

	v76.PageListLayout.Padding = UDim.new(0, 16)
	v76.playSessionId = ""

	if EngineFeature then
		v76.playSessionId = RbxAnalyticsService:GetPlaySessionId()
	end

	local t1 = {}
	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	if not t1[RobloxLocaleId] then
		t1[RobloxLocaleId] = Localization.new(RobloxLocaleId)
	end

	v76.TabHeader.Name = "PlayersTab"

	local v79 = uiblox["icons/menu/friends"]

	v76.TabHeader.TabLabel.Icon.Text = v79.name
	v76.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[v79.variant]
	v76.TabHeader.TabLabel.Title.Text = "People"

	local function getFriendStatus(p1) -- line: 177
		-- upvalues: LocalPlayer (ref)
		local ok, result2 = pcall(function() -- line: 178
			-- upvalues: LocalPlayer (ref), p1 (copy)
			return LocalPlayer:GetFriendStatus(p1)
		end)

		if ok then
			return result2
		end

		return Enum.FriendStatus.NotFriend
	end

	v76.Page.Name = "Players"

	local function showRightSideButtons(p2) -- line: 192
		-- upvalues: LocalPlayer (ref)
		return p2 and (p2 ~= LocalPlayer and (p2.UserId > 0 and LocalPlayer.UserId > 0))
	end
	local function useOptimizedPortraitLayout() -- line: 196
		-- upvalues: Utility (copy)
		return Utility:IsSmallTouchScreen() and Utility:IsPortrait()
	end
	local function getIsBlocked(p3) -- line: 200
		-- upvalues: BlockingUtility (copy)
		return BlockingUtility:IsPlayerBlockedByUserId(p3.UserId)
	end
	local function createFriendStatusTextLabel(p4, p5) -- line: 204
		-- upvalues: Theme (copy), FFlagConnectionsToFriendsRename (copy), t1 (copy), RobloxLocaleId (copy), Constants2 (copy), GetFFlagDefaultFriendingLabelTextNonEmpty (copy), LocalPlayer (ref), RbxAnalyticsService (copy), Utility (copy)
		if p4 == nil then
			return nil
		end

		local Frame = Instance.new("Frame")

		Frame.BackgroundTransparency = 1

		local TextButton = nil
		local u159 = nil

		if p4 == Enum.FriendStatus.Friend or p4 == Enum.FriendStatus.FriendRequestSent then
			TextButton = Instance.new("TextButton")
			TextButton.BackgroundTransparency = 1
			TextButton.FontSize = Theme.fontSize(Enum.FontSize.Size24)
			TextButton.Font = Theme.font(Enum.Font.SourceSans)
			TextButton.TextColor3 = Color3.new(1, 1, 1)
			TextButton.SelectionImageObject = Frame

			if p4 == Enum.FriendStatus.Friend then
				TextButton.Text = if not FFlagConnectionsToFriendsRename then t1[RobloxLocaleId]:Format(Constants2.ConnectionLocalizedKey) else t1[RobloxLocaleId]:Format(Constants2.FriendLocalizedKey)
			else
				TextButton.Text = "Request Sent"
			end
		elseif p4 == Enum.FriendStatus.Unknown or p4 == Enum.FriendStatus.NotFriend or p4 == Enum.FriendStatus.FriendRequestReceived then
			local v160, v161 = Utility:MakeStyledButton("FriendStatus", if not FFlagConnectionsToFriendsRename then t1[RobloxLocaleId]:Format(Constants2.AddConnectionLocalizedKey) else t1[RobloxLocaleId]:Format(Constants2.AddFriendLocalizedKey), UDim2.new(0, 182, 0, Theme.ButtonHeight), function() -- line: 233
				-- upvalues: TextButton (ref), u159 (ref), GetFFlagDefaultFriendingLabelTextNonEmpty (copy), FFlagConnectionsToFriendsRename (copy), t1 (copy), RobloxLocaleId (copy), Constants2 (copy), LocalPlayer (ref), p5 (copy), RbxAnalyticsService (copy)
				if TextButton and (u159 and u159.Text ~= "") then
					TextButton.ImageTransparency = 1
					u159.Text = ""

					if GetFFlagDefaultFriendingLabelTextNonEmpty() then
						u159.Text = if not FFlagConnectionsToFriendsRename then t1[RobloxLocaleId]:Format(Constants2.AddConnectionLocalizedKey) else t1[RobloxLocaleId]:Format(Constants2.AddFriendLocalizedKey)
					end

					if LocalPlayer and p5 then
						RbxAnalyticsService:ReportCounter("PlayersMenu-RequestFriendship")
						RbxAnalyticsService:SetRBXEventStream(Constants2.AnalyticsTargetName, Constants2.AnalyticsRequestFriendContext, Constants2.AnalyticsRequestFriendName, {
							category = "Game"
						})
						LocalPlayer:RequestFriendship(p5)
					end
				end
			end)

			TextButton = v160
			u159 = v161
			u159.ZIndex = 3
			u159.Position = u159.Position + UDim2.new(0, 0, 0, 1)
		end

		if TextButton then
			TextButton.Name = "FriendStatus"
			TextButton.ZIndex = 3
			TextButton.Size = UDim2.new(0, 150, 0, Theme.ButtonHeight)
			TextButton.Position = UDim2.new(1, -198, 0, 7)

			if u159 then
				u159.Position = UDim2.new(0, 0, 0, 0)
			end
		end

		return TextButton
	end
	local function createFriendStatusImageLabel(p6, p7) -- line: 281
		-- upvalues: Utility (copy), Theme (copy), LocalPlayer (ref), RbxAnalyticsService (copy), Constants2 (copy)
		if p6 == Enum.FriendStatus.Friend or p6 == Enum.FriendStatus.FriendRequestSent then
			local s1 = "icons/menu/friends"
			local n1 = 0

			if p6 ~= Enum.FriendStatus.Friend then
				s1 = "icons/actions/friends/friendAdd"
				n1 = 0.5
			end

			local v166, _ = Utility:MakeStyledImageButton("FriendStatus", s1, UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight), UDim2.new(0, 28, 0, 28))

			v166.Name = "FriendStatus"
			v166.Selectable = false
			v166.FriendStatusTextLabel.TextTransparency = n1

			return v166
		end

		if p6 == Enum.FriendStatus.Unknown or p6 == Enum.FriendStatus.NotFriend or p6 == Enum.FriendStatus.FriendRequestReceived then
			local u168 = nil
			local u169 = nil
			local v170, v171 = Utility:MakeStyledImageButton("FriendStatus", "icons/actions/friends/friendAdd", UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight), UDim2.new(0, 28, 0, 28), function() -- line: 307
				-- upvalues: u168 (ref), u169 (ref), LocalPlayer (ref), p7 (copy), RbxAnalyticsService (copy), Constants2 (copy)
				if u168 and (u169 and u168.ImageTransparency ~= 1) then
					u168.ImageTransparency = 1
					u169.TextTransparency = 1

					if LocalPlayer and p7 then
						RbxAnalyticsService:ReportCounter("PlayersMenu-RequestFriendship")
						RbxAnalyticsService:SetRBXEventStream(Constants2.AnalyticsTargetName, Constants2.AnalyticsRequestFriendContext, Constants2.AnalyticsRequestFriendName, {
							category = "Game"
						})
						LocalPlayer:RequestFriendship(p7)
					end
				end
			end)

			u168 = v170
			u169 = v171
			u168.Name = "FriendStatus"
			u168.Selectable = true

			return u168
		end

		return nil
	end

	local u86 = nil
	local u87 = nil
	local u88 = nil
	local u89 = nil
	local t2 = {}
	local v91 = VoiceAnalytics.new(RbxAnalyticsService, "Players")
	local u92 = false
	local t3 = {}
	local u94 = nil
	local u95 = nil

	local function u96() -- line: 352
		-- upvalues: v76 (copy), v69 (copy), t3 (ref)
		return v76.Page.AbsoluteSize.X < v69 * #t3
	end
	local function u97() -- line: 356
		-- upvalues: t3 (ref), u86 (ref), u87 (ref), u88 (ref), GetFFlagEnableConsoleJoinVoice (copy), u89 (ref), u92 (ref), u96 (ref), u94 (ref), GetFFlagCleanupMuteSelfButton (copy), u95 (ref), v62 (copy)
		t3 = {}

		if u86 then
			table.insert(t3, u86)
		end

		if u87 then
			table.insert(t3, u87)
		end

		if u88 then
			table.insert(t3, u88)
		end

		if GetFFlagEnableConsoleJoinVoice() and u89 then
			table.insert(t3, u89)
		end

		u92 = u96()

		if #t3 > 0 then
			local uDim2_2 = UDim2.new(1 / #t3, 0, 0, 52)
			local t4 = {
				Size = UDim2.new(1, (#t3 - 1) * -20, 0, 52),
				AutomaticSize = Enum.AutomaticSize.None
			}
			local t5 = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20)
			}

			if u92 then
				uDim2_2 = UDim2.new(1, 0, 0, 52)
				t4 = {
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}
				t5 = {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 16)
				}
			end

			local n2 = 1

			for _, v177 in t3 do
				v177.Size = uDim2_2
				v177.Parent = u94
				v177.LayoutOrder = n2
				n2 += 1
			end

			for v178, v179 in t5 do
				if GetFFlagCleanupMuteSelfButton() then
					if u95 then
						u95[v178] = v179
					end
				else
					u95[v178] = v179
				end
			end

			for v180, v181 in t4 do
				if GetFFlagCleanupMuteSelfButton() then
					if u94 then
						u94[v180] = v181
					end
				else
					u94[v180] = v181
				end
			end

			return
		end

		if v62 then
			if u94 then
				u94:Destroy()
				u94 = nil

				return
			end
		else
			u94:Destroy()
			u94 = nil
		end
	end
	local function getDisplayNameLabel(p8) -- line: 447
		if p8 and p8.Parent then
			return p8:FindFirstChild("DisplayNameLabel")
		end

		return nil
	end
	local function getInExperienceCombinedName(p9) -- line: 454
		if #p9 == 0 then
			return ""
		end

		local v184 = p9[1]

		if v184 == nil then
			return ""
		end

		local names = v184.names

		if names == nil then
			return ""
		end

		return names.getInExperienceCombinedName(false)
	end
	local function resizeFriendButton(p10, p11, p12, p13) -- line: 469
		-- upvalues: LocalPlayer (ref), BlockingUtility (copy), createFriendStatusImageLabel (copy), createFriendStatusTextLabel (copy), Utility (copy)
		local FriendStatus = p10:FindFirstChild("FriendStatus")

		if FriendStatus and p12 == p13 then
			return
		end

		if FriendStatus then
			FriendStatus:Destroy()
			FriendStatus = nil
		end

		local v191 = nil

		if p11 and (p11 ~= LocalPlayer and (p11.UserId > 0 and LocalPlayer.UserId > 0)) then
			local ok, result3 = pcall(function() -- line: 178
				-- upvalues: LocalPlayer (ref), p11 (copy)
				return LocalPlayer:GetFriendStatus(p11)
			end)

			v191 = if not ok then Enum.FriendStatus.NotFriend else result3
		end

		if BlockingUtility:IsPlayerBlockedByUserId(p11.UserId) == false then
			FriendStatus = if not p12 then createFriendStatusTextLabel(v191, p11) else createFriendStatusImageLabel(v191, p11)
		end

		if FriendStatus then
			FriendStatus.Name = "FriendStatus"
			FriendStatus.LayoutOrder = 5
			FriendStatus.Selectable = true

			local v194 = "utility-focus-state" .. "-friendstatuslabel-" .. p11.Name

			Utility:MakeFocusState(FriendStatus, v194)
			FriendStatus.Parent = p10
		end
	end
	local function friendStatusCreate(p14, p15) -- line: 503
		-- upvalues: GuiService (copy), u86 (ref), resizeFriendButton (copy), Utility (copy)
		local RightSideButtons = nil

		if p14 then
			RightSideButtons = p14:FindFirstChild("RightSideButtons")
		end

		if RightSideButtons then
			for _, child in pairs(RightSideButtons:GetChildren()) do
				if child and child.Name == "FriendStatus" then
					if child == GuiService.SelectedCoreObject then
						GuiService.SelectedCoreObject = u86
					end

					child:Destroy()
				end
			end

			resizeFriendButton(RightSideButtons, p15, Utility:IsPortrait(), nil)
		end
	end

	LocalPlayer.FriendStatusChanged:connect(function(p16, _) -- line: 525
		-- upvalues: v76 (copy), friendStatusCreate (copy)
		if p16 then
			local v202 = v76.Page:FindFirstChild("PlayerLabel" .. p16.Name)

			if v202 then
				friendStatusCreate(v202, p16)
			end
		end
	end)

	local resizeBlockButton = nil
	local trySelection = nil
	local v104 = BlockingAnalytics.new(LocalPlayer.UserId, {
		EventStream = RbxAnalyticsService
	})

	local function createBlockButton(p18, p19, p20, _) -- line: 538
		-- upvalues: BlockingUtility (copy), resizeBlockButton (ref), resizeFriendButton (copy), trySelection (ref), GuiService (copy), onBlockButtonActivated (copy), v104 (copy), Constants2 (copy), Utility (copy), RobloxTranslator (copy), Theme (copy)
		local function updateBlockButton(p22) -- line: 541
			-- upvalues: resizeBlockButton (ref), p18 (copy), p19 (copy), p20 (copy), resizeFriendButton (copy), trySelection (ref)
			local v377 = resizeBlockButton(p18, p19, p20, not p20)

			resizeFriendButton(p18, p19, p20, not p20)

			if p22 then
				trySelection(v377)
			end
		end
		local function blockUser() -- line: 549
			-- upvalues: GuiService (copy), onBlockButtonActivated (copy), p19 (copy), v104 (copy), Constants2 (copy), resizeBlockButton (ref), p18 (copy), p20 (copy), resizeFriendButton (copy), trySelection (ref)
			local v378 = GuiService.SelectedCoreObject ~= nil or GuiService.SelectedObject ~= nil

			onBlockButtonActivated(p19, v104, Constants2.AnalyticsInGameMenuName):andThen(function() -- line: 551
				-- upvalues: v378 (copy), resizeBlockButton (ref), p18 (copy), p19 (copy), p20 (copy), resizeFriendButton (copy), trySelection (ref)
				local v452 = v378
				local v453 = resizeBlockButton(p18, p19, p20, not p20)

				resizeFriendButton(p18, p19, p20, not p20)

				if v452 then
					trySelection(v453)
				end
			end)
		end
		local function unBlockUser() -- line: 556
			-- upvalues: BlockingUtility (copy), p19 (copy), v104 (copy), resizeBlockButton (ref), p18 (copy), p20 (copy), resizeFriendButton (copy)
			if BlockingUtility:UnblockPlayerAsync(p19) then
				v104:action("SettingsHub", "unblockUser", {
					blockeeUserId = p19.UserId
				})
				resizeBlockButton(p18, p19, p20, not p20)
				resizeFriendButton(p18, p19, p20, not p20)
			end
		end

		if BlockingUtility:IsPlayerBlockedByUserId(p19.UserId) then
			return Utility:MakeStyledButton("BlockButton", RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Unblock"), UDim2.new(0, 110, 0, Theme.ButtonHeight), unBlockUser)
		end

		return Utility:MakeStyledImageButton("BlockButton", "icons/actions/block", UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight), UDim2.new(0, 28, 0, 28), blockUser)
	end

	function trySelection(p23) -- line: 585
		-- upvalues: GuiService (copy)
		if p23 and not p23.Selectable then
			GuiService:Select(p23)

			return
		end

		GuiService.SelectedCoreObject = p23
	end
	function resizeBlockButton(p24, p25, p26, p27) -- line: 593
		-- upvalues: LocalPlayer (ref), createBlockButton (copy), Utility (copy)
		local BlockButton = p24:FindFirstChild("BlockButton")

		if BlockButton and p26 == p27 then
			return BlockButton
		end

		if BlockButton then
			BlockButton:Destroy()
			BlockButton = nil
		end

		if p25 and (p25 ~= LocalPlayer and (p25.UserId > 0 and LocalPlayer.UserId > 0)) then
			BlockButton = createBlockButton(p24, p25, p26, p27)
		end

		if BlockButton then
			BlockButton.Name = "BlockButton"
			BlockButton.LayoutOrder = 4
			BlockButton.Selectable = true

			local v216 = "utility-focus-state" .. "-blockbutton-" .. p25.Name

			Utility:MakeFocusState(BlockButton, v216)
			BlockButton.Parent = p24
		end

		return BlockButton
	end

	local u106 = false
	local u107 = false

	local function muteButtonUpdate(p28, p29) -- line: 622
		-- upvalues: MuteStatusIcons (copy), v65 (copy), EngineFeature2 (copy), default (copy), t2 (copy), Utility (copy), Theme (copy), v91 (copy), Constants (copy)
		local RightSideButtons = nil

		if p28 then
			RightSideButtons = p28:FindFirstChild("RightSideButtons")
		end

		if not RightSideButtons then
			return
		end

		local MuteStatusButton = RightSideButtons:FindFirstChild("MuteStatusButton")

		if p29 == nil then
			if MuteStatusButton then
				MuteStatusButton:Destroy()
			end

			return
		end

		local uDim2_3 = UDim2.fromOffset(36, 36)
		local uDim2_4 = UDim2.fromOffset(0, 0)
		local n3 = 0
		local v224 = p29.isMuted and MuteStatusIcons.MicOff or MuteStatusIcons.MicOn

		if p29.subscriptionFailed then
			v224 = MuteStatusIcons.Error
			uDim2_3 = UDim2.fromOffset(36, 36)
			uDim2_4 = UDim2.fromOffset(2, -2)

			if v65 and EngineFeature2 then
				n3 = 0.5
			end
		elseif p29.isMutedLocally then
			v224 = MuteStatusIcons.MicDisabled
			n3 = 0.5
		elseif not p29.subscriptionCompleted then
			v224 = MuteStatusIcons.Loading
		elseif p29.isSignalActive then
			local v225 = math.floor(0.5 + 5 * math.random()) * 20

			v224 = default:GetIcon("Unmuted" .. tostring(v225), "SpeakerLight")
		end

		if MuteStatusButton then
			local v226 = t2[p29.userId] or RightSideButtons:FindFirstChild("MuteStatusImageLabel", true)

			v226.Image = v224
			v226.Size = uDim2_3
			v226.ImageTransparency = n3

			return
		end

		if default.voiceUIVisible then
			local v227, v228 = Utility:MakeStyledImageButton("MuteStatus", v224, UDim2.fromOffset(Theme.ButtonHeight, Theme.ButtonHeight), uDim2_3, function() -- line: 682
				-- upvalues: default (copy), p29 (copy), v91 (copy), Constants (copy), v65 (copy), EngineFeature2 (copy)
				local v379 = default.participants[tostring(p29.userId)]

				if v379.subscriptionCompleted then
					if v91 then
						v91:onToggleMutePlayer(p29.userId, not v379.isMutedLocally)
					end

					default:ToggleMutePlayer(p29.userId, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)

					return
				end

				if v379.subscriptionFailed then
					if v65 then
						if not EngineFeature2 then
							default:SubscribeRetry(p29.userId)

							return
						end
					else
						default:SubscribeRetry(p29.userId)
					end
				end
			end)

			t2[p29.userId] = v228
			v228.ZIndex = 3
			v228.Position = v228.Position + uDim2_4
			v228.ImageTransparency = n3

			local v229 = "utility-focus-state" .. "-mutestatusbutton-" .. p29.userId

			Utility:MakeFocusState(v227, v229)
			v227.Parent = RightSideButtons
		end
	end

	local v109 = Create("Frame")({
		Name = "ButtonsContainer",
		BackgroundTransparency = 1,
		Visible = false,
		Size = UDim2.new(1, 0, 0, Theme.ButtonHeight),
		Parent = v76.Page
	})

	v76.ButtonsContainer = v109

	if FFlagEnableSideSheet or FFlagRelocateMobileMenuButtons and (FIntRelocateMobileMenuButtonsVariant == 1 or FIntRelocateMobileMenuButtonsVariant == 3) then
		v109.Parent = nil
	end

	Create("UIPadding")({
		PaddingBottom = UDim.new(0, 1),
		PaddingTop = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 1),
		PaddingRight = UDim.new(0, 1),
		Parent = v109
	})

	local v110, v111 = Utility:MakeStyledButton("LeaveButton", "Leave", UDim2.new(0.3333333333333333, -12, 1, 0), function() -- line: 739
		-- upvalues: GetFFlagEnableLeaveGameUpsellEntrypoint (copy), v76 (copy), Constants (copy)
		if GetFFlagEnableLeaveGameUpsellEntrypoint() and v76.HubRef.leaveGameUpsellProp ~= Constants.PHONE_UPSELL_VALUE_PROP.None then
			v76.HubRef:SwitchToPage(v76.HubRef.LeaveGameUpsellPage, nil, 1, true)

			return
		end

		v76.HubRef:SwitchToPage(v76.HubRef.LeaveGamePage, false, 1)
	end)

	v110.AnchorPoint = Vector2.new(0, 0)
	v110.Position = UDim2.new(0, 0, 0, 0)
	v111.Size = UDim2.new(1, -4, 1, 0)
	v111.Position = UDim2.new(0, 2, 0, 0)
	Create("UIListLayout")({
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Parent = v110
	})
	Create("UIPadding")({
		PaddingLeft = UDim.new(0.025, 0),
		Parent = v110
	})
	v111.Size = UDim2.new(0, 0, 1, 0)
	Create("UIFlexItem")({
		FlexMode = Enum.UIFlexMode.Grow,
		Parent = v111
	})

	if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
		v110.Parent = v109
	end

	local v112 = t1[RobloxLocaleId]:Format(Constants2.RespawnLocalizedKey)
	local v113, v114 = Utility:MakeStyledButton("ResetButton", v112, UDim2.new(0.3333333333333333, -12, 1, 0), function() -- line: 782
		-- upvalues: v76 (copy)
		v76.HubRef:SwitchToPage(v76.HubRef.ResetCharacterPage, false, 1)
	end)

	v113.AnchorPoint = Vector2.new(0.5, 0)
	v113.Position = UDim2.new(0.5, 0, 0, 0)
	v114.Size = UDim2.new(1, -4, 1, 0)
	v114.Position = UDim2.new(0, 2, 0, 0)

	if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
		v113.Parent = v109
	end

	local v115, v116 = Utility:MakeStyledButton("ResumeButton", "Resume", UDim2.new(0.3333333333333333, -12, 1, 0), function() -- line: 799
		-- upvalues: v76 (copy), RbxAnalyticsService (copy), Constants2 (copy)
		v76.HubRef:SetVisibility(false)
		RbxAnalyticsService:SetRBXEventStream(Constants2.AnalyticsTargetName, Constants2.AnalyticsResumeGameName, Constants2.AnalyticsMenuActionName, {
			source = Constants2.AnalyticsResumeButtonSource,
			playsessionid = v76.playSessionId,
			universeid = tostring(game.GameId)
		})
	end)

	v115.AnchorPoint = Vector2.new(1, 0)
	v115.Position = UDim2.new(1, 0, 0, 0)
	v116.Size = UDim2.new(1, -4, 1, 0)
	v116.Position = UDim2.new(0, 2, 0, 0)

	if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
		v115.Parent = v109

		if FFlagIEMTabFocusNav then
			v76.FirstSelectableObjects = {
				v115,
				v113,
				v110
			}
			v76.FirstSelectableObjectsUpdated:fire()
		end
	end

	local function pollImage() -- line: 831
		-- upvalues: default (copy), PlayerMuteStatusIcons (copy)
		local localMuted = default.localMuted

		if localMuted == nil then
			return PlayerMuteStatusIcons.Loading
		end

		if localMuted then
			return PlayerMuteStatusIcons.MicOff
		end

		if default.isTalking then
			local v231 = math.floor(0.5 + 5 * math.random()) * 20

			return (default:GetIcon("Unmuted" .. tostring(v231), "MicLight"))
		end

		return PlayerMuteStatusIcons.MicOn
	end
	local function updateButtonPosition(p30, p31, p32, p33) -- line: 848
		-- upvalues: v109 (copy)
		local v236 = v109:FindFirstChild(p30 .. "Button", true)

		if not v236 then
			return
		end

		v236.Position = p31
		v236.Size = p32
		v236.AnchorPoint = p33
	end
	local function muteButtonReset() -- line: 860
		-- upvalues: v109 (copy)
		local PlayerMuteButtonButton = v109:FindFirstChild("PlayerMuteButtonButton", true)

		if PlayerMuteButtonButton then
			PlayerMuteButtonButton:Destroy()
		end
	end
	local function resetButtonRow() -- line: 867
		-- upvalues: FFlagRelocateMobileMenuButtons (copy), FIntRelocateMobileMenuButtonsVariant (copy), v109 (copy)
		if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
			local uDim2_5 = UDim2.new(1, 0, 0, 0)
			local uDim2_6 = UDim2.new(0.3333333333333333, -12, 1, 0)
			local vector2 = Vector2.new(1, 0)
			local ResumeButtonButton = v109:FindFirstChild("ResumeButtonButton", true)

			if ResumeButtonButton then
				ResumeButtonButton.Position = uDim2_5
				ResumeButtonButton.Size = uDim2_6
				ResumeButtonButton.AnchorPoint = vector2
			end

			local uDim2_7 = UDim2.new(0.5, 0, 0, 0)
			local uDim2_8 = UDim2.new(0.3333333333333333, -12, 1, 0)
			local vector2_2 = Vector2.new(0.5, 0)
			local ResetButtonButton = v109:FindFirstChild("ResetButtonButton", true)

			if ResetButtonButton then
				ResetButtonButton.Position = uDim2_7
				ResetButtonButton.Size = uDim2_8
				ResetButtonButton.AnchorPoint = vector2_2
			end

			local uDim2_9 = UDim2.new(0, 0, 0, 0)
			local uDim2_10 = UDim2.new(0.3333333333333333, -12, 1, 0)
			local vector2_3 = Vector2.new(0, 0)
			local LeaveButtonButton = v109:FindFirstChild("LeaveButtonButton", true)

			if LeaveButtonButton then
				LeaveButtonButton.Position = uDim2_9
				LeaveButtonButton.Size = uDim2_10
				LeaveButtonButton.AnchorPoint = vector2_3
			end
		end

		local PlayerMuteButtonButton = v109:FindFirstChild("PlayerMuteButtonButton", true)

		if PlayerMuteButtonButton then
			PlayerMuteButtonButton:Destroy()
		end
	end
	local function updateMuteSelfButtonIcon() -- line: 891
		-- upvalues: GetFFlagCleanupMuteSelfButton (copy), u94 (ref), pollImage (copy)
		local MuteSelfButtonImageLabel = nil

		if GetFFlagCleanupMuteSelfButton() then
			if u94 then
				MuteSelfButtonImageLabel = u94:FindFirstChild("MuteSelfButtonImageLabel", true)
			end
		else
			MuteSelfButtonImageLabel = u94:FindFirstChild("MuteSelfButtonImageLabel", true)
		end

		if not MuteSelfButtonImageLabel then
			return
		end

		MuteSelfButtonImageLabel.Image = pollImage()
	end

	Utility:OnResized(v109, function(_, p35) -- line: 908
		-- upvalues: Utility (copy), Theme (copy), v109 (copy), FFlagRelocateMobileMenuButtons (copy), FIntRelocateMobileMenuButtonsVariant (copy), v114 (copy), v111 (copy), v116 (copy)
		if (p35 or Utility:IsSmallTouchScreen()) and not Theme.AlwaysShowBottomBar() then
			local v254 = p35 and Theme.textSize(18) or Theme.textSize(24)

			v109.Visible = true
			v109.Size = UDim2.new(1, 0, 0, Theme.ButtonHeight)

			if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
				v114.TextSize = v254
				v111.TextSize = v254
				v116.TextSize = v254

				return
			end
		else
			v109.Visible = false
			v109.Size = UDim2.new(1, 0, 0, 0)
		end
	end)

	local function reportAbuseButtonCreate(p36, p37) -- line: 924
		-- upvalues: LocalPlayer (ref), ReportAbuseMenuNewContainerPage (copy), Utility (copy), Theme (copy)
		local RightSideButtons = p36:FindFirstChild("RightSideButtons")

		if RightSideButtons then
			local ReportPlayer = RightSideButtons:FindFirstChild("ReportPlayer")

			if ReportPlayer then
				ReportPlayer:Destroy()
			end

			if p37 and (p37 ~= LocalPlayer and (p37.UserId > 0 and LocalPlayer.UserId > 0)) then
				local v259 = Utility:MakeStyledImageButton("ReportPlayer", "icons/actions/feedback", UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight), UDim2.new(0, 28, 0, 28), function() -- line: 933
					-- upvalues: ReportAbuseMenuNewContainerPage (copy), p37 (copy)
					ReportAbuseMenuNewContainerPage:ReportPlayer(p37, "MenuPlayerList")
				end)

				v259.Name = "ReportPlayer"
				v259.Position = UDim2.new(1, -260, 0, 7)
				v259.LayoutOrder = 3
				v259.Selectable = true

				local v260 = "utility-focus-state" .. "-reportplayer-" .. p37.Name

				Utility:MakeFocusState(v259, v260)
				v259.Parent = RightSideButtons
			end
		end
	end

	local u123 = nil
	local u124 = false
	local u125 = nil

	local function muteAllButtonRemove() -- line: 964
		-- upvalues: u87 (ref), u97 (ref)
		if u87 then
			u87.Visible = false
			u87:Destroy()
			u87 = nil
		end

		u97()
	end
	local function muteSelfButtonRemove() -- line: 973
		-- upvalues: u88 (ref), u125 (ref), u97 (ref)
		if u88 then
			u88.Visible = false
			u88:Destroy()
			u88 = nil
		end

		if u125 then
			u125:Disconnect()
			u125 = nil
		end

		u97()
	end
	local function joinVoiceButtonRemove() -- line: 986
		-- upvalues: u89 (ref), u97 (ref)
		if u89 then
			u89.Visible = false
			u89:Destroy()
			u89 = nil
		end

		u97()
	end
	local function shouldShowJoinVoiceButton() -- line: 995
		-- upvalues: GetFFlagEnableConsoleJoinVoice (copy), u124 (ref), v72 (copy), default (copy)
		return GetFFlagEnableConsoleJoinVoice() and (game:GetEngineFeature("VoiceChatSupported") and (not u124 and (not v72 and (default:verifyUniverseAndPlaceCanUseVoice() and (default:ShouldShowJoinVoiceOnDisconnect() and (default:GetVoiceConnectCookie() == "" and default:HasSeamlessVoiceFeature("InitialJoinVoice")))))))
	end
	local function createRow(p38, p39, b1: boolean?) -- line: 1006
		-- upvalues: Theme (copy), Create (copy)
		local v264 = Instance.new(p38)

		v264.Size = UDim2.new(1, 0, 0, 62)
		v264.Position = UDim2.new(0, 0, 0, 0)
		v264.ZIndex = 2
		v264.BackgroundColor3 = Theme.color("PlayerRowFrame")
		v264.BackgroundTransparency = Theme.transparency("PlayerRowFrame")
		Create("UICorner")({
			CornerRadius = Theme.DefaultCornerRadius,
			Parent = v264
		})

		local TextLabel

		if b1 then
			TextLabel = Instance.new("TextLabel")
			TextLabel.TextColor3 = Color3.new(1, 1, 1)
			TextLabel.TextSize = 24
		else
			TextLabel = Instance.new("ImageLabel")
		end

		TextLabel.Name = "Icon"
		TextLabel.BackgroundTransparency = 1
		TextLabel.Size = UDim2.new(0, 36, 0, 36)
		TextLabel.Position = UDim2.new(0, 12, 0, 12)
		TextLabel.ZIndex = 3
		TextLabel.Parent = v264

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Text = ""
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.Font = Theme.font(Enum.Font.SourceSans, "DisplayName")
		TextLabel2.FontSize = p39 and Theme.fontSize(Enum.FontSize.Size36, "DisplayName") or Theme.fontSize(Enum.FontSize.Size24, "DisplayName")
		TextLabel2.TextColor3 = Color3.new(1, 1, 1)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Position = p39 and UDim2.new(0, 60, 0.5, -10) or UDim2.new(0, 60, 0.5, 0)
		TextLabel2.Size = UDim2.new(0, 0, 0, 0)
		TextLabel2.ZIndex = 3
		TextLabel2.Parent = v264

		if p39 then
			local TextLabel3 = Instance.new("TextLabel")

			TextLabel3.Text = ""
			TextLabel3.Name = "SecondRow"
			TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel3.Font = Theme.font(Enum.Font.SourceSans)
			TextLabel3.FontSize = Theme.fontSize(Enum.FontSize.Size24, "Username")
			TextLabel3.TextColor3 = Color3.fromRGB(162, 162, 162)
			TextLabel3.BackgroundTransparency = 1
			TextLabel3.Position = UDim2.new(0, 60, 0.5, 12)
			TextLabel3.Size = UDim2.new(0, 0, 0, 0)
			TextLabel3.ZIndex = 3
			TextLabel3.Parent = v264
		end

		return v264
	end
	local function u131() -- line: 1065
		-- upvalues: createRow (copy), u124 (ref), GetFFlagEnableConsoleJoinVoice (copy), shouldShowJoinVoiceButton (copy), uDim2 (copy), Theme (copy), t1 (copy), RobloxLocaleId (copy), FFlagConnectionsToFriendsRename (copy), Constants2 (copy), uiblox (copy), BuilderIcons (copy), Utility (copy)
		local v268 = createRow("ImageButton", nil, true)

		v268.Size = UDim2.new(1, 0, 0, 52)

		local TextLabel = v268.TextLabel
		local Icon = v268.Icon

		if u124 or GetFFlagEnableConsoleJoinVoice() and shouldShowJoinVoiceButton() then
			v268.Size = uDim2
			TextLabel.Size = UDim2.new(1, -60, 0, 0)
			TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
			v268.AnchorPoint = Vector2.new(0, 0)
		end

		TextLabel.Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		TextLabel.AutoLocalize = false
		TextLabel.Text = t1[RobloxLocaleId]:Format(if not FFlagConnectionsToFriendsRename then Constants2.InviteConnectionsLocalizedKey else Constants2.InviteFriendsLocalizedKey)
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.Position = UDim2.new(0, 18, 0.5, 0)

		local v271 = uiblox["icons/actions/friends/friendInvite"]
		local v272 = if not v271 then Theme.Images["icons/actions/friends/friendInvite"] else uiblox["icons/actions/friends/friendInvite"]

		if v272 then
			if v271 then
				Icon.Text = v272.name
				Icon.FontFace = BuilderIcons.Font[v272.variant]
			else
				Icon.Image = v272.Image
				Icon.ImageRectOffset = v272.ImageRectOffset
				Icon.ImageRectSize = v272.ImageRectSize
			end
		end

		local function setIsHighlighted(p40) -- line: 1099
			-- upvalues: v268 (copy)
			if p40 then
				v268.ImageTransparency = 0.65

				return
			end

			v268.ImageTransparency = 0.85
		end

		v268.InputBegan:Connect(function() -- line: 1107
			-- upvalues: v268 (copy)
			v268.ImageTransparency = 0.65
		end)
		v268.InputEnded:Connect(function() -- line: 1110
			-- upvalues: v268 (copy)
			v268.ImageTransparency = 0.85
		end)
		v268.Activated:Connect(function() -- line: 1113
			-- upvalues: v268 (copy)
			v268.ImageTransparency = 0.85
		end)
		v268.TouchPan:Connect(function(_, p42) -- line: 1116
			-- upvalues: v268 (copy)
			if math.abs(p42.Y) > 20 then
				v268.ImageTransparency = 0.85
			end
		end)
		v268.SelectionGained:connect(function() -- line: 1122
			-- upvalues: v268 (copy)
			v268.ImageTransparency = 0.65
		end)
		v268.SelectionLost:connect(function() -- line: 1125
			-- upvalues: v268 (copy)
			v268.ImageTransparency = 0.85
		end)
		v268.SelectionImageObject = v268:Clone()
		Utility:MakeFocusState(v268, "utility-focus-state-sharegame")

		return v268
	end
	local function u132() -- line: 1136
		-- upvalues: createRow (copy), u86 (ref), Theme (copy), RobloxTranslator (copy), default (copy), Utility (copy)
		local v274 = createRow("ImageButton")

		v274.Size = UDim2.new(not u86 and 1 or 0.5, -10, 0, 52)
		v274.Position = UDim2.new(1, 0, 0, 0)
		v274.AnchorPoint = Vector2.new(1, 0)

		local TextLabel = v274.TextLabel
		local Icon = v274.Icon

		TextLabel.Size = UDim2.new(1, -60, 0, 0)
		TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
		TextLabel.Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		TextLabel.AutoLocalize = false
		TextLabel.Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.MuteAll")
		Icon.Size = UDim2.new(0, 32, 0, 32)
		Icon.Position = UDim2.new(0, 18, 0, 16)
		Icon.Image = default:GetIcon("UnmuteAll", "Misc")
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.Position = UDim2.new(0, 18, 0.5, 0)

		local function setIsHighlighted(p43) -- line: 1156
			-- upvalues: v274 (copy)
			if p43 then
				v274.ImageTransparency = 0.65

				return
			end

			v274.ImageTransparency = 0.85
		end

		v274.InputBegan:Connect(function() -- line: 1164
			-- upvalues: v274 (copy)
			v274.ImageTransparency = 0.65
		end)
		v274.InputEnded:Connect(function() -- line: 1167
			-- upvalues: v274 (copy)
			v274.ImageTransparency = 0.85
		end)
		v274.Activated:Connect(function() -- line: 1170
			-- upvalues: v274 (copy)
			v274.ImageTransparency = 0.85
		end)
		v274.TouchPan:Connect(function(_, p45) -- line: 1173
			-- upvalues: v274 (copy)
			if math.abs(p45.Y) > 20 then
				v274.ImageTransparency = 0.85
			end
		end)
		v274.SelectionGained:connect(function() -- line: 1179
			-- upvalues: v274 (copy)
			v274.ImageTransparency = 0.65
		end)
		v274.SelectionLost:connect(function() -- line: 1182
			-- upvalues: v274 (copy)
			v274.ImageTransparency = 0.85
		end)
		v274.SelectionImageObject = v274:Clone()
		Utility:MakeFocusState(v274, "utility-focus-state-muteall")

		return v274
	end
	local function u133() -- line: 1193
		-- upvalues: createRow (copy), Theme (copy), pollImage (copy), Utility (copy), t1 (copy), RobloxLocaleId (copy), default (copy), u125 (ref), u106 (ref), GetFFlagCleanupMuteSelfButton (copy), u94 (ref), v91 (copy), u88 (ref)
		local v278 = createRow("ImageButton")

		v278.Name = "MuteSelfButton"
		v278.Size = UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight)
		v278.Position = UDim2.new(1, 0, 0, 0)
		v278.AnchorPoint = Vector2.new(1, 0)

		local TextLabel = v278.TextLabel
		local Icon = v278.Icon

		TextLabel.Size = UDim2.new(1, -60, 0, 0)
		TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
		TextLabel.Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		TextLabel.AutoLocalize = false
		Icon.Name = "MuteSelfButtonImageLabel"
		Icon.Size = UDim2.new(0, 32, 0, 32)
		Icon.Position = UDim2.new(0, 18, 0, 16)
		Icon.Image = pollImage()
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.Position = UDim2.new(0, 18, 0.5, 0)

		local function setIsHighlighted(p46) -- line: 1214
			-- upvalues: v278 (copy)
			if p46 then
				v278.ImageTransparency = 0.65

				return
			end

			v278.ImageTransparency = 0.85
		end

		v278.InputBegan:Connect(function() -- line: 1222
			-- upvalues: v278 (copy)
			v278.ImageTransparency = 0.65
		end)
		v278.InputEnded:Connect(function() -- line: 1225
			-- upvalues: v278 (copy)
			v278.ImageTransparency = 0.85
		end)
		v278.Activated:Connect(function() -- line: 1228
			-- upvalues: v278 (copy)
			v278.ImageTransparency = 0.85
		end)
		v278.TouchPan:Connect(function(_, p48) -- line: 1231
			-- upvalues: v278 (copy)
			if math.abs(p48.Y) > 20 then
				v278.ImageTransparency = 0.85
			end
		end)
		v278.SelectionGained:connect(function() -- line: 1237
			-- upvalues: v278 (copy)
			v278.ImageTransparency = 0.65
		end)
		v278.SelectionLost:connect(function() -- line: 1240
			-- upvalues: v278 (copy)
			v278.ImageTransparency = 0.85
		end)
		v278.SelectionImageObject = v278:Clone()
		Utility:MakeFocusState(v278, "utility-focus-state-playermute")

		local function updatePlayerMuteText(p49) -- line: 1248
			-- upvalues: TextLabel (copy), t1 (copy), RobloxLocaleId (copy)
			local v390 = not p49 and "CoreScripts.InGameMenu.QuickActions.MuteSelf" or "CoreScripts.InGameMenu.QuickActions.UnmuteSelf"

			TextLabel.Text = t1[RobloxLocaleId]:Format(v390)
		end

		local v283 = not default.localMuted and "CoreScripts.InGameMenu.QuickActions.MuteSelf" or "CoreScripts.InGameMenu.QuickActions.UnmuteSelf"

		TextLabel.Text = t1[RobloxLocaleId]:Format(v283)
		u125 = default.muteChanged.Event:Connect(function(p50) -- line: 1255
			-- upvalues: u106 (ref), GetFFlagCleanupMuteSelfButton (copy), u94 (ref), pollImage (copy), TextLabel (copy), t1 (copy), RobloxLocaleId (copy)
			u106 = p50

			local MuteSelfButtonImageLabel = nil

			if GetFFlagCleanupMuteSelfButton() then
				if u94 then
					MuteSelfButtonImageLabel = u94:FindFirstChild("MuteSelfButtonImageLabel", true)
				end
			else
				MuteSelfButtonImageLabel = u94:FindFirstChild("MuteSelfButtonImageLabel", true)
			end

			if MuteSelfButtonImageLabel then
				MuteSelfButtonImageLabel.Image = pollImage()
			end

			local v393 = not p50 and "CoreScripts.InGameMenu.QuickActions.MuteSelf" or "CoreScripts.InGameMenu.QuickActions.UnmuteSelf"

			TextLabel.Text = t1[RobloxLocaleId]:Format(v393)
		end)
		v278.Activated:Connect(function() -- line: 1261
			-- upvalues: default (copy), v91 (copy), u106 (ref)
			default:ToggleMic("InGameMenuPlayers")

			if v91 then
				v91:onToggleMuteSelf(u106)
			end
		end)

		if GetFFlagCleanupMuteSelfButton() then
			return v278
		end

		u88 = v278
	end
	local function addMuteButtonExperience() -- line: 1276
		-- upvalues: v72 (copy), GetFFlagCleanupMuteSelfButton (copy), u88 (ref), u133 (ref)
		if v72 then
			return
		end

		if GetFFlagCleanupMuteSelfButton() then
			u88 = u133()

			return
		end

		u133()
	end

	if GetFFlagEnableConsoleJoinVoice() then
		function u123() -- line: 1289
			-- upvalues: createRow (copy), uDim2 (copy), Theme (copy), v61 (copy), t1 (copy), RobloxLocaleId (copy), uiblox (copy), BuilderIcons (copy), Utility (copy), default (copy), Constants (copy)
			local v284 = createRow("ImageButton", nil, true)

			v284.Size = UDim2.new(1, 0, 0, 52)
			v284.Size = uDim2
			v284.AnchorPoint = Vector2.new(0, 0)

			local TextLabel = v284.TextLabel

			TextLabel.Size = UDim2.new(1, -60, 0, 0)
			TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
			TextLabel.Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
			TextLabel.AutoLocalize = false

			if v61 then
				TextLabel.Text = t1[RobloxLocaleId]:Format("Feature.SettingsHub.Action.ConnectVoiceChat")
			else
				TextLabel.Text = "Connect Voice Chat"
			end

			local Icon = v284.Icon

			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.Position = UDim2.new(0, 18, 0.5, 0)

			local v287 = uiblox["icons/controls/publicAudioJoin"]
			local v288 = if not v287 then Theme.Images["icons/controls/publicAudioJoin"] else uiblox["icons/controls/publicAudioJoin"]

			if v288 then
				if v287 then
					Icon.Text = v288.name
					Icon.FontFace = BuilderIcons.Font[v288.variant]
				else
					Icon.Image = v288.Image
					Icon.ImageRectOffset = v288.ImageRectOffset
					Icon.ImageRectSize = v288.ImageRectSize
				end
			end

			local function setIsHighlighted(p51) -- line: 1324
				-- upvalues: v284 (copy)
				if p51 then
					v284.ImageTransparency = 0.65

					return
				end

				v284.ImageTransparency = 0.85
			end

			v284.InputBegan:Connect(function() -- line: 1332
				-- upvalues: v284 (copy)
				v284.ImageTransparency = 0.65
			end)
			v284.InputEnded:Connect(function() -- line: 1335
				-- upvalues: v284 (copy)
				v284.ImageTransparency = 0.85
			end)
			v284.Activated:Connect(function() -- line: 1338
				-- upvalues: v284 (copy)
				v284.ImageTransparency = 0.85
			end)
			v284.TouchPan:Connect(function(_, p53) -- line: 1341
				-- upvalues: v284 (copy)
				if math.abs(p53.Y) > 20 then
					v284.ImageTransparency = 0.85
				end
			end)
			v284.SelectionGained:connect(function() -- line: 1347
				-- upvalues: v284 (copy)
				v284.ImageTransparency = 0.65
			end)
			v284.SelectionLost:connect(function() -- line: 1350
				-- upvalues: v284 (copy)
				v284.ImageTransparency = 0.85
			end)
			v284.SelectionImageObject = v284:Clone()
			Utility:MakeFocusState(v284, "utility-focus-state-joinVoice")
			v284.Activated:Connect(function() -- line: 1358
				-- upvalues: default (copy), Constants (copy)
				default.pendingConnectionSource = Constants.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
				default:JoinVoice()
			end)

			return v284
		end
	end

	local function addJoinVoiceButton() -- line: 1367
		-- upvalues: shouldShowJoinVoiceButton (copy), u89 (ref), u123 (ref)
		if not shouldShowJoinVoiceButton() or u89 then
			return
		end

		u89 = u123()
	end
	local function createInspectButtonImage(p54) -- line: 1375
		-- upvalues: Utility (copy), Theme (copy)
		return (Utility:MakeStyledImageButton("InspectButton", "icons/actions/zoomIn", UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight), UDim2.new(0, 28, 0, 28), p54))
	end
	local function resizeInspectButton(p55, p56, p57, p58) -- line: 1386
		-- upvalues: RbxAnalyticsService (copy), Constants2 (copy), v76 (copy), GuiService (copy), Utility (copy), Theme (copy)
		local Inspect = p55:FindFirstChild("Inspect")

		if Inspect and p57 == p58 then
			return
		end

		if Inspect then
			Inspect:Destroy()
		end

		local v296 = Utility:MakeStyledImageButton("InspectButton", "icons/actions/zoomIn", UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight), UDim2.new(0, 28, 0, 28), function() -- line: 1396
			-- upvalues: RbxAnalyticsService (copy), Constants2 (copy), v76 (copy), GuiService (copy), p56 (copy)
			RbxAnalyticsService:SetRBXEventStream(Constants2.AnalyticsTargetName, Constants2.AnalyticsExamineAvatarName, Constants2.AnalyticsMenuActionName, {
				playsessionid = v76.playSessionId,
				universeid = tostring(game.GameId)
			})
			GuiService:InspectPlayerFromUserIdWithCtx(p56.UserId, "escapeMenu")
			v76.HubRef:SetVisibility(false)
		end)

		v296.Name = "Inspect"
		v296.LayoutOrder = 2
		v296.Selectable = true
		v296.Parent = p55

		local v297 = "utility-focus-state" .. "-inspect-" .. p56.Name

		Utility:MakeFocusState(v296, v297)
	end
	local function resizePlatformName(p59, p60, p61) -- line: 1419
		-- upvalues: result (copy), Utility (copy), Theme (copy), Create (copy)
		local PlatformNameContainer = p59:FindFirstChild("PlatformNameContainer")

		if PlatformNameContainer then
			PlatformNameContainer:Destroy()
		end

		if p60 == nil then
			return
		end

		local Frame = Instance.new("Frame")

		Frame.Name = "PlatformNameContainer"
		Frame.BackgroundTransparency = 1
		Frame.ZIndex = 3
		Frame.Position = UDim2.new(0, 0, 0, 0)
		Frame.Size = UDim2.new(0, 0, 1, 0)
		Frame.AutomaticSize = Enum.AutomaticSize.X
		Frame.Selectable = false
		Frame.LayoutOrder = -1
		Frame.Parent = p59

		local v303 = nil

		if game:GetEngineFeature("PlatformFriendsService") and game:GetEngineFeature("PlatformFriendsProfile") and result and result:IsProfileEnabled() and p61 and p61 ~= "" then
			function v303() -- line: 1452
				-- upvalues: result (copy), p61 (copy)
				result:ShowProfile(p61)
			end
		end

		local v304, v305 = Utility:MakeStyledButton("consoleNameContainer", p60, UDim2.new(0, 0, 0, Theme.ButtonHeight), v303)

		v304.AnchorPoint = Vector2.new(0, 0.5)
		v304.Position = UDim2.fromScale(0, 0.5)
		v304.AutomaticSize = Enum.AutomaticSize.X
		v304.Parent = Frame
		v305.Size = UDim2.fromScale(0, 1)
		v305.AutoLocalize = false
		v305.TextSize = Theme.platformNameTextSize
		v305.TextScaled = false
		v305.TextWrapped = false
		v305.AutomaticSize = Enum.AutomaticSize.X

		local v306 = Create("ImageLabel")({
			Name = "iconLabel",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo@3x.png",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = Theme.platformNameIconSize,
			ImageColor3 = Color3.new(1, 1, 1)
		})

		v306.Parent = v304
		Create("UIListLayout")({
			Name = "PLatformNameUIListLayout",
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		}).Parent = v304
		v306.LayoutOrder = 1
		v305.LayoutOrder = 2
		Create("UIPadding")({
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			Parent = v304
		})

		return Frame
	end
	local function u139() -- line: 1514
		-- upvalues: createRow (copy), FFlagIEMFocusNavToButtons (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), GuiService (copy)
		local v307 = createRow("ImageLabel", true)

		v307.TextLabel.Name = "DisplayNameLabel"
		v307.SecondRow.Name = "NameLabel"

		if FFlagIEMFocusNavToButtons then
			v307.Selectable = false
			v307.SelectionGroup = true
		end

		if GetFFlagLuaAppEnableOpenTypeSupport() then
			v307.NameLabel.OpenTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
		end

		local Frame = Instance.new("Frame")

		Frame.Name = "RightSideButtons"
		Frame.BackgroundTransparency = 1
		Frame.ZIndex = 2
		Frame.Position = UDim2.new(0, 0, 0, 0)
		Frame.Size = UDim2.new(1, -12, 1, 0)
		Frame.Parent = v307

		local u309 = nil

		Frame.ChildAdded:connect(function(p62) -- line: 1550
			-- upvalues: u309 (ref), v307 (copy), GuiService (copy), Frame (copy)
			if p62:IsA("GuiObject") then
				if u309 and p62 ~= u309 then
					u309:Destroy()
					u309 = nil
				end

				p62.SelectionGained:connect(function() -- line: 1556
					-- upvalues: v307 (copy), GuiService (copy), Frame (copy)
					if v307 then
						if GuiService.SelectedCoreObject and GuiService.SelectedCoreObject ~= nil and GuiService.SelectedCoreObject.Parent == Frame then
							v307.ImageTransparency = 0.65

							return
						end

						v307.ImageTransparency = 0.85
					end
				end)
				p62.SelectionLost:connect(function() -- line: 1559
					-- upvalues: p62 (copy), v307 (copy), GuiService (copy), Frame (copy)
					local v454 = p62

					if v307 then
						if GuiService.SelectedCoreObject and v454 ~= GuiService.SelectedCoreObject and GuiService.SelectedCoreObject.Parent == Frame then
							v307.ImageTransparency = 0.65

							return
						end

						v307.ImageTransparency = 0.85
					end
				end)
			end
		end)
		u309 = Instance.new("Frame")
		u309.Selectable = true
		u309.Size = UDim2.new(1, 0, 1, 0)
		u309.BackgroundTransparency = 1
		u309.SelectionImageObject = u309:Clone()
		u309.Parent = Frame

		local UIListLayout = Instance.new("UIListLayout")

		UIListLayout.Name = "RightSideListLayout"
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 12)
		UIListLayout.Parent = Frame
		pcall(function() -- line: 1581
			-- upvalues: v307 (copy)
			v307.NameLabel.Localize = false
			v307.DisplayNameLabel.Localize = false
		end)

		return v307
	end
	local function managePlayerNameCutoff(p63, p64) -- line: 1593
		-- upvalues: v71 (copy), UserProfileStore (copy), isEngineTruncationEnabledForIngameSettings (copy), Utility (copy), v66 (copy), formatUsername (copy)
		local u313 = nil
		local u314 = nil

		local function reportFlagChanged(p65, p66, p67) -- line: 1596
			-- upvalues: u313 (ref), p63 (copy), p64 (copy)
			if p66 == "AbsolutePosition" and u313 then
				local v402 = p65.AbsolutePosition.X - 20 - p63.NameLabel.AbsolutePosition.X

				p63.NameLabel.Text = "@" .. p64.Name
				p63.DisplayNameLabel.Text = p64.DisplayName

				if p67 then
					p63.DisplayNameLabel.Text = p67
				end

				local v403 = utf8.len(p64.DisplayName)

				if p67 then
					v403 = utf8.len(p67)
				end

				while v402 < p63.NameLabel.TextBounds.X and v403 > 0 do
					if p67 then
						local v404 = utf8.offset(p67, v403)

						p63.NameLabel.Text = string.sub(p67, 1, v404) .. "..."
					else
						local v405 = utf8.offset(p64.DisplayName, v403)

						p63.NameLabel.Text = string.sub(p64.DisplayName, 1, v405) .. "..."
					end

					v403 -= 1
				end

				local v406 = "@" .. p64.Name
				local v407 = string.len(v406)

				while v402 < p63.NameLabel.TextBounds.X and v407 > 0 do
					p63.NameLabel.Text = string.sub(v406, 1, v407) .. "..."
					v407 -= 1
				end
			end
		end
		local function reportFlagChangedWithCombinedName(p68, _, _) -- line: 1630
			-- upvalues: v71 (copy), p64 (copy), reportFlagChanged (copy), UserProfileStore (copy), p63 (copy)
			if v71 and not p64.UserId then
				reportFlagChanged(p68, "AbsolutePosition")

				return
			end

			UserProfileStore.get().fetchNamesByUserIds({ (tostring(p64.UserId)) }, function(p71) -- line: 1634
				-- upvalues: p63 (copy), reportFlagChanged (copy), p68 (copy), p64 (copy)
				local v456 = p63
				local v457 = if not v456 or not v456.Parent then nil else v456:FindFirstChild("DisplayNameLabel")

				if v457 == nil then
					return
				end

				local data = p71.data
				local s2

				if #data == 0 then
					s2 = ""
				else
					local v460 = data[1]

					if v460 == nil then
						s2 = ""
					else
						local names = v460.names

						s2 = if names ~= nil then names.getInExperienceCombinedName(false) else ""
					end
				end

				if string.len(s2) > 0 and s2 ~= v457.Text then
					reportFlagChanged(p68, "AbsolutePosition", s2)

					return
				end

				if p64.DisplayName ~= v457.Text then
					reportFlagChanged(p68, "AbsolutePosition")
				end
			end)
		end

		if not isEngineTruncationEnabledForIngameSettings() then
			Utility:OnResized(p63.NameLabel, function(_, p73) -- line: 1654
				-- upvalues: u313 (ref), Utility (copy), u314 (ref), p63 (copy), reportFlagChangedWithCombinedName (copy), p64 (copy), v71 (copy), UserProfileStore (copy)
				if u313 ~= nil and p73 == u313 then
					return
				end

				local v413 = p73 and not (Utility:IsSmallTouchScreen() and Utility:IsPortrait())

				u313 = v413

				if v413 then
					if u314 == nil then
						u314 = p63.RightSideButtons.ChildAdded:connect(function(p74) -- line: 1663
							-- upvalues: reportFlagChangedWithCombinedName (copy)
							if p74.Name == "Inspect" then
								p74.Changed:connect(function(_) -- line: 1665
									-- upvalues: reportFlagChangedWithCombinedName (copy), p74 (copy)
									reportFlagChangedWithCombinedName(p74, "AbsolutePosition")
								end)
								reportFlagChangedWithCombinedName(p74, "AbsolutePosition")
							end
						end)
					end

					local Inspect = p63.RightSideButtons:FindFirstChild("Inspect")

					if Inspect then
						Inspect.Changed:connect(function(p76) -- line: 1674
							-- upvalues: reportFlagChangedWithCombinedName (copy), Inspect (copy)
							reportFlagChangedWithCombinedName(Inspect, p76)
						end)
						reportFlagChangedWithCombinedName(Inspect, "AbsolutePosition")

						return
					end
				else
					if not p63:FindFirstChild("NameLabel") then
						return
					end

					p63.NameLabel.Text = "@" .. p64.Name

					if v71 and not p64.UserId then
						p63.DisplayNameLabel.Text = p64.DisplayName

						return
					end

					UserProfileStore.get().fetchNamesByUserIds({ (tostring(p64.UserId)) }, function(p77) -- line: 1688
						-- upvalues: p63 (copy), p64 (copy)
						local v465 = p63
						local v466 = if not v465 or not v465.Parent then nil else v465:FindFirstChild("DisplayNameLabel")

						if v466 == nil then
							return
						end

						local data = p77.data
						local s3

						if #data == 0 then
							s3 = ""
						else
							local v469 = data[1]

							if v469 == nil then
								s3 = ""
							else
								local names = v469.names

								s3 = if names ~= nil then names.getInExperienceCombinedName(false) else ""
							end
						end

						if string.len(s3) > 0 and s3 ~= v466.Text then
							v466.Text = s3

							return
						end

						local DisplayName = p64.DisplayName

						if DisplayName ~= v466.Text then
							v466.Text = DisplayName
						end
					end)
				end
			end)
		end

		local function getNearestRightSideButtonXPosition() -- line: 1708
			-- upvalues: p63 (copy)
			local AbsolutePositionX = nil

			for _, child in pairs(p63.RightSideButtons:GetChildren()) do
				if child:IsA("ImageButton") and (not AbsolutePositionX or AbsolutePositionX > child.AbsolutePosition.X) then
					AbsolutePositionX = child.AbsolutePosition.X
				end
			end

			return AbsolutePositionX
		end

		local u318 = nil

		local function rightSideButtonsChanged() -- line: 1723
			-- upvalues: getNearestRightSideButtonXPosition (copy), u318 (ref), p63 (copy), v66 (copy), formatUsername (copy), p64 (copy), v71 (copy), UserProfileStore (copy)
			local v418 = getNearestRightSideButtonXPosition()

			if v418 == u318 then
				return
			end

			u318 = v418

			local v419 = if not v418 then UDim2.new(1, -20, 0, 0) else UDim2.new(0, v418 - p63.NameLabel.AbsolutePosition.X - 20, 0, 0)

			p63.NameLabel.Size = v419
			p63.DisplayNameLabel.Size = v419
			p63.NameLabel.Text = if not v66 then "@" .. p64.Name else formatUsername(p64.Name)

			if v71 and not p64.UserId then
				p63.DisplayNameLabel.Text = p64.DisplayName

				return
			end

			UserProfileStore.get().fetchNamesByUserIds({ (tostring(p64.UserId)) }, function(p78) -- line: 1753
				-- upvalues: p63 (copy), p64 (copy)
				local v473 = p63
				local v474 = if not v473 or not v473.Parent then nil else v473:FindFirstChild("DisplayNameLabel")

				if v474 == nil then
					return
				end

				local data = p78.data
				local s4

				if #data == 0 then
					s4 = ""
				else
					local v477 = data[1]

					if v477 == nil then
						s4 = ""
					else
						local names = v477.names

						s4 = if names ~= nil then names.getInExperienceCombinedName(false) else ""
					end
				end

				if string.len(s4) > 0 and s4 ~= v474.Text then
					v474.Text = s4

					return
				end

				local DisplayName = p64.DisplayName

				if DisplayName ~= v474.Text then
					v474.Text = DisplayName
				end
			end)
		end

		if isEngineTruncationEnabledForIngameSettings() then
			u314 = p63.RightSideButtons.ChildAdded:connect(function(p79) -- line: 1772
				-- upvalues: rightSideButtonsChanged (copy)
				rightSideButtonsChanged()
				p79:GetPropertyChangedSignal("AbsolutePosition"):Connect(rightSideButtonsChanged)
			end)
			rightSideButtonsChanged()
		end
	end
	local function canShareCurrentGame() -- line: 1781
		-- upvalues: LocalPlayer (ref)
		return LocalPlayer.UserId > 0
	end

	local players = nil
	local t6 = {}
	local t7 = {}
	local u145 = false

	local function updateAllMuteButtons() -- line: 1791
		-- upvalues: u87 (ref), default (copy), Players (copy), t6 (copy), muteButtonUpdate (copy), u107 (ref), RobloxTranslator (copy)
		if not u87 then
			return
		end

		if not default.voiceUIVisible then
			return
		end

		local players2 = Players:GetPlayers()
		local v321 = true

		for _, v in ipairs(players2) do
			local v324 = t6[v.Name]

			if v and v324 then
				local v325 = default.participants[tostring(v.UserId)]

				if v325 and not v325.isMutedLocally then
					v321 = false
				end

				muteButtonUpdate(v324, v325)
			end
		end

		if v321 then
			u107 = true
		else
			u107 = false
		end

		local v326 = u107 and RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.UnmuteAll") or RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.MuteAll")

		if not u87 or not u87:FindFirstChild("TextLabel") then
			return
		end

		u87.TextLabel.Text = v326
		u87.Icon.Image = default:GetIcon(not u107 and "UnmuteAll" or "MuteAll", "Misc")
	end
	local function destroyAllUserMuteButtons() -- line: 1834
		-- upvalues: Players (copy), t6 (copy), GuiService (copy), UserInputService (copy), u86 (ref)
		for _, player in (Players:GetPlayers()) do
			local v329 = t6[player.Name]

			if v329 then
				local RightSideButtons = v329:FindFirstChild("RightSideButtons")

				if RightSideButtons then
					local MuteStatusButton = RightSideButtons:FindFirstChild("MuteStatusButton")

					if MuteStatusButton then
						if MuteStatusButton == GuiService.SelectedCoreObject then
							if UserInputService.GamepadEnabled then
								GuiService.SelectedCoreObject = u86
							else
								GuiService.SelectedCoreObject = nil
							end
						end

						MuteStatusButton:Destroy()
					end
				end
			end
		end
	end
	local function v148(_) -- line: 1857
		-- upvalues: FFlagIEMFocusNavToButtons (copy), v76 (copy), FFlagIEMTabFocusNav (copy), players (ref), Players (copy), v72 (copy), LocalPlayer (ref), Utility (copy), u124 (ref), u87 (ref), default (copy), FFlagHidePeoplePageInviteFriends (copy), FFlagAddInviteFriendsIntegration (copy), FFlagEnableSideSheet (copy), u86 (ref), RunService (copy), u94 (ref), Create (copy), u95 (ref), uDim2 (copy), GetFFlagLuaInExperienceCoreScriptsGameInviteUnification (copy), GameInviteAnalyticsManager (ref), GameInviteAnalytics (copy), EventStream (copy), RbxAnalyticsService (copy), Diag (copy), u131 (ref), GetFFlagEnableConsoleJoinVoice (copy), shouldShowJoinVoiceButton (copy), u89 (ref), u123 (ref), u97 (ref), GuiService (copy), t6 (copy), t7 (copy), u139 (ref), muteButtonUpdate (copy), SocialUtil (copy), v66 (copy), formatUsername (copy), isEngineTruncationEnabledForIngameSettings (copy), managePlayerNameCutoff (copy), friendStatusCreate (copy), resizeFriendButton (copy), resizeBlockButton (ref), resizeInspectButton (copy), reportAbuseButtonCreate (copy), u132 (ref), u107 (ref), RobloxTranslator (copy), GetFFlagVoiceChatUILogging (copy), v31 (copy), v91 (copy), Constants (copy), updateAllMuteButtons (copy), v67 (copy), v71 (copy), Cryo (copy), UserProfileStore (copy), resizePlatformName (copy), u145 (ref), GetFFlagCleanupMuteSelfButton (copy), pollImage (copy), UserInputService (copy), v68 (copy)
		if FFlagIEMFocusNavToButtons then
			v76.LastSelectableObjects = {}
		end

		if FFlagIEMTabFocusNav and not v76.ButtonsContainer.Visible then
			v76.FirstSelectableObjects = {}
		end

		players = Players:GetPlayers()

		if v72 then
			table.sort(players, function(p81, p82) -- line: 1867
				-- upvalues: LocalPlayer (ref)
				local v423 = p81.Name:lower()
				local v424 = p82.Name:lower()

				if p81 == LocalPlayer then
					v423 = " "
				end

				if p82 == LocalPlayer then
					v424 = " "
				end

				return v423 < v424
			end)
		else
			table.sort(players, function(p83, p84) -- line: 1880
				return p83.Name:lower() < p84.Name:lower()
			end)
		end

		local n4 = 20

		if Utility:IsSmallTouchScreen() or Utility:IsPortrait() then
			n4 = 85
		end

		local v334 = u124 and (not u87 and default.voiceUIVisible)
		local v335 = FFlagHidePeoplePageInviteFriends and (FFlagAddInviteFriendsIntegration and FFlagEnableSideSheet)
		local v336 = LocalPlayer.UserId > 0 and (not u86 and (not RunService:IsStudio() and not v335))

		if (v336 or v334) and not u94 then
			u94 = Create("Frame")({
				Name = "Holder",
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = v76.Page
			})
			u95 = Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20),
				Parent = u94
			})
		end

		local function layoutMuteAll() -- line: 1921
			-- upvalues: u94 (ref), Create (copy), v76 (copy), u86 (ref), uDim2 (copy), u87 (ref)
			if not u94 then
				u94 = Create("Frame")({
					Name = "Holder",
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 52),
					Parent = v76.Page
				})
			end

			u86.Parent = u94
			u86.Size = uDim2
			u87.Parent = u94
		end

		local v338 = RunService:IsStudio()

		if LocalPlayer.UserId > 0 and not u86 and not v338 and not v335 then
			local u339 = if not GetFFlagLuaInExperienceCoreScriptsGameInviteUnification() then GameInviteAnalytics.new():withEventStream(EventStream.new(RbxAnalyticsService)):withDiag(Diag.new(RbxAnalyticsService)):withButtonName(GameInviteAnalytics.ButtonName.SettingsHub) else GameInviteAnalyticsManager:withButtonName(GameInviteAnalyticsManager.ButtonName.SettingsHub)

			u86 = u131()
			u86.Activated:connect(function() -- line: 1953
				-- upvalues: u339 (ref), v76 (copy)
				u339:inputShareGameEntryPoint()
				v76.HubRef:InviteToGame()
			end)
			u86.LayoutOrder = 1

			if v334 then
				u86.Parent = u94
			else
				u86.Parent = v76.Page
			end
		end

		if GetFFlagEnableConsoleJoinVoice() and shouldShowJoinVoiceButton() then
			if shouldShowJoinVoiceButton() and not u89 then
				u89 = u123()
			end

			u97()
		end

		if FFlagIEMTabFocusNav then
			if v334 then
				table.insert(v76.FirstSelectableObjects, u87)
			end

			if v336 then
				table.insert(v76.FirstSelectableObjects, u86)
			end

			if v334 or v336 then
				v76.FirstSelectableObjectsUpdated:fire()
			end
		end

		local InspectMenuEnabled = GuiService:GetInspectMenuEnabled()

		for i = 1, #players do
			local v342 = players[i]
			local u343 = t6[v342.Name]

			if v342 then
				t7[v342.Name] = true

				if not u343 or not u343.Parent then
					u343 = u139((i - 1) * 80 + n4)
					u343.Parent = v76.Page
					t6[v342.Name] = u343
				end

				u343.Name = "PlayerLabel" .. v342.Name

				if u124 then
					local v344 = default.participants[tostring(v342.UserId)]

					muteButtonUpdate(u343, v344)
				end

				local v345 = SocialUtil.GetPlayerImage(math.max(1, v342.UserId), Enum.ThumbnailSize.Size100x100, Enum.ThumbnailType.AvatarThumbnail)

				u343.Icon.Image = v345
				u343.NameLabel.Text = if not v66 then "@" .. v342.Name else formatUsername(v342.Name)
				u343.ImageTransparency = 0.85
				u343.LayoutOrder = i + 1

				if isEngineTruncationEnabledForIngameSettings() then
					u343.NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
					u343.DisplayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
				end

				managePlayerNameCutoff(u343, v342)
				friendStatusCreate(u343, v342)

				local u346 = nil

				Utility:OnResized(u343, function(_, p86) -- line: 2035
					-- upvalues: u343 (ref), Utility (copy), resizeFriendButton (copy), v342 (copy), u346 (ref), resizeBlockButton (ref), InspectMenuEnabled (copy), resizeInspectButton (copy)
					local RightSideButtons = u343:FindFirstChild("RightSideButtons")
					local DisplayNameLabel = u343:FindFirstChild("DisplayNameLabel")
					local NameLabel = u343:FindFirstChild("NameLabel")
					local v432 = RightSideButtons and RightSideButtons:FindFirstChild("RightSideListLayout")

					if Utility:IsSmallTouchScreen() and Utility:IsPortrait() then
						u343.Size = UDim2.new(1, 0, 0, 105)

						if DisplayNameLabel then
							if NameLabel then
								DisplayNameLabel.Position = UDim2.new(0, 60, 0.275, -10)
								NameLabel.Position = UDim2.new(0, 60, 0.275, 12)
							else
								DisplayNameLabel.Position = UDim2.new(0, 60, 0.275, 0)
							end
						end

						if RightSideButtons then
							RightSideButtons.Position = UDim2.new(0, 57, 0, -2)
							RightSideButtons.Size = UDim2.new(1, -12, 0.99, -8)
						end

						if v432 then
							v432.HorizontalAlignment = Enum.HorizontalAlignment.Left
							v432.VerticalAlignment = Enum.VerticalAlignment.Bottom
						end
					else
						u343.Size = UDim2.new(1, 0, 0, 62)

						if DisplayNameLabel then
							if NameLabel then
								DisplayNameLabel.Position = UDim2.new(0, 60, 0.5, -10)
								NameLabel.Position = UDim2.new(0, 60, 0.5, 12)
							else
								DisplayNameLabel.Position = UDim2.new(0, 60, 0.5, 0)
							end
						end

						if RightSideButtons then
							RightSideButtons.Position = UDim2.new(0, 0, 0, 0)
							RightSideButtons.Size = UDim2.new(1, -12, 1, 0)
						end

						if v432 then
							v432.HorizontalAlignment = Enum.HorizontalAlignment.Right
							v432.VerticalAlignment = Enum.VerticalAlignment.Center
						end
					end

					if RightSideButtons then
						resizeFriendButton(RightSideButtons, v342, p86, u346)
						resizeBlockButton(RightSideButtons, v342, p86, u346)

						if InspectMenuEnabled then
							resizeInspectButton(RightSideButtons, v342, p86, u346)
						end

						u346 = p86
					end
				end)
				reportAbuseButtonCreate(u343, v342)

				if FFlagIEMFocusNavToButtons and i == #players then
					local RightSideButtons = u343:FindFirstChild("RightSideButtons")

					if RightSideButtons then
						for _, child in RightSideButtons:GetChildren() do
							if child:IsA("ImageButton") then
								table.insert(v76.LastSelectableObjects, child)
							end
						end

						v76.LastSelectableObjectsUpdated:fire()
					end
				end

				if FFlagIEMTabFocusNav and i == 1 and #v76.FirstSelectableObjects == 0 then
					local RightSideButtons = u343:FindFirstChild("RightSideButtons")

					if RightSideButtons then
						for _, child in RightSideButtons:GetChildren() do
							if child:IsA("ImageButton") then
								table.insert(v76.FirstSelectableObjects, child)
							end
						end

						v76.FirstSelectableObjectsUpdated:fire()
					end
				end
			end
		end

		if v334 then
			u87 = u132()
			u87.Activated:connect(function() -- line: 2134
				-- upvalues: u107 (ref), RobloxTranslator (copy), u87 (ref), default (copy), GetFFlagVoiceChatUILogging (copy), v31 (copy), v91 (copy), Constants (copy), updateAllMuteButtons (copy)
				u107 = not u107

				local v433 = u107 and RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.UnmuteAll") or RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.MuteAll")

				u87.TextLabel.Text = v433
				u87.Icon.Image = default:GetIcon(not u107 and "UnmuteAll" or "MuteAll", "Misc")

				if GetFFlagVoiceChatUILogging() then
					v31:debug("{} all players", not u107 and "Unmuting" or "Muting")
				end

				if v91 then
					v91:onToggleMuteAll(u107)
				end

				default:MuteAll(u107, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
				updateAllMuteButtons()
			end)
			u87.LayoutOrder = 1

			if v67 then
				layoutMuteAll()
			else
				u87.Parent = u94
			end

			u97()
		end

		local v353 = if not v71 then Cryo.List.filter(players, function(p87) -- line: 2172
			return (tostring(p87.UserId))
		end) else Cryo.List.filterMap(players, function(p88) -- line: 2164
			if not p88.UserId then
				return nil
			end

			return (tostring(p88.UserId))
		end)

		for _, v in ipairs(players) do
			t6[v.Name].DisplayNameLabel.Text = v.DisplayName
		end

		UserProfileStore.get().fetchNamesByUserIds(v353, function(p89) -- line: 2181
			-- upvalues: t6 (copy), resizePlatformName (copy)
			for _, v438 in p89.data do
				local v439 = t6[v438.names.getUsername(false)]

				if v439 then
					local v440 = v438.names.getInExperienceCombinedName(false)

					if string.len(v440) > 0 and v440 ~= v439.DisplayNameLabel.Text then
						v439.DisplayNameLabel.Text = v440
					end

					local RightSideButtons = v439:FindFirstChild("RightSideButtons")
					local v442 = nil

					if v438.names.getPlatformName(false) ~= "" then
						v442 = v438.names.getPlatformName(false)
					end

					if game:GetEngineFeature("PlatformFriendsService") and game:GetEngineFeature("PlatformFriendsProfile") then
						resizePlatformName(RightSideButtons, v442, v438.getPlatformProfileId(false))
					else
						resizePlatformName(RightSideButtons, v442)
					end
				end
			end
		end)

		local n5 = 0

		if u124 and not u145 then
			v31:debug("Setting Up Playerlist Mic Update Renderstep Hook")
			RunService:BindToRenderStep("player-list-mute-update", Enum.RenderPriority.Last.Value, function() -- line: 2213
				-- upvalues: n5 (ref), updateAllMuteButtons (copy), GetFFlagCleanupMuteSelfButton (copy), u94 (ref), pollImage (copy)
				n5 += 1

				if n5 % 3 == 0 then
					updateAllMuteButtons()

					local MuteSelfButtonImageLabel = nil

					if GetFFlagCleanupMuteSelfButton() then
						if u94 then
							MuteSelfButtonImageLabel = u94:FindFirstChild("MuteSelfButtonImageLabel", true)
						end
					else
						MuteSelfButtonImageLabel = u94:FindFirstChild("MuteSelfButtonImageLabel", true)
					end

					if not MuteSelfButtonImageLabel then
						return
					end

					MuteSelfButtonImageLabel.Image = pollImage()
				end
			end)
			u145 = true
		end

		for k, v in pairs(t6) do
			if not t7[k] then
				v:Destroy()
				t6[k] = nil
			end
		end

		if UserInputService.GamepadEnabled and (not FFlagIEMTabFocusNav or not GuiService.SelectedCoreObject) then
			if GetFFlagCleanupMuteSelfButton() then
				pcall(function() -- line: 2233
					-- upvalues: v68 (copy), v76 (copy), GuiService (copy), u86 (ref)
					if v68 then
						if v76.Active then
							GuiService.SelectedCoreObject = u86

							return
						end
					else
						GuiService.SelectedCoreObject = u86
					end
				end)
			else
				GuiService.SelectedCoreObject = u86
			end
		end

		Utility:OnResized("MenuPlayerListExtraPageSize", function(_, _) -- line: 2247
			-- upvalues: Utility (copy), players (ref), v76 (copy)
			local n6 = 20

			if Utility:IsSmallTouchScreen() or Utility:IsPortrait() then
				n6 = 85
			end

			local v447 = #players + 1

			if Utility:IsSmallTouchScreen() and Utility:IsPortrait() then
				v76.Page.Size = UDim2.new(1, 0, 0, n6 + v447 * 123 - 5)

				return
			end

			v76.Page.Size = UDim2.new(1, 0, 0, n6 + v447 * 80 - 5)
		end)
	end

	if game:GetEngineFeature("VoiceChatSupported") and not u124 then
		default:asyncInit():andThen(function() -- line: 2273
			-- upvalues: u124 (ref), default (copy), v72 (copy), GetFFlagCleanupMuteSelfButton (copy), u88 (ref), u133 (ref), updateAllMuteButtons (copy), t2 (copy), u87 (ref), u97 (ref), u125 (ref), GetFFlagEnableConsoleJoinVoice (copy), u89 (ref), v148 (copy), v67 (copy), v109 (copy), destroyAllUserMuteButtons (copy), resetButtonRow (copy)
			u124 = true
			default:SetupParticipantListeners()

			if not v72 then
				if GetFFlagCleanupMuteSelfButton() then
					u88 = u133()
				else
					u133()
				end
			end

			default.participantsUpdate.Event:Connect(function() -- line: 2278
				-- upvalues: updateAllMuteButtons (copy)
				updateAllMuteButtons()
			end)
			default.participantLeft.Event:Connect(function(_, p93) -- line: 2281
				-- upvalues: updateAllMuteButtons (copy), t2 (copy)
				updateAllMuteButtons()
				t2[p93] = nil
			end)
			default:getService().StateChanged:Connect(function(_, newState) -- line: 2286
				-- upvalues: u87 (ref), u97 (ref), u88 (ref), u125 (ref), GetFFlagEnableConsoleJoinVoice (copy), u89 (ref), u124 (ref), v148 (copy)
				if newState == Enum.VoiceChatState.Ended then
					if u87 then
						u87.Visible = false
						u87:Destroy()
						u87 = nil
					end

					u97()

					if u88 then
						u88.Visible = false
						u88:Destroy()
						u88 = nil
					end

					if u125 then
						u125:Disconnect()
						u125 = nil
					end

					u97()

					if GetFFlagEnableConsoleJoinVoice() then
						if u89 then
							u89.Visible = false
							u89:Destroy()
							u89 = nil
						end

						u97()
					end

					u124 = false

					return
				end

				if newState == Enum.VoiceChatState.Joined and u124 == false then
					u124 = true

					if GetFFlagEnableConsoleJoinVoice() then
						if u89 then
							u89.Visible = false
							u89:Destroy()
							u89 = nil
						end

						u97()
					end

					v148()
				end
			end)

			if v67 and not GetFFlagCleanupMuteSelfButton() then
				v148()
			end

			default.showVoiceUI.Event:Connect(function() -- line: 2310
				-- upvalues: GetFFlagCleanupMuteSelfButton (copy), u88 (ref), v72 (copy), u133 (ref), v109 (copy), GetFFlagEnableConsoleJoinVoice (copy), u89 (ref), u97 (ref), v148 (copy)
				if GetFFlagCleanupMuteSelfButton() then
					if not u88 and not v72 then
						if GetFFlagCleanupMuteSelfButton() then
							u88 = u133()
						else
							u133()
						end
					end
				elseif not v109:FindFirstChild("MuteSelfButton", true) and not v72 then
					if GetFFlagCleanupMuteSelfButton() then
						u88 = u133()
					else
						u133()
					end
				end

				if GetFFlagEnableConsoleJoinVoice() then
					if u89 then
						u89.Visible = false
						u89:Destroy()
						u89 = nil
					end

					u97()
				end

				v148()
			end)
			default.hideVoiceUI.Event:Connect(function() -- line: 2325
				-- upvalues: u87 (ref), u97 (ref), u88 (ref), u125 (ref), destroyAllUserMuteButtons (copy), v148 (copy), resetButtonRow (copy)
				if u87 then
					if u87 then
						u87.Visible = false
						u87:Destroy()
						u87 = nil
					end

					u97()
				end

				if u88 then
					u88.Visible = false
					u88:Destroy()
					u88 = nil
				end

				if u125 then
					u125:Disconnect()
					u125 = nil
				end

				u97()
				destroyAllUserMuteButtons()
				v148()
				resetButtonRow()
			end)
			default.muteAllChanged.Event:Connect(function() -- line: 2334
				-- upvalues: updateAllMuteButtons (copy)
				updateAllMuteButtons()
			end)
		end):catch(function(_) -- line: 2338
			-- upvalues: GetFFlagVoiceChatUILogging (copy), v31 (copy)
			if GetFFlagVoiceChatUILogging() then
				v31:warning("Failed to init VoiceChatServiceManager")
			end
		end)
	end

	v76.Displayed.Event:connect(v148)
	v76.Hidden.Event:connect(function() -- line: 2263
		-- upvalues: u145 (ref), v31 (copy), RunService (copy)
		if u145 then
			v31:debug("Unbinding Playerlist Mic Update Renderstep Hook")
			u145 = false
			RunService:UnbindFromRenderStep("player-list-mute-update")
		end
	end)
	Players.PlayerRemoving:Connect(function(player) -- line: 2348
		-- upvalues: t7 (copy), t6 (copy), GuiService (copy), UserInputService (copy), u86 (ref), GetFFlagDestroyPlayerCardOnLeave (copy)
		t7[player.Name] = nil

		local v361 = t6[player.Name]

		if not v361 then
			return
		end

		local RightSideButtons = v361:FindFirstChild("RightSideButtons")

		if not RightSideButtons then
			return
		end

		local FriendStatus = RightSideButtons:FindFirstChild("FriendStatus")

		if FriendStatus then
			if FriendStatus == GuiService.SelectedCoreObject then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = u86
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			FriendStatus:Destroy()
		end

		local ReportPlayer = RightSideButtons:FindFirstChild("ReportPlayer")

		if ReportPlayer then
			if ReportPlayer == GuiService.SelectedCoreObject then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = u86
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			ReportPlayer:Destroy()
		end

		local MuteStatusButton = RightSideButtons:FindFirstChild("MuteStatusButton")

		if MuteStatusButton then
			if MuteStatusButton == GuiService.SelectedCoreObject then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = u86
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			MuteStatusButton:Destroy()
		end

		local BlockButton = RightSideButtons:FindFirstChild("BlockButton")

		if BlockButton then
			if BlockButton == GuiService.SelectedCoreObject then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = u86
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			BlockButton:Destroy()
		end

		local Inspect = RightSideButtons:FindFirstChild("Inspect")

		if Inspect then
			if Inspect == GuiService.SelectedCoreObject then
				GuiService.SelectedCoreObject = nil
			end

			Inspect:Destroy()
		end

		if GetFFlagDestroyPlayerCardOnLeave() then
			t6[player.Name] = nil
			v361:Destroy()
		end
	end)

	local function removeInspectButtons() -- line: 2425
		-- upvalues: t6 (copy), GuiService (copy)
		for _, v in pairs(t6) do
			local RightSideButtons = v:FindFirstChild("RightSideButtons")

			if RightSideButtons then
				local Inspect = RightSideButtons:FindFirstChild("Inspect")

				if Inspect then
					if Inspect == GuiService.SelectedCoreObject then
						GuiService.SelectedCoreObject = nil
					end

					Inspect:Destroy()
				end
			end
		end
	end

	GuiService.InspectMenuEnabledChangedSignal:Connect(function(p96) -- line: 2442
		-- upvalues: removeInspectButtons (copy)
		if not p96 then
			removeInspectButtons()
		end
	end)

	function v76.CreateMenuButtonsContainer(_) -- line: 2448
		-- upvalues: FIntRelocateMobileMenuButtonsVariant (copy), v76 (copy), ReactRoblox (copy), v109 (copy), React (copy), MenuButtonsContainer (copy)
		if FIntRelocateMobileMenuButtonsVariant == 2 then
			if v76.buttonsContainerRoot then
				return
			end

			v76.buttonsContainerRoot = ReactRoblox.createRoot(v109)

			local ExperienceControlStore = v76.HubRef:GetExperienceControlStore()

			v76.buttonsContainerRoot:render(React.createElement(MenuButtonsContainer, {
				onLeaveGame = ExperienceControlStore.onLeaveGame,
				onRespawn = ExperienceControlStore.onRespawn,
				onResume = ExperienceControlStore.onResume,
				setAddMenuKeyBindings = function() -- line: 2460
				end,
				setRemoveMenuKeyBindings = function() -- line: 2461
				end,
				getVisibility = function() -- line: 2462
					return true
				end,
				getCanRespawn = ExperienceControlStore.getCanRespawn
			}))
		end
	end
	function v76.UnmountMenuButtonsContainer(_) -- line: 2470
		-- upvalues: FFlagMenuButtonsMountWithIEM (copy), FIntRelocateMobileMenuButtonsVariant (copy), v76 (copy)
		if FFlagMenuButtonsMountWithIEM and (FIntRelocateMobileMenuButtonsVariant == 2 and v76.buttonsContainerRoot) then
			v76.buttonsContainerRoot:unmount()
			v76.buttonsContainerRoot = nil
		end
	end

	return v76
end

return (Initialize())
