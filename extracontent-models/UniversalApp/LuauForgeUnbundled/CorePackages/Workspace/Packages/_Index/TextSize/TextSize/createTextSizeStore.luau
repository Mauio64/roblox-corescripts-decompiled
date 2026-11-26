local UserGameSettings = UserSettings():GetService("UserGameSettings")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/TextSize/Foundation")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/TextSize/Signals")

local function createTextSizeStore()
	local signal, v5 = Signals.createSignal(Foundation.Utility.getTextSizeOffset() or 0)
	local preferredTextSizeChangedConnection = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(function()
		v5(Foundation.Utility.getTextSizeOffset() or 0)
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
