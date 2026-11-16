local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildOverflowMenuStore/createBuildOverflowMenuStore")
local FFlagBuildExperienceMyCreationsLongPressMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMyCreationsLongPressMenu")
local descriptionWithGroupIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/descriptionWithGroupIcon")
local ExperienceResultsLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/ExperienceResultsLoadingSkeleton")
local ExperienceRowActionsMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/ExperienceRowActionsMenu")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsTab/useMyCreationsResults")

local badge = Foundation.Badge
local list = Foundation.List
local view = Foundation.View
local useMeasurableRef = Foundation.Hooks.useMeasurableRef

local badgeShape = Foundation.Enums.BadgeShape
local badgeSize = Foundation.Enums.BadgeSize
local badgeVariant = Foundation.Enums.BadgeVariant
local inputSize = Foundation.Enums.InputSize
local listItemInputType = Foundation.Enums.ListItemInputType

local function useRowActionsMenu()
	local v5 = useMeasurableRef(Vector2.zero, Vector2.zero)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local v6 = React.useCallback(function(p2, p3, p4)
		v5.current:SetPosition(p3)
		setState({ target = p2, isAtPointer = p4 })

		setState2(true)
	end, { v5 })
	local v7 = React.useCallback(function()
		setState2(false)
	end, {})
	return {
		rowActions = state,
		anchor = v5.current,
		isOpen = state2,
		open = v6,
		close = v7
	}
end

local function ExperienceListItem(props)
	local v5 = React.useMemo(function()
		return { type = nil, iconName = props.gameIcon, iconVariant = nil }
	end, { props.gameIcon })
	local v6 = React.useCallback(function()
		props.onOpenChat({
			universeId = props.universeId,
			placeId = props.placeId,
			sessionId = props.sessionId,
			experienceName = props.experienceName,
			creatorName = props.creatorName,
			gameIcon = props.gameIcon
		})
	end, {
		props.creatorName,
		props.experienceName,
		props.gameIcon,
		props.onOpenChat,
		props.placeId,
		props.sessionId,
		props.universeId
	})

	local onLongPress = props.onLongPress
	local v7

	if FFlagBuildExperienceMyCreationsLongPressMenu then
		v7 = React.useCallback(function(p2, p3)
			if onLongPress == nil then
				return
			end

			local v8 = {
				universeId = props.universeId,
				placeId = props.placeId,
				sessionId = props.sessionId,
				experienceName = props.experienceName,
				creatorName = props.creatorName,
				gameIcon = props.gameIcon
			}

			if p3.UserInputType == Enum.UserInputType.MouseButton2 then
				onLongPress(v8, Vector2.new(p3.Position.X, p3.Position.Y), true)
			else
				onLongPress(v8, p2.AbsolutePosition + Vector2.new(p2.AbsoluteSize.X, 0), false)
			end
		end, {
			onLongPress,
			props.creatorName,
			props.experienceName,
			props.gameIcon,
			props.placeId,
			props.sessionId,
			props.universeId
		})
	end

	local v8 = React.useMemo(function()
		if props.visibilityLabel == nil then
			return nil
		end

		return React.createElement(view, { tag = "row align-y-center auto-xy" }, {
			VisibilityBadge = React.createElement(badge, {
				text = props.visibilityLabel,
				shape = badgeShape.Box,
				size = badgeSize.Small,
				variant = badgeVariant.Neutral,
				testId = `{props.testIdPrefix}.VisibilityBadge.{props.universeId}`
			})
		})
	end, { props.testIdPrefix, props.universeId, props.visibilityLabel })

	local v9 = not (v7 == nil) and onLongPress ~= nil

	local createElement = React.createElement
	local item = list.Item
	local v10 = {
		LayoutOrder = props.LayoutOrder,
		leading = v5,
		title = props.experienceName,
		description = descriptionWithGroupIcon(props.description, props.isGroupGame, props.creatorName),
		testId = `{props.testIdPrefix}.ExperienceRow.{props.universeId}`,
		onActivated = v6,
		onSecondaryActivated = 0,
		input = 0,
		trailing = 0
	}

	if not v9 then
		v7 = nil
	end

	v10.onSecondaryActivated = v7
	local v11 = if v9 then listItemInputType.None else nil
	v10.input = v11
	v10.trailing = v8
	return createElement(item, v10)
end

local memo = React.memo(ExperienceListItem)

local function ExperienceResultsList(props)
	local testIdPrefix = props.testIdPrefix or "MyCreationsTab"
	local firstResultLayoutOrder = props.firstResultLayoutOrder or 1
	local clone = table.clone(props.leadingItems or {})
	local onOpenConfigurationPage = props.onOpenConfigurationPage
	local v5 = nil

	if FFlagBuildExperienceMyCreationsLongPressMenu then
		local v6 = useRowActionsMenu()

		if onOpenConfigurationPage ~= nil then
			v5 = v6
		end
	end

	local rowActions = if v5 ~= nil then v5.rowActions else nil

	if props.hasDisplayedResult and props.hasDisplayedItems then
		for k, item in props.items do
			local v6 = "U" .. item.universeId
			local v7 = k + firstResultLayoutOrder - 1
			local createElement = React.createElement
			local v9 = {
				LayoutOrder = v7,
				sessionId = item.sessionId,
				universeId = item.universeId,
				placeId = item.placeId,
				experienceName = item.experienceName,
				creatorName = item.creatorName,
				description = item.description,
				visibilityLabel = item.visibilityLabel,
				gameIcon = item.gameIcon,
				isGroupGame = item.isGroupGame,
				onOpenChat = props.onOpenChat,
				onLongPress = 0,
				testIdPrefix = 0
			}
			local v10 = if v5 ~= nil then v5.open else nil
			v9.onLongPress = v10
			v9.testIdPrefix = testIdPrefix
			clone[v6] = createElement(memo, v9)
		end
	elseif props.listStatus == "NotReady" or props.hasPendingSummary then
		for i = 1, 2 do
			clone[`Loading{i}`] = React.createElement(ExperienceResultsLoadingSkeleton, {
				LayoutOrder = i + firstResultLayoutOrder - 1,
				index = i,
				testIdPrefix = testIdPrefix
			})
		end
	elseif props.listStatus == "Failed" then
		clone.Error = React.createElement(list.Item, {
			LayoutOrder = firstResultLayoutOrder,
			title = props.loadError
		})
	end

	if props.failedLoadMore then
		clone.LoadMoreError = React.createElement(list.Item, {
			LayoutOrder = #props.items + firstResultLayoutOrder,
			title = props.loadError,
			testId = `{testIdPrefix}.LoadMoreError`,
			onActivated = props.retryLoadMore
		})
	end

	if v5 ~= nil then
		local createElement = React.createElement
		local v8 = if rowActions ~= nil then rowActions.target else nil
		local v9 = if rowActions ~= nil then v5.anchor else nil
		local v10 = if rowActions ~= nil then rowActions.isAtPointer else nil
		clone.RowActionsMenu = createElement(ExperienceRowActionsMenu, {
			target = v8,
			anchor = v9,
			isAtPointer = v10,
			isOpen = v5.isOpen,
			onClose = v5.close,
			onOpenConfigurationPage = onOpenConfigurationPage
		})
	end

	return React.createElement(list.Root, {
		hasDivider = false,
		isContained = { isContained = false, hasMargin = false },
		size = inputSize.Large
	}, clone)
end

return React.memo(ExperienceResultsList)
