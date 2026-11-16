local ThemeBackground = script:FindFirstAncestor("ThemeBackground")
local parent = ThemeBackground.Parent

local Signals = require(parent.Signals)

require(ThemeBackground.ThemeBackgroundTypes)

local frozen = table.freeze({ position = Vector2.zero, size = Vector2.zero })

local function createThemeBackgroundStore()
	local signal, v = Signals.createSignal(nil)
	local signal2, v2 = Signals.createSignal(frozen)

	return {
		getThemeBackground = signal,
		getGeometry = signal2,
		setThemeBackground = function(p)
			v(p)
		end,
		setGeometry = function(p)
			v2(p)
		end,
		reset = function()
			v(nil)
			v2(frozen)
		end
	}
end

return createThemeBackgroundStore
