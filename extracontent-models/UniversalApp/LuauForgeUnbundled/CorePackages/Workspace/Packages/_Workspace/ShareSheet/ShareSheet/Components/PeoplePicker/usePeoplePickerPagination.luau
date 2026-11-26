local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

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
	local listResult = data.listResult
	local isFetchingNextPage = listResult.isFetchingNextPage
	local v6 = listResult.nextPageToken ~= nil
	local isEligibilityLoading = data.isEligibilityLoading or isFetchingNextPage

	local nextPageToken = not isEligibilityLoading
		and v6
		and data.conversationCount < ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
		and listResult.nextPageToken
		or ""

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v7 = React.useCallback(function()
		if nextPageToken == "" or ref.current == nextPageToken then
			return
		end

		ref.current = nextPageToken
		data.loadMore(nextPageToken)
	end, { nextPageToken, data.loadMore })

	local ref3 = React.useRef({
		contentLength = nil,
		scrollOffset = 0,
		viewportLength = nil
	})

	local state, setState = React.useState(nil)
	local v8 = React.useCallback(function(): boolean
		local current = ref2.current

		if current then
			local y = current.CanvasPosition.Y
			local y2 = current.AbsoluteWindowSize.Y
			local y3 = current.AbsoluteCanvasSize.Y

			if y2 <= 0 then
				return false
			end

			local v9 = y + y2
			return y3 - y2 * v5 <= v9
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

			local v9 = scrollOffset + viewportLength
			return contentLength - viewportLength * v5 <= v9
		end
	end, {})
	local v9 = React.useCallback(function()
		local current = ref3.current

		if isPeoplePickerDisplayed and current.viewportLength ~= nil and current.contentLength ~= nil then
			local viewportLength = current.viewportLength
			local contentLength = current.contentLength
			local v10 = viewportLength > 0 and contentLength <= viewportLength

			if v10 then
				v7()
			end
		end
	end, { isPeoplePickerDisplayed, v7 })
	local v10 = React.useCallback(function(contentLength)
		ref3.current.contentLength = contentLength
		v9()
	end, { v9 })
	local v11 = React.useCallback(function(scrollOffset)
		ref3.current.scrollOffset = scrollOffset

		if not isPeoplePickerDisplayed then
			return
		end

		if not v8() then
			ref.current = nil
		end
	end, { isPeoplePickerDisplayed, v8 })
	local v12 = React.useCallback(function(p2)
		ref3.current.viewportLength = p2.Y
		setState(p2.Y * v5)
		v9()
	end, { v9 })
	local v13 = React.useCallback(function(current)
		ref2.current = current
	end, {})

	React.useEffect(function()
		if not isPeoplePickerDisplayed then
			ref.current = nil
			return
		end

		local v14 = false
		task.defer(function()
			if not v14 then
				v9()
			end
		end)
		return function()
			v14 = true
		end
	end, { isPeoplePickerDisplayed, v9 })
	local v16 = if isPeoplePickerDisplayed and nextPageToken ~= "" then v7 else nil
	return {
		isLoading = isEligibilityLoading,
		paginationProps = {
			endReachedThreshold = state,
			scrollingFrameRef = v13,
			onContentLengthChanged = v10,
			onEndReached = v16,
			onScrollOffsetChanged = v11,
			onViewportChanged = v12
		}
	}
end

return usePeoplePickerPagination
