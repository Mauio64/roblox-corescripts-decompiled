local parent = script:FindFirstAncestor("MomentsCreation").Parent

local Dash = require(parent.Dash)
require(parent.MomentsTypes)

local function makeTextOverlayEditsForEditor(list, p, p2: number)
	local v = not (p2 > 0) and 1 or p2

	if list and #list ~= 0 then
		return Dash.map(list, function(p3)
			local v2 = p3.scale * v

			return Dash.joinDeep(p3, {
				scale = 1 / v,
				textOverlayStyle = {
					fontSize = p3.textOverlayStyle.fontSize * v2
				}
			})
		end)
	end

	return { Dash.joinDeep(p, {
			scale = 1 / v
		}) }
end

return makeTextOverlayEditsForEditor
