local StarterGui = game:GetService("StarterGui")
local CorePackages = game:GetService("CorePackages")
local FFlagTopBarSignalizeSetCores = require(CorePackages.Workspace.Packages.InExperienceTopBar).Flags.FFlagTopBarSignalizeSetCores
local scriptParent = script.Parent
local SetTopBarEnabled = require(scriptParent.Actions.SetTopBarEnabled)

local function registerSetCores(p1) -- line: 12
	-- upvalues: StarterGui (copy), SetTopBarEnabled (copy)
	StarterGui:RegisterSetCore("TopbarEnabled", function(p2) -- line: 13
		-- upvalues: p1 (copy), SetTopBarEnabled (copy)
		if type(p2) == "boolean" then
			p1:dispatch(SetTopBarEnabled(p2))

			return
		end

		error("SetCore TopbarEnabled argument must be a boolean", 2)
	end)
	StarterGui:RegisterGetCore("TopbarEnabled", function() -- line: 21
		-- upvalues: p1 (copy)
		return p1:getState().displayOptions.topbarEnabled
	end)
end

if FFlagTopBarSignalizeSetCores then
	return nil
end

return registerSetCores
