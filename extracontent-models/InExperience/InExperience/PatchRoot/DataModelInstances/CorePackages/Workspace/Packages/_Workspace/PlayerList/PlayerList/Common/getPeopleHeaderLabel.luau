local ParentParent = script.Parent.Parent.Parent
local RobloxTranslator = require(ParentParent.RobloxTranslator)

local function getPeopleHeaderLabel() -- line: 7
	-- upvalues: RobloxTranslator (copy)
	return RobloxTranslator:FormatByKey("InGame.PlayerList.Players")
end

return getPeopleHeaderLabel
