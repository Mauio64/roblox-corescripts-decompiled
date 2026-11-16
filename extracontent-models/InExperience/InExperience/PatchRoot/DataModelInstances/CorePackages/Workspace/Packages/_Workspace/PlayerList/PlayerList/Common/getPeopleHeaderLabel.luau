local parent = script.Parent.Parent.Parent

local RobloxTranslator = require(parent.RobloxTranslator)

local function getPeopleHeaderLabel()
	return RobloxTranslator:FormatByKey("InGame.PlayerList.Players")
end

return getPeopleHeaderLabel
