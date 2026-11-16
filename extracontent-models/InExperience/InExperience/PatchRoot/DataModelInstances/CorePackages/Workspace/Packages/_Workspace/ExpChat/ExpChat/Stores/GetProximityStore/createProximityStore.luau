local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createProximityStore()
	local v = {}

	local v2 = { isInsideRenderDistance = false, isInsideMaximizeDistance = false }

	local function getKey(p) -- 3 equivalent calls inferred from this helper
		return (tostring(p))
	end

	local function getUserProximityState(p) -- 1 equivalent call inferred from this helper
		local key = getKey(p) -- inferred equivalent call

		if not v[key] then
			local signal, setter = createSignal(v2)
			v[key] = { getter = signal, setter = setter }
		end

		return v[key].getter
	end

	return {
		getUserProximityState = getUserProximityState,
		updateProximity = function(p, isInsideRenderDistance: boolean, isInsideMaximizeDistance: boolean)
			local key = getKey(p) -- inferred equivalent call

			if not v[key] then
				local _userProximityState = getUserProximityState(p) -- inferred equivalent call
			end

			v[key].setter({
				isInsideRenderDistance = isInsideRenderDistance,
				isInsideMaximizeDistance = isInsideMaximizeDistance
			})
		end,
		removeUser = function(p)
			local key = getKey(p) -- inferred equivalent call

			if v[key] then
				v[key].setter(v2)
				v[key] = nil
			end
		end
	}
end

return createProximityStore
