local ServerUI = script:FindFirstAncestor("ServerUI")
local ServerUIParent = ServerUI.Parent
local React = require(ServerUIParent.React)
local Cryo = require(ServerUIParent.Cryo)
local NavigationContext = require(ServerUI.Navigation.NavigationContext)

local function Navigation(p1) -- line: 7
	-- upvalues: React (copy), Cryo (copy), NavigationContext (copy)
	local v8, v9 = React.useState({})
	local v10 = React.useMemo(function() -- line: 10
		-- upvalues: v8 (copy)
		return v8 and v8[#v8] or nil
	end)

	return React.createElement(NavigationContext.Provider, {
		value = {
			stack = v8,
			setStack = v9,
			currentRoute = v10,
			reset = function(t1: {[any]: any}, p2, s1: string?) -- line: 14
				-- upvalues: v9 (copy)
				v9({{
					componentRefs = t1,
					params = p2,
					templateName = s1
				}})
			end,
			push = function(t2: {[any]: any}, p3, s2: string?) -- line: 22
				-- upvalues: v10 (copy), v9 (copy), Cryo (copy), v8 (copy)
				if s2 or v10 and v10.templateName then
					v9(Cryo.List.join(v8, {{
						componentRefs = t2,
						params = p3,
						templateName = s2 or v10.templateName
					}}))
				end
			end,
			pushParams = function(p4) -- line: 34
				-- upvalues: v10 (copy), v9 (copy), Cryo (copy), v8 (copy)
				if v10 then
					v9(Cryo.List.join(v8, {{
						componentRefs = v10.componentRefs,
						params = p4,
						templateName = v10.templateName
					}}))
				end
			end
		}
	}, p1.children)
end

return Navigation
