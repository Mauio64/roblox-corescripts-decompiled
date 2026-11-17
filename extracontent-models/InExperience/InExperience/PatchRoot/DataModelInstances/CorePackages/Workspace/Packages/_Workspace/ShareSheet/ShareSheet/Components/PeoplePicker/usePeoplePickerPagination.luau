local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

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
	local listResult = data.listResult
	local isFetchingNextPage = listResult.isFetchingNextPage
	local v2 = listResult.nextPageToken ~= nil
	local isEligibilityLoading = data.isEligibilityLoading or isFetchingNextPage

	local nextPageToken = not isEligibilityLoading
		and v2
		and data.conversationCount < ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
		and listResult.nextPageToken
		or ""

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v3 = React.useCallback(function()
		if nextPageToken == "" or ref.current == nextPageToken then
			return
		end

		ref.current = nextPageToken
		data.loadMore(nextPageToken)
	end, { nextPageToken, data.loadMore })

	local ref3 = React.useRef({ contentLength = nil, scrollOffset = 0, viewportLength = nil })

	local state, setState = React.useState(nil)
	local v4 = React.useCallback(function()
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
	local v5 = React.useCallback(function()
		local current = ref3.current

		if
			isPeoplePickerDisplayed
			and current.viewportLength ~= nil
			and current.contentLength ~= nil
			and isViewportUnderfilled(current.viewportLength, current.contentLength) -- inferred equivalent call
		then
			v3()
		end
	end, { isPeoplePickerDisplayed, v3 })
	local onContentLengthChanged = React.useCallback(function(contentLength: number)
		ref3.current.contentLength = contentLength
		v5()
	end, { v5 })
	local onScrollOffsetChanged = React.useCallback(function(scrollOffset: number)
		ref3.current.scrollOffset = scrollOffset

		if not isPeoplePickerDisplayed then
			return
		end

		if not v4() then
			ref.current = nil
		end
	end, { isPeoplePickerDisplayed, v4 })
	local onViewportChanged = React.useCallback(function(vector2: Vector2)
		ref3.current.viewportLength = vector2.Y
		setState(vector2.Y * v)
		v5()
	end, { v5 })
	local scrollingFrameRef = React.useCallback(function(current)
		ref2.current = current
	end, {})

	React.useEffect(function()
		if not isPeoplePickerDisplayed then
			ref.current = nil
			return
		end

		local v6 = false
		task.defer(function()
			if not v6 then
				v5()
			end
		end)
		return function()
			v6 = true
		end
	end, { isPeoplePickerDisplayed, v5 })
	local onEndReached

	if isPeoplePickerDisplayed and nextPageToken ~= "" then
		onEndReached = v3
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
