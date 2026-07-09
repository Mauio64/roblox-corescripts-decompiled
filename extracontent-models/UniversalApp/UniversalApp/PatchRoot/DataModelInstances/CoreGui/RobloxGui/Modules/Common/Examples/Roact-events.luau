local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local v4 = Roact.Component:extend("App")

function v4.render(_) -- line: 8
	-- upvalues: Roact (copy)
	return Roact.createElement("ScreenGui", {}, {
		Button = Roact.createElement("TextButton", {
			Size = UDim2.new(0.5, 0, 0.5, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			[Roact.Event.Activated] = function(_) -- line: 18
				print("The button was clicked!")
			end
		})
	})
end

return function() -- line: 25
	-- upvalues: Roact (copy), v4 (copy), CoreGui (copy)
	local v6 = Roact.createElement(v4)

	Roact.mount(v6, CoreGui, "Roact-events")
end
