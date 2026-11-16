local parent = script.Parent.Parent

local GetFFlagEnableLuobuInGameUpsell = require(parent.Flags.GetFFlagEnableLuobuInGameUpsell)

return function()
	return GetFFlagEnableLuobuInGameUpsell()
end
