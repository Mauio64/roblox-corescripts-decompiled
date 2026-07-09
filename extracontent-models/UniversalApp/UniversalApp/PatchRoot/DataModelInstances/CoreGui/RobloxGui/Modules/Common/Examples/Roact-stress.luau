local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local v5 = Roact.Component:extend("Node")

function v5.render(p1) -- line: 12
	-- upvalues: Roact (copy)
	local x = p1.props.x
	local y = p1.props.y
	local v10 = p1.props.time + x / 10 + y / 10

	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 10, 0, 10),
		Position = UDim2.new(0, 10 * x, 0, 10 * y),
		BackgroundColor3 = Color3.new(math.sin(v10) * 0.5 + 0.5, 0.5, 0.5)
	})
end

local v6 = Roact.Component:extend("App")

function v6.init(p2) -- line: 28
	p2.state = {
		time = tick()
	}
end
function v6.render(p3) -- line: 34
	-- upvalues: Roact (copy), v5 (copy)
	local time = p3.state.time
	local t1 = {}
	local n1 = 0

	for i = 0, 49 do
		for j = 0, 49 do
			n1 += 1
			t1[n1] = Roact.createElement(v5, {
				x = i,
				y = j,
				time = time
			})
		end
	end

	return Roact.createElement("ScreenGui", nil, t1)
end
function v6.didMount(p4) -- line: 53
	-- upvalues: RunService (copy)
	RunService.Stepped:Connect(function() -- line: 54
		-- upvalues: p4 (copy)
		p4:setState({
			time = tick()
		})
	end)
end

return function() -- line: 61
	-- upvalues: Roact (copy), v6 (copy), CoreGui (copy)
	Roact.mount(Roact.createElement(v6), CoreGui)
end
