local UserInputService = game:GetService("UserInputService")

local v = { _initialized = false, _isKeyboardJustOff = false }

function v:getInstance()
	if not self._initialized then
		self:initialize()
		self._initialized = true
	end

	return self
end

function v:initialize()
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
end

function v:isKeyboardJustOff()
	return self._isKeyboardJustOff
end

return {
	getInstance = function()
		return v:getInstance()
	end
}
