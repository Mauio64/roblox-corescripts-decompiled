local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local Style2 = require(parent.Style)
local Colors = Style2.Colors
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local CoPlayFooter = UIBlox.App.Tile.ExperienceTileMetadata.CoPlayFooter
local UserProfiles = require(parent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local DataHydration = require(parent.DataHydration)
local getAndFetchUserNamesByUserIds = DataHydration.UserProfile.getAndFetchUserNamesByUserIds
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local sortFriendsByPresenceAndRecencyFactory = require(GameTile.sortFriendsByPresenceAndRecencyFactory)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix = SharedFlags.FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix

local SharedFlags2 = require(parent.SharedFlags)
local FFlagHomeFriendNamesUseUserProfileHydration = SharedFlags2.FFlagHomeFriendNamesUseUserProfileHydration

local function useFetchSortedDisplayNames(friendUserIds)
	local result = {}

	if FFlagHomeFriendNamesUseUserProfileHydration then
		local joined = table.concat(friendUserIds, ",")
		local v = useSignalState((React.useMemo(function()
			return getAndFetchUserNamesByUserIds(string.split(joined, ","))
		end, { joined })))

		if v.status ~= DataHydration.DataStatus.NotReady then
			for _, item in friendUserIds do
				local name = v.namesByUserId[item]

				if name then
					table.insert(result, { userId = item, displayName = name.combinedName })
				end
			end
		end

		table.sort(result, sortFriendsByPresenceAndRecencyFactory("displayName"))
		return result
	else
		local v = useUserProfilesFetch({
			userIds = friendUserIds,
			query = UserProfiles.Queries.userProfilesCombinedNameByUserIds,
			skip = not friendUserIds or #friendUserIds == 0
		})

		if v and v.data and friendUserIds then
			for _, item in friendUserIds do
				table.insert(result, {
					userId = item,
					displayName = UserProfiles.Selectors.getCombinedNameFromId(v.data, item)
				})
			end
		end

		table.sort(result, sortFriendsByPresenceAndRecencyFactory("displayName"))
		return result
	end
end

local GridTileFriendFooter = {}

function GridTileFriendFooter.GridTileFriendFooter(props)
	local fontStyle

	if props.useLargerFont then
		fontStyle = useStyle().Font.Body
	else
		fontStyle = useStyle().Font.CaptionHeader
	end

	local size = useDesignTokens().Size
	local v = useTextSizeOffset()
	local v2 = useLocalization({ friendsSeparator = "Feature.GameDetails.Label.FriendsSeparator" })

	local size_100 = size.Size_100

	if not props.showOnlineBorder then
		size_100 -= 3
	end

	local function fn(p)
		return p.displayName
	end

	if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
		local v3 = useFetchSortedDisplayNames(props.friendUserIds or {})
		local createElement = React.createElement
		local onFriendFooterActivatedsByActivated = {
			Size = UDim2.new(1, 0, 0, size.Size_500 + v),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			[React.Event.Activated] = props.onFriendFooterActivated,
			Selectable = false
		}

		local createElement2 = React.createElement
		local userIds = {}

		local v4 = {
			users = 0,
			labelText = 0,
			showEmphasisBorder = 0,
			faceGroupCount = 2,
			styleProps = 0
		}
		local v5 = { OnlineFriends = 0 }

		for i = 1, #v3 do
			userIds[i] = v3[i].userId
		end

		v4.users = userIds
		local friendsSeparator = v2.friendsSeparator
		v4.labelText = Array.join(Array.map(v3, fn), friendsSeparator)
		v4.showEmphasisBorder = props.showOnlineBorder

		v4.styleProps = {
			faceWidth = size.Size_500,
			faceHeight = size.Size_500,
			faceGroupGap = -size.Size_150,
			containerGap = size_100,
			badgeBorderWidth = 3,
			badgeHeight = size.Size_500,
			fontStyle = fontStyle,
			badgeSpacingLeading = size.Size_100,
			badgeSpacingTrailing = size.Size_100,
			badgeBackgroundColor = { Color = Colors.Smoke, Transparency = 0 },
			badgeContentColor = { Color = Colors.White, Transparency = 0 }
		}
		v5.OnlineFriends = createElement2(CoPlayFooter, v4)
		return (createElement("TextButton", onFriendFooterActivatedsByActivated, v5))
	else
		local createElement = React.createElement
		local v3 = {
			Size = UDim2.new(1, 0, 0, size.Size_500 + v),
			BackgroundTransparency = 1
		}

		local createElement2 = React.createElement
		local friends = props.friends or {}
		local userIds = {}

		local v4 = {
			users = 0,
			labelText = 0,
			showEmphasisBorder = 0,
			faceGroupCount = 2,
			styleProps = 0
		}
		local v5 = { OnlineFriends = 0 }

		for i = 1, #friends do
			userIds[i] = friends[i].userId
		end

		v4.users = userIds
		local friends2 = props.friends or {}
		local friendsSeparator = v2.friendsSeparator
		v4.labelText = Array.join(Array.map(friends2, fn), friendsSeparator)
		v4.showEmphasisBorder = props.showOnlineBorder

		v4.styleProps = {
			faceWidth = size.Size_500,
			faceHeight = size.Size_500,
			faceGroupGap = -size.Size_150,
			containerGap = size_100,
			badgeBorderWidth = 3,
			badgeHeight = size.Size_500,
			fontStyle = fontStyle,
			badgeSpacingLeading = size.Size_100,
			badgeSpacingTrailing = size.Size_100,
			badgeBackgroundColor = { Color = Colors.Smoke, Transparency = 0 },
			badgeContentColor = { Color = Colors.White, Transparency = 0 }
		}
		v5.OnlineFriends = createElement2(CoPlayFooter, v4)
		return createElement("Frame", v3, v5)
	end
end

function GridTileFriendFooter.getUserIdsForFacePile(list)
	local userIds = {}

	for i = 1, #list do
		userIds[i] = list[i].userId
	end

	return userIds
end

function GridTileFriendFooter.getDisplayName(p, p2: string)
	return Array.join(Array.map(p, function(p3)
		return p3.displayName
	end), p2)
end

return GridTileFriendFooter
