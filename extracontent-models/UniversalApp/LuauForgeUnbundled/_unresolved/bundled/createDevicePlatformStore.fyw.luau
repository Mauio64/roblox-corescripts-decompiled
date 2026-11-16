local CorePackages = game:GetService("CorePackages")

local Signals = require(CorePackages.Packages.Signals)

local function createDevicePlatformStore()
	local signal, v5 = Signals.createSignal(Enum.Platform.None)

	return {
		getPlatform = signal,
		setPlatform = function(p2)
			v5(p2)
		end,
		reset = function()
			v5(Enum.Platform.None)
		end
	}
end

return createDevicePlatformStore
