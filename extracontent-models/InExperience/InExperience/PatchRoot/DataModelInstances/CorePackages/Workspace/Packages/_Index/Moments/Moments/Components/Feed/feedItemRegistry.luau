require(script.Parent.FeedTypes)

local t1 = {}

local function register(t2: {[any]: any}) -- line: 17
	-- upvalues: t1 (copy)
	for _, v7 in t2 do
		t1[v7.kind] = v7
	end
end

for _, v4 in (require(script.Parent.Items.Moment)) do
	t1[v4.kind] = v4
end

return t1
