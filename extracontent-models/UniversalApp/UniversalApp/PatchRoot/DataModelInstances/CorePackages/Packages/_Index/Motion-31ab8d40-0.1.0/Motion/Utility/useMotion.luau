local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent
local React = require(parent3.React)
local useAnimatedValue = require(parent.useAnimatedValue)
require(parent2.Types)
local TimingConfigs = require(parent.TimingConfigs)
local TransitionPreset = require(parent2.Enums.TransitionPreset)

local function useMotion(items)
	local ref = React.useRef({})
	local result = {}
	local v = {}

	for k, item in items do
		if not (type(item) ~= "table" or k ~= "transition") then
			continue
		end

		local v2, v3 = useAnimatedValue(item)
		result[k] = v2
		v[k] = v3
	end

	local function animate(p, p2)
		if not p then
			return
		end

		local count = 0
		local v2 = {}

		for k in v do
			if k ~= "transition" and p[k] ~= nil then
				count += 1
			end
		end

		local count2 = 0

		local function propertyOnComplete(k: string) -- 1 equivalent call inferred from this helper
			v2[k] = p[k]
			count2 += 1

			if p2 and p2.onAnimationComplete then
				p2.onAnimationComplete(k)
			end

			if count2 == count and p2 and p2.onAnimationComplete then
				p2.onAnimationComplete(true)
			end
		end

		for k, v3 in v do
			if not (k ~= "transition" and p[k] ~= nil) then
				continue
			end

			if ref.current[k] then
				local v4 = ref.current[k]

				if v4 then
					task.cancel(v4)
				end

				ref.current[k] = nil
			end

			local v4 = p.transition

			if not v4 then
				v4 = {}
				v4[TransitionPreset.Default] = TimingConfigs.getDefaultTransition()
			end

			local v5 = v4[k] or v4[TransitionPreset.Default] or TimingConfigs.getDefaultTransition()

			local clone = table.clone(v5)

			function clone.onComplete()
				propertyOnComplete(k) -- inferred equivalent call
			end

			local delay = clone.delay or 0

			if delay > 0 then
				local thread = task.delay(delay, function()
					ref.current[k] = nil

					v3(p[k], clone)
				end)

				ref.current[k] = thread
			else
				v3(p[k], clone)
			end
		end
	end

	return result, animate
end

return useMotion
