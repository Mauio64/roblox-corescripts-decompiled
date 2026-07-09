local Parent = script:FindFirstAncestor("Responsive").Parent
local React = require(Parent.React)
local Responsive = require(script.Parent.Parent.Responsive)
local ContainerRef = require(script.Parent.Parent.Context.ContainerRef)
local v5 = game:DefineFastFlag("LuaAppResponsiveFixHookDeps", false)

function id(p1) -- line: 9
	return p1
end
function useResponsiveImpl(p2, p3, s1: string?) -- line: 17
	-- upvalues: React (copy), ContainerRef (copy), Responsive (copy), v5 (copy)
	local v10 = if typeof(p2) ~= "function" then id else p2
	local v11 = React.useContext(ContainerRef)
	local v12, v13 = React.useState(v10(Responsive.DefaultKey))
	local v14 = React.useRef("")
	local v15 = React.useRef({
		Key = Responsive.DefaultKey
	})
	local t1 = nil

	if typeof(p2) == "table" then
		t1 = {}

		for _, v18 in p2 do
			t1[v18] = true
		end
	end

	React.useEffect(function() -- line: 34
		-- upvalues: v11 (copy), Responsive (copy), p3 (copy), s1 (copy), t1 (ref), v14 (copy), v15 (copy), v13 (copy), v10 (copy)
		if v11 and v11.current then
			local v19 = Responsive.bindContainer(v11.current, p3)
			local v20 = v19:connect(function() -- line: 37
				-- upvalues: v19 (copy), s1 (copy), t1 (ref), v14 (copy), v15 (copy), v13 (copy), v10 (copy)
				local v22 = v19:currentKey(s1)

				if t1 then
					if t1[v22] or v14.current and t1[v14.current] then
						v15.current = v19:currentRule(s1)
						v13(v22)
					end
				else
					v15.current = v19:currentRule(s1)
					v13(v10(v22))
				end

				v14.current = v22
			end)

			v15.current = v19:currentRule(s1)

			local v21 = v19:currentKey(s1)

			v13(v10(v21))
			v14.current = v21

			return function() -- line: 56
				-- upvalues: v20 (copy), v19 (copy)
				v20:disconnect()
				v19:destroy()
			end
		end

		return function() -- line: 61
		end
	end, {
		v11,
		not not v11 and (v11.current or false),
		if not v5 then nil else p3,
		if not v5 then nil else s1
	})

	return v12, v15.current
end

return useResponsiveImpl
