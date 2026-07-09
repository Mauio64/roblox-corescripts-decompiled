local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)

local function createReactTelemetryLayer(p1, p2) -- line: 11
	-- upvalues: React (copy), Cryo (copy)
	local v7 = React.createContext(function() -- line: 16
		-- upvalues: Cryo (copy), p2 (copy)
		return Cryo.Dictionary.union({}, p2)
	end)

	return {
		Context = v7,
		Provider = function(t1: {[any]: any}) -- line: 23
			-- upvalues: React (copy), p1 (copy), Cryo (copy), v7 (copy)
			local v9 = React.useContext(p1)
			local v10 = React.useCallback(function() -- line: 25
				-- upvalues: t1 (copy), Cryo (copy), v9 (copy)
				local value = t1.value

				if typeof(value) == "function" then
					value = value()
				end

				return Cryo.Dictionary.union(v9(), value)
			end, {
				v9,
				t1.value
			})

			return React.createElement(v7.Provider, {
				value = v10
			}, t1.children)
		end
	}
end

return createReactTelemetryLayer
