local StarterGui = game:GetService("StarterGui")

local CorePackages = game:GetService("CorePackages")
local InExperienceTopBar = require(CorePackages.Workspace.Packages.InExperienceTopBar)
local FFlagTopBarSignalizeSetCores = InExperienceTopBar.Flags.FFlagTopBarSignalizeSetCores

local parent = script.Parent

local SetTopBarEnabled = require(parent.Actions.SetTopBarEnabled)

local function registerSetCores(object)
	StarterGui:RegisterSetCore("TopbarEnabled", function(p)
		if type(p) == "boolean" then
			object:dispatch(SetTopBarEnabled(p))
		else
			error("SetCore TopbarEnabled argument must be a boolean", 2)
		end
	end)

	StarterGui:RegisterGetCore("TopbarEnabled", function()
		return object:getState().displayOptions.topbarEnabled
	end)
end

if FFlagTopBarSignalizeSetCores then
	return nil
end

return registerSetCores
