local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").useDesignTokens
local colors = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").Colors
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Localization").Hooks.useLocalization
local array = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/LuauPolyfill").Array
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local coPlayFooter = UIBlox.App.Tile.ExperienceTileMetadata.CoPlayFooter
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/UserProfiles")
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DataHydration")
local getAndFetchUserNamesByUserIds = DataHydration.UserProfile.getAndFetchUserNamesByUserIds
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SignalsReact").useSignalState
local sortFriendsByPresenceAndRecencyFactory = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/sortFriendsByPresenceAndRecencyFactory")

local fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix

local fFlagHomeFriendNamesUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagHomeFriendNamesUseUserProfileHydration

local function useFetchSortedDisplayNames(friendUserIds)
	local result = {}

	if fFlagHomeFriendNamesUseUserProfileHydration then
		local joined = table.concat(friendUserIds, ",")
		local v6 = useSignalState((React.useMemo(function()
			return getAndFetchUserNamesByUserIds(string.split(joined, ","))
		end, { joined })))

		if v6.status ~= DataHydration.DataStatus.NotReady then
			for k, item in friendUserIds do
				local name = v6.namesByUserId[item]

				if name then
					table.insert(result, {
						userId = item,
						displayName = name.combinedName
					})
				end
			end
		end

		table.sort(result, sortFriendsByPresenceAndRecencyFactory("displayName"))
		return result
	else
		local v5 = useUserProfilesFetch({
			userIds = friendUserIds,
			query = UserProfiles.Queries.userProfilesCombinedNameByUserIds,
			skip = not friendUserIds or #friendUserIds == 0
		})

		if v5 and v5.data and friendUserIds then
			for k, item in friendUserIds do
				table.insert(result, {
					userId = item,
					displayName = UserProfiles.Selectors.getCombinedNameFromId(v5.data, item)
				})
			end
		end

		table.sort(result, sortFriendsByPresenceAndRecencyFactory("displayName"))
		return result
	end
end

return {
	GridTileFriendFooter = function(props)
		local v5 = if props.useLargerFont then useStyle().Font.Body else useStyle().Font.CaptionHeader
		local size = useDesignTokens().Size
		local v6 = useTextSizeOffset()
		local v7 = useLocalization({
			friendsSeparator = "Feature.GameDetails.Label.FriendsSeparator"
		})

		local size_100 = size.Size_100

		if not props.showOnlineBorder then
			size_100 -= 3
		end

		local function fn(p2)
			return p2.displayName
		end

		if fFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			local v8 = useFetchSortedDisplayNames(props.friendUserIds or {})
			local createElement = React.createElement
			local onFriendFooterActivatedsByActivated = {
				Size = UDim2.new(1, 0, 0, size.Size_500 + v6),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				[React.Event.Activated] = props.onFriendFooterActivated,
				Selectable = false
			}

			local createElement2 = React.createElement
			local userIds = {}

			local v10 = {
				users = 0,
				labelText = 0,
				showEmphasisBorder = 0,
				faceGroupCount = 2,
				styleProps = 0
			}
			local v11 = { OnlineFriends = 0 }

			for i = 1, #v8 do
				userIds[i] = v8[i].userId
			end

			v10.users = userIds
			local friendsSeparator = v7.friendsSeparator
			v10.labelText = array.join(array.map(v8, fn), friendsSeparator)
			v10.showEmphasisBorder = props.showOnlineBorder

			v10.styleProps = {
				faceWidth = size.Size_500,
				faceHeight = size.Size_500,
				faceGroupGap = -size.Size_150,
				containerGap = size_100,
				badgeBorderWidth = 3,
				badgeHeight = size.Size_500,
				fontStyle = v5,
				badgeSpacingLeading = size.Size_100,
				badgeSpacingTrailing = size.Size_100,
				badgeBackgroundColor = { Color = colors.Smoke, Transparency = 0 },
				badgeContentColor = { Color = colors.White, Transparency = 0 }
			}
			v11.OnlineFriends = createElement2(coPlayFooter, v10)
			return createElement("TextButton", onFriendFooterActivatedsByActivated, v11)
		else
			local createElement = React.createElement
			local v8 = {
				Size = UDim2.new(1, 0, 0, size.Size_500 + v6),
				BackgroundTransparency = 1
			}

			local createElement2 = React.createElement
			local friends = props.friends or {}
			local userIds = {}

			local v10 = {
				users = 0,
				labelText = 0,
				showEmphasisBorder = 0,
				faceGroupCount = 2,
				styleProps = 0
			}
			local v11 = { OnlineFriends = 0 }

			for i = 1, #friends do
				userIds[i] = friends[i].userId
			end

			v10.users = userIds
			local friends2 = props.friends or {}
			local friendsSeparator = v7.friendsSeparator
			v10.labelText = array.join(array.map(friends2, fn), friendsSeparator)
			v10.showEmphasisBorder = props.showOnlineBorder

			v10.styleProps = {
				faceWidth = size.Size_500,
				faceHeight = size.Size_500,
				faceGroupGap = -size.Size_150,
				containerGap = size_100,
				badgeBorderWidth = 3,
				badgeHeight = size.Size_500,
				fontStyle = v5,
				badgeSpacingLeading = size.Size_100,
				badgeSpacingTrailing = size.Size_100,
				badgeBackgroundColor = { Color = colors.Smoke, Transparency = 0 },
				badgeContentColor = { Color = colors.White, Transparency = 0 }
			}
			v11.OnlineFriends = createElement2(coPlayFooter, v10)
			return createElement("Frame", v8, v11)
		end
	end,
	getUserIdsForFacePile = function(list)
		local userIds = {}

		for i = 1, #list do
			userIds[i] = list[i].userId
		end

		return userIds
	end,
	getDisplayName = function(p2, p3)
		return array.join(array.map(p2, function(p4)
			return p4.displayName
		end), p3)
	end
}
