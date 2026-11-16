local module = require("@luauforge/bundled/fCE")

local function assignRef(callback, current)
	if type(callback) == "function" then
		callback(current)
	elseif type(callback) == "table" then
		callback.current = current
	end
end

local function useSubmitOnKeyboardReturn(current, p2, p3)
	local ref = module.useRef(current)
	ref.current = current

	local ref2 = module.useRef(false)
	local ref3 = module.useRef({})

	local v5 = module.useCallback(function()
		for k, connection in ref3.current do
			connection:Disconnect()
		end

		ref3.current = {}
	end, {})

	local v6 = module.useCallback(function()
		if ref2.current then
			return
		end

		ref2.current = true
		ref.current()
	end, {})

	local v7 = module.useCallback(function(current2)
		local v8 = p3

		if type(v8) == "function" then
			v8(current2)
		elseif type(v8) == "table" then
			v8.current = current2
		end

		v5()
		ref2.current = false

		if current2 == nil or not p2 then
			return
		end

		local textBox = current2:FindFirstChildWhichIsA("TextBox", true)

		if textBox == nil then
			return
		end

		ref3.current = {
			textBox.ReturnPressedFromOnScreenKeyboard:Connect(v6),
			textBox.Focused:Connect(function()
				ref2.current = false
			end)
		}
	end, { p3, p2, v6, v5 })

	module.useEffect(function()
		return v5
	end, { v5 })

	if p2 then
		return v7, v6
	end

	return v7, nil
end

return useSubmitOnKeyboardReturn
