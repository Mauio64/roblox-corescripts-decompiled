local parent = script:FindFirstAncestor("SocialCommon").Parent
local FormFactor = require(parent.FormFactor)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	return useSelector(function(p): boolean
		return p.FormFactor == FormFactor.Enums.FormFactor.WIDE
	end)
end
