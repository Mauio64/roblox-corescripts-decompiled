local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)

local function useAnimateFullscreen(b1: boolean, p1: ((...any) -> ...any), p2) -- line: 7
	-- upvalues: React (copy), ReactOtter (copy)
	local v8 = p1 ~= nil
	local v9 = (not b1 or not v8) and 1 or 0
	local v10, v11 = React.useState(v9)
	local v12, v13 = React.useState(false)
	local v14 = React.useCallback(function() -- line: 17
		-- upvalues: v13 (copy)
		v13(false)
	end, {})
	local v15, v16 = ReactOtter.useAnimatedBinding(v9, v14)

	React.useEffect(function() -- line: 23
		-- upvalues: v9 (copy), v10 (copy), v11 (copy), v13 (copy), v16 (copy), ReactOtter (copy), p2 (copy)
		if v9 == v10 then
			return nil
		end

		v11(v9)
		v13(true)
		v16(ReactOtter.spring(v9, p2))

		return nil
	end, {
		v9,
		v10,
		p2
	})

	return (v12 or b1) and v8, v15
end

return useAnimateFullscreen
