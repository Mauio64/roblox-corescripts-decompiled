local HttpService = game:GetService("HttpService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Roact = require(scriptParentParent.Roact)
local mockStyle = require(scriptParent.mockStyle)

return function(p1) -- line: 8
	-- upvalues: HttpService (copy), mockStyle (copy), Roact (copy)
	local Frame = Instance.new("Frame")

	Frame.Name = HttpService:GenerateGUID(false)

	local v8 = mockStyle(p1)
	local v9 = Roact.mount(v8, Frame)

	return Frame, function() -- line: 14
		-- upvalues: Roact (copy), v9 (copy), Frame (copy)
		Roact.unmount(v9)
		Frame:Destroy()
	end
end
