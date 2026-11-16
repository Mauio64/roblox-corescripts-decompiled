local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetConversationListStore")
local fetchConversationListPageToSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/fetchConversationListPageToSignals")
local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")

local v5 = ShareSheetConstants.FIntShareSheetPeoplePickerLoadMoreThresholdWindowHundredthsPercent / 10000

local function isViewportNearEnd(p2, p3, p4): boolean
	if p3 <= 0 then
		return false
	end

	local v6 = p2 + p3
	return p4 - p3 * v5 <= v6
end

local function isViewportUnderfilled(p2, p3): boolean
	return p2 > 0 and p3 <= p2
end

local function usePeoplePickerPagination(data)
	local isPeoplePickerDisplayed = data.isPeoplePickerDisplayed
	local v6, v7, v8

	if fFlagShareSheetFriendsSort then
		local listResult = data.listResult
		v6 = listResult.isFetchingNextPage
		v7 = listResult.nextPageToken ~= nil
		v8 = listResult.nextPageToken
	else
		v6 = data.listStatus.isFetchingConversations == true
		v7 = data.listStatus.oldestConversationIsFetched ~= true
		v8 = data.listStatus.nextCursor
	end

	local isEligibilityLoading = data.isEligibilityLoading or v6

	local v9 = not isEligibilityLoading
		and v7
		and data.conversationCount < ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
		and v8
		or ""

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v10 = React.useCallback(function()
		if v9 == "" or ref.current == v9 then
			return
		end

		ref.current = v9

		if fFlagShareSheetFriendsSort then
			data.loadMore(v9)
		else
			fetchConversationListPageToSignals({ cursor = v9 })
		end
	end, { v9, data.loadMore })

	local ref3 = React.useRef({
		contentLength = nil,
		scrollOffset = 0,
		viewportLength = nil
	})

	local state, setState = React.useState(nil)
	local v11 = React.useCallback(function(): boolean
		local current = ref2.current

		if current then
			local y = current.CanvasPosition.Y
			local y2 = current.AbsoluteWindowSize.Y
			local y3 = current.AbsoluteCanvasSize.Y

			if y2 <= 0 then
				return false
			end

			local v12 = y + y2
			return y3 - y2 * v5 <= v12
		else
			local current2 = ref3.current

			if current2.viewportLength == nil or current2.contentLength == nil then
				return false
			end

			local scrollOffset = current2.scrollOffset
			local viewportLength = current2.viewportLength
			local contentLength = current2.contentLength

			if viewportLength <= 0 then
				return false
			end

			local v12 = scrollOffset + viewportLength
			return contentLength - viewportLength * v5 <= v12
		end
	end, {})
	local v12 = React.useCallback(function()
		local current = ref3.current

		if isPeoplePickerDisplayed and current.viewportLength ~= nil and current.contentLength ~= nil then
			local viewportLength = current.viewportLength
			local contentLength = current.contentLength
			local v13 = viewportLength > 0 and contentLength <= viewportLength

			if v13 then
				v10()
			end
		end
	end, { isPeoplePickerDisplayed, v10 })
	local v13 = React.useCallback(function(contentLength)
		ref3.current.contentLength = contentLength
		v12()
	end, { v12 })
	local v14 = React.useCallback(function(scrollOffset)
		ref3.current.scrollOffset = scrollOffset

		if not isPeoplePickerDisplayed then
			return
		end

		if not v11() then
			ref.current = nil
		end
	end, { isPeoplePickerDisplayed, v11 })
	local v15 = React.useCallback(function(p2)
		ref3.current.viewportLength = p2.Y
		setState(p2.Y * v5)
		v12()
	end, { v12 })
	local v16 = React.useCallback(function(current)
		ref2.current = current
	end, {})

	React.useEffect(function()
		if not isPeoplePickerDisplayed then
			ref.current = nil
			return
		end

		local v17 = false
		task.defer(function()
			if not v17 then
				v12()
			end
		end)
		return function()
			v17 = true
		end
	end, { isPeoplePickerDisplayed, v12 })
	local v19 = if isPeoplePickerDisplayed and v9 ~= "" then v10 else nil
	return {
		isLoading = isEligibilityLoading,
		paginationProps = {
			endReachedThreshold = state,
			scrollingFrameRef = v16,
			onContentLengthChanged = v13,
			onEndReached = v19,
			onScrollOffsetChanged = v14,
			onViewportChanged = v15
		}
	}
end

return usePeoplePickerPagination
