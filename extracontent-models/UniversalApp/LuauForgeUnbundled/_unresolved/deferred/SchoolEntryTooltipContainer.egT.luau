local module = require("@luauforge/deferred/egU")
local useNavigationFocus = require("@luauforge/deferred/egV").useNavigationFocus

require("@luauforge/deferred/egW")
local module2 = require("@luauforge/deferred/egY")
local module3 = require("@luauforge/deferred/eht")
local module4 = require("@luauforge/deferred/ehu")

local defineFastInt = game:DefineFastInt("SchoolEntryTooltipDurationSeconds", 3)

local function SchoolEntryTooltipContainer(props)
	module3()
	local v5 = useNavigationFocus()
	local v6, v7 = module2()
	local v8 = props.occludingOverlayType ~= nil

	if not v5 then
		v6 = nil
	end

	local v9 = v6 == nil or v8

	module.useImperativeHandle(props.dismissTooltipRef, function()
		return v7
	end, { v7 })

	module.useEffect(function()
		if v9 then
			return
		end

		local thread = task.delay(defineFastInt, v7)
		return function()
			task.cancel(thread)
		end
	end, { v6, v7, v9 })

	if v9 then
		return nil
	end

	return module.createElement(module4, { variant = v6, anchorRef = props.anchorRef })
end

return SchoolEntryTooltipContainer
