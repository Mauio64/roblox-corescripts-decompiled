local RoactUtils = script:FindFirstAncestor("RoactUtils")
local parent = RoactUtils.Parent
local React = require(parent.React)

require(RoactUtils.types)

local defineFastFlag = game:DefineFastFlag("LuaAppLazyComponentAsyncChunkLoad", false)

local function createLazyComponent(callback)
	local memo = React.memo(function(p)
		if not defineFastFlag then
			local v = React.useMemo(callback, {})
			return React.createElement(v, p)
		end

		local state, setState = React.useState({ state = "idle" })

		if state.state == "idle" then
			task.spawn(function()
				setState({ state = "pending" })
				local success, result = pcall(callback)

				if success then
					setState({ state = "resolved", component = result })
				else
					setState({ state = "failed", error = result })
				end
			end)
			return nil
		end

		if state.state == "failed" then
			error(state.error, 0)
		elseif state.state == "pending" then
			return nil
		end

		return React.createElement(state.component, p)
	end)

	return function(p)
		return React.createElement(memo, p)
	end
end

return createLazyComponent
