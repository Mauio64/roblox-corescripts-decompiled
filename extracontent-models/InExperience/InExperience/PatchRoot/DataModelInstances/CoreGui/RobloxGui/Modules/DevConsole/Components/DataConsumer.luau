local CorePackages = game:GetService("CorePackages")
local Components = script.Parent.Parent.Components
local Roact = require(CorePackages.Packages.Roact)
local Immutable = require(script.Parent.Parent.Immutable)
local DataContext = require(Components.DataContext)

return function(p1, ...) -- line: 8
	-- upvalues: Roact (copy), Immutable (copy), DataContext (copy)
	if not p1 then
		error("Expected component to be passed to connection, got nil.")
	end

	local t1 = {}

	for i = 1, select("#", ...) do
		t1[i] = select(i, ...)
	end

	local v9 = string.format("Consumer(%s)_DependsOn_%s", tostring(p1), t1[1])
	local v10 = Roact.Component:extend(v9)

	function v10.init(p2) -- line: 21
		-- upvalues: t1 (copy)
		local t2 = {}

		for _, v in pairs(t1) do
			local v16 = p2.props.DevConsoleData[v]

			if not v16 then
				local v17 = string.format("%s %s", tostring(v), "could not be found. Make sure DataProvider is above this consumer")

				error(v17)

				return
			end

			t2[v] = v16
		end

		p2:setState(t2)
	end
	function v10.render(p3) -- line: 40
		-- upvalues: Immutable (copy), Roact (copy), p1 (copy)
		local v19 = Immutable.JoinDictionaries(p3.props.componentProps, p3.state)

		return Roact.createElement(p1, v19)
	end

	local function DataConsumerWrapper(p4) -- line: 45
		-- upvalues: Roact (copy), DataContext (copy), v10 (copy)
		return Roact.createElement(DataContext.Consumer, {
			render = function(p5) -- line: 47
				-- upvalues: Roact (copy), v10 (copy), p4 (copy)
				return Roact.createElement(v10, {
					componentProps = p4,
					DevConsoleData = p5
				})
			end
		})
	end

	return DataConsumerWrapper
end
