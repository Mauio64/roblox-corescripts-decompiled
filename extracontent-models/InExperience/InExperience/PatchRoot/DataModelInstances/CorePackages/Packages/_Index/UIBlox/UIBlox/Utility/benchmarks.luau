local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local ReactUtils = require(ParentParentParent.ReactUtils)
local mockStyleComponent = require(ParentParent.Utility.mockStyleComponent)
local render = require(ParentParentParent.Dev.ReactTestingLibrary).render
local benchmark = require(ParentParentParent.Dev.JestBenchmark).benchmark

function measureFPS(p1, n1: number?) -- line: 14
	task.wait()
	task.wait()
	p1.start("fps")
	task.wait(n1 or 0.5)
	p1.stop()
end
function mountComponentTimes(p2, n2: number, s1: string) -- line: 22
	-- upvalues: mockStyleComponent (copy), benchmark (copy), render (copy)
	local t1 = {}

	for i = 1, n2 do
		t1[i] = p2
	end

	local v15 = mockStyleComponent(t1)

	benchmark(`Mount { s1 } { n2 } times`, function() -- line: 29
		-- upvalues: render (copy), v15 (copy)
		render(v15):unmount()
	end)
end
function AutoScrollingFrame(p3) -- line: 35
	-- upvalues: ReactUtils (copy), React (copy)
	local v17 = ReactUtils.useClock()

	return React.createElement("ScrollingFrame", {
		Size = UDim2.fromOffset(100, 100),
		CanvasSize = UDim2.fromOffset(100, 0),
		CanvasPosition = v17:map(function(n3: number) -- line: 41
			return Vector2.new(0, n3 * 10000)
		end),
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	}, p3.children)
end
function scrollComponentTimes(p4, n4: number, s2: string) -- line: 48
	-- upvalues: React (copy), mockStyleComponent (copy), benchmark (copy), render (copy)
	local t2 = {}

	for i = 1, n4 do
		t2[i] = p4
	end

	t2[n4 + 1] = React.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		FillDirection = Enum.FillDirection.Vertical
	})

	local v23 = mockStyleComponent(React.createElement(AutoScrollingFrame, {}, t2))

	benchmark(`Scroll { s2 } { n4 } times`, function(p5) -- line: 62
		-- upvalues: render (copy), v23 (copy)
		local v26 = render(v23)

		measureFPS(p5)
		v26:unmount()
	end)
end

return {
	mountComponentTimes = mountComponentTimes,
	scrollComponentTimes = scrollComponentTimes,
	measureFPS = measureFPS
}
