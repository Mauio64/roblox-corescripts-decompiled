local module = require("@luauforge/bundled/fCE")

local UserInputService = game:GetService("UserInputService")

local module2 = require("@luauforge/bundled/fFN")

local v5 = { 0, 0.05, 0.1, 0.2, 0.4, 0.8 }

local function useAutoFocusTextField(p2, p3, p4)
	local ref = module.useRef(nil)
	local ref2 = module.useRef(nil)
	local ref3 = module.useRef(nil)
	local ref4 = module.useRef(false)
	local ref5 = module.useRef(false)

	local v6 = module.useCallback(function()
		if module2 and (p4 or UserInputService).PreferredInput == Enum.PreferredInput.Touch then
			return
		end

		local current = ref.current
		local current2 = ref2.current

		if
			ref4.current
			or current == nil
			or current2 == nil
			or current2:FindFirstAncestorWhichIsA("LayerCollector") == nil
		then
			return
		end

		local getIsFocused = current.getIsFocused

		if getIsFocused ~= nil and getIsFocused() then
			return
		end

		current.focus()
	end, { p4 })

	local v7 = module.useCallback(function()
		if not p3 then
			return
		end

		for k, duration in v5 do
			task.delay(duration, v6)
		end
	end, { p3, v6 })

	local v8 = module.useCallback(function()
		if ref5.current or not p3 then
			return
		end

		ref5.current = true
		v7()
	end, { p3, v7 })

	local v9 = module.useCallback(function(current)
		p2.current = current
		ref.current = current

		if current == nil then
			ref5.current = false
		else
			v8()
		end
	end, { p2, v8 })

	local v10 = module.useCallback(function(current)
		if ref3.current ~= nil then
			ref3.current:Disconnect()
			ref3.current = nil
		end

		ref2.current = current

		if current == nil then
			ref5.current = false
			return
		end

		if not p3 then
			return
		end

		ref3.current = current.AncestryChanged:Connect(function()
			v6()
			task.defer(v6)
		end)
		v8()
	end, { p3, v6, v8 })

	module.useEffect(function()
		return function()
			ref4.current = true

			if ref3.current ~= nil then
				ref3.current:Disconnect()
				ref3.current = nil
			end
		end
	end, {})

	return v9, v10, v7
end

return useAutoFocusTextField
