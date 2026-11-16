local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)
local MomentsCommon = require(parent.MomentsCommon)

local Reaction = MomentsCommon.Components.Reaction
local ReactionSize = MomentsCommon.Enums.ReactionSize

local reactionExplosionTicker = require(script.Parent.reactionExplosionTicker)
local reactionExplosionMath = require(script.Parent.reactionExplosionMath)

local Medium = ReactionSize.Medium

local color = Color3.new(1, 1, 1)

local memo = React.memo(function(props)
	local v = React.useMemo(function()
		local mapped = props.progress:map(function(p)
			return reactionExplosionMath.solveParticle(p, props.particle)
		end)

		return {
			position = mapped:map(function(p)
				return UDim2.fromOffset(p.x, p.y)
			end),
			rotation = mapped:map(function(p)
				return p.rotation
			end),
			scale = mapped:map(function(p)
				return p.scale
			end),
			imageStyle = mapped:map(function(p)
				return { Color3 = color, Transparency = p.transparency }
			end)
		}
	end, { props.progress, props.particle })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = v.position,
		Rotation = v.rotation,
		Size = UDim2.fromOffset(32, 32)
	}, {
		Glyph = React.createElement(Reaction, {
			reactionType = props.reactionType,
			size = Medium,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			scale = v.scale,
			imageStyle = v.imageStyle
		})
	})
end)

local function ReactionExplosion(props)
	local ticker = props.ticker or reactionExplosionTicker.shared

	local v = React.useMemo(function()
		return props.particleCount
			or math.random(reactionExplosionMath.MIN_PARTICLES, reactionExplosionMath.MAX_PARTICLES)
	end, { props.particleCount })

	local v2 = React.useMemo(function()
		local result = {}

		for i = 1, v do
			local angle = (i - 1) * (6.283185307179586 / v) + (math.random() - 0.5) * reactionExplosionMath.ANGLE_JITTER
			local reach = reactionExplosionMath.MAX_REACH * (reactionExplosionMath.REACH_MIN_FACTOR + math.random() * reactionExplosionMath.REACH_RANGE)
			local v2 = math.random() < 0.5 and -1 or 1
			result[i] = {
				angle = angle,
				reach = reach,
				spin = (reactionExplosionMath.SPIN_MIN + math.random() * reactionExplosionMath.SPIN_RANGE) * v2,
				sizeScale = reactionExplosionMath.SIZE_MIN + math.random() * reactionExplosionMath.SIZE_RANGE
			}
		end

		return result
	end, { v })

	local progress, v3 = React.useBinding(0)

	local ref = React.useRef(props.onComplete)
	ref.current = props.onComplete

	React.useLayoutEffect(function()
		local v4 = nil
		local v5 = false
		local v6 = nil
		v6 = ticker.add(function(p: number)
			if v4 == nil then
				v4 = p
			end

			local v7 = math.clamp((p - v4) / reactionExplosionMath.DURATION, 0, 1)
			v3(v7)

			if v7 >= 1 and not v5 then
				v5 = true
				v6()
				local current = ref.current

				if current ~= nil then
					current()
				end
			end
		end)
		return v6
	end, { ticker })

	local children = {}

	for k, particle in v2 do
		children[`particle_{k}`] = React.createElement(memo, {
			reactionType = props.reactionType,
			progress = progress,
			particle = particle
		})
	end

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = props.position,
			Size = UDim2.fromOffset(0, 0)
		},
		children
	)
end

return React.memo(ReactionExplosion)
