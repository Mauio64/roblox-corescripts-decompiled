local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Packages = CorePackages.Packages
local React = require(Packages.React)
local LuauPolyfill = require(Packages.LuauPolyfill)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local function isClickOrTap(input): boolean -- 1 equivalent call inferred from this helper
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end

return function(p: number)
	local state, setState = React.useState("")
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState(false)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v = React.useCallback(function()
		if ref2.current then
			clearTimeout(ref2.current)
		end

		if ref.current then
			ref.current:Disconnect()
			ref.current = nil
		end
	end, { ref2, ref })
	local v2 = React.useCallback(function()
		v()
		setState3(true)

		ref2.current = setTimeout(function()
			v()
			setState3(false)
		end, p)

		ref.current = UserInputService.InputBegan:Connect(function(input, _)
			if not isClickOrTap(input) then -- inferred equivalent call
				return
			end

			v()
			setState3(false)
		end)
	end, { ref2, ref })

	React.useEffect(function()
		return v
	end, {})

	return state, state2, state3, (React.useCallback(function(p2: string, p3: string)
		setState(p2)
		setState2(p3)
		v2()
	end, {}))
end
