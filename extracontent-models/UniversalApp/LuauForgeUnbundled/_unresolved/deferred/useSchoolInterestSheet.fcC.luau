local module = require("@luauforge/deferred/eko")

local module2 = require("@luauforge/deferred/fcD")
require("@luauforge/deferred/fcA")

local function trim(value)
	return string.match(value, "^%s*(.-)%s*$") or ""
end

local function useSchoolInterestSheet(p2, onClose)
	local state, setState = module.useState("")
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState(false)
	local ref = module.useRef(0)

	module.useLayoutEffect(function()
		if p2 then
			ref.current += 1
			setState("")
			setState2(false)
			setState3(false)
		end
	end, { p2 })

	return {
		isOpen = p2,
		schoolName = state,
		onSchoolNameChanged = module.useCallback(function(p3)
			setState(p3)
			setState2(false)
		end, {}),
		hasError = state2,
		isSubmitting = state3,
		onSend = module.useCallback(function()
			local v6 = string.match(state, "^%s*(.-)%s*$") or ""

			if state3 or v6 == "" then
				return
			end

			setState2(false)
			setState3(true)

			local current = ref.current
			local function isCurrent(): boolean
				return ref.current == current
			end

			module2(v6):andThen(function()
				if ref.current == current then
					onClose()
				end
			end):catch(function()
				if ref.current == current then
					setState2(true)
					setState3(false)
				end
			end)
		end, { state, state3, onClose }),
		onClose = onClose
	}
end

return useSchoolInterestSheet
