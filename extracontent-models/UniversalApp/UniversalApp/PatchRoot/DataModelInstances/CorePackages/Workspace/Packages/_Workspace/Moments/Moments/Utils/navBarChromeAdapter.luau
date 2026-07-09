local Parent = script:FindFirstAncestor("Moments").Parent
local AppNavBar = require(Parent.AppNavBar)

local function createNavBarChromeAdapter(t1: {[any]: any}?) -- line: 50
	-- upvalues: AppNavBar (copy)
	local v5 = t1 or {}
	local v6 = v5.visibilityControl or AppNavBar.VisibilityControl
	local v7 = (v5.isScrollAwayEnabled or AppNavBar.getScrollAwayEnabled)()

	return {
		isEnabled = v7,
		setVisible = function(b1: boolean) -- line: 61
			-- upvalues: v7 (copy), v6 (copy)
			if not v7 then
				return
			end

			if b1 then
				v6.show()

				return
			end

			v6.hide()
		end,
		dispose = function() -- line: 72
			-- upvalues: v7 (copy), v6 (copy)
			if not v7 then
				return
			end

			v6.show()
		end
	}
end

return createNavBarChromeAdapter
