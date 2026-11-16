local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function findFirstChildByNameAndClass(instance, p: string, className: string)
	if not instance then
		return nil
	end

	for _, child in ipairs(instance:GetChildren()) do
		if child.Name == p and child:IsA(className) then
			return child
		end
	end

	return nil
end

local function createAdorneeStore()
	local v = {}

	local function getKey(p) -- 4 equivalent calls inferred from this helper
		return (tostring(p))
	end

	local function getAdornee(p) -- 1 equivalent call inferred from this helper
		local key = getKey(p) -- inferred equivalent call

		if not v[key] then
			local signal, setter = createSignal(nil)
			v[key] = { getter = signal, setter = setter }
		end

		return v[key].getter
	end

	return {
		getAdornee = getAdornee,
		handleAdorneeAdded = function(p, p2, p3)
			local key = getKey(p) -- inferred equivalent call
			local v2 = findFirstChildByNameAndClass(p2, "Head", "BasePart")

			if p3.Health ~= 0 then
				v2 = p2
			end

			if not v[key] then
				local _adornee = getAdornee(p) -- inferred equivalent call
			end

			v[key].setter(v2)
		end,
		handleHumanoidDied = function(p)
			local key = getKey(p) -- inferred equivalent call

			if v[key] then
				local getter = v[key].getter(false)
				local v2

				if getter then
					v2 = findFirstChildByNameAndClass(getter, "Head", "BasePart") or getter
				end

				v[key].setter(v2)
			end
		end,
		handlePlayerRemoved = function(p)
			local key = getKey(p) -- inferred equivalent call

			if v[key] then
				v[key].setter(nil)
			end

			v[key] = nil
		end
	}
end

return createAdorneeStore
