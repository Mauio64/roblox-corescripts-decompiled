local ParentParent = script.Parent.Parent
local GetFFlagEnableLuobuInGameUpsell = require(ParentParent.Flags.GetFFlagEnableLuobuInGameUpsell)

return function() -- line: 5
	-- upvalues: GetFFlagEnableLuobuInGameUpsell (copy)
	return GetFFlagEnableLuobuInGameUpsell()
end
