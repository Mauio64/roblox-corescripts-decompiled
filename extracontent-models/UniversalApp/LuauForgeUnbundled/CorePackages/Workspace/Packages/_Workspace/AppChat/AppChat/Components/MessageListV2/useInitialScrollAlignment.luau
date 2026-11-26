local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ViewRecyclerReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ViewRecyclerReact")

local function useInitialScrollAlignment(p2, p3, p4, p5)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	if ref.current == nil and not p3 then
		local v5 = if p2 then ViewRecyclerReact.ScrollAlignment.Start else ViewRecyclerReact.ScrollAlignment.End
		ref.current = v5
	end

	local current = ref.current

	React.useEffect(function()
		if p3 then
			ref2.current = false
			return
		end

		if ref2.current or current ~= ViewRecyclerReact.ScrollAlignment.Start then
			return
		end

		local current2 = p4.current

		if current2 == nil then
			return
		end

		ref2.current = true
		current2.scrollToStart()
	end, { p3, current, p5 })

	return current
end

return useInitialScrollAlignment
