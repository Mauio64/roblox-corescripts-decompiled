local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useTokens = Foundation.Hooks.useTokens
local statusIndicator = Foundation.StatusIndicator
local statusIndicatorShape = Foundation.Enums.StatusIndicatorShape
local statusIndicatorSize = Foundation.Enums.StatusIndicatorSize
local statusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
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
local fFlagSduiActiveFriendsFooterTreatment = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiActiveFriendsFooterTreatment
local fFlagSduiGameTileFixFacePileZIndex = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileFixFacePileZIndex

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

local function getFormattedText(list, p2, props)
	if p2 == 0 then
		return nil
	end

	local v5

	if p2 == 1 then
		v5 = props.textFormatOne
	else
		v5 = if p2 == 2 then props.textFormatTwo else props.textFormatMany
	end

	if not v5 or v5 == "" then
		return nil
	end

	local displayName = if list[1] then list[1].displayName else nil

	if displayName or not v5:find("{name}", 1, true) then
		return (v5:gsub("{(%w+)}", {
			name = displayName or "",
			count = tostring(p2 - 1)
		}))
	end

	return nil
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
	local v14

	if fFlagSduiActiveFriendsFooterTreatment then
		v14 = getFormattedText(v12, #v9, props) or getDisplayText(v12, v7.separator, v13)
	else
		v14 = getDisplayText(v12, v7.separator, v13)
	end

	local userIds = {}

	for i = 1, v13 do
		userIds[i] = v12[i].userId
	end

	local children = {}

	for i = 1, v13 do
		local v15 = userIds[i]
		local formatted = `userId_{i}`
		local createElement = React.createElement
		local v17 = {
			LayoutOrder = i,
			BackgroundTransparency = 0,
			BackgroundColor3 = v5.Color.Content.Muted.Color3,
			Image = `rbxthumb://type=AvatarHeadShot&id={v15}&w=100&h=100`,
			Size = UDim2.fromOffset(iconWidth, iconWidth),
			Position = UDim2.fromOffset((i - 1) * iconWidth / 2, 0),
			ZIndex = 0
		}
		local v18 = if fFlagSduiGameTileFixFacePileZIndex then v13 - i + 1 else nil
		v17.ZIndex = v18
		local v19 = {
			BorderRadius = React.createElement("UICorner", {
				CornerRadius = UDim.new(0.5, 0)
			}),
			Border = 0,
			PresenceDot = 0
		}

		local v20 = if not props.hideBorder then React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v5.Color.System.Emphasis.Color3,
			Transparency = 0,
			Thickness = 1
		}) else nil
		v19.Border = v20

		local v21 = if fFlagSduiActiveFriendsFooterTreatment and props.showPresenceDot then React.createElement(statusIndicator, {
			variant = statusIndicatorVariant.Success,
			shape = statusIndicatorShape.Circle,
			size = statusIndicatorSize.XSmall,
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.fromScale(1, 1)
		}) else nil
		v19.PresenceDot = v21
		children[formatted] = createElement("ImageLabel", v17, v19)
	end

	local createElement = React.createElement
	local v16 = {
		position = position,
		anchorPoint = anchorPoint,
		automaticSize = automaticSize,
		size = size,
		layoutOrder = layoutOrder,
		zIndex = zIndex,
		sduiContext = props.sduiContext,
		textIconGap = 0,
		leftText = 0,
		leftTextFlexMode = 0,
		leftIconComponent = 0,
		onActivated = 0,
		testId = 0
	}

	local v17 = if fFlagSduiActiveFriendsFooterTreatment then props.textIconGap or v5.Gap.Small else v5.Gap.Small
	v16.textIconGap = v17

	v16.leftText = v14
	v16.leftTextFlexMode = Enum.UIFlexMode.Shrink
	v16.leftIconComponent = React.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		children
	)

	v16.onActivated = v6
	v16.testId = props.testId
	return createElement(SduiTileFooter, v16)
end

return React.memo(SduiGameTileActiveFriendsFooter)
