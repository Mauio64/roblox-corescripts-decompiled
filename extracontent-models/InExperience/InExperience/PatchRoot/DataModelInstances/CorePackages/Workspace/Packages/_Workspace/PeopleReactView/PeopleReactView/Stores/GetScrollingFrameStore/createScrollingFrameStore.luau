local parent = script:FindFirstAncestor("PeopleReactView").Parent

local Signals = require(parent.Signals)

local PeopleService = require(parent.PeopleService)

local fFlagFixVirtualizedGridNumItems = PeopleService.getService("Flags").FFlagFixVirtualizedGridNumItems

local function createScrollingFrameStore()
	local signal, v = Signals.createSignal(0)
	local signal2, v2 = Signals.createSignal(0)
	local signal3, v3 = Signals.createSignal(0)
	local v4, setCanvasPositionYOffset

	if fFlagFixVirtualizedGridNumItems then
		v4, setCanvasPositionYOffset = Signals.createSignal(0)
	else
		v4 = nil
	end

	local getCanvasPositionY

	if fFlagFixVirtualizedGridNumItems then
		getCanvasPositionY = Signals.createComputed(function(p)
			return signal3(p) + v4(p)
		end)
	end

	local absolutePositionChangedConnection = nil
	local absoluteSizeChangedConnection = nil
	local canvasPositionChangedConnection = nil

	local function fn(instance)
		if absolutePositionChangedConnection then
			absolutePositionChangedConnection:Disconnect()
		end

		if absoluteSizeChangedConnection then
			absoluteSizeChangedConnection:Disconnect()
		end

		if canvasPositionChangedConnection then
			canvasPositionChangedConnection:Disconnect()
		end

		v(instance.AbsolutePosition.Y)
		v2(instance.AbsoluteSize.Y)
		v3(instance.CanvasPosition.Y)

		absolutePositionChangedConnection = instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			v(instance.AbsolutePosition.Y)
		end)

		absoluteSizeChangedConnection = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			v2(instance.AbsoluteSize.Y)
		end)

		canvasPositionChangedConnection = instance:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			v3(instance.CanvasPosition.Y)
		end)
	end

	local function fn2()
		if absolutePositionChangedConnection then
			absolutePositionChangedConnection:Disconnect()
		end

		if absoluteSizeChangedConnection then
			absoluteSizeChangedConnection:Disconnect()
		end

		if canvasPositionChangedConnection then
			canvasPositionChangedConnection:Disconnect()
		end
	end

	if not fFlagFixVirtualizedGridNumItems then
		getCanvasPositionY = signal3
	end

	if not fFlagFixVirtualizedGridNumItems then
		setCanvasPositionYOffset = nil
	end

	return {
		getAbsolutePositionY = signal,
		getAbsoluteSizeY = signal2,
		getCanvasPositionY = getCanvasPositionY,
		setScrollingFrame = fn,
		setCanvasPositionYOffset = setCanvasPositionYOffset,
		cleanUp = fn2
	}
end

return createScrollingFrameStore
