local parent = script.Parent.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local ReactUtils = require(parent2.ReactUtils)

local mockStyleComponent = require(parent.Utility.mockStyleComponent)
local ReactTestingLibrary = require(parent2.Dev.ReactTestingLibrary)
local render = ReactTestingLibrary.render

local JestBenchmark = require(parent2.Dev.JestBenchmark)
local benchmark = JestBenchmark.benchmark

function measureFPS(p, value: number?)
	task.wait()
	task.wait()
	p.start("fps")
	task.wait(value or 0.5)
	p.stop()
end

function mountComponentTimes(p, p2: number, p3: string)
	local v = {}

	for i = 1, p2 do
		v[i] = p
	end

	local v2 = mockStyleComponent(v)

	benchmark(`Mount {p3} {p2} times`, function()
		render(v2):unmount()
	end)
end

function AutoScrollingFrame(p)
	local v = ReactUtils.useClock()

	return React.createElement("ScrollingFrame", {
		Size = UDim2.fromOffset(100, 100),
		CanvasSize = UDim2.fromOffset(100, 0),
		CanvasPosition = v:map(function(p2: number)
			return Vector2.new(0, p2 * 10000)
		end),
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	}, p.children)
end

function scrollComponentTimes(p, p2: number, p3: string)
	local v = {}

	for i = 1, p2 do
		v[i] = p
	end

	v[p2 + 1] = React.createElement("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		FillDirection = Enum.FillDirection.Vertical
	})

	local v2 = mockStyleComponent(React.createElement(AutoScrollingFrame, {}, v))

	benchmark(`Scroll {p3} {p2} times`, function(p4)
		local v3 = render(v2)
		measureFPS(p4)
		v3:unmount()
	end)
end

return {
	mountComponentTimes = mountComponentTimes,
	scrollComponentTimes = scrollComponentTimes,
	measureFPS = measureFPS
}
