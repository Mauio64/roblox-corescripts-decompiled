local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local parent = script.Parent
local RequestFriendship = require(parent.Thunks.RequestFriendship)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local PlayerListVisibilityStore = PlayerList.PlayerListVisibilityStore
local PlayerContextualMenuStore = PlayerList.PlayerContextualMenuStore
local builderIcon = PlayerList.builderIcon
local buildMenuHeader = PlayerContextualMenuStore.buildMenuHeader

local LocalPlayer = Players.LocalPlayer

local v = builderIcon("person-plus")
local icon = builderIcon("person-trash-can")
local icon2 = builderIcon("circle-slash")
local icon3 = builderIcon("speech-bubble-exclamation")
local icon4 = builderIcon("magnifying-glass-plus")

local function translate(p: string, p2: string) -- 10 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return RobloxTranslator:FormatByKey(p)
	end)
	return if success and result and result ~= "" then result else p2
end

local function getFriendLabelAndIcon(friendStatus)
	if friendStatus == Enum.FriendStatus.Friend then
		return translate("InGame.PlayerDropDown.Unfriend", "Unfriend"), icon -- inferred equivalent call
	elseif friendStatus == Enum.FriendStatus.FriendRequestSent then
		return translate("InGame.PlayerDropDown.CancelRequest", "Cancel request"), v -- inferred equivalent call
	elseif friendStatus == Enum.FriendStatus.FriendRequestReceived then
		return translate("InGame.PlayerDropDown.Accept", "Accept request"), v -- inferred equivalent call
	else
		return translate("InGame.PlayerDropDown.Action.ConnectionRequest", "Friend request"), v -- inferred equivalent call
	end
end

local function getFriendTelemetryAction(friendStatus): string -- 1 equivalent call inferred from this helper
	if friendStatus == Enum.FriendStatus.Friend then
		return "friend_remove"
	end

	if friendStatus == Enum.FriendStatus.FriendRequestSent then
		return "friend_cancel"
	end

	if friendStatus == Enum.FriendStatus.FriendRequestReceived then
		return "friend_accept"
	end

	return "friend_send"
end

local function openReportDialog(p)
	local isNewInGameMenuEnabled = require(RobloxGui.Modules.isNewInGameMenuEnabled)

	if isNewInGameMenuEnabled() then
		local InGameMenuInit = require(RobloxGui.Modules.InGameMenuInit)
		InGameMenuInit.openReportDialog(p, "PlayerListReskin")
	else
		local ReportAbuseMenuContainerPage = require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuContainerPage)
		ReportAbuseMenuContainerPage:ReportPlayer(p, "PlayerListReskin")
	end
end

local function assembleMenuItems(data)
	local v2 = {}

	if not (data.isSelf or data.isBlocked) then
		local friendLabelAndIcon, icon5 = getFriendLabelAndIcon(data.friendStatus)
		local v3 = data.friendStatus == Enum.FriendStatus.Friend
		local v4 = {
			key = "friend",
			label = friendLabelAndIcon,
			icon = icon5,
			onActivated = data.actions.onFriend,
			telemetryAction = getFriendTelemetryAction(data.friendStatus), -- inferred equivalent call
			onceGroup = "friending",
			requiresConfirm = v3 and true or nil,
			confirmLabel = 0
		}
		local confirmLabel

		if v3 then
			confirmLabel = translate("InGame.PlayerDropDown.ConfirmUnfriend", "Tap to confirm unfriend") -- inferred equivalent call
		end

		v4.confirmLabel = confirmLabel
		table.insert(v2, v4)

		if data.friendStatus == Enum.FriendStatus.FriendRequestReceived then
			local v5 = {
				key = "decline",
				label = translate("InGame.PlayerDropDown.Decline", "Decline"), -- inferred equivalent call
				icon = icon,
				onActivated = data.actions.onDecline,
				telemetryAction = "friend_decline",
				onceGroup = "friending"
			}
			table.insert(v2, v5)
		end
	end

	if data.inspectMenuEnabled then
		local v3 = {
			key = "examine",
			label = translate("InGame.PlayerDropDown.Examine", "Examine avatar"), -- inferred equivalent call
			icon = icon4,
			onActivated = data.actions.onExamine,
			telemetryAction = "avatar_examine"
		}
		table.insert(v2, v3)
	end

	if data.isSelf then
		return v2
	end

	local label

	if data.isBlocked then
		label = translate("InGame.PlayerDropDown.UnBlock", "Unblock") -- inferred equivalent call
	else
		label = translate("InGame.PlayerDropDown.Block", "Block") -- inferred equivalent call
	end

	local v3 = {
		key = "block",
		label = label,
		icon = icon2,
		onActivated = data.actions.onBlock,
		telemetryAction = data.isBlocked and "user_unblock" or "user_block"
	}
	table.insert(v2, v3)

	local v4 = {
		key = "report",
		label = translate("InGame.PlayerDropDown.Report", "Report abuse"), -- inferred equivalent call
		icon = icon3,
		onActivated = data.actions.onReport,
		telemetryAction = "user_report"
	}
	table.insert(v2, v4)

	return v2
end

return {
	buildMenuData = function(player, callback, flag: boolean?, p)
		local userId = player.UserId
		local isSelf

		if LocalPlayer == nil then
			isSelf = false
		else
			isSelf = player == LocalPlayer
		end

		local isBlocked = false
		local friendStatus = Enum.FriendStatus.Unknown

		if not isSelf then
			pcall(function()
				isBlocked = BlockingUtility:IsPlayerBlockedByUserId(userId)
			end)

			if not isBlocked then
				if p == nil then
					pcall(function()
						friendStatus = LocalPlayer:GetFriendStatus(player)
					end)
				else
					friendStatus = p
				end
			end
		end

		local items = assembleMenuItems({
			isSelf = isSelf,
			isBlocked = isBlocked,
			friendStatus = friendStatus,
			inspectMenuEnabled = GuiService:GetInspectMenuEnabled(),
			actions = {
				onFriend = function()
					if
						friendStatus == Enum.FriendStatus.Friend
						or friendStatus == Enum.FriendStatus.FriendRequestSent
					then
						RbxAnalyticsService:TrackEvent("Game", "RevokeFriendship", "PlayerDropDown")
						LocalPlayer:RevokeFriendship(player)
					elseif friendStatus == Enum.FriendStatus.FriendRequestReceived then
						RequestFriendship(player, true)()
					else
						RequestFriendship(player)()
					end
				end,
				onDecline = function()
					RbxAnalyticsService:TrackEvent("Game", "DeclineFriendship", "PlayerDropDown")
					LocalPlayer:RevokeFriendship(player)
				end,
				onExamine = function()
					if flag then
						PlayerContextualMenuStore.setSuppressNextDismissRestore(true)
						PlayerListVisibilityStore.setVisible(false)
					end

					GuiService:InspectPlayerFromUserIdWithCtx(userId, "leaderBoard")
					callback()
				end,
				onBlock = function()
					if flag and not isBlocked then
						PlayerContextualMenuStore.setSuppressNextDismissRestore(true)
						PlayerListVisibilityStore.setVisible(false)
					end

					if isBlocked then
						coroutine.wrap(function()
							BlockingUtility:UnblockPlayerAsync(player)
						end)()
					else
						local onBlockButtonActivated = require(RobloxGui.Modules.Settings.onBlockButtonActivated)
						onBlockButtonActivated(player, nil, "PlayerListReskin", {})
					end

					callback()
				end,
				onReport = function()
					if flag then
						PlayerContextualMenuStore.setSuppressNextDismissRestore(true)
						PlayerListVisibilityStore.setVisible(false)
					end

					openReportDialog(player)
					callback()
				end
			}
		})

		local menuData = {
			player = player,
			header = buildMenuHeader(player),
			items = items,
			telemetry = 0
		}
		local friendStatus2

		if not isSelf then
			friendStatus2 = friendStatus.Name
		end

		menuData.telemetry = { isSelf = isSelf, friendStatus = friendStatus2 }
		return menuData
	end,
	assembleMenuItems = assembleMenuItems,
	getFriendLabelAndIcon = getFriendLabelAndIcon
}
