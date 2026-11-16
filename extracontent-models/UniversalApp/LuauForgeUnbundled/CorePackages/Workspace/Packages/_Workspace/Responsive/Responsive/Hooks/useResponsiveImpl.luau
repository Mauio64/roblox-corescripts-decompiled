local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Responsive")
local ContainerRef = require("@game/CorePackages/Workspace/Packages/_Workspace/Responsive/Responsive/Context/ContainerRef")

local defineFastFlag = game:DefineFastFlag("LuaAppResponsiveFixHookDeps", false)

function LUAUFORGE_MODULE_GLOBALS_xQ_id(p2)
	return p2
end

function LUAUFORGE_MODULE_GLOBALS_xQ_useResponsiveImpl(value, p2, p3)
	local v5 = if typeof(value) == "function" then value else LUAUFORGE_MODULE_GLOBALS_xQ_id

	local v6 = React.useContext(ContainerRef)
	local state, setState = React.useState(v5(Responsive.DefaultKey))
	local ref = React.useRef("")
	local ref2 = React.useRef({ Key = Responsive.DefaultKey })
	local set

	if typeof(value) == "table" then
		set = {}

		for k, item in value do
			set[item] = true
		end
	else
		set = nil
	end

	local useEffect = React.useEffect
	local function fn()
		if not (v6 and v6.current) then
			return function() end
		end

		local v7 = Responsive.bindContainer(v6.current, p2)
		local connection = v7:connect(function()
			local currentKey = v7:currentKey(p3)

			if set then
				if set[currentKey] or ref.current and set[ref.current] then
					ref2.current = v7:currentRule(p3)
					setState(currentKey)
				end
			else
				ref2.current = v7:currentRule(p3)
				setState(v5(currentKey))
			end

			ref.current = currentKey
		end)

		ref2.current = v7:currentRule(p3)
		local currentKey = v7:currentKey(p3)
		setState(v5(currentKey))
		ref.current = currentKey

		return function()
			connection:disconnect()
			v7:destroy()
		end
	end

	local current = v6 and v6.current or false
	local v8 = if defineFastFlag then p2 else nil
	useEffect(fn, {
		v6,
		current,
		v8,
		if defineFastFlag then p3 else nil
	})

	return state, ref2.current
end

return LUAUFORGE_MODULE_GLOBALS_xQ_useResponsiveImpl
