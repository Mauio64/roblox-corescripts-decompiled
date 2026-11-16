local parent = script.Parent.Parent
require(parent.util.Types)

local function destroyHelper(items)
	for _, item in items do
		for _, v in item do
			if v.created and v.instance then
				v.instance:Destroy()
			end
		end
	end
end

return function(p, p2)
	destroyHelper(p)
	destroyHelper(p2)
end
