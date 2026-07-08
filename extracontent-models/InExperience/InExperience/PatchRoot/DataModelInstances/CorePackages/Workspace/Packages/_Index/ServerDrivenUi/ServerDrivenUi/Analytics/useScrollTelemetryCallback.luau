local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local React = require(Parent.React)

require(Parent.UnifiedLogging)

local GetDisplayStore = require(Parent.Display).GetDisplayStore
local feedScroll = require(Parent.ScrollTelemetry).feedScroll
local SduiErrors = require(Parent.SduiCoreSystem).SduiErrors

local function useScrollTelemetryCallback(t1: {[any]: any}?, t2: {[any]: any}, p1) -- line: 17
	-- upvalues: React (copy), SduiErrors (copy), GetDisplayStore (copy), feedScroll (copy)
	return (React.useCallback(function(n1: number, n2: number, n3: number) -- line: 23
		-- upvalues: t1 (copy), t2 (copy), p1 (copy), SduiErrors (copy), GetDisplayStore (copy), feedScroll (copy)
		if t1 and (t1.current ~= nil and t2.current) then
			local current = t2.current
			local ScrollingDirection = t1.current.ScrollingDirection
			local n4 = 0

			if ScrollingDirection == Enum.ScrollingDirection.X then
				n4 = t1.current.AbsoluteSize.X
			elseif ScrollingDirection == Enum.ScrollingDirection.Y then
				n4 = t1.current.AbsoluteSize.Y
			else
				p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.InvalidScrollDirection, {
					name = `{ current.collectionId }`,
					message = `Direction { ScrollingDirection.Name } is an unsupported option for feedScroll event`
				}, p1.appPage)
			end

			local v16 = GetDisplayStore(false).getViewportSize(false)
			local t3 = {
				gameSetTargetId = nil,
				distance = n1,
				screenSizeX = v16.X,
				screenSizeY = v16.Y,
				scrollAreaSize = n4,
				scrollDepth = if not (n4 > 0) then nil else n1 / n4,
				startDepth = if not (n4 > 0) then nil else n3 / n4,
				startPos = n3,
				scrollDuration = n2,
				sortPos = current.collectionPosition,
				gameSetTypeId = tostring(current.collectionId)
			}

			feedScroll(p1.dependencies.eventIngest, p1.appPage, ScrollingDirection, t3)
		end
	end, {
		p1,
		t2,
		t1
	}))
end

return useScrollTelemetryCallback
