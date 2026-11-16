local UserTile = script:FindFirstAncestor("UserTile")
local parent = UserTile.Parent

local React = require(parent.React)
require(parent.Foundation)
local Cryo = require(parent.Cryo)

local DataHydration = require(parent.DataHydration)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(parent.Signals)

local UserTile2 = require(UserTile.Components.UserTile)
require(script.Parent.Parent.Enums.LayoutMode)

local v = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function UserTileContainer(options)
	local isTrustedConnection = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p)
			if options.userId and options.userId ~= "" then
				return (v.getIsTrustedConnection(options.userId).data(p))
			end

			return nil
		end)
	end, { options.userId })))

	local v2 = React.useMemo(function()
		return Cryo.Dictionary.join(options or {}, { isTrustedConnection = isTrustedConnection })
	end, { options, isTrustedConnection })

	return React.createElement(UserTile2, v2)
end

return UserTileContainer
