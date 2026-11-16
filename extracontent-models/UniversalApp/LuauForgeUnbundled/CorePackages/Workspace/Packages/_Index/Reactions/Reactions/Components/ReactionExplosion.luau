local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Reactions/React")

local Reaction = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Components/Reaction")
local ReactionSize = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionSize")
require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Enums/ReactionType")
local reactionExplosionTicker = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/reactionExplosionTicker")
local reactionExplosionMath = require("@game/CorePackages/Workspace/Packages/_Index/Reactions/Reactions/Utils/reactionExplosionMath")

local medium = ReactionSize.Medium

local color = Color3.new(1, 1, 1)

local memo = React.memo(function(props)
	local v5 = React.useMemo(function()
		local mapped = props.progress:map(function(p2)
			return reactionExplosionMath.solveParticle(p2, props.particle)
		end)

		return {
			position = mapped:map(function(p2)
				return UDim2.fromOffset(p2.x, p2.y)
			end),
			rotation = mapped:map(function(p2)
				return p2.rotation
			end),
			scale = mapped:map(function(p2)
				return p2.scale
			end),
			imageStyle = mapped:map(function(p2)
				return { Color3 = color, Transparency = p2.transparency }
			end)
		}
	end, { props.progress, props.particle })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = v5.position,
		Rotation = v5.rotation,
		Size = UDim2.fromOffset(32, 32)
	}, {
		Glyph = React.createElement(Reaction, {
			reactionType = props.reactionType,
			size = medium,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			scale = v5.scale,
			imageStyle = v5.imageStyle
		})
	})
end)

local function ReactionExplosion(props)
	local ticker = props.ticker or reactionExplosionTicker.shared

	local v5 = React.useMemo(function()
		return props.particleCount or math.random(reactionExplosionMath.MIN_PARTICLES, reactionExplosionMath.MAX_PARTICLES)
	end, { props.particleCount })

	local v6 = React.useMemo(function()
		local result = {}

		for i = 1, v5 do
			local v7 = (i - 1) * (6.283185307179586 / v5) + (math.random() - 0.5) * reactionExplosionMath.ANGLE_JITTER
			local v8 = reactionExplosionMath.MAX_REACH * (reactionExplosionMath.REACH_MIN_FACTOR + math.random() * reactionExplosionMath.REACH_RANGE)
			local v9 = math.random() < 0.5 and -1 or 1
			result[i] = {
				angle = v7,
				reach = v8,
				spin = (reactionExplosionMath.SPIN_MIN + math.random() * reactionExplosionMath.SPIN_RANGE) * v9,
				sizeScale = reactionExplosionMath.SIZE_MIN + math.random() * reactionExplosionMath.SIZE_RANGE
			}
		end

		return result
	end, { v5 })

	local v7, v8 = React.useBinding(0)

	local ref = React.useRef(props.onComplete)
	ref.current = props.onComplete

	React.useLayoutEffect(function()
		local v9 = nil
		local v10 = false
		local v11 = nil
		v11 = ticker.add(function(p2)
			if v9 == nil then
				v9 = p2
			end

			local v12 = math.clamp((p2 - v9) / reactionExplosionMath.DURATION, 0, 1)
			v8(v12)

			if v12 >= 1 and not v10 then
				v10 = true
				v11()
				local current = ref.current

				if current ~= nil then
					current()
				end
			end
		end)
		return v11
	end, { ticker })

	local children = {}

	for k, v9 in v6 do
		children[`particle_{k}`] = React.createElement(memo, {
			reactionType = props.reactionType,
			progress = v7,
			particle = v9
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
