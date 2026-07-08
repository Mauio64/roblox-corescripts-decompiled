local UserInputService = game:GetService("UserInputService")
local t1 = {
	getInstance = function(p1) -- line: 6
		if not p1._initialized then
			p1:initialize()
			p1._initialized = true
		end

		return p1
	end,
	initialize = function(p2) -- line: 14
		-- upvalues: UserInputService (copy)
		p2._isKeyboardJustOff = false
		UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function() -- line: 16
			-- upvalues: UserInputService (copy), p2 (copy)
			if not UserInputService.OnScreenKeyboardVisible then
				p2._isKeyboardJustOff = true
			end
		end)
		UserInputService.InputEnded:Connect(function(_) -- line: 21
			-- upvalues: p2 (copy)
			if p2._isKeyboardJustOff then
				p2._isKeyboardJustOff = false
			end
		end)
	end,
	isKeyboardJustOff = function(p4) -- line: 32
		return p4._isKeyboardJustOff
	end
}

return {
	getInstance = function() -- line: 37
		-- upvalues: t1 (copy)
		return t1:getInstance()
	end
}
