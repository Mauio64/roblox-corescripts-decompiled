local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)

require(Modules.AvatarExperience.Common.Types)

local SetBodyPartRangeIds = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyPartRangeIds)
local SetRangeIdToBodyPartsToSliderAndColor3Values = require(Modules.AvatarExperience.AvatarEditor.Actions.SetRangeIdToBodyPartsToSliderAndColor3Values)

return function(p1) -- line: 23
	-- upvalues: Utils (copy), SetBodyPartRangeIds (copy), SetRangeIdToBodyPartsToSliderAndColor3Values (copy)
	return function(p2) -- line: 24
		-- upvalues: p1 (copy), Utils (copy), SetBodyPartRangeIds (copy), SetRangeIdToBodyPartsToSliderAndColor3Values (copy)
		local DefaultBodyColorRanges = p2:getState().AvatarExperience.AvatarEditor.DefaultBodyColorRanges

		assert(DefaultBodyColorRanges ~= nil, "defaultBodyColorRanges is nil")

		local t1 = {}
		local t2 = {}

		for v10, v11 in p1 do
			local v12, v13 = Utils.findRangeAndSliderValueForColor3(v11, DefaultBodyColorRanges)

			t1[v10] = v12
			t2[v10] = v13
		end

		p2:dispatch(SetBodyPartRangeIds(t1))

		for v14, v15 in t2 do
			local v16 = p1[v14]
			local v17 = t1[v14]

			p2:dispatch(SetRangeIdToBodyPartsToSliderAndColor3Values(v17, v14, v15, v16))
		end
	end
end
