local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)

return function(p1, p2, p3) -- line: 12
	-- upvalues: Utils (copy)
	return function(p4) -- line: 13
		-- upvalues: Utils (copy), p1 (copy), p2 (copy), p3 (copy)
		local category = p4:getState().AvatarExperience.AvatarEditor.Categories.category
		local subcategory = p4:getState().AvatarExperience.AvatarEditor.Categories.subcategory
		local v9 = Utils.getUserId(p4:getState())
		local RequestId = p4:getState().AvatarExperience.Common.Widgets.WidgetInfo.RequestId

		p1(p2, category, subcategory, p3, v9, RequestId)
	end
end
