local Parent = script:FindFirstAncestor("BenchmarkUtils").Parent
local React = require(Parent.React)
local ReactUtils = require(Parent.ReactUtils)
local render = require(Parent.ReactTestingLibrary).render
local benchmark = require(Parent.JestBenchmark).benchmark
local describe = require(Parent.JestGlobals).describe

local function AutoScrollingFrame(t1: {[any]: any}) -- line: 60
	-- upvalues: ReactUtils (copy), React (copy)
	local v16 = ReactUtils.useClock()

	return React.createElement("ScrollingFrame", {
		Size = UDim2.fromOffset(100, 100),
		CanvasSize = UDim2.fromOffset(100, 0),
		CanvasPosition = v16:map(function(n1: number) -- line: 66
			return Vector2.new(0, n1 * 10000)
		end),
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	}, t1.children)
end

return {
	DEFAULT_MOUNT_TIMES = 200,
	DEFAULT_SCROLL_TIMES = 200,
	DEFAULT_FPS_DURATION = 0.5,
	benchFile = function(p1, p2: ((...any) -> ...any)) -- line: 131
		-- upvalues: describe (copy)
		local v34 = string.gsub(p1.Name, "%.bench$", "")

		describe(v34, p2)
	end,
	measureFPS = function(t2: {[any]: any}, n2: number?) -- line: 33
		task.wait()
		task.wait()
		t2.start("fps")
		task.wait(n2 or 0.5)
		t2.stop()
	end,
	mountComponentTimes = function(p3, s1: string, n3: number?) -- line: 41
		-- upvalues: benchmark (copy), React (copy), render (copy)
		local v13 = n3 or 200
		local v14 = `Mount { s1 } { v13 } times`

		benchmark(v14, function() -- line: 45
			-- upvalues: v13 (copy), p3 (copy), React (copy), render (copy)
			local t3 = {}

			for i = 1, v13 do
				t3[i] = p3
			end

			local v37 = React.createElement("Frame", {
				Size = UDim2.fromScale(1, 1)
			}, t3)

			render(v37):unmount()
		end)
	end,
	scrollComponentTimes = function(p4, s2: string, n4: number?) -- line: 73
		-- upvalues: React (copy), AutoScrollingFrame (copy), benchmark (copy), render (copy)
		local v20 = n4 or 200
		local t4 = {}

		for i = 1, v20 do
			t4[i] = p4
		end

		t4[v20 + 1] = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			FillDirection = Enum.FillDirection.Vertical
		})

		local v23 = React.createElement("ScreenGui", {}, {
			Content = React.createElement(AutoScrollingFrame, {
				children = t4
			})
		})
		local v24 = `Scroll { s2 } { v20 } times`

		benchmark(v24, function(p5) -- line: 91
			-- upvalues: render (copy), v23 (copy)
			local v40 = render(v23)

			task.wait()
			task.wait()
			p5.start("fps")
			task.wait(0.5)
			p5.stop()
			v40:unmount()
		end)
	end,
	benchmarkRender = function(p6, s3: string) -- line: 98
		-- upvalues: benchmark (copy), render (copy)
		local v27 = `Render { s3 }`

		benchmark(v27, function() -- line: 100
			-- upvalues: render (copy), p6 (copy)
			render(p6):unmount()
		end)
	end,
	benchmarkRerender = function(p7: ((...any) -> ...any), s4: string, t5: {[any]: any}) -- line: 106
		-- upvalues: benchmark (copy), render (copy)
		assert(#t5 > 0, "propChanges must contain at least one element")

		local v31 = `Rerender { s4 } with prop changes`

		benchmark(v31, function() -- line: 110
			-- upvalues: render (copy), p7 (copy), t5 (copy)
			local v41 = render(p7(t5[1]))

			for i = 2, #t5 do
				v41:rerender(p7(t5[i]))
			end

			v41:unmount()
		end)
	end,
	AutoScrollingFrame = AutoScrollingFrame
}
