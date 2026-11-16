local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local ReactOtter = require(parent2.ReactOtter)

require(parent.Types)

local function validateNumber(value, value2: number?) -- 23 equivalent calls inferred from this helper
	if type(value) == "number" then
		return value
	end

	return value2 or 0
end

local function useAnimatedValue(value)
	local ref = React.useRef(nil)

	local v = React.useCallback(function(...)
		if ref.current ~= nil then
			if type(ref.current) == "function" then
				ref.current(...)
			elseif ref.current._isMockFunction then
				ref.current(...)
			end
		end
	end, { ref })

	if typeof(value) == "UDim" then
		local v2, v3 = ReactOtter.useAnimatedBinding(
			{ scale = validateNumber(value.Scale), offset = validateNumber(value.Offset) }, -- inferred equivalent call
			v
		)

		return v2:map(function(p)
			return UDim.new(p.scale, p.offset)
		end), function(p, data)
			if not p then
				return
			end

			if typeof(p) ~= "UDim" then
				warn("Expected UDim target but got", (typeof(p)))
				return
			end

			local current

			if data then
				current = data.onComplete or nil
			end

			ref.current = current

			local v4 = data and {
				duration = data.duration or 0.3,
				easingStyle = data.easingStyle
			} or nil

			v3({
				scale = ReactOtter.ease(validateNumber(p.Scale), v4), -- inferred equivalent call
				offset = ReactOtter.ease(validateNumber(p.Offset), v4) -- inferred equivalent call
			})
		end
	elseif typeof(value) == "UDim2" then
		local v2, v3 = ReactOtter.useAnimatedBinding(
			{
				xScale = validateNumber(value.X.Scale), -- inferred equivalent call
				xOffset = validateNumber(value.X.Offset), -- inferred equivalent call
				yScale = validateNumber(value.Y.Scale), -- inferred equivalent call
				yOffset = validateNumber(value.Y.Offset) -- inferred equivalent call
			},
			v
		)

		return v2:map(function(data)
			return UDim2.new(data.xScale, data.xOffset, data.yScale, data.yOffset)
		end), function(p, data)
			if not p then
				return
			end

			if typeof(p) ~= "UDim2" then
				warn("Expected UDim2 target but got", (typeof(p)))
				return
			end

			local current

			if data then
				current = data.onComplete or nil
			end

			ref.current = current

			local v4 = data and {
				duration = data.duration or 0.3,
				easingStyle = data.easingStyle
			} or nil

			v3({
				xScale = ReactOtter.ease(validateNumber(p.X.Scale), v4), -- inferred equivalent call
				xOffset = ReactOtter.ease(validateNumber(p.X.Offset), v4), -- inferred equivalent call
				yScale = ReactOtter.ease(validateNumber(p.Y.Scale), v4), -- inferred equivalent call
				yOffset = ReactOtter.ease(validateNumber(p.Y.Offset), v4) -- inferred equivalent call
			})
		end
	elseif typeof(value) == "Vector2" then
		local v2, v3 = ReactOtter.useAnimatedBinding({
			x = validateNumber(value.X), -- inferred equivalent call
			y = validateNumber(value.Y) -- inferred equivalent call
		}, v)

		return v2:map(function(p)
			return Vector2.new(p.x, p.y)
		end), function(p, data)
			if not p then
				return
			end

			if typeof(p) ~= "Vector2" then
				warn("Expected Vector2 target but got", (typeof(p)))
				return
			end

			local current

			if data then
				current = data.onComplete or nil
			end

			ref.current = current

			local v4 = data and {
				duration = data.duration or 0.3,
				easingStyle = data.easingStyle
			} or nil

			v3({
				x = ReactOtter.ease(validateNumber(p.X), v4), -- inferred equivalent call
				y = ReactOtter.ease(validateNumber(p.Y), v4) -- inferred equivalent call
			})
		end
	elseif typeof(value) == "Color3" then
		local v2, v3 = ReactOtter.useAnimatedBinding(
			{
				r = validateNumber(value.R), -- inferred equivalent call
				g = validateNumber(value.G), -- inferred equivalent call
				b = validateNumber(value.B) -- inferred equivalent call
			},
			v
		)

		return v2:map(function(data)
			return Color3.new(data.r, data.g, data.b)
		end), function(data, data2)
			if not data then
				return
			end

			if typeof(data) ~= "Color3" then
				warn("Expected Color3 target but got", (typeof(data)))
				return
			end

			local current

			if data2 then
				current = data2.onComplete or nil
			end

			ref.current = current

			local v4 = data2 and {
				duration = data2.duration or 0.3,
				easingStyle = data2.easingStyle
			} or nil

			v3({
				r = ReactOtter.ease(validateNumber(data.R), v4), -- inferred equivalent call
				g = ReactOtter.ease(validateNumber(data.G), v4), -- inferred equivalent call
				b = ReactOtter.ease(validateNumber(data.B), v4) -- inferred equivalent call
			})
		end
	elseif typeof(value) == "number" then
		local v2, v3 = ReactOtter.useAnimatedBinding(validateNumber(value), v) -- inferred equivalent call

		return v2:map(function(p: number)
			return p
		end), function(value2, data)
			if typeof(value2) ~= "number" then
				return
			end

			local current

			if data then
				current = data.onComplete or nil
			end

			ref.current = current

			local v4 = data and {
				duration = data.duration or 0.3,
				easingStyle = data.easingStyle
			} or nil

			v3(ReactOtter.ease(value2, v4))
		end
	else
		warn("Unsupported type for animated value:", (typeof(value)))
		return React.createBinding(value), function() end
	end
end

return useAnimatedValue
