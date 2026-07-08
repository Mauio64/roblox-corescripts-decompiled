local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local Colors = require(GameTileParent.Style).Colors
local useLocalization = require(GameTileParent.Localization).Hooks.useLocalization
local Array = require(GameTileParent.LuauPolyfill).Array
local UIBlox = require(GameTileParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local CoPlayFooter = UIBlox.App.Tile.ExperienceTileMetadata.CoPlayFooter
local UserProfiles = require(GameTileParent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local sortFriendsByPresenceAndRecencyFactory = require(GameTile.sortFriendsByPresenceAndRecencyFactory)
local FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix = require(GameTileParent.SharedFlags).FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix

local function useFetchSortedDisplayNames(t1: {[any]: any}) -- line: 55
	-- upvalues: useUserProfilesFetch (copy), UserProfiles (copy), sortFriendsByPresenceAndRecencyFactory (copy)
	local t2 = {}
	local v24 = useUserProfilesFetch({
		userIds = t1,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds,
		skip = not t1 or #t1 == 0
	})

	if v24 and (v24.data and t1) then
		for _, v26 in t1 do
			table.insert(t2, {
				userId = v26,
				displayName = UserProfiles.Selectors.getCombinedNameFromId(v24.data, v26)
			})
		end
	end

	table.sort(t2, sortFriendsByPresenceAndRecencyFactory("displayName"))

	return t2
end

return {
	GridTileFriendFooter = function(t3: {[any]: any}) -- line: 77
		-- upvalues: useStyle (copy), useDesignTokens (copy), useTextSizeOffset (copy), useLocalization (copy), FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix (copy), useFetchSortedDisplayNames (copy), React (copy), CoPlayFooter (copy), Array (copy), Colors (copy)
		local v28 = if not t3.useLargerFont then useStyle().Font.CaptionHeader else useStyle().Font.Body
		local Global = useDesignTokens().Global
		local v30 = useTextSizeOffset()
		local v31 = useLocalization({
			friendsSeparator = "Feature.GameDetails.Label.FriendsSeparator"
		})
		local Space_50 = Global.Space_50

		if not t3.showOnlineBorder then
			Space_50 -= 3
		end

		if FFlagLuaAppMigrateGameTileActiveFriendsHydrationFix then
			local v33 = useFetchSortedDisplayNames(t3.friendUserIds or {})
			local createElement = React.createElement
			local t4 = {
				Size = UDim2.new(1, 0, 0, Global.Space_250 + v30),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				[React.Event.Activated] = t3.onFriendFooterActivated,
				Selectable = false
			}
			local t5 = {}
			local createElement2 = React.createElement
			local v38 = CoPlayFooter
			local t6 = {
				faceGroupCount = 2
			}
			local t7 = {}

			for i = 1, #v33 do
				t7[i] = v33[i].userId
			end

			t6.users = t7

			local friendsSeparator = v31.friendsSeparator

			t6.labelText = Array.join(Array.map(v33, function(p1) -- line: 48
				return p1.displayName
			end), friendsSeparator)
			t6.showEmphasisBorder = t3.showOnlineBorder
			t6.styleProps = {
				badgeBorderWidth = 3,
				faceWidth = Global.Size_250,
				faceHeight = Global.Size_250,
				faceGroupGap = -Global.Space_75,
				containerGap = Space_50,
				badgeHeight = Global.Size_250,
				fontStyle = v28,
				badgeSpacingLeading = Global.Space_50,
				badgeSpacingTrailing = Global.Space_50,
				badgeBackgroundColor = {
					Transparency = 0,
					Color = Colors.Smoke
				},
				badgeContentColor = {
					Transparency = 0,
					Color = Colors.White
				}
			}
			t5.OnlineFriends = createElement2(v38, t6)

			return (createElement("TextButton", t4, t5))
		end

		local createElement = React.createElement
		local t8 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, Global.Space_250 + v30)
		}
		local t9 = {}
		local createElement3 = React.createElement
		local v47 = CoPlayFooter
		local t10 = {
			faceGroupCount = 2
		}
		local v49 = t3.friends or {}
		local t11 = {}

		for i = 1, #v49 do
			t11[i] = v49[i].userId
		end

		t10.users = t11

		local v52 = t3.friends or {}
		local friendsSeparator = v31.friendsSeparator

		t10.labelText = Array.join(Array.map(v52, function(p2) -- line: 48
			return p2.displayName
		end), friendsSeparator)
		t10.showEmphasisBorder = t3.showOnlineBorder
		t10.styleProps = {
			badgeBorderWidth = 3,
			faceWidth = Global.Size_250,
			faceHeight = Global.Size_250,
			faceGroupGap = -Global.Space_75,
			containerGap = Space_50,
			badgeHeight = Global.Size_250,
			fontStyle = v28,
			badgeSpacingLeading = Global.Space_50,
			badgeSpacingTrailing = Global.Space_50,
			badgeBackgroundColor = {
				Transparency = 0,
				Color = Colors.Smoke
			},
			badgeContentColor = {
				Transparency = 0,
				Color = Colors.White
			}
		}
		t9.OnlineFriends = createElement3(v47, t10)

		return createElement("Frame", t8, t9)
	end,
	getUserIdsForFacePile = function(t12: {[any]: any}) -- line: 37
		local t13 = {}

		for i = 1, #t12 do
			t13[i] = t12[i].userId
		end

		return t13
	end,
	getDisplayName = function(t14: {[any]: any}, s1: string) -- line: 46
		-- upvalues: Array (copy)
		return Array.join(Array.map(t14, function(p3) -- line: 48
			return p3.displayName
		end), s1)
	end
}
