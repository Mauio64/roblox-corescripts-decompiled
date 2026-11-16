local parent = script:FindFirstAncestor("Responsive").Parent
local React = require(parent.React)
local Responsive = require(script.Parent.Parent.Responsive)
local ContainerRef = require(script.Parent.Parent.Context.ContainerRef)

local defineFastFlag = game:DefineFastFlag("LuaAppResponsiveFixHookDeps", false)

function id(p)
	return p
end

function useResponsiveImpl(value, p, p2: string?)
	local v

	if typeof(value) == "function" then
		v = value
	else
		v = id
	end

	local v2 = React.useContext(ContainerRef)
	local state, setState = React.useState(v(Responsive.DefaultKey))
	local ref = React.useRef("")
	local ref2 = React.useRef({ Key = Responsive.DefaultKey })
	local set

	if typeof(value) == "table" then
		set = {}

		for _, item in value do
			set[item] = true
		end
	else
		set = nil
	end

	local useEffect = React.useEffect
	local function fn()
		if not (v2 and v2.current) then
			return function() end
		end

		local v3 = Responsive.bindContainer(v2.current, p)
		local connection = v3:connect(function()
			local currentKey = v3:currentKey(p2)

			if set then
				if set[currentKey] or ref.current and set[ref.current] then
					ref2.current = v3:currentRule(p2)
					setState(currentKey)
				end
			else
				ref2.current = v3:currentRule(p2)
				setState(v(currentKey))
			end

			ref.current = currentKey
		end)

		ref2.current = v3:currentRule(p2)
		local currentKey = v3:currentKey(p2)
		setState(v(currentKey))
		ref.current = currentKey

		return function()
			connection:disconnect()
			v3:destroy()
		end
	end

	local current = v2 and v2.current or false
	local v3

	if defineFastFlag then
		v3 = p
	end

	local v4

	if defineFastFlag then
		v4 = p2
	end

	useEffect(fn, { v2, current, v3, v4 })

	return state, ref2.current
end

return useResponsiveImpl
