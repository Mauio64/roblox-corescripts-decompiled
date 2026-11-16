local Dimensions = {
	getter = function(callback)
		return { type = "getter", callback = callback }
	end,
	consistentSize = function(size: number)
		return { type = "consistentSize", size = size }
	end,
	consistentUDim2 = function(udim: UDim2)
		return { type = "consistentUDim2", udim2 = udim }
	end
}

function Dimensions.withSpacing(inner, spacing: number)
	assert(
		inner.type ~= "getter",
		"withSpacing does not support getter. Instead, include your padding as part of your returned position."
	)

	if inner.type == "spaced" then
		return Dimensions.withSpacing(inner.inner, spacing)
	end

	return { type = "spaced", spacing = spacing, inner = inner }
end

return Dimensions
