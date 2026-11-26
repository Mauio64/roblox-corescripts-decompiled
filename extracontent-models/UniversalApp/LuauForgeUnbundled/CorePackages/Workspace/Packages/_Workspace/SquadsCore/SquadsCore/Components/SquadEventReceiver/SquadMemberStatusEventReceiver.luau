local GuiService = game:GetService("GuiService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local RoduxSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxSquads")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Localization").Hooks.useLocalization
local userProfileStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UserProfiles").Stores.UserProfileStore
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector

local useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector

return function(): nil
	local v5 = useCurrentSquadSelector()
	local v6 = useLocalUserId()
	local ref = React.useRef(nil)

	local v7 = useLocalization({
		friendJoinedYourPartyText = "Feature.Squads.Label.FriendJoinedYourParty",
		multiplePeopleJoinedYourPartyText = "Feature.Squads.Label.MultiplePeopleJoinedYourParty",
		twoFriendsJoinedYourPartyText = "Feature.Squads.Label.TwoFriendsJoinedYourParty"
	})

	local v9 = useSelector((React.useCallback(function(p2)
		return p2.Squad.UserBlocking.isBlockedByMe
	end, {})))

	React.useEffect(function()
		local members = if v5 then v5.members else nil

		if ref.current and members then
			local set = Cryo.List.toSet(Cryo.List.map(ref.current, function(p2)
				return (tostring(p2.userId))
			end))

			local userIds = {}

			for k, member in members do
				local userId = tostring(member.userId)

				if set[userId] or userId == v6 or v9[userId] then
					continue
				end

				table.insert(userIds, userId)
			end

			local count = #userIds

			if count > 0 then
				if count > 2 then
					GuiService:SendNotification({
						Title = v7.multiplePeopleJoinedYourPartyText,
						Icon = getStandardSizeAvatarHeadShotRbxthumb(userIds[1])
					})
				else
					userProfileStore.get().fetchNamesByUserIds(userIds, function(p2)
						if #p2.data > 0 and p2.status == "success" then
							local v10

							if count == 1 then
								v10 = v7.friendJoinedYourPartyText:gsub("{(.-)}", {
									combinedName = p2.data[1].names.getCombinedName(false)
								})
							else
								v10 = v7.twoFriendsJoinedYourPartyText:gsub("{(.-)}", {
									combinedName1 = p2.data[1].names.getCombinedName(false),
									combinedName2 = p2.data[2].names.getCombinedName(false)
								})
							end

							if count == 1 then
							end

							GuiService:SendNotification({
								Title = v10,
								Icon = getStandardSizeAvatarHeadShotRbxthumb(userIds[1])
							})
						end
					end)
				end
			end
		end

		ref.current = members
	end, { v5 and v5.members })

	return nil
end
