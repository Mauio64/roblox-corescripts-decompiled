local parent = script:FindFirstAncestor("ExperienceLoadingScript").Parent

local Rodux = require(parent.Rodux)
local ArgCheck = require(parent.ArgCheck)

return Rodux.makeActionCreator(script.Name, function(productInfo)
	ArgCheck.isType(productInfo, "table", "SetGameProductInfo action expects productInfo to be a table")
	return { productInfo = productInfo }
end)
