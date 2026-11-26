local buttonTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/UserList").Enums.ButtonTypes

require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Common/Types")

local fFlagUserListActionsV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/SharedFlags").FFlagUserListActionsV2

local function fn() end

local v5 = {
	JoinExperience = buttonTypes.Join,
	Chat = buttonTypes.Chat,
	AddFriend = buttonTypes.Add,
	AcceptFriendRequest = buttonTypes.Accept,
	PendingFriendRequest = buttonTypes.Pending
}

local function mapProfileCTAToRowCTA(p2, p3, p4)
	if not (p2 and p2.buttons) then
		return nil
	end

	for k, button in p2.buttons do
		local v6 = v5[button.type]

		if v6 then
			local v7 = p3[v6]
			local v8 = v6 == buttonTypes.Pending or nil
			return {
				type = v6,
				onActivated = v7 and function()
					v7(p4)
				end or fn,
				isDisabled = fFlagUserListActionsV2 and button.disabledReason ~= nil and true or v8,
				disabledReason = button.disabledReason
			}
		end
	end

	return nil
end

return mapProfileCTAToRowCTA
