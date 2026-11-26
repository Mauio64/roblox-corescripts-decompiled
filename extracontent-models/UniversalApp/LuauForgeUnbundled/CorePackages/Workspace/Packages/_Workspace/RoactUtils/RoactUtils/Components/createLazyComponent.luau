local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/RoactUtils/types")

local defineFastFlag = game:DefineFastFlag("LuaAppLazyComponentAsyncChunkLoad", false)

local function createLazyComponent(callback)
	local memo = React.memo(function(p2)
		if not defineFastFlag then
			local v5 = React.useMemo(callback, {})
			return React.createElement(v5, p2)
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

		return React.createElement(state.component, p2)
	end)

	return function(p2)
		return React.createElement(memo, p2)
	end
end

return createLazyComponent
