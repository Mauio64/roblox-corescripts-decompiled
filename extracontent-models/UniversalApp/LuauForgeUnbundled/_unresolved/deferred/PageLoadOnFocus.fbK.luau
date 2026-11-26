local module = require("@luauforge/deferred/eko")
local useEventCallback = require("@luauforge/deferred/fbL").useEventCallback
local useNavigationFocus = require("@luauforge/deferred/ekp").useNavigationFocus

require("@luauforge/deferred/fby")
require("@luauforge/deferred/fbz")
local module2 = require("@luauforge/deferred/fbH")

local function PageLoadOnFocus(data): nil
	local eventName = data.eventName
	local fields = data.fields
	local isReady = data.isReady ~= false

	local v5 = useNavigationFocus()
	local v6 = module2()

	local v7 = useEventCallback(function()
		v6(eventName, fields)
	end)

	local ref = module.useRef(false)

	module.useEffect(function(): nil
		if not v5 then
			ref.current = false
			return nil
		end

		if isReady and not ref.current then
			ref.current = true
			v7()
		end

		return nil
	end, { v5, isReady, v7 })

	return nil
end

return PageLoadOnFocus
