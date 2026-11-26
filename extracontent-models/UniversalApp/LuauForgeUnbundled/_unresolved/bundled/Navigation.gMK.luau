local module = require("@luauforge/bundled/gMy")
local module2 = require("@luauforge/bundled/gMB")
local module3 = require("@luauforge/bundled/gMJ")

local function Navigation(p2)
	local state, setState = module.useState({})

	local v5 = module.useMemo(function()
		return state and state[#state] or nil
	end)

	local function push(p3, p4, p5)
		if p5 or v5 and v5.templateName then
			setState(module2.List.join(state, {
				{
					componentRefs = p3,
					params = p4,
					templateName = p5 or v5.templateName
				}
			}))
		end
	end

	local function pushParams(p3)
		if v5 then
			setState(module2.List.join(state, {
				{
					componentRefs = v5.componentRefs,
					params = p3,
					templateName = v5.templateName
				}
			}))
		end
	end

	return module.createElement(module3.Provider, {
		value = {
			stack = state,
			setStack = setState,
			currentRoute = v5,
			reset = function(p3, p4, p5)
				setState({
					{ componentRefs = p3, params = p4, templateName = p5 }
				})
			end,
			push = push,
			pushParams = pushParams
		}
	}, p2.children)
end

return Navigation
