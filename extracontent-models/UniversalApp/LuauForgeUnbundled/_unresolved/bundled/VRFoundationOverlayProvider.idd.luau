local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local function VRFoundationOverlayProvider(p2)
	local state, setState = React.useState(nil)
	local v5 = useIsSpatial()

	React.useEffect(function()
		if v5 then
			local thread = task.spawn(function()
				local luaAppScreenGui = CoreGui:WaitForChild("LuaAppScreenGui")

				local mainAppScreen_SurfaceGui = if luaAppScreenGui then luaAppScreenGui:WaitForChild("MainAppScreen_SurfaceGui") else nil

				if mainAppScreen_SurfaceGui and mainAppScreen_SurfaceGui:IsA("SurfaceGui") then
					setState(mainAppScreen_SurfaceGui)
				end
			end)

			return function()
				task.cancel(thread)
			end
		end

		setState(nil)
	end, { v5 })

	if v5 then
		return (React.createElement(Foundation.OverlayProvider, { gui = state }, {
			Children = React.createElement(React.Fragment, nil, p2.children)
		}))
	end

	return (React.createElement(React.Fragment, nil, p2.children))
end

return VRFoundationOverlayProvider
