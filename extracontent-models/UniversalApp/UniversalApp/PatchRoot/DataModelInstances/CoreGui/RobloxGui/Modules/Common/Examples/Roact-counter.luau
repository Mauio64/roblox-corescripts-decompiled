local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local function TickLabel(p1) -- line: 10
	-- upvalues: Roact (copy)
	local value = p1.value

	return Roact.createElement("TextLabel", {
		TextSize = 48,
		Size = UDim2.new(1, 0, 1, 0),
		Text = ("Current tick is %d!"):format(value)
	})
end

local v5 = Roact.Component:extend("App")

function v5.init(p2) -- line: 22
	p2.running = false
	p2.state = {
		count = 0
	}
end
function v5.render(p3) -- line: 33
	-- upvalues: Roact (copy), TickLabel (copy)
	return Roact.createElement("ScreenGui", {
		Name = "Roact-demo-counter"
	}, {
		Count = Roact.createElement(TickLabel, {
			value = p3.state.count
		})
	})
end
function v5.didMount(p4) -- line: 43
	spawn(function() -- line: 47
		-- upvalues: p4 (copy)
		p4.running = true

		while p4.running do
			p4:setState({
				count = p4.state.count + 1
			})
			wait(1)
		end
	end)
end
function v5.willUnmount(p5) -- line: 63
	p5.running = false
end

return function() -- line: 69
	-- upvalues: Roact (copy), v5 (copy), CoreGui (copy)
	Roact.mount(Roact.createElement(v5), CoreGui, "Roact-counter")
end
