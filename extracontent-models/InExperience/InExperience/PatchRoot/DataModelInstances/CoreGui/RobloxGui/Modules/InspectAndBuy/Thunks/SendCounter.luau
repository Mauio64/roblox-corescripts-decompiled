local ParentParent = script.Parent.Parent
local Thunk = require(ParentParent.Thunk)
local Analytics = require(ParentParent.Services.Analytics)
local t1 = { Analytics }

local function SendCounter(p1) -- line: 12
	-- upvalues: Thunk (copy), t1 (copy), Analytics (copy)
	return Thunk.new(script.Name, t1, function(_, p3) -- line: 13
		-- upvalues: Analytics (copy), p1 (copy)
		p3[Analytics].sendCounter(p1)
	end)
end

return SendCounter
