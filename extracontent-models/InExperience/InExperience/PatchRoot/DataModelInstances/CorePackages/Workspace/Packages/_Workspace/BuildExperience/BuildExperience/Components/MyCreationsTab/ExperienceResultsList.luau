local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(BuildExperience.Chat.chatTypes)
require(BuildExperience.Stores.GetBuildOverflowMenuStore.createBuildOverflowMenuStore)
local FFlagBuildExperienceMyCreationsLongPressMenu = require(BuildExperience.Flags.FFlagBuildExperienceMyCreationsLongPressMenu)
local descriptionWithGroupIcon = require(BuildExperience.utils.descriptionWithGroupIcon)
local ExperienceResultsLoadingSkeleton = require(script.Parent.ExperienceResultsLoadingSkeleton)
local ExperienceRowActionsMenu = require(script.Parent.ExperienceRowActionsMenu)
require(script.Parent.useMyCreationsResults)

local Badge = Foundation.Badge
local List = Foundation.List
local View = Foundation.View
local useMeasurableRef = Foundation.Hooks.useMeasurableRef

local BadgeShape = Foundation.Enums.BadgeShape
local BadgeSize = Foundation.Enums.BadgeSize
local BadgeVariant = Foundation.Enums.BadgeVariant
local InputSize = Foundation.Enums.InputSize
local ListItemInputType = Foundation.Enums.ListItemInputType

local function useRowActionsMenu()
	local v = useMeasurableRef(Vector2.zero, Vector2.zero)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local open = React.useCallback(function(target, vector2: Vector2, isAtPointer: boolean)
		v.current:SetPosition(vector2)
		setState({ target = target, isAtPointer = isAtPointer })

		setState2(true)
	end, { v })
	local close = React.useCallback(function()
		setState2(false)
	end, {})
	return {
		rowActions = state,
		anchor = v.current,
		isOpen = state2,
		open = open,
		close = close
	}
end

local function ExperienceListItem(props)
	local leading = React.useMemo(function()
		return { type = nil, iconName = props.gameIcon, iconVariant = nil }
	end, { props.gameIcon })
	local onActivated = React.useCallback(function()
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
	local onSecondaryActivated

	if FFlagBuildExperienceMyCreationsLongPressMenu then
		onSecondaryActivated = React.useCallback(function(p, p2)
			if onLongPress == nil then
				return
			end

			local v = {
				universeId = props.universeId,
				placeId = props.placeId,
				sessionId = props.sessionId,
				experienceName = props.experienceName,
				creatorName = props.creatorName,
				gameIcon = props.gameIcon
			}

			if p2.UserInputType == Enum.UserInputType.MouseButton2 then
				onLongPress(v, Vector2.new(p2.Position.X, p2.Position.Y), true)
			else
				onLongPress(v, p.AbsolutePosition + Vector2.new(p.AbsoluteSize.X, 0), false)
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

	local trailing = React.useMemo(function()
		if props.visibilityLabel == nil then
			return nil
		end

		return React.createElement(View, { tag = "row align-y-center auto-xy" }, {
			VisibilityBadge = React.createElement(Badge, {
				text = props.visibilityLabel,
				shape = BadgeShape.Box,
				size = BadgeSize.Small,
				variant = BadgeVariant.Neutral,
				testId = `{props.testIdPrefix}.VisibilityBadge.{props.universeId}`
			})
		})
	end, { props.testIdPrefix, props.universeId, props.visibilityLabel })
	local v

	if onSecondaryActivated == nil then
		v = false
	else
		v = onLongPress ~= nil
	end

	local createElement = React.createElement
	local item = List.Item
	local v2 = {
		LayoutOrder = props.LayoutOrder,
		leading = leading,
		title = props.experienceName,
		description = descriptionWithGroupIcon(props.description, props.isGroupGame, props.creatorName),
		testId = `{props.testIdPrefix}.ExperienceRow.{props.universeId}`,
		onActivated = onActivated,
		onSecondaryActivated = 0,
		input = 0,
		trailing = 0
	}

	if not v then
		onSecondaryActivated = nil
	end

	v2.onSecondaryActivated = onSecondaryActivated
	local input

	if v then
		input = ListItemInputType.None
	end

	v2.input = input
	v2.trailing = trailing
	return createElement(item, v2)
end

local memo = React.memo(ExperienceListItem)

local function ExperienceResultsList(props)
	local testIdPrefix = props.testIdPrefix or "MyCreationsTab"
	local firstResultLayoutOrder = props.firstResultLayoutOrder or 1
	local clone = table.clone(props.leadingItems or {})
	local onOpenConfigurationPage = props.onOpenConfigurationPage
	local v = nil

	if FFlagBuildExperienceMyCreationsLongPressMenu then
		local v2 = useRowActionsMenu()

		if onOpenConfigurationPage ~= nil then
			v = v2
		end
	end

	local rowActions

	if v ~= nil then
		rowActions = v.rowActions
	end

	if props.hasDisplayedResult and props.hasDisplayedItems then
		for k, item in props.items do
			local v2 = "U" .. item.universeId
			local layoutOrder = k + firstResultLayoutOrder - 1
			local createElement = React.createElement
			local v3 = {
				LayoutOrder = layoutOrder,
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
			local onLongPress

			if v ~= nil then
				onLongPress = v.open
			end

			v3.onLongPress = onLongPress
			v3.testIdPrefix = testIdPrefix
			clone[v2] = createElement(memo, v3)
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
		clone.Error = React.createElement(List.Item, {
			LayoutOrder = firstResultLayoutOrder,
			title = props.loadError
		})
	end

	if props.failedLoadMore then
		clone.LoadMoreError = React.createElement(List.Item, {
			LayoutOrder = #props.items + firstResultLayoutOrder,
			title = props.loadError,
			testId = `{testIdPrefix}.LoadMoreError`,
			onActivated = props.retryLoadMore
		})
	end

	if v ~= nil then
		local createElement = React.createElement
		local target

		if rowActions ~= nil then
			target = rowActions.target
		end

		local anchor

		if rowActions ~= nil then
			anchor = v.anchor
		end

		local isAtPointer

		if rowActions ~= nil then
			isAtPointer = rowActions.isAtPointer
		end

		clone.RowActionsMenu = createElement(ExperienceRowActionsMenu, {
			target = target,
			anchor = anchor,
			isAtPointer = isAtPointer,
			isOpen = v.isOpen,
			onClose = v.close,
			onOpenConfigurationPage = onOpenConfigurationPage
		})
	end

	return React.createElement(List.Root, {
		hasDivider = false,
		isContained = { isContained = false, hasMargin = false },
		size = InputSize.Large
	}, clone)
end

return React.memo(ExperienceResultsList)
