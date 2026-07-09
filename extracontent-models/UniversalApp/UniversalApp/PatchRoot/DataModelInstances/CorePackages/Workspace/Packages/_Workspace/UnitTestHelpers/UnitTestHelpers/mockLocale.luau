local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local LocalizationProvider = require(ParentParent.Localization).LocalizationProvider
local Signal = require(ParentParent.AppCommonLib).Signal

return function(p1) -- line: 8
	-- upvalues: Roact (copy), LocalizationProvider (copy), Signal (copy)
	return Roact.createElement(LocalizationProvider, {
		localization = {
			Format = function(_, p3, _) -- line: 11
				return p3
			end,
			changed = Signal.new()
		}
	}, {
		TestElement1 = p1
	})
end
