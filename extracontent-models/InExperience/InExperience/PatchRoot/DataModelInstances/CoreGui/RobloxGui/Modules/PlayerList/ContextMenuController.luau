local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local scriptParent = script.Parent
local RequestFriendship = require(scriptParent.Thunks.RequestFriendship)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local PlayerListVisibilityStore = PlayerList.PlayerListVisibilityStore
local PlayerContextualMenuStore = PlayerList.PlayerContextualMenuStore
local builderIcon = PlayerList.builderIcon
local buildMenuHeader = PlayerContextualMenuStore.buildMenuHeader
local LocalPlayer = Players.LocalPlayer
local v17 = builderIcon("person-plus")
local v18 = builderIcon("person-trash-can")
local v19 = builderIcon("circle-slash")
local v20 = builderIcon("speech-bubble-exclamation")
local v21 = builderIcon("magnifying-glass-plus")

local function translate(s1: string, s2: string) -- line: 43
	-- upvalues: RobloxTranslator (copy)
	local ok, result = pcall(function() -- line: 44
		-- upvalues: RobloxTranslator (copy), s1 (copy)
		return RobloxTranslator:FormatByKey(s1)
	end)

	if ok and (result and result ~= "") then
		return result
	end

	return s2
end
local function getFriendLabelAndIcon(p1) -- line: 53
	-- upvalues: RobloxTranslator (copy), v18 (copy), v17 (copy)
	if p1 == Enum.FriendStatus.Friend then
		local s3 = "InGame.PlayerDropDown.UnFriend"
		local ok, result = pcall(function() -- line: 44
			-- upvalues: RobloxTranslator (copy), s3 (copy)
			return RobloxTranslator:FormatByKey(s3)
		end)

		return (not ok or (not result or result == "")) and "Unfriend" or result, v18
	end

	if p1 == Enum.FriendStatus.FriendRequestSent then
		local s4 = "InGame.PlayerDropDown.CancelRequest"
		local ok, result = pcall(function() -- line: 44
			-- upvalues: RobloxTranslator (copy), s4 (copy)
			return RobloxTranslator:FormatByKey(s4)
		end)

		return (not ok or (not result or result == "")) and "Cancel request" or result, v17
	end

	if p1 == Enum.FriendStatus.FriendRequestReceived then
		local s5 = "InGame.PlayerDropDown.Accept"
		local ok, result = pcall(function() -- line: 44
			-- upvalues: RobloxTranslator (copy), s5 (copy)
			return RobloxTranslator:FormatByKey(s5)
		end)

		return (not ok or (not result or result == "")) and "Accept request" or result, v17
	end

	local s6 = "InGame.PlayerDropDown.Action.ConnectionRequest"
	local ok, result = pcall(function() -- line: 44
		-- upvalues: RobloxTranslator (copy), s6 (copy)
		return RobloxTranslator:FormatByKey(s6)
	end)

	return (not ok or (not result or result == "")) and "Friend request" or result, v17
end
local function openReportDialog(p2) -- line: 64
	-- upvalues: RobloxGui (copy)
	if require(RobloxGui.Modules.isNewInGameMenuEnabled)() then
		require(RobloxGui.Modules.InGameMenuInit).openReportDialog(p2, "PlayerListReskin")

		return
	end

	require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuNewContainerPage):ReportPlayer(p2, "PlayerListReskin")
end
local function assembleMenuItems(t1: {[any]: any}) -- line: 83
	-- upvalues: getFriendLabelAndIcon (copy), RobloxTranslator (copy), v18 (copy), v21 (copy), v19 (copy), v20 (copy)
	local t2 = {}

	if not t1.isSelf and not t1.isBlocked then
		local v46, v47 = getFriendLabelAndIcon(t1.friendStatus)
		local v48 = t1.friendStatus == Enum.FriendStatus.Friend
		local t3 = {
			key = "friend",
			label = v46,
			icon = v47,
			onActivated = t1.actions.onFriend,
			requiresConfirm = not not v48 or nil
		}
		local v53

		if v48 then
			local s7 = "InGame.PlayerDropDown.ConfirmUnFriend"
			local ok, result = pcall(function() -- line: 44
				-- upvalues: RobloxTranslator (copy), s7 (copy)
				return RobloxTranslator:FormatByKey(s7)
			end)

			v53 = (not ok or (not result or result == "")) and "Tap to confirm unfriend" or result
		else
			v53 = nil
		end

		t3.confirmLabel = v53
		table.insert(t2, t3)

		if t1.friendStatus == Enum.FriendStatus.FriendRequestReceived then
			local t4 = {
				key = "decline"
			}
			local s8 = "InGame.PlayerDropDown.Decline"
			local ok, result = pcall(function() -- line: 44
				-- upvalues: RobloxTranslator (copy), s8 (copy)
				return RobloxTranslator:FormatByKey(s8)
			end)

			t4.label = (not ok or (not result or result == "")) and "Decline" or result
			t4.icon = v18
			t4.onActivated = t1.actions.onDecline
			table.insert(t2, t4)
		end
	end

	if t1.inspectMenuEnabled then
		local t5 = {
			key = "examine"
		}
		local s9 = "InGame.PlayerDropDown.Examine"
		local ok, result = pcall(function() -- line: 44
			-- upvalues: RobloxTranslator (copy), s9 (copy)
			return RobloxTranslator:FormatByKey(s9)
		end)

		t5.label = (not ok or (not result or result == "")) and "Examine avatar" or result
		t5.icon = v21
		t5.onActivated = t1.actions.onExamine
		table.insert(t2, t5)
	end

	if not t1.isSelf then
		local t6 = {
			key = "block"
		}
		local v66

		if t1.isBlocked then
			local s10 = "InGame.PlayerDropDown.UnBlock"
			local ok, result = pcall(function() -- line: 44
				-- upvalues: RobloxTranslator (copy), s10 (copy)
				return RobloxTranslator:FormatByKey(s10)
			end)

			v66 = (not ok or (not result or result == "")) and "Unblock" or result
		else
			local s11 = "InGame.PlayerDropDown.Block"
			local ok, result = pcall(function() -- line: 44
				-- upvalues: RobloxTranslator (copy), s11 (copy)
				return RobloxTranslator:FormatByKey(s11)
			end)

			v66 = (not ok or (not result or result == "")) and "Block" or result
		end

		t6.label = v66
		t6.icon = v19
		t6.onActivated = t1.actions.onBlock
		table.insert(t2, t6)

		local t7 = {
			key = "report"
		}
		local s12 = "InGame.PlayerDropDown.Report"
		local ok, result = pcall(function() -- line: 44
			-- upvalues: RobloxTranslator (copy), s12 (copy)
			return RobloxTranslator:FormatByKey(s12)
		end)

		t7.label = (not ok or (not result or result == "")) and "Report abuse" or result
		t7.icon = v20
		t7.onActivated = t1.actions.onReport
		table.insert(t2, t7)
	end

	return t2
end

return {
	buildMenuData = function(p3, p4: ((...any) -> ...any), b1: boolean?) -- line: 146
		-- upvalues: LocalPlayer (copy), BlockingUtility (copy), assembleMenuItems (copy), GuiService (copy), RbxAnalyticsService (copy), RequestFriendship (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), RobloxGui (copy), openReportDialog (copy), buildMenuHeader (copy)
		local UserId = p3.UserId
		local v78 = LocalPlayer ~= nil and p3 == LocalPlayer
		local u79 = false
		local Unknown = Enum.FriendStatus.Unknown

		if not v78 then
			pcall(function() -- line: 153
				-- upvalues: u79 (ref), BlockingUtility (copy), UserId (copy)
				u79 = BlockingUtility:IsPlayerBlockedByUserId(UserId)
			end)

			if not u79 then
				pcall(function() -- line: 157
					-- upvalues: Unknown (ref), LocalPlayer (copy), p3 (copy)
					Unknown = LocalPlayer:GetFriendStatus(p3)
				end)
			end
		end

		local v81 = assembleMenuItems({
			isSelf = v78,
			isBlocked = u79,
			friendStatus = Unknown,
			inspectMenuEnabled = GuiService:GetInspectMenuEnabled(),
			actions = {
				onFriend = function() -- line: 169
					-- upvalues: Unknown (ref), RbxAnalyticsService (copy), LocalPlayer (copy), p3 (copy), RequestFriendship (copy), p4 (copy)
					if Unknown == Enum.FriendStatus.Friend or Unknown == Enum.FriendStatus.FriendRequestSent then
						RbxAnalyticsService:TrackEvent("Game", "RevokeFriendship", "PlayerDropDown")
						LocalPlayer:RevokeFriendship(p3)
					elseif Unknown == Enum.FriendStatus.FriendRequestReceived then
						RequestFriendship(p3, true)()
					else
						RequestFriendship(p3)()
					end

					p4()
				end,
				onDecline = function() -- line: 180
					-- upvalues: RbxAnalyticsService (copy), LocalPlayer (copy), p3 (copy), p4 (copy)
					RbxAnalyticsService:TrackEvent("Game", "DeclineFriendship", "PlayerDropDown")
					LocalPlayer:RevokeFriendship(p3)
					p4()
				end,
				onExamine = function() -- line: 185
					-- upvalues: b1 (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), GuiService (copy), UserId (copy), p4 (copy)
					if b1 then
						PlayerContextualMenuStore.setSuppressNextDismissRestore(true)
						PlayerListVisibilityStore.setVisible(false)
					end

					GuiService:InspectPlayerFromUserIdWithCtx(UserId, "leaderBoard")
					p4()
				end,
				onBlock = function() -- line: 193
					-- upvalues: b1 (copy), u79 (ref), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), BlockingUtility (copy), p3 (copy), RobloxGui (copy), p4 (copy)
					if b1 and not u79 then
						PlayerContextualMenuStore.setSuppressNextDismissRestore(true)
						PlayerListVisibilityStore.setVisible(false)
					end

					if u79 then
						coroutine.wrap(function() -- line: 199
							-- upvalues: BlockingUtility (copy), p3 (copy)
							BlockingUtility:UnblockPlayerAsync(p3)
						end)()
					else
						require(RobloxGui.Modules.Settings.onBlockButtonActivated)(p3, nil, "PlayerListReskin", {})
					end

					p4()
				end,
				onReport = function() -- line: 208
					-- upvalues: b1 (copy), PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy), openReportDialog (copy), p3 (copy), p4 (copy)
					if b1 then
						PlayerContextualMenuStore.setSuppressNextDismissRestore(true)
						PlayerListVisibilityStore.setVisible(false)
					end

					openReportDialog(p3)
					p4()
				end
			}
		})

		return {
			player = p3,
			header = buildMenuHeader(p3),
			items = v81
		}
	end,
	assembleMenuItems = assembleMenuItems,
	getFriendLabelAndIcon = getFriendLabelAndIcon
}
