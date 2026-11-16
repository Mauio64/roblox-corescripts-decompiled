local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)

local function createStateContext(p)
	local context = React.createContext({
		get = function()
			return Cryo.Dictionary.union({}, p)
		end,
		set = function() end
	})

	return {
		Provider = context.Provider,
		useClearState = function()
			local set = React.useContext(context).set
			return React.useCallback(function()
				set(p)
			end, { set })
		end,
		useGetState = function()
			return React.useContext(context).get
		end,
		useMergeState = function()
			local set = React.useContext(context).set
			return React.useCallback(function(p2)
				set(function(p3)
					return Cryo.Dictionary.join(p3, p2)
				end)
			end, { set })
		end,
		useSetState = function()
			return React.useContext(context).set
		end
	}
end

return createStateContext
