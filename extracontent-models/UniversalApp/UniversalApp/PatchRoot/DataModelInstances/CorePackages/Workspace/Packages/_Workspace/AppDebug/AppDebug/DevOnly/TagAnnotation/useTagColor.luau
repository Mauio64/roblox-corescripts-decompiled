local Parent = script:FindFirstAncestor("AppDebug").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local useTokens = Foundation.Hooks.useTokens

local function hashTestId(s1: string) -- line: 25
	local n1 = 0

	for i = 1, #s1 do
		n1 = (n1 * 31 + string.byte(s1, i)) % 10000
	end

	return n1
end
local function useTagColor(s2: string) -- line: 33
	-- upvalues: useTokens (copy), React (copy)
	local v11 = useTokens()

	return (React.useMemo(function() -- line: 35
		-- upvalues: v11 (copy), s2 (copy)
		local Extended = v11.Color.Extended
		local t1 = {
			Extended.Red.Red_600,
			Extended.Orange.Orange_600,
			Extended.Yellow.Yellow_400,
			Extended.Green.Green_500,
			Extended.Turquoise.Turquoise_500,
			Extended.Blue.Blue_600,
			Extended.Purple.Purple_600,
			Extended.Pink.Pink_600,
			Extended.Magenta.Magenta_600
		}
		local v14 = s2
		local n2 = 0

		for i = 1, #v14 do
			n2 = (n2 * 31 + string.byte(v14, i)) % 10000
		end

		return t1[n2 % #t1 + 1]
	end, {
		v11,
		s2
	}))
end

return useTagColor
