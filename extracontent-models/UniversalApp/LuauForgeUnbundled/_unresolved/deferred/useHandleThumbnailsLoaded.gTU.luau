local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dSV")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module2 = require("@luauforge/deferred/gPp")

local function useHandleThumbnailsLoaded()
	local state, setState = React.useState({})
	local v5 = useDispatch()

	local ref = React.useRef(false)

	local v6 = module2()

	local v7 = React.useCallback(function(p2, p3)
		if not (p2 and p3) or ref.current then
			return
		end

		setState(function(p4)
			local clone = table.clone(p4)
			local clone2 = table.clone(p4[p2] or {})
			table.insert(clone2, p3)
			clone[p2] = clone2
			return clone
		end)
	end, {})

	React.useEffect(function()
		if ref.current then
			ref.current = false
		end
	end, { v6 })

	React.useEffect(function()
		if next(state) == nil then
			return
		end

		local filtered = Cryo.Dictionary.filter(state, function(p2, list): boolean
			return #list > 0
		end)

		if next(filtered) ~= nil then
			v5(module.AppendThumbnails(filtered))

			ref.current = true
			setState({})
		end
	end, { state, v5 })

	return v7
end

return useHandleThumbnailsLoaded
