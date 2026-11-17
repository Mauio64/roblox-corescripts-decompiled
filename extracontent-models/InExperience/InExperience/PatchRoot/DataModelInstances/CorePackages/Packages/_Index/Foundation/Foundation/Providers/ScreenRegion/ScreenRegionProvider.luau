local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

require(script.Parent.ScreenRegion)
require(script.Parent.ScreenRegionKind)
local regionPolicies = require(script.Parent.regionPolicies)
local resolveRegion = require(script.Parent.resolveRegion)

local context = React.createContext(nil)

local function createManager(regionPolicies2)
	local v = {}
	local count = 0

	local function recompute(p)
		local v2 = v[p]
		local v3 = regionPolicies2[p]

		if v2 == nil or v3 == nil then
			return
		end

		local v4 = {}

		for _, v5 in v2 do
			table.insert(v4, v5)
		end

		local region = resolveRegion(v4, v3)

		for k in region.dismissed do
			v2[k].isDismissed = true
		end

		for k, v5 in v2 do
			local state = {
				isVisible = region.visible[k] == true,
				isDismissed = v5.isDismissed
			}

			if not (state.isVisible ~= v5.state.isVisible or state.isDismissed ~= v5.state.isDismissed) then
				continue
			end

			v5.state = state
			v5.onChange(state)
		end
	end

	return {
		register = function(p, id: number, kind, onChange)
			local v2 = v[p] or {}
			v[p] = v2
			v2[id] = {
				id = id,
				kind = kind,
				isOpen = false,
				isMounted = false,
				isDismissed = false,
				onChange = onChange,
				state = { isVisible = false, isDismissed = false }
			}
		end,
		update = function(p, p2: number, data)
			local v2 = v[p]
			local v3

			if v2 then
				v3 = v2[p2]
			end

			if v3 == nil then
				return
			end

			if data.isOpen then
				if not v3.isOpen or v3.claimKey ~= data.claimKey then
					count += 1
					v3.claimedAt = count
				end
			else
				v3.claimedAt = nil
				v3.isDismissed = false
			end

			v3.isOpen = data.isOpen
			v3.isMounted = data.isMounted
			v3.claimKey = data.claimKey
			v3.priority = data.priority
			recompute(p)
		end,
		unregister = function(p, p2: number)
			local v2 = v[p]

			if v2 and v2[p2] then
				v2[p2] = nil
				recompute(p)
			end
		end
	}
end

return {
	ScreenRegionProvider = function(p)
		local v = React.useMemo(function()
			return createManager(regionPolicies)
		end, {})

		return React.createElement(context.Provider, { value = v }, p.children)
	end,
	ScreenRegionContext = context,
	createManager = createManager
}
