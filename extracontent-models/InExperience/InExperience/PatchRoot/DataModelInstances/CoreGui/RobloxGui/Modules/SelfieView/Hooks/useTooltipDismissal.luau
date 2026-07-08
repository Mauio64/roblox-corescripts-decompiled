local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Packages = CorePackages.Packages
local React = require(Packages.React)
local LuauPolyfill = require(Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local function isClickOrTap(p1) -- line: 12
	return p1.UserInputType == Enum.UserInputType.MouseButton1 or p1.UserInputType == Enum.UserInputType.Touch
end

return function(n1: number) -- line: 17
	-- upvalues: React (copy), clearTimeout (copy), setTimeout (copy), UserInputService (copy)
	local v11, v12 = React.useState("")
	local v13, v14 = React.useState("")
	local v15, v16 = React.useState(false)
	local v17 = React.useRef(nil)
	local v18 = React.useRef(nil)
	local v19 = React.useCallback(function() -- line: 23
		-- upvalues: v18 (copy), clearTimeout (copy), v17 (copy)
		if v18.current then
			clearTimeout(v18.current)
		end

		if v17.current then
			v17.current:Disconnect()
			v17.current = nil
		end
	end, {
		v18,
		v17
	})
	local v20 = React.useCallback(function() -- line: 32
		-- upvalues: v19 (copy), v16 (copy), v18 (copy), setTimeout (copy), n1 (copy), v17 (copy), UserInputService (copy)
		v19()
		v16(true)
		v18.current = setTimeout(function() -- line: 39
			-- upvalues: v19 (copy), v16 (copy)
			v19()
			v16(false)
		end, n1)
		v17.current = UserInputService.InputBegan:Connect(function(input, _) -- line: 44
			-- upvalues: v19 (copy), v16 (copy)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			v19()
			v16(false)
		end)
	end, {
		v18,
		v17
	})

	React.useEffect(function() -- line: 54
		-- upvalues: v19 (copy)
		return v19
	end, {})

	return v11, v13, v15, (React.useCallback(function(s1: string, s2: string) -- line: 58
		-- upvalues: v12 (copy), v14 (copy), v20 (copy)
		v12(s1)
		v14(s2)
		v20()
	end, {}))
end
