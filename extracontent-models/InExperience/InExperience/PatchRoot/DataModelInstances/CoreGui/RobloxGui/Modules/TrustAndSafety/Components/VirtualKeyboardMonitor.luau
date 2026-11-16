local UserInputService = game:GetService("UserInputService")

local v = {
	getInstance = function(self)
		if not self._initialized then
			self:initialize()
			self._initialized = true
		end

		return self
	end,
	initialize = function(self)
		self._isKeyboardJustOff = false
		UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(function()
			if not UserInputService.OnScreenKeyboardVisible then
				self._isKeyboardJustOff = true
			end
		end)
		UserInputService.InputEnded:Connect(function(_)
			if self._isKeyboardJustOff then
				self._isKeyboardJustOff = false
			end
		end)
	end,
	isKeyboardJustOff = function(p)
		return p._isKeyboardJustOff
	end
}

return {
	getInstance = function()
		return v:getInstance()
	end
}
