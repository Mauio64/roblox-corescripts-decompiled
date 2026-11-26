local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local formFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FormFactor").Enums.FormFactor
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/RoactUtils")

local fillBehavior = Foundation.Enums.FillBehavior
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function selectFormFactor(p2)
	return p2.FormFactor
end

local function useBuildHomeTabsFillBehavior()
	if useSelector(selectFormFactor) == formFactor.COMPACT then
		return fillBehavior.Fill
	end

	return fillBehavior.Fit
end

return useBuildHomeTabsFillBehavior
