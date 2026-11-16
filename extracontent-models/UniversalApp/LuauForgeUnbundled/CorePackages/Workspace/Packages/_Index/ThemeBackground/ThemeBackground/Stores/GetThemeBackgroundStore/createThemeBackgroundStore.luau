local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ThemeBackground/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/ThemeBackground/ThemeBackground/ThemeBackgroundTypes")

local frozen = table.freeze({ position = Vector2.zero, size = Vector2.zero })

local function createThemeBackgroundStore()
	local signal, v5 = Signals.createSignal(nil)
	local signal2, v6 = Signals.createSignal(frozen)

	return {
		getThemeBackground = signal,
		getGeometry = signal2,
		setThemeBackground = function(p2)
			v5(p2)
		end,
		setGeometry = function(p2)
			v6(p2)
		end,
		reset = function()
			v5(nil)
			v6(frozen)
		end
	}
end

return createThemeBackgroundStore
