local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(Modules.AvatarExperience.Common.Types)

local SetBodyPartRangeIds = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyPartRangeIds)
local SetBodyColor3s = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyColor3s)
local SetRangeIdToBodyPartsToSliderAndColor3Values = require(Modules.AvatarExperience.AvatarEditor.Actions.SetRangeIdToBodyPartsToSliderAndColor3Values)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)

return function(p1, p2) -- line: 26
	-- upvalues: Utils (copy), SetRangeIdToBodyPartsToSliderAndColor3Values (copy), SetBodyColor3s (copy), SetBodyPartRangeIds (copy)
	return function(p3) -- line: 27
		-- upvalues: p1 (copy), Utils (copy), p2 (copy), SetRangeIdToBodyPartsToSliderAndColor3Values (copy), SetBodyColor3s (copy), SetBodyPartRangeIds (copy)
		local t1 = {}

		for k, v in pairs(p1) do
			local v14, v15 = Utils.findRangeAndSliderValueForColor3(v, p2)

			SetRangeIdToBodyPartsToSliderAndColor3Values(v14, k, v15, v)
			t1[k] = v14
		end

		p3:dispatch(SetBodyColor3s(p1))
		p3:dispatch(SetBodyPartRangeIds(t1))
	end
end
