local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local ViewRecycler = require(parent.ViewRecycler)

local function useInitialScrollAlignment(flag: boolean, flag2: boolean, p, p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	if ref.current == nil and not flag2 then
		local current

		if flag then
			current = ViewRecycler.ScrollAlignment.Start
		else
			current = ViewRecycler.ScrollAlignment.End
		end

		ref.current = current
	end

	local current = ref.current

	React.useEffect(function()
		if flag2 then
			ref2.current = false
			return
		end

		if ref2.current or current ~= ViewRecycler.ScrollAlignment.Start then
			return
		end

		local current2 = p.current

		if current2 == nil then
			return
		end

		ref2.current = true
		current2.scrollToStart()
	end, { flag2, current, p2 })

	return current
end

return useInitialScrollAlignment
