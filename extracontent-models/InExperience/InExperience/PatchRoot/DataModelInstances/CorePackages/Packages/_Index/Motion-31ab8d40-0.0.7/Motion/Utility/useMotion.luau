local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local React = require(scriptParentParentParent.React)
local useAnimatedValue = require(scriptParent.useAnimatedValue)

require(scriptParentParent.Types)

local TimingConfigs = require(scriptParent.TimingConfigs)
local TransitionPreset = require(scriptParentParent.Enums.TransitionPreset)

local function useMotion(p1) -- line: 20
	-- upvalues: React (copy), useAnimatedValue (copy), TransitionPreset (copy), TimingConfigs (copy)
	local t1 = {}
	local t2 = {}
	local v12 = React.useRef({})

	for v13, v14 in p1 do
		if type(v14) ~= "table" or v13 ~= "transition" then
			local v15, v16 = useAnimatedValue(v14)

			t1[v13] = v15
			t2[v13] = v16
		end
	end

	local function animate(p2, t3: {[any]: any}?) -- line: 40
		-- upvalues: t2 (copy), v12 (copy), TransitionPreset (copy), TimingConfigs (copy)
		if not p2 then
			return
		end

		local n1 = 0
		local t4 = {}

		for v22 in t2 do
			if v22 ~= "transition" and p2[v22] ~= nil then
				n1 += 1
			end
		end

		local n2 = 0

		local function propertyOnComplete(s1: string) -- line: 57
			-- upvalues: t4 (copy), p2 (copy), n2 (ref), t3 (copy), n1 (ref)
			t4[s1] = p2[s1]
			n2 += 1

			if t3 and t3.onAnimationComplete then
				t3.onAnimationComplete(s1)
			end

			if n2 == n1 and t3 and t3.onAnimationComplete then
				t3.onAnimationComplete(true)
			end
		end

		for v25, v26 in t2 do
			if v25 ~= "transition" and p2[v25] ~= nil then
				if v12.current[v25] then
					local v27 = v12.current[v25]

					if v27 then
						task.cancel(v27)
					end

					v12.current[v25] = nil
				end

				local v28 = p2.transition or {
					[TransitionPreset.Default] = TimingConfigs.getDefaultTransition()
				}
				local v29 = v28[v25] or (v28[TransitionPreset.Default] or TimingConfigs.getDefaultTransition())
				local v30 = table.clone(v29)

				function v30.onComplete() -- line: 94
					-- upvalues: v25 (copy), t4 (copy), p2 (copy), n2 (ref), t3 (copy), n1 (ref)
					local v34 = v25

					t4[v34] = p2[v34]
					n2 += 1

					if t3 and t3.onAnimationComplete then
						t3.onAnimationComplete(v34)
					end

					if n2 == n1 and t3 and t3.onAnimationComplete then
						t3.onAnimationComplete(true)
					end
				end

				local v31 = v30.delay or 0

				if v31 > 0 then
					local thread = task.delay(v31, function() -- line: 103
						-- upvalues: v12 (copy), v25 (copy), v26 (copy), p2 (copy), v30 (copy)
						v12.current[v25] = nil
						v26(p2[v25], v30)
					end)

					v12.current[v25] = thread
				else
					v26(p2[v25], v30)
				end
			end
		end
	end

	return t1, animate
end

return useMotion
