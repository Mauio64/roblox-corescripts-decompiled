local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local function destroyHelper(t1: {[any]: any}) -- line: 6
	for _, v5 in t1 do
		for _, v7 in v5 do
			if v7.created and v7.instance then
				v7.instance:Destroy()
			end
		end
	end
end

return function(p1, p2) -- line: 18
	-- upvalues: destroyHelper (copy)
	destroyHelper(p1)
	destroyHelper(p2)
end
