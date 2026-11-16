local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation").Hooks.useTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization").Hooks.useLocalization

local SduiTileFooter = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTileFooter")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiActionType = SduiCoreSystem.SduiActionType
local sduiParsers = SduiCoreSystem.SduiParsers
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UserProfiles")
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local SduiInGameFriendsData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/DataStore/SduiInGameFriendsData")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration/UserProfile")
local getAndFetchUserNamesByUserIds = DataHydration.UserProfile.getAndFetchUserNamesByUserIds

local fFlagHomeFriendNamesUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagHomeFriendNamesUseUserProfileHydration

local function getUserIdsForFacePile(list, p2)
	local userIds = {}

	for i = 1, p2 do
		userIds[i] = list[i].userId
	end

	return userIds
end

local function getDisplayText(list, separator, p2)
	local displayNames = {}

	for i = 1, p2 do
		displayNames[i] = list[i].displayName
	end

	return table.concat(displayNames, separator)
end

local function alphabeticalSort(p2, p3): boolean
	if not p2.displayName then
		return false
	end

	if p3.displayName then
		return p2.displayName:lower() < p3.displayName:lower()
	end

	return true
end

local function getSortedFriendNames(items, p2)
	local sortedFriendNames = {}

	if p2.status == DataHydration.DataStatus.NotReady then
		return sortedFriendNames
	end

	for k, item in items do
		local name = p2.namesByUserId[tostring(item)]

		if name then
			table.insert(sortedFriendNames, {
				userId = item,
				displayName = name.combinedName
			})
		end
	end

	table.sort(sortedFriendNames, alphabeticalSort)
	return sortedFriendNames
end

local function getSortedFriendDisplayNames(items, p2)
	if not (items and p2 and p2.data) then
		return {}
	end

	local result = {}

	for k, item in items do
		table.insert(result, {
			userId = item,
			displayName = UserProfiles.Selectors.getCombinedNameFromId(p2.data, item)
		})
	end

	table.sort(result, alphabeticalSort)
	return result
end

local function SduiGameTileActiveFriendsFooter(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local zIndex = props.zIndex
	local position = props.position

	local v5 = useTokens()

	local iconWidth = props.iconWidth or v5.Size.Size_500

	local v6 = React.useCallback(function(p2)
		if props.onActivated then
			props.onActivated(p2)
			return
		end

		local safeParseCallback = sduiParsers.safeParseCallback({
			actionType = sduiActionType.OpenJoinFriends,
			actionParams = { placeId = props.placeId, universeId = props.universeId }
		}, props.sduiContext, props.analyticsContext)

		if safeParseCallback then
			safeParseCallback(p2)
		end
	end, {
		props.placeId,
		props.universeId,
		props.analyticsContext,
		props.onActivated,
		props.sduiContext
	})

	local v7 = useLocalization({
		separator = "Feature.GameDetails.Label.FriendsSeparator"
	})

	local getInGameFriendsByGame = SduiInGameFriendsData.getInGameFriendsByGame

	local v8 = SignalsReact.useSignalState(getInGameFriendsByGame)
	local v9 = React.useMemo(function()
		local result = {}

		for k, v10 in v8[props.universeId] or {} do
			table.insert(result, k)
		end

		return result
	end, { v8, props.universeId })
	local v10

	if fFlagHomeFriendNamesUseUserProfileHydration then
		v10 = nil
	else
		v10 = useUserProfilesFetch({
			userIds = v9,
			query = UserProfiles.Queries.userProfilesCombinedNameByUserIds,
			skip = #v9 == 0
		})
	end

	local v11

	if fFlagHomeFriendNamesUseUserProfileHydration then
		local joined = table.concat(v9, ",")
		local v12 = React.useMemo(function()
			return getAndFetchUserNamesByUserIds(string.split(joined, ","))
		end, { joined })
		v11 = SignalsReact.useSignalState(v12)
	else
		v11 = nil
	end

	local v12 = React.useMemo(function()
		if v11 then
			return getSortedFriendNames(v9, v11)
		end

		return getSortedFriendDisplayNames(v9, v10)
	end, { v9, v10, v11 })

	local v13 = math.min(props.maxAvatars or 3, #v12)

	local displayText = getDisplayText(v12, v7.separator, v13)
	local userIds = {}

	for i = 1, v13 do
		userIds[i] = v12[i].userId
	end

	local children = {}

	for i = 1, v13 do
		local v14 = userIds[i]
		local formatted = `userId_{i}`
		local createElement = React.createElement
		local v16 = {
			LayoutOrder = i,
			BackgroundTransparency = 0,
			BackgroundColor3 = v5.Color.Content.Muted.Color3,
			Image = `rbxthumb://type=AvatarHeadShot&id={v14}&w=100&h=100`,
			Size = UDim2.fromOffset(iconWidth, iconWidth),
			Position = UDim2.fromOffset((i - 1) * iconWidth / 2, 0)
		}
		local v17 = {
			BorderRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			Border = 0
		}

		local v18 = if not props.hideBorder then React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v5.Color.System.Emphasis.Color3,
			Transparency = 0,
			Thickness = 1
		}) else nil
		v17.Border = v18
		children[formatted] = createElement("ImageLabel", v16, v17)
	end

	return React.createElement(SduiTileFooter, {
		position = position,
		anchorPoint = anchorPoint,
		automaticSize = automaticSize,
		size = size,
		layoutOrder = layoutOrder,
		zIndex = zIndex,
		sduiContext = props.sduiContext,
		textIconGap = v5.Gap.Small,
		leftText = displayText,
		leftTextFlexMode = Enum.UIFlexMode.Shrink,
		leftIconComponent = React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			children
		),
		onActivated = v6,
		testId = props.testId
	})
end

return React.memo(SduiGameTileActiveFriendsFooter)
