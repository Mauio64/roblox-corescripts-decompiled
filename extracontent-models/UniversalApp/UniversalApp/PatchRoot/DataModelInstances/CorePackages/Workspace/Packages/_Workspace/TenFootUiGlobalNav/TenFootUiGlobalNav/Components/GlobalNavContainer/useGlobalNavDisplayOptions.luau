local Parent = script:FindFirstAncestor("TenFootUiGlobalNav").Parent
local React = require(Parent.React)
local GlobalNavDisplayOption = require(Parent.TenFootUiCommon).TenFootUiRNTypes.GlobalNavDisplayOption

local function useGlobalNavDisplayOptions(p1, p2) -- line: 9
	-- upvalues: React (copy), GlobalNavDisplayOption (copy)
	local v7, v8 = React.useState(GlobalNavDisplayOption.ShowAll)

	React.useEffect(function() -- line: 13
		-- upvalues: p2 (copy), p1 (copy), v8 (copy), GlobalNavDisplayOption (copy)
		local v9 = p2(p1)

		if v9 and v9.globalNavDisplayOption then
			v8(v9.globalNavDisplayOption)

			return
		end

		v8(GlobalNavDisplayOption.ShowAll)
	end, {
		p1,
		p2
	})

	return v7
end

return useGlobalNavDisplayOptions
