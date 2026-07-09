local MomentsCreation = script:FindFirstAncestor("MomentsCreation")

require(MomentsCreation.Types.CreationFlowTypes)

local function createCreationToolRegistry(t1: {[any]: any}?) -- line: 15
	local t2 = {}
	local t3 = {}

	local function rebuildOrdered() -- line: 19
		-- upvalues: t3 (ref), t2 (copy)
		t3 = {}

		for _, v10 in t2 do
			table.insert(t3, v10)
		end

		table.sort(t3, function(p1, p2) -- line: 24
			return (p1.cta.order or 0) < (p2.cta.order or 0)
		end)
	end

	if t1 ~= nil then
		for _, v8 in t1 do
			t2[v8.kind] = v8
		end

		rebuildOrdered()
	end

	return {
		register = function(t4: {[any]: any}) -- line: 29
			-- upvalues: t2 (copy), rebuildOrdered (copy)
			for _, v13 in t4 do
				t2[v13.kind] = v13
			end

			rebuildOrdered()
		end,
		get = function(s1: string) -- line: 36
			-- upvalues: t2 (copy)
			return t2[s1]
		end,
		getAll = function() -- line: 40
			-- upvalues: t3 (ref)
			return t3
		end
	}
end

return createCreationToolRegistry
