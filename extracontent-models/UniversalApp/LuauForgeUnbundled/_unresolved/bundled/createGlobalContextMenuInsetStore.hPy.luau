local CorePackages = game:GetService("CorePackages")

require(CorePackages.Packages.Signals)
local createSessionScopedSignal = require("@luauforge/bundled/haC").createSessionScopedSignal

local function defaultInset()
	return { left = 0, top = 0, right = 0, bottom = 0 }
end

local function createGlobalContextMenuInsetStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal({
		left = 0,
		top = 0,
		right = 0,
		bottom = 0
	})

	return {
		getGlobalContextMenuInset = sessionScopedSignal,
		setGlobalContextMenuInset = function(p2, p3, p4, p5)
			v5({ left = p2, top = p3, right = p4, bottom = p5 })
		end,
		reset = function()
			v5({ left = 0, top = 0, right = 0, bottom = 0 })
		end
	}
end

return createGlobalContextMenuInsetStore
