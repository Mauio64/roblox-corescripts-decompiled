local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local function createStateContext(p2)
	local context = React.createContext({
		get = function()
			return Cryo.Dictionary.union({}, p2)
		end,
		set = function() end
	})

	return {
		Provider = context.Provider,
		useClearState = function()
			local set = React.useContext(context).set
			return React.useCallback(function()
				set(p2)
			end, { set })
		end,
		useGetState = function()
			return React.useContext(context).get
		end,
		useMergeState = function()
			local set = React.useContext(context).set
			return React.useCallback(function(p3)
				set(function(p4)
					return Cryo.Dictionary.join(p4, p3)
				end)
			end, { set })
		end,
		useSetState = function()
			return React.useContext(context).set
		end
	}
end

return createStateContext
