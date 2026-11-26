local module = require("@luauforge/deferred/gzS")

local module2 = require("@luauforge/deferred/gzT")
local progress = module2.Progress
local progressShape = module2.Enums.ProgressShape

local usePageNavigation = require("@luauforge/deferred/gzY").usePageNavigation

local function HeaderProgressBar()
	local progress2 = usePageNavigation().getProgress()

	return progress2 > 0
		and module.createElement(progress, {
			value = progress2,
			shape = progressShape.Bar,
			testId = "header-progress-bar"
		})
		or nil
end

return module.memo(HeaderProgressBar)
