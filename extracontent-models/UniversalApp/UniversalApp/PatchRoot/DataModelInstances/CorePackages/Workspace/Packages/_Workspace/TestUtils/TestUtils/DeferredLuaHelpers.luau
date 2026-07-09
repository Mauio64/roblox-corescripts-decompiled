local ParentParent = script.Parent.Parent
local ReactRoblox = require(ParentParent.ReactRoblox)

local function waitForEventsTimes(p1: ((...any) -> ...any), n1: number) -- line: 39
	for _ = 1, n1 do
		p1(function() -- line: 41
			task.defer(coroutine.running())
			coroutine.yield()
		end)
	end
end
local function waitForEvents(p2) -- line: 48
	p2(function() -- line: 41
		task.defer(coroutine.running())
		coroutine.yield()
	end)
end
local function forceUpdateGuiObject(p3: ((...any) -> ...any), ...) -- line: 52
	for i = 1, select("#", ...) do
		local v14 = select(i, ...)
		local _ = if not v14:IsA("ScrollingFrame") then v14.AbsoluteSize.Y else v14.AbsoluteCanvasSize.Y
	end

	p3(function() -- line: 61
		task.wait()
	end)
end
local function noAct(p4: ((...any) -> ...any)) -- line: 66
	p4()
end
local function createActWrapper(p5: ((...any) -> ...any)) -- line: 70
	-- upvalues: ReactRoblox (copy), noAct (copy)
	return (setmetatable({
		act = function(...) -- line: 72
			-- upvalues: p5 (copy), ReactRoblox (copy)
			return p5(ReactRoblox.act, ...)
		end
	}, {
		__call = function(_, ...) -- line: 76
			-- upvalues: p5 (copy), noAct (copy)
			return p5(noAct, ...)
		end
	}))
end

return {
	forceUpdateGuiObject = createActWrapper(forceUpdateGuiObject),
	waitForEvents = createActWrapper(waitForEvents),
	waitForEventsTimes = createActWrapper(waitForEventsTimes)
}
