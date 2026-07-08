local Parent = script:FindFirstAncestor("Moments").Parent
local React = require(Parent.React)
local MomentsCommon = require(Parent.MomentsCommon)
local Reaction = MomentsCommon.Components.Reaction
local ReactionSize = MomentsCommon.Enums.ReactionSize
local reactionExplosionTicker = require(script.Parent.reactionExplosionTicker)
local reactionExplosionMath = require(script.Parent.reactionExplosionMath)
local Medium = ReactionSize.Medium
local color3 = Color3.new(1, 1, 1)
local v10 = React.memo(function(t1: {[any]: any}) -- line: 38
	-- upvalues: React (copy), reactionExplosionMath (copy), color3 (copy), Reaction (copy), Medium (copy)
	local v13 = React.useMemo(function() -- line: 41
		-- upvalues: t1 (copy), reactionExplosionMath (copy), color3 (copy)
		local v24 = t1.progress:map(function(p1) -- line: 42
			-- upvalues: reactionExplosionMath (copy), t1 (copy)
			return reactionExplosionMath.solveParticle(p1, t1.particle)
		end)

		return {
			position = v24:map(function(p2) -- line: 46
				return UDim2.fromOffset(p2.x, p2.y)
			end),
			rotation = v24:map(function(p3) -- line: 49
				return p3.rotation
			end),
			scale = v24:map(function(p4) -- line: 52
				return p4.scale
			end),
			imageStyle = v24:map(function(p5) -- line: 55
				-- upvalues: color3 (copy)
				return {
					Color3 = color3,
					Transparency = p5.transparency
				}
			end)
		}
	end, {
		t1.progress,
		t1.particle
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = v13.position,
		Rotation = v13.rotation,
		Size = UDim2.fromOffset(32, 32)
	}, {
		Glyph = React.createElement(Reaction, {
			reactionType = t1.reactionType,
			size = Medium,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			scale = v13.scale,
			imageStyle = v13.imageStyle
		})
	})
end)

local function ReactionExplosion(t2: {[any]: any}) -- line: 93
	-- upvalues: reactionExplosionTicker (copy), React (copy), reactionExplosionMath (copy), v10 (copy)
	local v15 = t2.ticker or reactionExplosionTicker.shared
	local v16 = React.useMemo(function() -- line: 96
		-- upvalues: t2 (copy), reactionExplosionMath (copy)
		return t2.particleCount or math.random(reactionExplosionMath.MIN_PARTICLES, reactionExplosionMath.MAX_PARTICLES)
	end, { t2.particleCount })
	local v17 = React.useMemo(function() -- line: 102
		-- upvalues: v16 (copy), reactionExplosionMath (copy)
		local t3 = {}

		for i = 1, v16 do
			local v27 = (i - 1) * (6.283185307179586 / v16) + (math.random() - 0.5) * reactionExplosionMath.ANGLE_JITTER
			local v28 = reactionExplosionMath.MAX_REACH * (reactionExplosionMath.REACH_MIN_FACTOR + math.random() * reactionExplosionMath.REACH_RANGE)
			local v29 = not (math.random() < 0.5) and 1 or -1
			local v30 = (reactionExplosionMath.SPIN_MIN + math.random() * reactionExplosionMath.SPIN_RANGE) * v29
			local v31 = reactionExplosionMath.SIZE_MIN + math.random() * reactionExplosionMath.SIZE_RANGE

			t3[i] = {
				angle = v27,
				reach = v28,
				spin = v30,
				sizeScale = v31
			}
		end

		return t3
	end, { v16 })
	local v18, v19 = React.useBinding(0)
	local v20 = React.useRef(t2.onComplete)

	v20.current = t2.onComplete
	React.useLayoutEffect(function() -- line: 122
		-- upvalues: v15 (copy), reactionExplosionMath (copy), v19 (copy), v20 (copy)
		local u32 = nil
		local u33 = false
		local u34 = nil

		u34 = v15.add(function(n1: number) -- line: 128
			-- upvalues: u32 (ref), reactionExplosionMath (copy), v19 (copy), u33 (ref), u34 (ref), v20 (copy)
			if u32 == nil then
				u32 = n1
			end

			local v41 = math.clamp((n1 - u32) / reactionExplosionMath.DURATION, 0, 1)

			v19(v41)

			if v41 >= 1 and not u33 then
				u33 = true
				u34()

				local current = v20.current

				if current ~= nil then
					current()
				end
			end
		end)

		return u34
	end, { v15 })

	local t4 = {}

	for v22, v23 in v17 do
		t4[`particle_{ v22 }`] = React.createElement(v10, {
			reactionType = t2.reactionType,
			progress = v18,
			particle = v23
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = t2.position,
		Size = UDim2.fromOffset(0, 0)
	}, t4)
end

return React.memo(ReactionExplosion)
