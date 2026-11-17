local UserGameSettings = UserSettings():GetService("UserGameSettings")

local parent = script:FindFirstAncestor("TextSize").Parent
local Foundation = require(parent.Foundation)
local Signals = require(parent.Signals)

local function createTextSizeStore()
	local signal, v = Signals.createSignal(Foundation.Utility.getTextSizeOffset() or 0)
	local preferredTextSizeChangedConnection = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(function()
		v(Foundation.Utility.getTextSizeOffset() or 0)
	end)

	return {
		getTextSizeOffset = signal,
		cleanup = function()
			if preferredTextSizeChangedConnection then
				preferredTextSizeChangedConnection:Disconnect()
				preferredTextSizeChangedConnection = nil
			end
		end
	}
end

return createTextSizeStore
