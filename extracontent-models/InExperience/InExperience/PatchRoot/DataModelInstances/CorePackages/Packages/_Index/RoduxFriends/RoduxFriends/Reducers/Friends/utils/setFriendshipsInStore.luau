local Parent = script:FindFirstAncestor("RoduxFriends").Parent
local llama = require(Parent.llama)
local addUser = require(script.Parent.addUser)
local removeUser = require(script.Parent.removeUser)

function difference(p1, p2) -- line: 8
	local t1 = {}

	for _, v in pairs(p1) do
		t1[v] = true
	end

	for _, v in pairs(p2) do
		t1[v] = nil
	end

	local t2 = {}
	local n1 = 0

	for _, v in pairs(p1) do
		if t1[v] then
			n1 += 1
			t2[n1] = v
		end
	end

	return t2
end

return function(p3, p4) -- line: 33
	-- upvalues: llama (copy), addUser (copy), removeUser (copy)
	local str = tostring(p4.namedIds.users)
	local v19 = p3[str] or {}
	local v20 = llama.List.map(llama.Dictionary.values(p4.responseBody.data), function(p5) -- line: 37
		return (tostring(p5.id))
	end)
	local v21 = difference(v20, v19)
	local v22 = difference(v19, v20)

	for _, v in pairs(v21) do
		p3 = llama.Dictionary.join(p3, {
			[str] = addUser(p3[str], v),
			[v] = addUser(p3[v], str)
		})
	end

	for _, v in pairs(v22) do
		p3 = llama.Dictionary.join(p3, {
			[str] = removeUser(p3[str], v),
			[v] = removeUser(p3[v], str)
		})
	end

	for k, v in pairs(p3) do
		if llama.isEmpty(v) then
			p3[k] = nil
		end
	end

	return p3
end
