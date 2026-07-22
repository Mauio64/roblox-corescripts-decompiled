local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local Dash = require(Parent.Dash)

require(Parent.MomentsTypes)

local function makeTextOverlayEditsForEditor(t1: {[any]: any}?, p1, n1: number) -- line: 21
	-- upvalues: Dash (copy)
	local v7 = not (n1 > 0) and 1 or n1

	if not t1 or #t1 == 0 then
		return { Dash.joinDeep(p1, {
			scale = 1 / v7
		}) }
	end

	return Dash.map(t1, function(p2) -- line: 34
		-- upvalues: v7 (copy), Dash (copy)
		local v9 = p2.scale * v7

		return Dash.joinDeep(p2, {
			scale = 1 / v7,
			textOverlayStyle = {
				fontSize = p2.textOverlayStyle.fontSize * v9
			}
		})
	end)
end

return makeTextOverlayEditsForEditor
