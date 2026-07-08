local scriptParent = script.Parent
local t1 = {}

for v3, v4 in (require(scriptParent.Images)) do
	t1[v4] = v3
end

return t1
