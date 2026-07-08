local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local BlockingUtility = require(CorePackages.Workspace.Packages.BlockingUtility)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local scriptParent = script.Parent
local RequestFriendship = require(scriptParent.Thunks.RequestFriendship)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local PlayerListVisibilityStore = PlayerList.PlayerListVisibilityStore
local builderIcon = PlayerList.builderIcon
local buildMenuHeader = PlayerList.PlayerContextualMenuStore.buildMenuHeader
local LocalPlayer = Players.LocalPlayer
local v15 = builderIcon("person-plus")
local v16 = builderIcon("person-trash-can")
local v17 = builderIcon("circle-slash")
local v18 = builderIcon("speech-bubble-exclamation")
local v19 = builderIcon("magnifying-glass-plus")

local function translate(s1: string, s2: string) -- line: 41
	-- upvalues: RobloxTranslator (copy)
	local ok, result = pcall(function() -- line: 42
		-- upvalues: RobloxTranslator (copy), s1 (copy)
		return RobloxTranslator:FormatByKey(s1)
	end)

	if ok and (result and result ~= "") then
		return result
	end

	return s2
end
local function getFriendLabelAndIcon(p1) -- line: 52
	-- upvalues: RobloxTranslator (copy), v16 (copy), v15 (copy)
	if p1 == Enum.FriendStatus.Friend then
		local s3 = "InGame.PlayerDropDown.UnFriend"
		local ok, result = pcall(function() -- line: 42
			-- upvalues: RobloxTranslator (copy), s3 (copy)
			return RobloxTranslator:FormatByKey(s3)
		end)

		return (not ok or (not result or result == "")) and "Unfriend" or result, v16
	end

	if p1 == Enum.FriendStatus.FriendRequestSent then
		local s4 = "InGame.PlayerDropDown.CancelRequest"
		local ok, result = pcall(function() -- line: 42
			-- upvalues: RobloxTranslator (copy), s4 (copy)
			return RobloxTranslator:FormatByKey(s4)
		end)

		return (not ok or (not result or result == "")) and "Cancel request" or result, v15
	end

	if p1 == Enum.FriendStatus.FriendRequestReceived then
		local s5 = "InGame.PlayerDropDown.Accept"
		local ok, result = pcall(function() -- line: 42
			-- upvalues: RobloxTranslator (copy), s5 (copy)
			return RobloxTranslator:FormatByKey(s5)
		end)

		return (not ok or (not result or result == "")) and "Accept request" or result, v15
	end

	local s6 = "InGame.PlayerDropDown.Action.ConnectionRequest"
	local ok, result = pcall(function() -- line: 42
		-- upvalues: RobloxTranslator (copy), s6 (copy)
		return RobloxTranslator:FormatByKey(s6)
	end)

	return (not ok or (not result or result == "")) and "Friend request" or result, v15
end
local function openReportDialog(p2) -- line: 63
	-- upvalues: RobloxGui (copy)
	if require(RobloxGui.Modules.isNewInGameMenuEnabled)() then
		require(RobloxGui.Modules.InGameMenuInit).openReportDialog(p2, "PlayerListReskin")

		return
	end

	require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuNewContainerPage):ReportPlayer(p2, "PlayerListReskin")
end
local function assembleMenuItems(t1: {[any]: any}) -- line: 86
	-- upvalues: getFriendLabelAndIcon (copy), RobloxTranslator (copy), v19 (copy), v17 (copy), v18 (copy)
	local t2 = {}

	if not t1.isSelf and not t1.isBlocked then
		local v44, v45 = getFriendLabelAndIcon(t1.friendStatus)

		table.insert(t2, {
			key = "friend",
			label = v44,
			icon = v45,
			onActivated = t1.actions.onFriend
		})
	end

	if t1.inspectMenuEnabled then
		local t3 = {
			key = "examine"
		}
		local s7 = "InGame.PlayerDropDown.Examine"
		local ok, result = pcall(function() -- line: 42
			-- upvalues: RobloxTranslator (copy), s7 (copy)
			return RobloxTranslator:FormatByKey(s7)
		end)

		t3.label = (not ok or (not result or result == "")) and "Examine avatar" or result
		t3.icon = v19
		t3.onActivated = t1.actions.onExamine
		table.insert(t2, t3)
	end

	if not t1.isSelf then
		local t4 = {
			key = "block"
		}
		local v54

		if t1.isBlocked then
			local s8 = "InGame.PlayerDropDown.UnBlock"
			local ok, result = pcall(function() -- line: 42
				-- upvalues: RobloxTranslator (copy), s8 (copy)
				return RobloxTranslator:FormatByKey(s8)
			end)

			v54 = (not ok or (not result or result == "")) and "Unblock" or result
		else
			local s9 = "InGame.PlayerDropDown.Block"
			local ok, result = pcall(function() -- line: 42
				-- upvalues: RobloxTranslator (copy), s9 (copy)
				return RobloxTranslator:FormatByKey(s9)
			end)

			v54 = (not ok or (not result or result == "")) and "Block" or result
		end

		t4.label = v54
		t4.icon = v17
		t4.onActivated = t1.actions.onBlock
		table.insert(t2, t4)

		local t5 = {
			key = "report"
		}
		local s10 = "InGame.PlayerDropDown.Report"
		local ok, result = pcall(function() -- line: 42
			-- upvalues: RobloxTranslator (copy), s10 (copy)
			return RobloxTranslator:FormatByKey(s10)
		end)

		t5.label = (not ok or (not result or result == "")) and "Report abuse" or result
		t5.icon = v18
		t5.onActivated = t1.actions.onReport
		table.insert(t2, t5)
	end

	return t2
end

return {
	buildMenuData = function(p3, p4: ((...any) -> ...any), b1: boolean?) -- line: 138
		-- upvalues: LocalPlayer (copy), BlockingUtility (copy), assembleMenuItems (copy), GuiService (copy), RequestFriendship (copy), PlayerListVisibilityStore (copy), RobloxGui (copy), openReportDialog (copy), buildMenuHeader (copy)
		local UserId = p3.UserId
		local v66 = LocalPlayer ~= nil and p3 == LocalPlayer
		local u67 = false
		local Unknown = Enum.FriendStatus.Unknown

		if not v66 then
			pcall(function() -- line: 147
				-- upvalues: u67 (ref), BlockingUtility (copy), UserId (copy)
				u67 = BlockingUtility:IsPlayerBlockedByUserId(UserId)
			end)

			if not u67 then
				pcall(function() -- line: 151
					-- upvalues: Unknown (ref), LocalPlayer (copy), p3 (copy)
					Unknown = LocalPlayer:GetFriendStatus(p3)
				end)
			end
		end

		local v69 = assembleMenuItems({
			isSelf = v66,
			isBlocked = u67,
			friendStatus = Unknown,
			inspectMenuEnabled = GuiService:GetInspectMenuEnabled(),
			actions = {
				onFriend = function() -- line: 163
					-- upvalues: Unknown (ref), LocalPlayer (copy), p3 (copy), RequestFriendship (copy), p4 (copy)
					if Unknown == Enum.FriendStatus.Friend or Unknown == Enum.FriendStatus.FriendRequestSent then
						LocalPlayer:RevokeFriendship(p3)
					elseif Unknown == Enum.FriendStatus.FriendRequestReceived then
						RequestFriendship(p3, true)()
					else
						RequestFriendship(p3)()
					end

					p4()
				end,
				onExamine = function() -- line: 173
					-- upvalues: GuiService (copy), UserId (copy), p4 (copy), b1 (copy), PlayerListVisibilityStore (copy)
					GuiService:InspectPlayerFromUserIdWithCtx(UserId, "leaderBoard")
					p4()

					if b1 then
						PlayerListVisibilityStore.setVisible(false)
					end
				end,
				onBlock = function() -- line: 180
					-- upvalues: u67 (ref), BlockingUtility (copy), p3 (copy), RobloxGui (copy), p4 (copy)
					if u67 then
						coroutine.wrap(function() -- line: 182
							-- upvalues: BlockingUtility (copy), p3 (copy)
							BlockingUtility:UnblockPlayerAsync(p3)
						end)()
					else
						require(RobloxGui.Modules.Settings.onBlockButtonActivated)(p3, nil, "PlayerListReskin", {})
					end

					p4()
				end,
				onReport = function() -- line: 191
					-- upvalues: openReportDialog (copy), p3 (copy), p4 (copy)
					openReportDialog(p3)
					p4()
				end
			}
		})

		return {
			player = p3,
			header = buildMenuHeader(p3),
			items = v69
		}
	end,
	assembleMenuItems = assembleMenuItems,
	getFriendLabelAndIcon = getFriendLabelAndIcon
}
