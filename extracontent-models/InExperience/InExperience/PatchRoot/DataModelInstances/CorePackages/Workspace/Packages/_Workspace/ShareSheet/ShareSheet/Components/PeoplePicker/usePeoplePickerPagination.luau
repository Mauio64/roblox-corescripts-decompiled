local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

require(parent.AppChat.GetConversationListStore)
local fetchConversationListPageToSignals = require(parent.AppChat.fetchConversationListPageToSignals)
local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
require(ShareSheet.Types)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)

local v = ShareSheetConstants.FIntShareSheetPeoplePickerLoadMoreThresholdWindowHundredthsPercent / 10000

local function isViewportNearEnd(p: number, p2: number, p3: number): boolean -- 2 equivalent calls inferred from this helper
	if p2 <= 0 then
		return false
	end

	local v2 = p + p2
	return p3 - p2 * v <= v2
end

local function isViewportUnderfilled(viewportLength: number, contentLength: number): boolean -- 1 equivalent call inferred from this helper
	return viewportLength > 0 and contentLength <= viewportLength
end

local function usePeoplePickerPagination(data)
	local isPeoplePickerDisplayed = data.isPeoplePickerDisplayed
	local v2, v3, v4

	if FFlagShareSheetFriendsSort then
		local listResult = data.listResult
		v2 = listResult.isFetchingNextPage
		v3 = listResult.nextPageToken ~= nil
		v4 = listResult.nextPageToken
	else
		v2 = data.listStatus.isFetchingConversations == true
		v3 = data.listStatus.oldestConversationIsFetched ~= true
		v4 = data.listStatus.nextCursor
	end

	local isEligibilityLoading = data.isEligibilityLoading or v2

	local v5 = not isEligibilityLoading
		and v3
		and data.conversationCount < ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
		and v4
		or ""

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v6 = React.useCallback(function()
		if v5 == "" or ref.current == v5 then
			return
		end

		ref.current = v5

		if FFlagShareSheetFriendsSort then
			data.loadMore(v5)
		else
			fetchConversationListPageToSignals({ cursor = v5 })
		end
	end, { v5, data.loadMore })

	local ref3 = React.useRef({ contentLength = nil, scrollOffset = 0, viewportLength = nil })

	local state, setState = React.useState(nil)
	local v7 = React.useCallback(function()
		local current = ref2.current

		if current then
			return isViewportNearEnd( -- inferred equivalent call
				current.CanvasPosition.Y,
				current.AbsoluteWindowSize.Y,
				current.AbsoluteCanvasSize.Y
			)
		else
			local current2 = ref3.current

			if current2.viewportLength == nil or current2.contentLength == nil then
				return false
			end

			return isViewportNearEnd(current2.scrollOffset, current2.viewportLength, current2.contentLength) -- inferred equivalent call
		end
	end, {})
	local v8 = React.useCallback(function()
		local current = ref3.current

		if
			isPeoplePickerDisplayed
			and current.viewportLength ~= nil
			and current.contentLength ~= nil
			and isViewportUnderfilled(current.viewportLength, current.contentLength) -- inferred equivalent call
		then
			v6()
		end
	end, { isPeoplePickerDisplayed, v6 })
	local onContentLengthChanged = React.useCallback(function(contentLength: number)
		ref3.current.contentLength = contentLength
		v8()
	end, { v8 })
	local onScrollOffsetChanged = React.useCallback(function(scrollOffset: number)
		ref3.current.scrollOffset = scrollOffset

		if not isPeoplePickerDisplayed then
			return
		end

		if not v7() then
			ref.current = nil
		end
	end, { isPeoplePickerDisplayed, v7 })
	local onViewportChanged = React.useCallback(function(vector2: Vector2)
		ref3.current.viewportLength = vector2.Y
		setState(vector2.Y * v)
		v8()
	end, { v8 })
	local scrollingFrameRef = React.useCallback(function(current)
		ref2.current = current
	end, {})

	React.useEffect(function()
		if not isPeoplePickerDisplayed then
			ref.current = nil
			return
		end

		local v9 = false
		task.defer(function()
			if not v9 then
				v8()
			end
		end)
		return function()
			v9 = true
		end
	end, { isPeoplePickerDisplayed, v8 })
	local onEndReached

	if isPeoplePickerDisplayed and v5 ~= "" then
		onEndReached = v6
	end

	return {
		isLoading = isEligibilityLoading,
		paginationProps = {
			endReachedThreshold = state,
			scrollingFrameRef = scrollingFrameRef,
			onContentLengthChanged = onContentLengthChanged,
			onEndReached = onEndReached,
			onScrollOffsetChanged = onScrollOffsetChanged,
			onViewportChanged = onViewportChanged
		}
	}
end

return usePeoplePickerPagination
