local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent
local React = require(parent.React)
require(parent.AppCommonLib)
local HoverTileCoordinator = require(GameTile.HoverTileCoordinator)

local function useIsHoveredTile(p, p2: string, flag: boolean, p3)
	local v = p3 or HoverTileCoordinator.default

	local state, setState = React.useState(false)

	React.useEffect(function()
		if not flag then
			return
		end

		local function checkAndUpdateState(p4: string?) -- 2 equivalent calls inferred from this helper
			setState(p4 ~= nil and p4 == p2)
		end

		checkAndUpdateState(v.hoveredKey) -- inferred equivalent call

		local changedConnection = v.changed:connect(function(p4)
			checkAndUpdateState(p4) -- inferred equivalent call
		end)

		return function()
			if changedConnection ~= nil then
				changedConnection:disconnect()
				changedConnection = nil
			end
		end
	end, { flag, p2, v })

	React.useEffect(function()
		if not flag then
			return
		end

		local connections = {}

		if p.current ~= nil then
			table.insert(connections, p.current.MouseLeave:Connect(function()
				v:cancelHover(p2)
			end))

			table.insert(connections, p.current.MouseEnter:Connect(function()
				v:requestHover(p2)
			end))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { p2, p, flag, v })

	React.useEffect(function()
		return function()
			if p2 then
				v:cancelHover(p2)
			end
		end
	end, { p2, v })

	return flag and state
end

return useIsHoveredTile
