local parent = script:FindFirstAncestor("Moments").Parent

local AppNavBar = require(parent.AppNavBar)

local function createNavBarChromeAdapter(options)
	local v = options or {}

	local visibilityControl = v.visibilityControl or AppNavBar.VisibilityControl
	local isEnabled = (v.isScrollAwayEnabled or AppNavBar.getScrollAwayEnabled)()

	return {
		isEnabled = isEnabled,
		setVisible = function(flag: boolean)
			if not isEnabled then
				return
			end

			if flag then
				visibilityControl.show()
			else
				visibilityControl.hide()
			end
		end,
		dispose = function()
			if not isEnabled then
				return
			end

			visibilityControl.show()
		end
	}
end

return createNavBarChromeAdapter
