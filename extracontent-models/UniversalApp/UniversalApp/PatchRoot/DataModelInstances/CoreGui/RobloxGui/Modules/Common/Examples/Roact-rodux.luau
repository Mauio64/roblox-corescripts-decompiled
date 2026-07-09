local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Rodux = require(CorePackages.Packages.Rodux)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local v6 = Roact.Component:extend("App")

function v6.render(p1) -- line: 18
	-- upvalues: Roact (copy)
	local count = p1.props.count
	local onClick = p1.props.onClick

	return Roact.createElement("ScreenGui", nil, {
		Label = Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			Text = "Count: " .. tostring(count),
			TextSize = 48,
			AutoButtonColor = false,
			[Roact.Event.Activated] = onClick
		})
	})
end

local u7 = RoactRodux.connect(function(p2, _) -- line: 40
	return {
		count = p2.count
	}
end, function(p4) -- line: 44
	print("hello?")

	return {
		onClick = function() -- line: 47
			-- upvalues: p4 (copy)
			p4({
				type = "increment"
			})
		end
	}
end)(v6)

local function reducer(p5, p6) -- line: 61
	local v17 = p5 or {
		count = 0
	}

	if p6.type == "increment" then
		return {
			count = v17.count + 1
		}
	end

	return v17
end

return function() -- line: 76
	-- upvalues: Rodux (copy), reducer (copy), Roact (copy), RoactRodux (copy), u7 (ref), CoreGui (copy)
	local v18 = Rodux.Store.new(reducer)
	local v19 = Roact.createElement(RoactRodux.StoreProvider, {
		store = v18
	}, {
		App = Roact.createElement(u7)
	})

	Roact.mount(v19, CoreGui, "Roact-demo-rodux")
end
