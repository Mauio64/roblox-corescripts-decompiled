game:GetService("CorePackages")

local parent = script.Parent
local ScreenList = require(parent.ScreenList)

return function(options, p)
	return {
		ScreenList = ScreenList((options or {}).ScreenList, p)
	}
end
