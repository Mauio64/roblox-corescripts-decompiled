local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local React = require(parent.React)
require(parent.UnifiedLogging)
local Display = require(parent.Display)
local GetDisplayStore = Display.GetDisplayStore

local ScrollTelemetry = require(parent.ScrollTelemetry)
local feedScroll = ScrollTelemetry.feedScroll

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors

local function useScrollTelemetryCallback(p, p2, p3)
	return (React.useCallback(function(distance: number, scrollDuration: number, startPos: number)
		if p and p.current ~= nil and p2.current then
			local current = p2.current
			local scrollingDirection = p.current.ScrollingDirection
			local scrollAreaSize = 0

			if scrollingDirection == Enum.ScrollingDirection.X then
				scrollAreaSize = p.current.AbsoluteSize.X
			elseif scrollingDirection == Enum.ScrollingDirection.Y then
				scrollAreaSize = p.current.AbsoluteSize.Y
			else
				p3.dependencies.logger.reportError(
					SduiErrors.SduiErrorType.InvalidScrollDirection,
					{
						name = `{current.collectionId}`,
						message = `Direction {scrollingDirection.Name} is an unsupported option for feedScroll event`
					},
					p3.appPage
				)
			end

			local viewportSize = GetDisplayStore(false).getViewportSize(false)

			local v = {
				distance = distance,
				screenSizeX = viewportSize.X,
				screenSizeY = viewportSize.Y,
				scrollAreaSize = scrollAreaSize,
				scrollDepth = 0,
				startDepth = 0,
				startPos = 0,
				scrollDuration = 0,
				sortPos = 0,
				gameSetTypeId = 0,
				gameSetTargetId = nil
			}
			local scrollDepth

			if scrollAreaSize > 0 then
				scrollDepth = distance / scrollAreaSize
			end

			v.scrollDepth = scrollDepth
			local startDepth

			if scrollAreaSize > 0 then
				startDepth = startPos / scrollAreaSize
			end

			v.startDepth = startDepth
			v.startPos = startPos
			v.scrollDuration = scrollDuration
			v.sortPos = current.collectionPosition
			v.gameSetTypeId = tostring(current.collectionId)

			feedScroll(p3.dependencies.eventIngest, p3.appPage, scrollingDirection, v)
		end
	end, { p3, p2, p }))
end

return useScrollTelemetryCallback
