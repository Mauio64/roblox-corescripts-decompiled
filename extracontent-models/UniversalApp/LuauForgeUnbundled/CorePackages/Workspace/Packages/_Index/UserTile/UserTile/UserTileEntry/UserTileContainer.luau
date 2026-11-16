local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/Foundation")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/Cryo")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/DataHydration")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/SignalsReact").useSignalState
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/UserTile/Signals")

local UserTile = require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Components/UserTile")
require("@game/CorePackages/Workspace/Packages/_Index/UserTile/UserTile/Enums/LayoutMode")

local v5 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function UserTileContainer(options)
	local v7 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			if options.userId and options.userId ~= "" then
				return (v5.getIsTrustedConnection(options.userId).data(p2))
			end

			return nil
		end)
	end, { options.userId })))

	local v8 = React.useMemo(function()
		return Cryo.Dictionary.join(options or {}, { isTrustedConnection = v7 })
	end, { options, v7 })

	return React.createElement(UserTile, v8)
end

return UserTileContainer
