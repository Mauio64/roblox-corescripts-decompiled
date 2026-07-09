local UserTile = script:FindFirstAncestor("UserTile")
local UserTileParent = UserTile.Parent
local React = require(UserTileParent.React)

require(UserTileParent.Foundation)

local Cryo = require(UserTileParent.Cryo)
local DataHydration = require(UserTileParent.DataHydration)
local useSignalState = require(UserTileParent.SignalsReact).useSignalState
local Signals = require(UserTileParent.Signals)
local UserTile2 = require(UserTile.Components.UserTile)

require(script.Parent.Parent.Enums.LayoutMode)

local v9 = game:DefineFastFlag("TCIndicatorHydration", false)
local v10 = if not v9 then nil else DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function UserTileContainer(t1: {[any]: any}) -- line: 46
	-- upvalues: v9 (copy), React (copy), Signals (copy), v10 (copy), useSignalState (copy), Cryo (copy), UserTile2 (copy)
	local u13 = nil

	if v9 then
		local v14 = React.useMemo(function() -- line: 49
			-- upvalues: Signals (copy), t1 (copy), v10 (copy)
			return Signals.createComputed(function(p1) -- line: 50
				-- upvalues: t1 (copy), v10 (copy)
				if t1.userId and t1.userId ~= "" then
					return (v10.getIsTrustedConnection(t1.userId).data(p1))
				end

				return nil
			end)
		end, { t1.userId })

		u13 = useSignalState(v14)
	end

	local v15 = if not v9 then table.clone(t1) else React.useMemo(function() -- line: 62
		-- upvalues: Cryo (copy), t1 (copy), u13 (ref)
		return Cryo.Dictionary.join(t1 or {}, {
			isTrustedConnection = u13
		})
	end, {
		t1,
		u13
	})

	return React.createElement(UserTile2, v15)
end

return UserTileContainer
