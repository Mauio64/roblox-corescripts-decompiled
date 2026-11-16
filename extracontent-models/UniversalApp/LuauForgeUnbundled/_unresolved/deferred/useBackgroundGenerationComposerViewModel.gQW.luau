local UserInputService = game:GetService("UserInputService")
require("@luauforge/deferred/gQN")
local module = require("@luauforge/deferred/gQM")

require("@luauforge/deferred/gQU")
local module2 = require("@luauforge/deferred/gQX")

local v5 = {
	TouchStarted = UserInputService.TouchStarted,
	TouchEnded = UserInputService.TouchEnded
}

local function useBackgroundGenerationComposerViewModel(data, p2)
	local v6 = p2 or v5
	local v7 = module2.useResponsiveEdgeSurface()
	local ref = module.useRef(nil)
	local ref2 = module.useRef(nil)

	module.useEffect(function()
		if not v7 then
			return
		end

		local v8 = nil
		local v9 = nil
		local changedConnection = nil

		local function disconnectActiveInput()
			if changedConnection then
				changedConnection:Disconnect()
				changedConnection = nil
			end

			v8 = nil
			v9 = nil
		end

		local function maybeReleaseFocus(p3): boolean
			if v8 ~= p3 or v9 == nil then
				return false
			end

			local current = ref.current
			local current2 = ref2.current

			if current == nil or current2 == nil then
				return false
			end

			local v10 = Vector2.new(p3.Position.X, p3.Position.Y) - v9
			local v11 = v10.Y >= 24 and v10.Y > math.abs(v10.X)

			if not v11 then
				return false
			end

			if changedConnection then
				changedConnection:Disconnect()
				changedConnection = nil
			end

			v8 = nil
			v9 = nil

			current2.releaseFocus()
			return true
		end

		local touchStartedConnection = v6.TouchStarted:Connect(function(data2)
			if changedConnection then
				changedConnection:Disconnect()
				changedConnection = nil
			end

			v8 = nil
			v9 = nil

			local current = ref.current

			if current == nil or ref2.current == nil then
				return
			end

			local vector2 = Vector2.new(data2.Position.X, data2.Position.Y)
			local v10 = vector2.X - current.AbsolutePosition.X

			if v10 < 0 or current.AbsoluteSize.X < v10 then
				return
			end

			v8 = data2
			v9 = vector2
			changedConnection = data2.Changed:Connect(function()
				if not maybeReleaseFocus(data2) and data2.UserInputState == Enum.UserInputState.End then
					if changedConnection then
						changedConnection:Disconnect()
						changedConnection = nil
					end

					v8 = nil
					v9 = nil
				end
			end)
		end)

		local touchEndedConnection = v6.TouchEnded:Connect(function(otherPart)
			if v8 == otherPart and not maybeReleaseFocus(otherPart) then
				if changedConnection then
					changedConnection:Disconnect()
					changedConnection = nil
				end

				v8 = nil
				v9 = nil
			end
		end)

		return function()
			touchStartedConnection:Disconnect()
			touchEndedConnection:Disconnect()

			if changedConnection then
				changedConnection:Disconnect()
				changedConnection = nil
			end

			v8 = nil
			v9 = nil
		end
	end, { v7, v6 })

	return {
		prompt = data.prompt,
		onPromptChanged = data.onPromptChanged,
		onSubmit = data.onSubmit,
		isSubmitEnabled = data.isSubmitEnabled,
		isInputDisabled = data.isInputDisabled,
		placeholder = data.placeholder,
		hasError = data.hasError,
		errorMessage = data.errorMessage,
		composerRef = ref,
		textBoxRef = ref2
	}
end

return useBackgroundGenerationComposerViewModel
