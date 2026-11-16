local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local FormFactor = require(parent.FormFactor)
local formFactor = FormFactor.Enums.FormFactor
local RoactUtils = require(parent.RoactUtils)

local FillBehavior = Foundation.Enums.FillBehavior
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function selectFormFactor(p)
	return p.FormFactor
end

local function useBuildHomeTabsFillBehavior()
	if useSelector(selectFormFactor) == formFactor.COMPACT then
		return FillBehavior.Fill
	end

	return FillBehavior.Fit
end

return useBuildHomeTabsFillBehavior
