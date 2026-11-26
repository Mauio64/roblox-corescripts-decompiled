local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/AppCommonLib")
local HoverTileCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/HoverTileCoordinator")

local function useIsHoveredTile(p2, p3, p4, p5)
	local v5 = p5 or HoverTileCoordinator.default

	local state, setState = React.useState(false)

	React.useEffect(function()
		if not p4 then
			return
		end

		local function checkAndUpdateState(p6)
			setState(p6 ~= nil and p6 == p3)
		end

		local hoveredKey = v5.hoveredKey
		setState(hoveredKey ~= nil and hoveredKey == p3)

		local changedConnection = v5.changed:connect(function(p6)
			setState(p6 ~= nil and p6 == p3)
		end)

		return function()
			if changedConnection ~= nil then
				changedConnection:disconnect()
				changedConnection = nil
			end
		end
	end, { p4, p3, v5 })

	React.useEffect(function()
		if not p4 then
			return
		end

		local connections = {}

		if p2.current ~= nil then
			table.insert(connections, p2.current.MouseLeave:Connect(function()
				v5:cancelHover(p3)
			end))

			table.insert(connections, p2.current.MouseEnter:Connect(function()
				v5:requestHover(p3)
			end))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p3, p2, p4, v5 })

	React.useEffect(function()
		return function()
			if p3 then
				v5:cancelHover(p3)
			end
		end
	end, { p3, v5 })

	return p4 and state
end

return useIsHoveredTile
