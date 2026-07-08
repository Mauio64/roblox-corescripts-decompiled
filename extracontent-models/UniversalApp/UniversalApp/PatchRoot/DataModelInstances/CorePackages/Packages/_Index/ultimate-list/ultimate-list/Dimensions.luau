local t1 = {
	getter = function(p1: ((...any) -> ...any)) -- line: 27
		return {
			type = "getter",
			callback = p1
		}
	end,
	consistentSize = function(n1: number) -- line: 34
		return {
			type = "consistentSize",
			size = n1
		}
	end,
	consistentUDim2 = function(uDim2: UDim2) -- line: 41
		return {
			type = "consistentUDim2",
			udim2 = uDim2
		}
	end
}

function t1.withSpacing(t2: {[any]: any}, n2: number) -- line: 48
	-- upvalues: t1 (copy)
	assert(t2.type ~= "getter", "withSpacing does not support getter. Instead, include your padding as part of your returned position.")

	if t2.type == "spaced" then
		return t1.withSpacing(t2.inner, n2)
	end

	return {
		type = "spaced",
		spacing = n2,
		inner = t2
	}
end

return t1
