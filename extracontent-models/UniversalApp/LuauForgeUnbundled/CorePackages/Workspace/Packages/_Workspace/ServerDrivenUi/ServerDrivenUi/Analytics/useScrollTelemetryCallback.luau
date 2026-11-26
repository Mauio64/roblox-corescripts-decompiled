local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UnifiedLogging")
local getDisplayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Display").GetDisplayStore

local feedScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ScrollTelemetry").feedScroll

local sduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").SduiErrors

local function useScrollTelemetryCallback(p2, p3, p4)
	return (React.useCallback(function(p5, scrollDuration, startPos)
		if p2 and p2.current ~= nil and p3.current then
			local current = p3.current
			local scrollingDirection = p2.current.ScrollingDirection
			local v5 = 0

			if scrollingDirection == Enum.ScrollingDirection.X then
				v5 = p2.current.AbsoluteSize.X
			elseif scrollingDirection == Enum.ScrollingDirection.Y then
				v5 = p2.current.AbsoluteSize.Y
			else
				p4.dependencies.logger.reportError(
					sduiErrors.SduiErrorType.InvalidScrollDirection,
					{
						name = `{current.collectionId}`,
						message = `Direction {scrollingDirection.Name} is an unsupported option for feedScroll event`
					},
					p4.appPage
				)
			end

			local viewportSize = getDisplayStore(false).getViewportSize(false)

			local v6 = {
				distance = p5,
				screenSizeX = viewportSize.X,
				screenSizeY = viewportSize.Y,
				scrollAreaSize = v5,
				scrollDepth = 0,
				startDepth = 0,
				startPos = 0,
				scrollDuration = 0,
				sortPos = 0,
				gameSetTypeId = 0,
				gameSetTargetId = nil
			}

			local v7 = if v5 > 0 then p5 / v5 else nil
			v6.scrollDepth = v7
			local v8 = if v5 > 0 then startPos / v5 else nil
			v6.startDepth = v8
			v6.startPos = startPos
			v6.scrollDuration = scrollDuration
			v6.sortPos = current.collectionPosition
			v6.gameSetTypeId = tostring(current.collectionId)

			feedScroll(p4.dependencies.eventIngest, p4.appPage, scrollingDirection, v6)
		end
	end, { p4, p3, p2 }))
end

return useScrollTelemetryCallback
