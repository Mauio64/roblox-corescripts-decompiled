local UserInputService = game:GetService("UserInputService")
local t1 = {
	_initialized = false,
	_isKeyboardJustOff = false,
	getInstance = function(p1) -- line: 8
		if not p1._initialized then
			p1:initialize()
			p1._initialized = true
		end

		return p1
	end,
	initialize = function(p2) -- line: 16
		-- upvalues: UserInputService (copy)
		p2._isKeyboardJustOff = false
		UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 18
			-- upvalues: UserInputService (copy), p2 (copy)
			if not UserInputService.OnScreenKeyboardVisible then
				p2._isKeyboardJustOff = true
			end
		end)
		UserInputService.InputEnded:Connect(function(_) -- line: 23
			-- upvalues: p2 (copy)
			if p2._isKeyboardJustOff then
				p2._isKeyboardJustOff = false
			end
		end)
	end,
	isKeyboardJustOff = function(p4) -- line: 35
		return p4._isKeyboardJustOff
	end
}

return {
	getInstance = function() -- line: 40
		-- upvalues: t1 (copy)
		return t1:getInstance()
	end
}
