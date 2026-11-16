local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")
local LocalizationService = game:GetService("LocalizationService")
local VoiceChatServiceManager = require(RobloxGui.Modules.VoiceChat.VoiceChatServiceManager)
local default = VoiceChatServiceManager.default

RobloxGui:WaitForChild("Modules"):WaitForChild("TenFootInterface")
local UserProfiles = require(CorePackages.Workspace.Packages.UserProfiles)
local formatUsername = UserProfiles.Formatters.formatUsername
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local UIBlox = require(CorePackages.Packages.UIBlox)
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local InExperienceLocales = require(CorePackages.Workspace.Packages.InExperienceLocales)
local Localization = InExperienceLocales.Localization

local Utility = require(RobloxGui.Modules.Settings.Utility)
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local ReportAbuseMenuContainerPage = require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuContainerPage)
local SocialUtil = require(RobloxGui.Modules:WaitForChild("SocialUtil"))
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local onBlockButtonActivated = require(script:FindFirstAncestor("Settings").onBlockButtonActivated)
local VoiceAnalytics = require(script:FindFirstAncestor("Settings").Analytics.VoiceAnalytics)
local Constants = require(RobloxGui.Modules.VoiceChat.Constants)
local BlockingAnalytics = require(script:FindFirstAncestor("Settings").Analytics.BlockingAnalytics)
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)
local MenuButtonsContainer = require(RobloxGui.Modules.Settings.Components.MenuButtons.MenuButtonsContainer)

local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local uiblox = BuilderIcons.Migration.uiblox

local GameInvite = require(CorePackages.Workspace.Packages.GameInvite)
local GameInviteAnalyticsManager = GameInvite.GameInviteAnalyticsManager

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagUserProfilePlatformProfile = SharedFlags.FFlagUserProfilePlatformProfile
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags.GetFFlagLuaAppEnableOpenTypeSupport
local FFlagIEMTabFocusNav = SharedFlags.FFlagIEMTabFocusNav
local isSideSheetEnabled = require(CorePackages.Workspace.Packages.InExperienceSideSheetUtils.isSideSheetEnabled)
local FFlagRelocateMobileMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagRelocateMobileMenuButtons)
local FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
local FFlagMenuButtonsMountWithIEM = require(RobloxGui.Modules.Settings.Flags.FFlagMenuButtonsMountWithIEM)
local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local FFlagHidePeoplePageInviteFriends = SharedFlags.FFlagHidePeoplePageInviteFriends
local FFlagAddInviteFriendsIntegration = SharedFlags.FFlagAddInviteFriendsIntegration

local UserProfileStore = UserProfiles.Stores.UserProfileStore

local _, result = pcall(function()
	return game:GetService("PlatformFriendsService")
end)

local Theme = require(script.Parent.Parent.Theme)

local Constants2 = require(RobloxGui.Modules:WaitForChild("InGameMenu"):WaitForChild("Resources"):WaitForChild("Constants"))

local udim = UDim2.new(0.5, -10, 0, 52)

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
local defineFastFlag = game:DefineFastFlag("EnableConsoleJoinVoiceTranslation", false)
local defineFastFlag2 = game:DefineFastFlag("CheckButtonFrameBeforeDestroy", false)

local isEngineTruncationEnabledForIngameSettings = require(RobloxGui.Modules.Flags.isEngineTruncationEnabledForIngameSettings)

local engineFeature2 = game:GetEngineFeature("VoiceChatMultistreamSubscriptionsEnabled")

local defineFastFlag3 = game:DefineFastFlag("LuaFlagVoiceChatDisableSubscribeRetryForMultistream", true)
local defineFastFlag4 = game:DefineFastFlag("PlayerListRefactorUsernameFormatting", false)
local defineFastFlag5 = game:DefineFastFlag("CheckShareGameButtonInMuteAllLayout", false)
local defineFastFlag6 = game:DefineFastFlag("OnlyCaptureFocusIfOnPlayerPage", false)

local defineFastInt = game:DefineFastInt("SettingsHubPlayersButtonsResponsiveThreshold", 200)
local GetFFlagCleanupMuteSelfButton = require(RobloxGui.Modules.Settings.Flags.GetFFlagCleanupMuteSelfButton)

local defineFastFlag7 = game:DefineFastFlag("CheckForNilUserIdOnPlayerList", false)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()

local muteStatusIcons = default.MuteStatusIcons
local playerMuteStatusIcons = default.PlayerMuteStatusIcons

local function Initialize()
	local SettingsPageFactory = require(RobloxGui.Modules.Settings.SettingsPageFactory)
	local newPage = SettingsPageFactory:CreateNewPage()

	newPage.PageListLayout.Padding = UDim.new(0, 16)
	newPage.playSessionId = ""

	if engineFeature then
		newPage.playSessionId = RbxAnalyticsService:GetPlaySessionId()
	end

	local v2 = {}
	local robloxLocaleId = LocalizationService.RobloxLocaleId

	if not v2[robloxLocaleId] then
		v2[robloxLocaleId] = Localization.new(robloxLocaleId)
	end

	newPage.TabHeader.Name = "PlayersTab"
	local iconsmenufriends = uiblox["icons/menu/friends"]
	newPage.TabHeader.TabLabel.Icon.Text = iconsmenufriends.name
	newPage.TabHeader.TabLabel.Icon.FontFace = BuilderIcons.Font[iconsmenufriends.variant]

	newPage.TabHeader.TabLabel.Title.Text = "People"

	local function getFriendStatus(p)
		local success, result2 = pcall(function()
			return LocalPlayer:GetFriendStatus(p)
		end)

		return if success then result2 else Enum.FriendStatus.NotFriend
	end

	newPage.Page.Name = "Players"

	local function showRightSideButtons(p)
		if p then
			if p == LocalPlayer or not (p.UserId > 0) then
				p = false
			else
				p = LocalPlayer.UserId > 0
			end
		end

		return p
	end

	local function useOptimizedPortraitLayout() -- 3 equivalent calls inferred from this helper
		return Utility:IsSmallTouchScreen() and Utility:IsPortrait()
	end

	local function getIsBlocked(p) -- 2 equivalent calls inferred from this helper
		return BlockingUtility:IsPlayerBlockedByUserId(p.UserId)
	end

	local function createFriendStatusTextLabel(result2, p)
		if result2 == nil then
			return nil
		end

		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1

		local friendStatus = nil
		local v3 = nil

		if result2 == Enum.FriendStatus.Friend or result2 == Enum.FriendStatus.FriendRequestSent then
			friendStatus = Instance.new("TextButton")
			friendStatus.BackgroundTransparency = 1
			friendStatus.FontSize = Theme.fontSize(Enum.FontSize.Size24)
			friendStatus.Font = Theme.font(Enum.Font.SourceSans)
			friendStatus.TextColor3 = Color3.new(1, 1, 1)
			friendStatus.SelectionImageObject = frame

			if result2 == Enum.FriendStatus.Friend then
				friendStatus.Text = v2[robloxLocaleId]:Format(Constants2.FriendLocalizedKey)
			else
				friendStatus.Text = "Request Sent"
			end
		elseif
			result2 == Enum.FriendStatus.Unknown
			or result2 == Enum.FriendStatus.NotFriend
			or result2 == Enum.FriendStatus.FriendRequestReceived
		then
			local function fn()
				if friendStatus and v3 and v3.Text ~= "" then
					friendStatus.ImageTransparency = 1
					v3.Text = ""

					if GetFFlagDefaultFriendingLabelTextNonEmpty() then
						v3.Text = v2[robloxLocaleId]:Format(Constants2.AddFriendLocalizedKey)
					end

					if LocalPlayer and p then
						RbxAnalyticsService:ReportCounter("PlayersMenu-RequestFriendship")
						RbxAnalyticsService:SetRBXEventStream(
							Constants2.AnalyticsTargetName,
							Constants2.AnalyticsRequestFriendContext,
							Constants2.AnalyticsRequestFriendName,
							{ category = "Game" }
						)

						LocalPlayer:RequestFriendship(p)
					end
				end
			end

			friendStatus, v3 = Utility:MakeStyledButton(
				"FriendStatus",
				v2[robloxLocaleId]:Format(Constants2.AddFriendLocalizedKey),
				UDim2.new(0, 182, 0, Theme.ButtonHeight),
				fn
			)

			v3.ZIndex = 3
			v3.Position += UDim2.new(0, 0, 0, 1)
		end

		if not friendStatus then
			return friendStatus
		end

		friendStatus.Name = "FriendStatus"
		friendStatus.ZIndex = 3
		friendStatus.Size = UDim2.new(0, 150, 0, Theme.ButtonHeight)
		friendStatus.Position = UDim2.new(1, -198, 0, 7)

		if v3 then
			v3.Position = UDim2.new(0, 0, 0, 0)
		end

		return friendStatus
	end

	local function createFriendStatusImageLabel(result2, p)
		if result2 == Enum.FriendStatus.Friend or result2 == Enum.FriendStatus.FriendRequestSent then
			local v3, textTransparency

			if result2 == Enum.FriendStatus.Friend then
				v3 = "icons/menu/friends"
				textTransparency = 0
			else
				v3 = "icons/actions/friends/friendAdd"
				textTransparency = 0.5
			end

			local friendStatus, _ = Utility:MakeStyledImageButton(
				"FriendStatus",
				v3,
				UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight),
				UDim2.new(0, 28, 0, 28)
			)

			friendStatus.Name = "FriendStatus"
			friendStatus.Selectable = false
			friendStatus.FriendStatusTextLabel.TextTransparency = textTransparency

			return friendStatus
		else
			if
				result2 ~= Enum.FriendStatus.Unknown
				and result2 ~= Enum.FriendStatus.NotFriend
				and result2 ~= Enum.FriendStatus.FriendRequestReceived
			then
				return nil
			end

			local friendStatus = nil
			local v3 = nil
			local function fn()
				if friendStatus and v3 and friendStatus.ImageTransparency ~= 1 then
					friendStatus.ImageTransparency = 1
					v3.TextTransparency = 1

					if LocalPlayer and p then
						RbxAnalyticsService:ReportCounter("PlayersMenu-RequestFriendship")
						RbxAnalyticsService:SetRBXEventStream(
							Constants2.AnalyticsTargetName,
							Constants2.AnalyticsRequestFriendContext,
							Constants2.AnalyticsRequestFriendName,
							{ category = "Game" }
						)

						LocalPlayer:RequestFriendship(p)
					end
				end
			end
			friendStatus, v3 = Utility:MakeStyledImageButton(
				"FriendStatus",
				"icons/actions/friends/friendAdd",
				UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight),
				UDim2.new(0, 28, 0, 28),
				fn
			)

			friendStatus.Name = "FriendStatus"
			friendStatus.Selectable = true
			return friendStatus
		end
	end

	local selectedCoreObject2 = nil
	local v3 = nil
	local v4 = nil
	local v5 = nil
	local v6 = {}
	local v7 = VoiceAnalytics.new(RbxAnalyticsService, "Players")

	local v8 = false

	local v9 = {}
	local parent2 = nil
	local v10 = nil

	local function fn(): boolean
		return newPage.Page.AbsoluteSize.X < defineFastInt * #v9
	end

	local function fn2()
		v9 = {}

		if selectedCoreObject2 then
			table.insert(v9, selectedCoreObject2)
		end

		if v3 then
			table.insert(v9, v3)
		end

		if v4 then
			table.insert(v9, v4)
		end

		if GetFFlagEnableConsoleJoinVoice() and v5 then
			table.insert(v9, v5)
		end

		v8 = fn()

		if #v9 > 0 then
			local udim2 = UDim2.new(1 / #v9, 0, 0, 52)
			local v11 = {
				Size = UDim2.new(1, (#v9 - 1) * -20, 0, 52),
				AutomaticSize = Enum.AutomaticSize.None
			}

			local v12 = {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20)
			}

			if v8 then
				udim2 = UDim2.new(1, 0, 0, 52)
				v11 = { Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y }

				v12 = {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 16)
				}
			end

			local layoutOrder = 1

			for _, v13 in v9 do
				v13.Size = udim2
				v13.Parent = parent2
				v13.LayoutOrder = layoutOrder
				layoutOrder += 1
			end

			for k, v13 in v12 do
				if GetFFlagCleanupMuteSelfButton() then
					if v10 then
						v10[k] = v13
					end
				else
					v10[k] = v13
				end
			end

			for k, v13 in v11 do
				if GetFFlagCleanupMuteSelfButton() then
					if parent2 then
						parent2[k] = v13
					end
				else
					parent2[k] = v13
				end
			end
		elseif defineFastFlag2 then
			if parent2 then
				parent2:Destroy()
				parent2 = nil
			end
		else
			parent2:Destroy()
			parent2 = nil
		end
	end

	local function getDisplayNameLabel(instance) -- 3 equivalent calls inferred from this helper
		if instance and instance.Parent then
			return instance:FindFirstChild("DisplayNameLabel")
		end

		return nil
	end

	local function getInExperienceCombinedName(list)
		if #list == 0 then
			return ""
		end

		local item = list[1]

		if item == nil then
			return ""
		end

		local names = item.names

		if names == nil then
			return ""
		end

		return names.getInExperienceCombinedName(false)
	end

	local function resizeFriendButton(parent, p, p2, p3)
		local friendStatus = parent:FindFirstChild("FriendStatus")

		if friendStatus and p2 == p3 then
			return
		end

		if friendStatus then
			friendStatus:Destroy()
			friendStatus = nil
		end

		local result2 = nil
		local v11

		if p then
			if p == LocalPlayer or not (p.UserId > 0) then
				v11 = false
			else
				v11 = LocalPlayer.UserId > 0
			end
		else
			v11 = p
		end

		if v11 then
			local success
			success, result2 = pcall(function()
				return LocalPlayer:GetFriendStatus(p)
			end)

			if not success then
				result2 = Enum.FriendStatus.NotFriend
			end
		end

		if getIsBlocked(p) == false then -- inferred equivalent call
			if p2 then
				friendStatus = createFriendStatusImageLabel(result2, p)
			else
				friendStatus = createFriendStatusTextLabel(result2, p)
			end
		end

		if friendStatus then
			friendStatus.Name = "FriendStatus"
			friendStatus.LayoutOrder = 5
			friendStatus.Selectable = true
			Utility:MakeFocusState(friendStatus, "utility-focus-state" .. "-friendstatuslabel-" .. p.Name)
			friendStatus.Parent = parent
		end
	end

	local function friendStatusCreate(instance, p)
		local rightSideButtons

		if instance then
			rightSideButtons = instance:FindFirstChild("RightSideButtons")
		end

		if rightSideButtons then
			for _, child in pairs(rightSideButtons:GetChildren()) do
				if not (child and child.Name == "FriendStatus") then
					continue
				end

				if GuiService.SelectedCoreObject == child then
					GuiService.SelectedCoreObject = selectedCoreObject2
				end

				child:Destroy()
			end

			resizeFriendButton(rightSideButtons, p, Utility:IsPortrait(), nil)
		end
	end

	LocalPlayer.FriendStatusChanged:connect(function(p, _)
		local child = p and newPage.Page:FindFirstChild("PlayerLabel" .. p.Name)

		if child then
			friendStatusCreate(child, p)
		end
	end)

	local resizeBlockButton
	local trySelection
	local v11 = BlockingAnalytics.new(LocalPlayer.UserId, { EventStream = RbxAnalyticsService })

	local function createBlockButton(parent, p, p2, _)
		local isBlocked = getIsBlocked(p) -- inferred equivalent call

		local function updateBlockButton(p3) -- 1 equivalent call inferred from this helper
			local v12 = resizeBlockButton(parent, p, p2, not p2)
			resizeFriendButton(parent, p, p2, not p2)

			if p3 then
				trySelection(v12)
			end
		end

		local function blockUser()
			local v12 = GuiService.SelectedCoreObject ~= nil or GuiService.SelectedObject ~= nil
			onBlockButtonActivated(p, v11, Constants2.AnalyticsInGameMenuName):andThen(function()
				updateBlockButton(v12) -- inferred equivalent call
			end)
		end

		local function unBlockUser()
			if BlockingUtility:UnblockPlayerAsync(p) then
				v11:action("SettingsHub", "unblockUser", { blockeeUserId = p.UserId })
				resizeBlockButton(parent, p, p2, not p2)
				resizeFriendButton(parent, p, p2, not p2)
			end
		end

		if isBlocked then
			return Utility:MakeStyledButton(
				"BlockButton",
				RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.Unblock"),
				UDim2.new(0, 110, 0, Theme.ButtonHeight),
				unBlockUser
			)
		end

		return Utility:MakeStyledImageButton(
			"BlockButton",
			"icons/actions/block",
			UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight),
			UDim2.new(0, 28, 0, 28),
			blockUser
		)
	end

	trySelection = function(selectedCoreObject)
		if selectedCoreObject and not selectedCoreObject.Selectable then
			GuiService:Select(selectedCoreObject)
		else
			GuiService.SelectedCoreObject = selectedCoreObject
		end
	end

	resizeBlockButton = function(parent, p, p2, p3)
		local blockButton = parent:FindFirstChild("BlockButton")

		if blockButton and p2 == p3 then
			return blockButton
		end

		if blockButton then
			blockButton:Destroy()
			blockButton = nil
		end

		local v12

		if p then
			if p == LocalPlayer or not (p.UserId > 0) then
				v12 = false
			else
				v12 = LocalPlayer.UserId > 0
			end
		else
			v12 = p
		end

		if v12 then
			blockButton = createBlockButton(parent, p, p2, p3)
		end

		if not blockButton then
			return blockButton
		end

		blockButton.Name = "BlockButton"
		blockButton.LayoutOrder = 4
		blockButton.Selectable = true
		Utility:MakeFocusState(blockButton, "utility-focus-state" .. "-blockbutton-" .. p.Name)
		blockButton.Parent = parent

		return blockButton
	end

	local v12 = false
	local v13 = false

	local function muteButtonUpdate(instance, data)
		local rightSideButtons

		if instance then
			rightSideButtons = instance:FindFirstChild("RightSideButtons")
		end

		if not rightSideButtons then
			return
		end

		local muteStatusButton = rightSideButtons:FindFirstChild("MuteStatusButton")

		if data == nil then
			if muteStatusButton then
				muteStatusButton:Destroy()
			end
		else
			local udim2 = UDim2.fromOffset(36, 36)
			local udim3 = UDim2.fromOffset(0, 0)
			local imageTransparency = 0

			local image = data.isMuted and muteStatusIcons.MicOff or muteStatusIcons.MicOn

			if data.subscriptionFailed then
				image = muteStatusIcons.Error
				udim2 = UDim2.fromOffset(36, 36)
				udim3 = UDim2.fromOffset(2, -2)

				if defineFastFlag3 and engineFeature2 then
					imageTransparency = 0.5
				end
			elseif data.isMutedLocally then
				image = muteStatusIcons.MicDisabled
				imageTransparency = 0.5
			elseif data.subscriptionCompleted then
				if data.isSignalActive then
					image = default:GetIcon(
						"Unmuted" .. tostring(math.floor(0.5 + 5 * math.random()) * 20),
						"SpeakerLight"
					)
				end
			else
				image = muteStatusIcons.Loading
			end

			if muteStatusButton then
				local v14 = v6[data.userId] or rightSideButtons:FindFirstChild("MuteStatusImageLabel", true)
				v14.Image = image
				v14.Size = udim2
				v14.ImageTransparency = imageTransparency
			elseif default.voiceUIVisible then
				local styledImageButton, v14 = Utility:MakeStyledImageButton(
					"MuteStatus",
					image,
					UDim2.fromOffset(Theme.ButtonHeight, Theme.ButtonHeight),
					udim2,
					function()
						local participant = default.participants[tostring(data.userId)]

						if participant.subscriptionCompleted then
							if v7 then
								v7:onToggleMutePlayer(data.userId, not participant.isMutedLocally)
							end

							default:ToggleMutePlayer(data.userId, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
						elseif participant.subscriptionFailed then
							if defineFastFlag3 then
								if not engineFeature2 then
									default:SubscribeRetry(data.userId)
								end
							else
								default:SubscribeRetry(data.userId)
							end
						end
					end
				)

				v6[data.userId] = v14
				v14.ZIndex = 3
				v14.Position += udim3
				v14.ImageTransparency = imageTransparency
				Utility:MakeFocusState(styledImageButton, "utility-focus-state" .. "-mutestatusbutton-" .. data.userId)
				styledImageButton.Parent = rightSideButtons
			end
		end
	end

	local v14 = Create("Frame")({
		Name = "ButtonsContainer",
		Size = UDim2.new(1, 0, 0, Theme.ButtonHeight),
		BackgroundTransparency = 1,
		Parent = newPage.Page,
		Visible = false
	})

	newPage.ButtonsContainer = v14

	if
		isSideSheetEnabled
		or FFlagRelocateMobileMenuButtons
		and (FIntRelocateMobileMenuButtonsVariant == 1 or FIntRelocateMobileMenuButtonsVariant == 3)
	then
		v14.Parent = nil
	end

	Create("UIPadding")({
		PaddingBottom = UDim.new(0, 1),
		PaddingTop = UDim.new(0, 1),
		PaddingLeft = UDim.new(0, 1),
		PaddingRight = UDim.new(0, 1),
		Parent = v14
	})

	local function fn3()
		if
			GetFFlagEnableLeaveGameUpsellEntrypoint()
			and newPage.HubRef.leaveGameUpsellProp ~= Constants.PHONE_UPSELL_VALUE_PROP.None
		then
			newPage.HubRef:SwitchToPage(newPage.HubRef.LeaveGameUpsellPage, nil, 1, true)
		else
			newPage.HubRef:SwitchToPage(newPage.HubRef.LeaveGamePage, false, 1)
		end
	end

	local styledButton, parent = Utility:MakeStyledButton("LeaveButton", "Leave", UDim2.new(1 / 3, -12, 1, 0), fn3)
	styledButton.AnchorPoint = Vector2.new(0, 0)
	styledButton.Position = UDim2.new(0, 0, 0, 0)
	parent.Size = UDim2.new(1, -4, 1, 0)
	parent.Position = UDim2.new(0, 2, 0, 0)
	Create("UIListLayout")({
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Parent = styledButton
	})

	Create("UIPadding")({ PaddingLeft = UDim.new(0.025, 0), Parent = styledButton })

	parent.Size = UDim2.new(0, 0, 1, 0)

	Create("UIFlexItem")({ FlexMode = Enum.UIFlexMode.Grow, Parent = parent })

	if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
		styledButton.Parent = v14
	end

	local styledButton2, v15 = Utility:MakeStyledButton(
		"ResetButton",
		v2[robloxLocaleId]:Format(Constants2.RespawnLocalizedKey),
		UDim2.new(1 / 3, -12, 1, 0),
		function()
			newPage.HubRef:SwitchToPage(newPage.HubRef.ResetCharacterPage, false, 1)
		end
	)
	styledButton2.AnchorPoint = Vector2.new(0.5, 0)
	styledButton2.Position = UDim2.new(0.5, 0, 0, 0)
	v15.Size = UDim2.new(1, -4, 1, 0)
	v15.Position = UDim2.new(0, 2, 0, 0)

	if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
		styledButton2.Parent = v14
	end

	local function fn4()
		newPage.HubRef:SetVisibility(false)
		RbxAnalyticsService:SetRBXEventStream(
			Constants2.AnalyticsTargetName,
			Constants2.AnalyticsResumeGameName,
			Constants2.AnalyticsMenuActionName,
			{
				source = Constants2.AnalyticsResumeButtonSource,
				playsessionid = newPage.playSessionId,
				universeid = tostring(game.GameId)
			}
		)
	end

	local styledButton3, v16 = Utility:MakeStyledButton("ResumeButton", "Resume", UDim2.new(1 / 3, -12, 1, 0), fn4)
	styledButton3.AnchorPoint = Vector2.new(1, 0)
	styledButton3.Position = UDim2.new(1, 0, 0, 0)
	v16.Size = UDim2.new(1, -4, 1, 0)
	v16.Position = UDim2.new(0, 2, 0, 0)

	if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
		styledButton3.Parent = v14

		if FFlagIEMTabFocusNav then
			newPage.FirstSelectableObjects = { styledButton3, styledButton2, styledButton }
			newPage.FirstSelectableObjectsUpdated:fire()
		end
	end

	local function pollImage()
		local localMuted = default.localMuted

		if localMuted == nil then
			return playerMuteStatusIcons.Loading
		end

		if localMuted then
			return playerMuteStatusIcons.MicOff
		end

		if default.isTalking then
			return (default:GetIcon("Unmuted" .. tostring(math.floor(0.5 + 5 * math.random()) * 20), "MicLight"))
		end

		return playerMuteStatusIcons.MicOn
	end

	local function updateButtonPosition(p, position, size, anchorPoint) -- 3 equivalent calls inferred from this helper
		local child = v14:FindFirstChild(p .. "Button", true)

		if not child then
			return
		end

		child.Position = position
		child.Size = size
		child.AnchorPoint = anchorPoint
	end

	local function muteButtonReset() -- 1 equivalent call inferred from this helper
		local playerMuteButtonButton = v14:FindFirstChild("PlayerMuteButtonButton", true)

		if playerMuteButtonButton then
			playerMuteButtonButton:Destroy()
		end
	end

	local function resetButtonRow()
		if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
			updateButtonPosition("ResumeButton", UDim2.new(1, 0, 0, 0), UDim2.new(1 / 3, -12, 1, 0), Vector2.new(1, 0)) -- inferred equivalent call

			updateButtonPosition( -- inferred equivalent call
				"ResetButton",
				UDim2.new(0.5, 0, 0, 0),
				UDim2.new(1 / 3, -12, 1, 0),
				Vector2.new(0.5, 0)
			)

			updateButtonPosition("LeaveButton", UDim2.new(0, 0, 0, 0), UDim2.new(1 / 3, -12, 1, 0), Vector2.new(0, 0)) -- inferred equivalent call
		end

		muteButtonReset() -- inferred equivalent call
	end

	local function updateMuteSelfButtonIcon() -- 2 equivalent calls inferred from this helper
		local muteSelfButtonImageLabel = nil

		if GetFFlagCleanupMuteSelfButton() then
			if parent2 then
				muteSelfButtonImageLabel = parent2:FindFirstChild("MuteSelfButtonImageLabel", true)
			end
		else
			muteSelfButtonImageLabel = parent2:FindFirstChild("MuteSelfButtonImageLabel", true)
		end

		if not muteSelfButtonImageLabel then
			return
		end

		muteSelfButtonImageLabel.Image = pollImage()
	end

	Utility:OnResized(v14, function(_, p)
		if (p or Utility:IsSmallTouchScreen()) and not Theme.AlwaysShowBottomBar() then
			local textSize = p and Theme.textSize(18) or Theme.textSize(24)
			v14.Visible = true
			v14.Size = UDim2.new(1, 0, 0, Theme.ButtonHeight)

			if not FFlagRelocateMobileMenuButtons or FIntRelocateMobileMenuButtonsVariant == 0 then
				v15.TextSize = textSize
				parent.TextSize = textSize
				v16.TextSize = textSize
			end
		else
			v14.Visible = false
			v14.Size = UDim2.new(1, 0, 0, 0)
		end
	end)

	local function reportAbuseButtonCreate(instance, player)
		local rightSideButtons = instance:FindFirstChild("RightSideButtons")

		if rightSideButtons then
			local reportPlayer = rightSideButtons:FindFirstChild("ReportPlayer")

			if reportPlayer then
				reportPlayer:Destroy()
			end

			local v17

			if player then
				if player == LocalPlayer or not (player.UserId > 0) then
					v17 = false
				else
					v17 = LocalPlayer.UserId > 0
				end
			else
				v17 = player
			end

			if v17 then
				local function fn5()
					ReportAbuseMenuContainerPage:ReportPlayer(player, "MenuPlayerList")
				end

				local reportPlayer2 = Utility:MakeStyledImageButton(
					"ReportPlayer",
					"icons/actions/feedback",
					UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight),
					UDim2.new(0, 28, 0, 28),
					fn5
				)

				reportPlayer2.Name = "ReportPlayer"
				reportPlayer2.Position = UDim2.new(1, -260, 0, 7)
				reportPlayer2.LayoutOrder = 3
				reportPlayer2.Selectable = true
				Utility:MakeFocusState(reportPlayer2, "utility-focus-state" .. "-reportplayer-" .. player.Name)
				reportPlayer2.Parent = rightSideButtons
			end
		end
	end

	local flag = false
	local eventConnection = nil

	local function muteAllButtonRemove() -- 2 equivalent calls inferred from this helper
		if v3 then
			v3.Visible = false
			v3:Destroy()
			v3 = nil
		end

		fn2()
	end

	local function muteSelfButtonRemove() -- 2 equivalent calls inferred from this helper
		if v4 then
			v4.Visible = false
			v4:Destroy()
			v4 = nil
		end

		if eventConnection then
			eventConnection:Disconnect()
			eventConnection = nil
		end

		fn2()
	end

	local function joinVoiceButtonRemove() -- 3 equivalent calls inferred from this helper
		if v5 then
			v5.Visible = false
			v5:Destroy()
			v5 = nil
		end

		fn2()
	end

	local function shouldShowJoinVoiceButton()
		local v17 = GetFFlagEnableConsoleJoinVoice()
			and game:GetEngineFeature("VoiceChatSupported")
			and not (flag or enabled)
			and default:verifyUniverseAndPlaceCanUseVoice()
			and default:ShouldShowJoinVoiceOnDisconnect()

		if v17 then
			if default:GetVoiceConnectCookie() == "" then
				return (default:HasSeamlessVoiceFeature("InitialJoinVoice"))
			end

			return false
		end

		return v17
	end

	local function createRow(className, p, flag2: boolean?)
		local instance = Instance.new(className)
		instance.Size = UDim2.new(1, 0, 0, 62)
		instance.Position = UDim2.new(0, 0, 0, 0)
		instance.ZIndex = 2
		instance.BackgroundColor3 = Theme.color("PlayerRowFrame")
		instance.BackgroundTransparency = Theme.transparency("PlayerRowFrame")
		Create("UICorner")({ CornerRadius = Theme.DefaultCornerRadius, Parent = instance })
		local icon

		if flag2 then
			icon = Instance.new("TextLabel")
			icon.TextColor3 = Color3.new(1, 1, 1)
			icon.TextSize = 24
		else
			icon = Instance.new("ImageLabel")
		end

		icon.Name = "Icon"
		icon.BackgroundTransparency = 1
		icon.Size = UDim2.new(0, 36, 0, 36)
		icon.Position = UDim2.new(0, 12, 0, 12)
		icon.ZIndex = 3
		icon.Parent = instance

		local textLabel = Instance.new("TextLabel")
		textLabel.Text = ""
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Font = Theme.font(Enum.Font.SourceSans, "DisplayName")
		textLabel.FontSize = p and Theme.fontSize(Enum.FontSize.Size36, "DisplayName")
			or Theme.fontSize(Enum.FontSize.Size24, "DisplayName")
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.BackgroundTransparency = 1
		textLabel.Position = p and UDim2.new(0, 60, 0.5, -10) or UDim2.new(0, 60, 0.5, 0)
		textLabel.Size = UDim2.new(0, 0, 0, 0)
		textLabel.ZIndex = 3
		textLabel.Parent = instance

		if not p then
			return instance
		end

		local secondRow = Instance.new("TextLabel")
		secondRow.Text = ""
		secondRow.Name = "SecondRow"
		secondRow.TextXAlignment = Enum.TextXAlignment.Left
		secondRow.Font = Theme.font(Enum.Font.SourceSans)
		secondRow.FontSize = Theme.fontSize(Enum.FontSize.Size24, "Username")
		secondRow.TextColor3 = Color3.fromRGB(162, 162, 162)
		secondRow.BackgroundTransparency = 1
		secondRow.Position = UDim2.new(0, 60, 0.5, 12)
		secondRow.Size = UDim2.new(0, 0, 0, 0)
		secondRow.ZIndex = 3
		secondRow.Parent = instance

		return instance
	end

	local function fn5()
		local row = createRow("ImageButton", nil, true)
		row.Size = UDim2.new(1, 0, 0, 52)
		local textLabel = row.TextLabel
		local icon = row.Icon

		if flag or GetFFlagEnableConsoleJoinVoice() and shouldShowJoinVoiceButton() then
			row.Size = udim
			textLabel.Size = UDim2.new(1, -60, 0, 0)
			textLabel.TextTruncate = Enum.TextTruncate.AtEnd
			row.AnchorPoint = Vector2.new(0, 0)
		end

		textLabel.Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		textLabel.AutoLocalize = false
		textLabel.Text = v2[robloxLocaleId]:Format(Constants2.InviteFriendsLocalizedKey)

		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 18, 0.5, 0)
		local iconsactionsfriendsfriendInvite = uiblox["icons/actions/friends/friendInvite"]
		local iconsactionsfriendsfriendInvite2

		if iconsactionsfriendsfriendInvite then
			iconsactionsfriendsfriendInvite2 = uiblox["icons/actions/friends/friendInvite"]
		else
			iconsactionsfriendsfriendInvite2 = Theme.Images["icons/actions/friends/friendInvite"]
		end

		if iconsactionsfriendsfriendInvite2 then
			if iconsactionsfriendsfriendInvite then
				icon.Text = iconsactionsfriendsfriendInvite2.name
				icon.FontFace = BuilderIcons.Font[iconsactionsfriendsfriendInvite2.variant]
			else
				icon.Image = iconsactionsfriendsfriendInvite2.Image
				icon.ImageRectOffset = iconsactionsfriendsfriendInvite2.ImageRectOffset
				icon.ImageRectSize = iconsactionsfriendsfriendInvite2.ImageRectSize
			end
		end

		local function setIsHighlighted(p) -- 6 equivalent calls inferred from this helper
			if p then
				row.ImageTransparency = 0.65
			else
				row.ImageTransparency = 0.85
			end
		end

		row.InputBegan:Connect(function()
			setIsHighlighted(true) -- inferred equivalent call
		end)
		row.InputEnded:Connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.Activated:Connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.TouchPan:Connect(function(_, p)
			if math.abs(p.Y) > 20 then
				setIsHighlighted(false) -- inferred equivalent call
			end
		end)

		row.SelectionGained:connect(function()
			setIsHighlighted(true) -- inferred equivalent call
		end)
		row.SelectionLost:connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.SelectionImageObject = row:Clone()

		Utility:MakeFocusState(row, "utility-focus-state-sharegame")

		return row
	end

	local function fn6()
		local row = createRow("ImageButton")
		row.Size = UDim2.new(selectedCoreObject2 and 0.5 or 1, -10, 0, 52)
		row.Position = UDim2.new(1, 0, 0, 0)
		row.AnchorPoint = Vector2.new(1, 0)
		local textLabel = row.TextLabel
		local icon = row.Icon

		textLabel.Size = UDim2.new(1, -60, 0, 0)
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel.Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		textLabel.AutoLocalize = false
		textLabel.Text = RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.MuteAll")

		icon.Size = UDim2.new(0, 32, 0, 32)
		icon.Position = UDim2.new(0, 18, 0, 16)
		icon.Image = default:GetIcon("UnmuteAll", "Misc")
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 18, 0.5, 0)

		local function setIsHighlighted(p) -- 6 equivalent calls inferred from this helper
			if p then
				row.ImageTransparency = 0.65
			else
				row.ImageTransparency = 0.85
			end
		end

		row.InputBegan:Connect(function()
			setIsHighlighted(true) -- inferred equivalent call
		end)
		row.InputEnded:Connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.Activated:Connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.TouchPan:Connect(function(_, p)
			if math.abs(p.Y) > 20 then
				setIsHighlighted(false) -- inferred equivalent call
			end
		end)

		row.SelectionGained:connect(function()
			setIsHighlighted(true) -- inferred equivalent call
		end)
		row.SelectionLost:connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.SelectionImageObject = row:Clone()

		Utility:MakeFocusState(row, "utility-focus-state-muteall")

		return row
	end

	local function fn7()
		local muteSelfButton = createRow("ImageButton")
		muteSelfButton.Name = "MuteSelfButton"
		muteSelfButton.Size = UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight)
		muteSelfButton.Position = UDim2.new(1, 0, 0, 0)
		muteSelfButton.AnchorPoint = Vector2.new(1, 0)
		local textLabel = muteSelfButton.TextLabel
		local muteSelfButtonImageLabel = muteSelfButton.Icon

		textLabel.Size = UDim2.new(1, -60, 0, 0)
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel.Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		textLabel.AutoLocalize = false

		muteSelfButtonImageLabel.Name = "MuteSelfButtonImageLabel"
		muteSelfButtonImageLabel.Size = UDim2.new(0, 32, 0, 32)
		muteSelfButtonImageLabel.Position = UDim2.new(0, 18, 0, 16)
		muteSelfButtonImageLabel.Image = pollImage()
		muteSelfButtonImageLabel.AnchorPoint = Vector2.new(0, 0.5)
		muteSelfButtonImageLabel.Position = UDim2.new(0, 18, 0.5, 0)

		local function setIsHighlighted(p) -- 6 equivalent calls inferred from this helper
			if p then
				muteSelfButton.ImageTransparency = 0.65
			else
				muteSelfButton.ImageTransparency = 0.85
			end
		end

		muteSelfButton.InputBegan:Connect(function()
			setIsHighlighted(true) -- inferred equivalent call
		end)
		muteSelfButton.InputEnded:Connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		muteSelfButton.Activated:Connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		muteSelfButton.TouchPan:Connect(function(_, p)
			if math.abs(p.Y) > 20 then
				setIsHighlighted(false) -- inferred equivalent call
			end
		end)

		muteSelfButton.SelectionGained:connect(function()
			setIsHighlighted(true) -- inferred equivalent call
		end)
		muteSelfButton.SelectionLost:connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		muteSelfButton.SelectionImageObject = muteSelfButton:Clone()

		Utility:MakeFocusState(muteSelfButton, "utility-focus-state-playermute")

		local function updatePlayerMuteText(p) -- 1 equivalent call inferred from this helper
			textLabel.Text = v2[robloxLocaleId]:Format(p and "CoreScripts.InGameMenu.QuickActions.UnmuteSelf" or "CoreScripts.InGameMenu.QuickActions.MuteSelf")
		end

		local v17 = default.localMuted and "CoreScripts.InGameMenu.QuickActions.UnmuteSelf"
			or "CoreScripts.InGameMenu.QuickActions.MuteSelf"
		textLabel.Text = v2[robloxLocaleId]:Format(v17)

		eventConnection = default.muteChanged.Event:Connect(function(p)
			v12 = p
			updateMuteSelfButtonIcon() -- inferred equivalent call
			updatePlayerMuteText(p) -- inferred equivalent call
		end)

		muteSelfButton.Activated:Connect(function()
			default:ToggleMic("InGameMenuPlayers")

			if v7 then
				v7:onToggleMuteSelf(v12)
			end
		end)

		if GetFFlagCleanupMuteSelfButton() then
			return muteSelfButton
		end

		v4 = muteSelfButton
	end

	local function addMuteButtonExperience() -- 1 equivalent call inferred from this helper
		if enabled then
			return
		end

		if GetFFlagCleanupMuteSelfButton() then
			v4 = fn7()
		else
			fn7()
		end
	end

	local fn8 = GetFFlagEnableConsoleJoinVoice() and function()
		local row = createRow("ImageButton", nil, true)
		row.Size = UDim2.new(1, 0, 0, 52)
		row.Size = udim
		row.AnchorPoint = Vector2.new(0, 0)

		local textLabel = row.TextLabel
		textLabel.Size = UDim2.new(1, -60, 0, 0)
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd

		textLabel.Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold")
		textLabel.AutoLocalize = false

		if defineFastFlag then
			textLabel.Text = v2[robloxLocaleId]:Format("Feature.SettingsHub.Action.ConnectVoiceChat")
		else
			textLabel.Text = "Connect Voice Chat"
		end

		local icon = row.Icon
		icon.AnchorPoint = Vector2.new(0, 0.5)
		icon.Position = UDim2.new(0, 18, 0.5, 0)

		local iconscontrolspublicAudioJoin = uiblox["icons/controls/publicAudioJoin"]
		local iconscontrolspublicAudioJoin2

		if iconscontrolspublicAudioJoin then
			iconscontrolspublicAudioJoin2 = uiblox["icons/controls/publicAudioJoin"]
		else
			iconscontrolspublicAudioJoin2 = Theme.Images["icons/controls/publicAudioJoin"]
		end

		if iconscontrolspublicAudioJoin2 then
			if iconscontrolspublicAudioJoin then
				icon.Text = iconscontrolspublicAudioJoin2.name
				icon.FontFace = BuilderIcons.Font[iconscontrolspublicAudioJoin2.variant]
			else
				icon.Image = iconscontrolspublicAudioJoin2.Image
				icon.ImageRectOffset = iconscontrolspublicAudioJoin2.ImageRectOffset
				icon.ImageRectSize = iconscontrolspublicAudioJoin2.ImageRectSize
			end
		end

		local function setIsHighlighted(p) -- 6 equivalent calls inferred from this helper
			if p then
				row.ImageTransparency = 0.65
			else
				row.ImageTransparency = 0.85
			end
		end

		row.InputBegan:Connect(function()
			setIsHighlighted(true) -- inferred equivalent call
		end)
		row.InputEnded:Connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.Activated:Connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.TouchPan:Connect(function(_, p)
			if math.abs(p.Y) > 20 then
				setIsHighlighted(false) -- inferred equivalent call
			end
		end)

		row.SelectionGained:connect(function()
			setIsHighlighted(true) -- inferred equivalent call
		end)
		row.SelectionLost:connect(function()
			setIsHighlighted(false) -- inferred equivalent call
		end)
		row.SelectionImageObject = row:Clone()

		Utility:MakeFocusState(row, "utility-focus-state-joinVoice")

		row.Activated:Connect(function()
			default.pendingConnectionSource = Constants.VOICE_CONNECTION_SOURCE.SETTINGS_TOGGLE_ON
			default:JoinVoice()
		end)

		return row
	end or nil

	local function addJoinVoiceButton() -- 1 equivalent call inferred from this helper
		if shouldShowJoinVoiceButton() and not v5 then
			v5 = fn8()
		end
	end

	local function createInspectButtonImage(fn9) -- 1 equivalent call inferred from this helper
		return (Utility:MakeStyledImageButton(
			"InspectButton",
			"icons/actions/zoomIn",
			UDim2.new(0, Theme.ButtonHeight, 0, Theme.ButtonHeight),
			UDim2.new(0, 28, 0, 28),
			fn9
		))
	end

	local function resizeInspectButton(rightSideButtons, player, p, p2)
		local inspect = rightSideButtons:FindFirstChild("Inspect")

		if inspect and p == p2 then
			return
		end

		if inspect then
			inspect:Destroy()
		end

		local function fn9()
			RbxAnalyticsService:SetRBXEventStream(
				Constants2.AnalyticsTargetName,
				Constants2.AnalyticsExamineAvatarName,
				Constants2.AnalyticsMenuActionName,
				{ playsessionid = newPage.playSessionId, universeid = tostring(game.GameId) }
			)

			GuiService:InspectPlayerFromUserIdWithCtx(player.UserId, "escapeMenu")
			newPage.HubRef:SetVisibility(false)
		end

		local inspect2 = createInspectButtonImage(fn9) -- inferred equivalent call
		inspect2.Name = "Inspect"
		inspect2.LayoutOrder = 2
		inspect2.Selectable = true
		inspect2.Parent = rightSideButtons
		Utility:MakeFocusState(inspect2, "utility-focus-state" .. "-inspect-" .. player.Name)
	end

	local function resizePlatformName(rightSideButtons, p, p2)
		local platformNameContainer = rightSideButtons:FindFirstChild("PlatformNameContainer")

		if platformNameContainer then
			platformNameContainer:Destroy()
		end

		if p == nil then
			return
		end

		local platformNameContainer2 = Instance.new("Frame")
		platformNameContainer2.Name = "PlatformNameContainer"
		platformNameContainer2.BackgroundTransparency = 1
		platformNameContainer2.ZIndex = 3
		platformNameContainer2.Position = UDim2.new(0, 0, 0, 0)
		platformNameContainer2.Size = UDim2.new(0, 0, 1, 0)
		platformNameContainer2.AutomaticSize = Enum.AutomaticSize.X
		platformNameContainer2.Selectable = false
		platformNameContainer2.LayoutOrder = -1
		platformNameContainer2.Parent = rightSideButtons

		local fn9 = game:GetEngineFeature("PlatformFriendsService")
			and game:GetEngineFeature("PlatformFriendsProfile")
			and result
			and result:IsProfileEnabled()
			and p2
			and p2 ~= ""
			and function()
				result:ShowProfile(p2)
			end
			or nil

		local styledButton4, v17 = Utility:MakeStyledButton(
			"consoleNameContainer",
			p,
			UDim2.new(0, 0, 0, Theme.ButtonHeight),
			fn9
		)

		styledButton4.AnchorPoint = Vector2.new(0, 0.5)
		styledButton4.Position = UDim2.fromScale(0, 0.5)
		styledButton4.AutomaticSize = Enum.AutomaticSize.X
		styledButton4.Parent = platformNameContainer2

		v17.Size = UDim2.fromScale(0, 1)
		v17.AutoLocalize = false
		v17.TextSize = Theme.platformNameTextSize
		v17.TextScaled = false
		v17.TextWrapped = false
		v17.AutomaticSize = Enum.AutomaticSize.X

		local v18 = Create("ImageLabel")({
			Name = "iconLabel",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = Theme.platformNameIconSize,
			Image = "rbxasset://textures/ui/Shell/Icons/PlatformLogo@3x.png",
			ImageColor3 = Color3.new(1, 1, 1)
		})

		v18.Parent = styledButton4

		local instance = Create("UIListLayout")({
			Name = "PLatformNameUIListLayout",
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		})

		instance.Parent = styledButton4

		v18.LayoutOrder = 1
		v17.LayoutOrder = 2

		Create("UIPadding")({
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			Parent = styledButton4
		})

		return platformNameContainer2
	end

	local function fn9()
		local row = createRow("ImageLabel", true)
		row.TextLabel.Name = "DisplayNameLabel"
		row.SecondRow.Name = "NameLabel"
		row.Selectable = false
		row.SelectionGroup = true

		if GetFFlagLuaAppEnableOpenTypeSupport() then
			row.NameLabel.OpenTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
		end

		local rightSideButtons = Instance.new("Frame")
		rightSideButtons.Name = "RightSideButtons"
		rightSideButtons.BackgroundTransparency = 1
		rightSideButtons.ZIndex = 2
		rightSideButtons.Position = UDim2.new(0, 0, 0, 0)
		rightSideButtons.Size = UDim2.new(1, -12, 1, 0)
		rightSideButtons.Parent = row

		local frame = nil

		local function fn10(guiObject) -- 2 equivalent calls inferred from this helper
			if row then
				if
					GuiService.SelectedCoreObject
					and GuiService.SelectedCoreObject ~= guiObject
					and GuiService.SelectedCoreObject.Parent == rightSideButtons
				then
					row.ImageTransparency = 0.65
				else
					row.ImageTransparency = 0.85
				end
			end
		end

		rightSideButtons.ChildAdded:connect(function(guiObject)
			if guiObject:IsA("GuiObject") then
				if frame and guiObject ~= frame then
					frame:Destroy()
					frame = nil
				end

				guiObject.SelectionGained:connect(function()
					fn10(nil) -- inferred equivalent call
				end)
				guiObject.SelectionLost:connect(function()
					fn10(guiObject) -- inferred equivalent call
				end)
			end
		end)

		frame = Instance.new("Frame")
		frame.Selectable = true
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundTransparency = 1
		frame.SelectionImageObject = frame:Clone()
		frame.Parent = rightSideButtons

		local rightSideListLayout = Instance.new("UIListLayout")
		rightSideListLayout.Name = "RightSideListLayout"
		rightSideListLayout.FillDirection = Enum.FillDirection.Horizontal
		rightSideListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		rightSideListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		rightSideListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		rightSideListLayout.Padding = UDim.new(0, 12)
		rightSideListLayout.Parent = rightSideButtons

		pcall(function()
			row.NameLabel.Localize = false

			row.DisplayNameLabel.Localize = false
		end)

		return row
	end

	local function managePlayerNameCutoff(instance, player)
		local v17 = nil
		local childAddedConnection = nil
		local function reportFlagChanged(p, p2, text)
			if p2 == "AbsolutePosition" and v17 then
				local v18 = p.AbsolutePosition.X - 20 - instance.NameLabel.AbsolutePosition.X
				instance.NameLabel.Text = "@" .. player.Name
				instance.DisplayNameLabel.Text = player.DisplayName

				if text then
					instance.DisplayNameLabel.Text = text
				end

				local v19 = utf8.len(player.DisplayName)

				if text then
					v19 = utf8.len(text)
				end

				while v18 < instance.NameLabel.TextBounds.X and v19 > 0 do
					if text then
						local v20 = utf8.offset(text, v19)
						instance.NameLabel.Text = string.sub(text, 1, v20) .. "..."
					else
						local v20 = utf8.offset(player.DisplayName, v19)
						instance.NameLabel.Text = string.sub(player.DisplayName, 1, v20) .. "..."
					end

					v19 -= 1
				end

				local v20 = "@" .. player.Name
				local v21 = string.len(v20)

				while v18 < instance.NameLabel.TextBounds.X and v21 > 0 do
					instance.NameLabel.Text = string.sub(v20, 1, v21) .. "..."
					v21 -= 1
				end
			end
		end

		local function reportFlagChangedWithCombinedName(p, _, _)
			if defineFastFlag7 and not player.UserId then
				reportFlagChanged(p, "AbsolutePosition")
			else
				UserProfileStore.get().fetchNamesByUserIds({ (tostring(player.UserId)) }, function(p2)
					local displayNameLabel = getDisplayNameLabel(instance) -- inferred equivalent call

					if displayNameLabel == nil then
						return
					end

					local data = p2.data
					local v18

					if #data == 0 then
						v18 = ""
					else
						local v19 = data[1]

						if v19 == nil then
							v18 = ""
						else
							local names = v19.names
							v18 = names == nil and "" or names.getInExperienceCombinedName(false)
						end
					end

					if string.len(v18) > 0 and v18 ~= displayNameLabel.Text then
						reportFlagChanged(p, "AbsolutePosition", v18)
					elseif player.DisplayName ~= displayNameLabel.Text then
						reportFlagChanged(p, "AbsolutePosition")
					end
				end)
			end
		end

		if not isEngineTruncationEnabledForIngameSettings() then
			Utility:OnResized(instance.NameLabel, function(_, p)
				if v17 ~= nil and v17 == p then
					return
				end

				if p then
					p = not useOptimizedPortraitLayout() -- inferred equivalent call
				end

				v17 = p

				if p then
					if childAddedConnection == nil then
						childAddedConnection = instance.RightSideButtons.ChildAdded:connect(function(p2)
							if p2.Name == "Inspect" then
								p2.Changed:connect(function(_)
									reportFlagChangedWithCombinedName(p2, "AbsolutePosition")
								end)
								reportFlagChangedWithCombinedName(p2, "AbsolutePosition")
							end
						end)
					end

					local inspect = instance.RightSideButtons:FindFirstChild("Inspect")

					if inspect then
						inspect.Changed:connect(function(p2)
							reportFlagChangedWithCombinedName(inspect, p2)
						end)

						reportFlagChangedWithCombinedName(inspect, "AbsolutePosition")
					end
				else
					if not instance:FindFirstChild("NameLabel") then
						return
					end

					instance.NameLabel.Text = "@" .. player.Name

					if defineFastFlag7 and not player.UserId then
						instance.DisplayNameLabel.Text = player.DisplayName
					else
						UserProfileStore.get().fetchNamesByUserIds({ (tostring(player.UserId)) }, function(p2)
							local displayNameLabel = getDisplayNameLabel(instance) -- inferred equivalent call

							if displayNameLabel == nil then
								return
							end

							local data = p2.data
							local text

							if #data == 0 then
								text = ""
							else
								local v18 = data[1]

								if v18 == nil then
									text = ""
								else
									local names = v18.names
									text = names == nil and "" or names.getInExperienceCombinedName(false)
								end
							end

							if string.len(text) > 0 and text ~= displayNameLabel.Text then
								displayNameLabel.Text = text
								return
							end

							local displayName = player.DisplayName

							if displayName ~= displayNameLabel.Text then
								displayNameLabel.Text = displayName
							end
						end)
					end
				end
			end)
		end

		local function getNearestRightSideButtonXPosition()
			local x = nil

			for _, button in pairs(instance.RightSideButtons:GetChildren()) do
				if button:IsA("ImageButton") and (not x or button.AbsolutePosition.X < x) then
					x = button.AbsolutePosition.X
				end
			end

			return x
		end

		local v18 = nil
		local function rightSideButtonsChanged()
			local nearestRightSideButtonXPosition = getNearestRightSideButtonXPosition()

			if nearestRightSideButtonXPosition == v18 then
				return
			end

			v18 = nearestRightSideButtonXPosition
			local udim2

			if nearestRightSideButtonXPosition then
				udim2 = UDim2.new(0, nearestRightSideButtonXPosition - instance.NameLabel.AbsolutePosition.X - 20, 0, 0)
			else
				udim2 = UDim2.new(1, -20, 0, 0)
			end

			instance.NameLabel.Size = udim2
			instance.DisplayNameLabel.Size = udim2
			local nameLabel = instance.NameLabel
			local text

			if defineFastFlag4 then
				text = formatUsername(player.Name)
			else
				text = "@" .. player.Name
			end

			nameLabel.Text = text

			if defineFastFlag7 and not player.UserId then
				instance.DisplayNameLabel.Text = player.DisplayName
			else
				UserProfileStore.get().fetchNamesByUserIds({ (tostring(player.UserId)) }, function(p)
					local displayNameLabel = getDisplayNameLabel(instance) -- inferred equivalent call

					if displayNameLabel == nil then
						return
					end

					local data = p.data
					local text2

					if #data == 0 then
						text2 = ""
					else
						local v19 = data[1]

						if v19 == nil then
							text2 = ""
						else
							local names = v19.names
							text2 = names == nil and "" or names.getInExperienceCombinedName(false)
						end
					end

					if string.len(text2) > 0 and text2 ~= displayNameLabel.Text then
						displayNameLabel.Text = text2
						return
					end

					local displayName = player.DisplayName

					if displayName ~= displayNameLabel.Text then
						displayNameLabel.Text = displayName
					end
				end)
			end
		end

		if isEngineTruncationEnabledForIngameSettings() then
			childAddedConnection = instance.RightSideButtons.ChildAdded:connect(function(instance2)
				rightSideButtonsChanged()
				instance2:GetPropertyChangedSignal("AbsolutePosition"):Connect(rightSideButtonsChanged)
			end)

			rightSideButtonsChanged()
		end
	end

	local function canShareCurrentGame(): boolean -- 2 equivalent calls inferred from this helper
		return LocalPlayer.UserId > 0
	end

	local players = nil
	local v17 = {}
	local v18 = {}

	local flag2 = false

	local function updateAllMuteButtons()
		if not (v3 and default.voiceUIVisible) then
			return
		end

		local players2 = Players:GetPlayers()
		local flag3 = true

		for _, player in ipairs(players2) do
			local v19 = v17[player.Name]

			if not (player and v19) then
				continue
			end

			local participant = default.participants[tostring(player.UserId)]

			if participant and not participant.isMutedLocally then
				flag3 = false
			end

			muteButtonUpdate(v19, participant)
		end

		v13 = if flag3 then true else false
		local text = v13 and RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.UnmuteAll")
			or RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.MuteAll")

		if v3 and v3:FindFirstChild("TextLabel") then
			v3.TextLabel.Text = text
			v3.Icon.Image = default:GetIcon(v13 and "MuteAll" or "UnmuteAll", "Misc")
		end
	end

	local function destroyAllUserMuteButtons()
		local players2 = Players:GetPlayers()

		for _, player in players2 do
			local v19 = v17[player.Name]

			if not v19 then
				continue
			end

			local rightSideButtons = v19:FindFirstChild("RightSideButtons")

			if not rightSideButtons then
				continue
			end

			local muteStatusButton = rightSideButtons:FindFirstChild("MuteStatusButton")

			if not muteStatusButton then
				continue
			end

			if GuiService.SelectedCoreObject == muteStatusButton then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = selectedCoreObject2
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			muteStatusButton:Destroy()
		end
	end

	local function fn10(_)
		newPage.LastSelectableObjects = {}

		if FFlagIEMTabFocusNav and not newPage.ButtonsContainer.Visible then
			newPage.FirstSelectableObjects = {}
		end

		players = Players:GetPlayers()

		if enabled then
			table.sort(players, function(a, b): boolean
				local name = a.Name:lower()
				local name2 = b.Name:lower()

				return (a == LocalPlayer and " " or name) < (b == LocalPlayer and " " or name2)
			end)
		else
			table.sort(players, function(a, b): boolean
				return a.Name:lower() < b.Name:lower()
			end)
		end

		local v19 = (Utility:IsSmallTouchScreen() or Utility:IsPortrait()) and 85 or 20

		local voiceUIVisible = flag and not v3 and default.voiceUIVisible
		local v20 = FFlagHidePeoplePageInviteFriends and FFlagAddInviteFriendsIntegration and isSideSheetEnabled
		local v21 = canShareCurrentGame() and not selectedCoreObject2 and not (RunService:IsStudio() or v20) -- inferred equivalent call

		if (v21 or voiceUIVisible) and not parent2 then
			parent2 = Create("Frame")({
				Name = "Holder",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Parent = newPage.Page,
				LayoutOrder = 1
			})

			v10 = Create("UIListLayout")({
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 20),
				Parent = parent2
			})
		end

		local function layoutMuteAll()
			if not parent2 then
				parent2 = Create("Frame")({
					Name = "Holder",
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 52),
					Parent = newPage.Page,
					LayoutOrder = 1
				})
			end

			selectedCoreObject2.Parent = parent2
			selectedCoreObject2.Size = udim
			v3.Parent = parent2
		end

		local v22 = not RunService:IsStudio()

		if canShareCurrentGame() and not selectedCoreObject2 and v22 and not v20 then -- inferred equivalent call
			local v23 = GameInviteAnalyticsManager:withButtonName(GameInviteAnalyticsManager.ButtonName.SettingsHub)

			selectedCoreObject2 = fn5()
			selectedCoreObject2.Activated:connect(function()
				v23:inputShareGameEntryPoint()

				newPage.HubRef:InviteToGame()
			end)

			selectedCoreObject2.LayoutOrder = 1

			if voiceUIVisible then
				selectedCoreObject2.Parent = parent2
			else
				selectedCoreObject2.Parent = newPage.Page
			end
		end

		if GetFFlagEnableConsoleJoinVoice() and shouldShowJoinVoiceButton() then
			addJoinVoiceButton() -- inferred equivalent call
			fn2()
		end

		if FFlagIEMTabFocusNav then
			if voiceUIVisible then
				table.insert(newPage.FirstSelectableObjects, v3)
			end

			if v21 then
				table.insert(newPage.FirstSelectableObjects, selectedCoreObject2)
			end

			if voiceUIVisible or v21 then
				newPage.FirstSelectableObjectsUpdated:fire()
			end
		end

		local inspectMenuEnabled = GuiService:GetInspectMenuEnabled()

		for i = 1, #players do
			local player = players[i]

			local v23 = v17[player.Name]

			if not player then
				continue
			end

			v18[player.Name] = true

			if not (v23 and v23.Parent) then
				v23 = fn9((i - 1) * 80 + v19)
				v23.Parent = newPage.Page
				v17[player.Name] = v23
			end

			v23.Name = "PlayerLabel" .. player.Name

			if flag then
				muteButtonUpdate(v23, default.participants[tostring(player.UserId)])
			end

			local playerImage = SocialUtil.GetPlayerImage(
				math.max(1, player.UserId),
				Enum.ThumbnailSize.Size100x100,
				Enum.ThumbnailType.AvatarThumbnail
			)

			v23.Icon.Image = playerImage

			local nameLabel = v23.NameLabel
			local text

			if defineFastFlag4 then
				text = formatUsername(player.Name)
			else
				text = "@" .. player.Name
			end

			nameLabel.Text = text

			v23.ImageTransparency = 0.85

			v23.LayoutOrder = i + 1

			if isEngineTruncationEnabledForIngameSettings() then
				v23.NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
				v23.DisplayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
			end

			managePlayerNameCutoff(v23, player)

			friendStatusCreate(v23, player)

			local v24 = nil
			Utility:OnResized(v23, function(_, p)
				local rightSideButtons = v23:FindFirstChild("RightSideButtons")
				local displayNameLabel = v23:FindFirstChild("DisplayNameLabel")
				local nameLabel2 = v23:FindFirstChild("NameLabel")
				local rightSideListLayout = rightSideButtons and rightSideButtons:FindFirstChild("RightSideListLayout")

				if useOptimizedPortraitLayout() then -- inferred equivalent call
					v23.Size = UDim2.new(1, 0, 0, 105)

					if displayNameLabel then
						if nameLabel2 then
							displayNameLabel.Position = UDim2.new(0, 60, 0.275, -10)
							nameLabel2.Position = UDim2.new(0, 60, 0.275, 12)
						else
							displayNameLabel.Position = UDim2.new(0, 60, 0.275, 0)
						end
					end

					if rightSideButtons then
						rightSideButtons.Position = UDim2.new(0, 57, 0, -2)
						rightSideButtons.Size = UDim2.new(1, -12, 0.99, -8)
					end

					if rightSideListLayout then
						rightSideListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
						rightSideListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
					end
				else
					v23.Size = UDim2.new(1, 0, 0, 62)

					if displayNameLabel then
						if nameLabel2 then
							displayNameLabel.Position = UDim2.new(0, 60, 0.5, -10)
							nameLabel2.Position = UDim2.new(0, 60, 0.5, 12)
						else
							displayNameLabel.Position = UDim2.new(0, 60, 0.5, 0)
						end
					end

					if rightSideButtons then
						rightSideButtons.Position = UDim2.new(0, 0, 0, 0)
						rightSideButtons.Size = UDim2.new(1, -12, 1, 0)
					end

					if rightSideListLayout then
						rightSideListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
						rightSideListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
					end
				end

				if rightSideButtons then
					resizeFriendButton(rightSideButtons, player, p, v24)
					resizeBlockButton(rightSideButtons, player, p, v24)

					if inspectMenuEnabled then
						resizeInspectButton(rightSideButtons, player, p, v24)
					end

					v24 = p
				end
			end)

			reportAbuseButtonCreate(v23, player)

			if i == #players then
				local rightSideButtons = v23:FindFirstChild("RightSideButtons")

				if rightSideButtons then
					for _, button in rightSideButtons:GetChildren() do
						if button:IsA("ImageButton") then
							table.insert(newPage.LastSelectableObjects, button)
						end
					end

					newPage.LastSelectableObjectsUpdated:fire()
				end
			end

			if not (FFlagIEMTabFocusNav and i == 1 and #newPage.FirstSelectableObjects == 0) then
				continue
			end

			local rightSideButtons = v23:FindFirstChild("RightSideButtons")

			if not rightSideButtons then
				continue
			end

			for _, button in rightSideButtons:GetChildren() do
				if button:IsA("ImageButton") then
					table.insert(newPage.FirstSelectableObjects, button)
				end
			end

			newPage.FirstSelectableObjectsUpdated:fire()
		end

		if voiceUIVisible then
			v3 = fn6()
			v3.Activated:connect(function()
				v13 = not v13
				local text = v13 and RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.UnmuteAll")
					or RobloxTranslator:FormatByKey("Feature.SettingsHub.Action.MuteAll")
				v3.TextLabel.Text = text
				v3.Icon.Image = default:GetIcon(v13 and "MuteAll" or "UnmuteAll", "Misc")

				if GetFFlagVoiceChatUILogging() then
					v:debug("{} all players", v13 and "Muting" or "Unmuting")
				end

				if v7 then
					v7:onToggleMuteAll(v13)
				end

				default:MuteAll(v13, Constants.VOICE_CONTEXT_TYPE.IN_GAME_MENU)
				updateAllMuteButtons()
			end)

			v3.LayoutOrder = 1

			if not defineFastFlag5 or selectedCoreObject2 ~= nil then
				layoutMuteAll()
			else
				v3.Parent = parent2
			end

			fn2()
		end

		local v23

		if defineFastFlag7 then
			v23 = Cryo.List.filterMap(players, function(p)
				if p.UserId then
					return (tostring(p.UserId))
				end

				return nil
			end)
		else
			v23 = Cryo.List.filter(players, function(p)
				return (tostring(p.UserId))
			end)
		end

		for _, player in ipairs(players) do
			v17[player.Name].DisplayNameLabel.Text = player.DisplayName
		end

		UserProfileStore.get().fetchNamesByUserIds(v23, function(p)
			for _, v24 in p.data do
				local v25 = v17[v24.names.getUsername(false)]

				if not v25 then
					continue
				end

				local text = v24.names.getInExperienceCombinedName(false)

				if string.len(text) > 0 and text ~= v25.DisplayNameLabel.Text then
					v25.DisplayNameLabel.Text = text
				end

				local rightSideButtons = v25:FindFirstChild("RightSideButtons")
				local v26

				if v24.names.getPlatformName(false) ~= "" then
					v26 = v24.names.getPlatformName(false)
				end

				if
					game:GetEngineFeature("PlatformFriendsService")
					and game:GetEngineFeature("PlatformFriendsProfile")
				then
					resizePlatformName(rightSideButtons, v26, v24.getPlatformProfileId(false))
				else
					resizePlatformName(rightSideButtons, v26)
				end
			end
		end, FFlagUserProfilePlatformProfile)

		local count = 0

		if flag and not flag2 then
			v:debug("Setting Up Playerlist Mic Update Renderstep Hook")
			RunService:BindToRenderStep("player-list-mute-update", Enum.RenderPriority.Last.Value, function()
				count += 1

				if count % 3 == 0 then
					updateAllMuteButtons()
					updateMuteSelfButtonIcon() -- inferred equivalent call
				end
			end)
			flag2 = true
		end

		for k, v24 in pairs(v17) do
			if v18[k] then
				continue
			end

			v24:Destroy()
			v17[k] = nil
		end

		if UserInputService.GamepadEnabled and not (FFlagIEMTabFocusNav and GuiService.SelectedCoreObject) then
			if GetFFlagCleanupMuteSelfButton() then
				pcall(function()
					if defineFastFlag6 then
						if newPage.Active then
							GuiService.SelectedCoreObject = selectedCoreObject2
						end
					else
						GuiService.SelectedCoreObject = selectedCoreObject2
					end
				end)
			else
				GuiService.SelectedCoreObject = selectedCoreObject2
			end
		end

		Utility:OnResized("MenuPlayerListExtraPageSize", function(_, _)
			local v24 = (Utility:IsSmallTouchScreen() or Utility:IsPortrait()) and 85 or 20

			local v25 = #players + 1

			if useOptimizedPortraitLayout() then -- inferred equivalent call
				newPage.Page.Size = UDim2.new(1, 0, 0, v24 + v25 * 123 - 5)
			else
				newPage.Page.Size = UDim2.new(1, 0, 0, v24 + v25 * 80 - 5)
			end
		end)
	end

	local function fn11()
		if flag2 then
			v:debug("Unbinding Playerlist Mic Update Renderstep Hook")
			flag2 = false
			RunService:UnbindFromRenderStep("player-list-mute-update")
		end
	end

	if game:GetEngineFeature("VoiceChatSupported") and not flag then
		default:asyncInit():andThen(function()
			flag = true
			default:SetupParticipantListeners()
			addMuteButtonExperience() -- inferred equivalent call
			default.participantsUpdate.Event:Connect(function()
				updateAllMuteButtons()
			end)
			default.participantLeft.Event:Connect(function(_, p)
				updateAllMuteButtons()
				v6[p] = nil
			end)
			default:getService().StateChanged:Connect(function(_, p)
				if p == Enum.VoiceChatState.Ended then
					muteAllButtonRemove() -- inferred equivalent call
					muteSelfButtonRemove() -- inferred equivalent call

					if GetFFlagEnableConsoleJoinVoice() then
						joinVoiceButtonRemove() -- inferred equivalent call
					end

					flag = false
				elseif p == Enum.VoiceChatState.Joined and flag == false then
					flag = true

					if GetFFlagEnableConsoleJoinVoice() then
						joinVoiceButtonRemove() -- inferred equivalent call
					end

					fn10()
				end
			end)

			if not GetFFlagCleanupMuteSelfButton() then
				fn10()
			end

			default.showVoiceUI.Event:Connect(function()
				if GetFFlagCleanupMuteSelfButton() then
					if not (v4 or enabled) then
						if GetFFlagCleanupMuteSelfButton() then
							v4 = fn7()
						else
							fn7()
						end
					end
				elseif not (v14:FindFirstChild("MuteSelfButton", true) or enabled) then
					if GetFFlagCleanupMuteSelfButton() then
						v4 = fn7()
					else
						fn7()
					end
				end

				if GetFFlagEnableConsoleJoinVoice() then
					joinVoiceButtonRemove() -- inferred equivalent call
				end

				fn10()
			end)
			default.hideVoiceUI.Event:Connect(function()
				if v3 then
					muteAllButtonRemove() -- inferred equivalent call
				end

				muteSelfButtonRemove() -- inferred equivalent call
				destroyAllUserMuteButtons()
				fn10()
				resetButtonRow()
			end)
			default.muteAllChanged.Event:Connect(function()
				updateAllMuteButtons()
			end)
		end):catch(function(_)
			if GetFFlagVoiceChatUILogging() then
				v:warning("Failed to init VoiceChatServiceManager")
			end
		end)
	end

	newPage.Displayed.Event:connect(fn10)
	newPage.Hidden.Event:connect(fn11)

	Players.PlayerRemoving:Connect(function(player)
		v18[player.Name] = nil

		local v19 = v17[player.Name]

		if not v19 then
			return
		end

		local rightSideButtons = v19:FindFirstChild("RightSideButtons")

		if not rightSideButtons then
			return
		end

		local friendStatus = rightSideButtons:FindFirstChild("FriendStatus")

		if friendStatus then
			if GuiService.SelectedCoreObject == friendStatus then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = selectedCoreObject2
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			friendStatus:Destroy()
		end

		local reportPlayer = rightSideButtons:FindFirstChild("ReportPlayer")

		if reportPlayer then
			if GuiService.SelectedCoreObject == reportPlayer then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = selectedCoreObject2
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			reportPlayer:Destroy()
		end

		local muteStatusButton = rightSideButtons:FindFirstChild("MuteStatusButton")

		if muteStatusButton then
			if GuiService.SelectedCoreObject == muteStatusButton then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = selectedCoreObject2
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			muteStatusButton:Destroy()
		end

		local blockButton = rightSideButtons:FindFirstChild("BlockButton")

		if blockButton then
			if GuiService.SelectedCoreObject == blockButton then
				if UserInputService.GamepadEnabled then
					GuiService.SelectedCoreObject = selectedCoreObject2
				else
					GuiService.SelectedCoreObject = nil
				end
			end

			blockButton:Destroy()
		end

		local inspect = rightSideButtons:FindFirstChild("Inspect")

		if inspect then
			if GuiService.SelectedCoreObject == inspect then
				GuiService.SelectedCoreObject = nil
			end

			inspect:Destroy()
		end

		if GetFFlagDestroyPlayerCardOnLeave() then
			v17[player.Name] = nil
			v19:Destroy()
		end
	end)

	local function removeInspectButtons()
		for _, v19 in pairs(v17) do
			local rightSideButtons = v19:FindFirstChild("RightSideButtons")

			if not rightSideButtons then
				continue
			end

			local inspect = rightSideButtons:FindFirstChild("Inspect")

			if not inspect then
				continue
			end

			if GuiService.SelectedCoreObject == inspect then
				GuiService.SelectedCoreObject = nil
			end

			inspect:Destroy()
		end
	end

	GuiService.InspectMenuEnabledChangedSignal:Connect(function(p)
		if not p then
			removeInspectButtons()
		end
	end)

	function newPage.CreateMenuButtonsContainer(_)
		if FIntRelocateMobileMenuButtonsVariant == 2 then
			if newPage.buttonsContainerRoot then
				return
			end

			newPage.buttonsContainerRoot = ReactRoblox.createRoot(v14)
			local experienceControlStore = newPage.HubRef:GetExperienceControlStore()
			newPage.buttonsContainerRoot:render(React.createElement(MenuButtonsContainer, {
				onLeaveGame = experienceControlStore.onLeaveGame,
				onRespawn = experienceControlStore.onRespawn,
				onResume = experienceControlStore.onResume,
				setAddMenuKeyBindings = function() end,
				setRemoveMenuKeyBindings = function() end,
				getVisibility = function(): boolean
					return true
				end,
				getCanRespawn = experienceControlStore.getCanRespawn
			}))
		end
	end

	function newPage.UnmountMenuButtonsContainer(_)
		if
			FFlagMenuButtonsMountWithIEM
			and FIntRelocateMobileMenuButtonsVariant == 2
			and newPage.buttonsContainerRoot
		then
			newPage.buttonsContainerRoot:unmount()
			newPage.buttonsContainerRoot = nil
		end
	end

	return newPage
end

return Initialize()
