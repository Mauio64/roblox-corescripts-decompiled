local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local function makeTextOverlayEditsForEditor(list, p2, p3)
	local v5 = not (p3 > 0) and 1 or p3

	if list and #list ~= 0 then
		return Dash.map(list, function(p4)
			local v6 = p4.scale * v5

			return Dash.joinDeep(p4, {
				scale = 1 / v5,
				textOverlayStyle = {
					fontSize = p4.textOverlayStyle.fontSize * v6
				}
			})
		end)
	end

	return { Dash.joinDeep(p2, {
			scale = 1 / v5
		}) }
end

return makeTextOverlayEditsForEditor
