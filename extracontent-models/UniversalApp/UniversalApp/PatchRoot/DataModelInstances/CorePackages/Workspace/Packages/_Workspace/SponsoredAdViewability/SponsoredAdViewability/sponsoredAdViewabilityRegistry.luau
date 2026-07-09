local CollectionService = game:GetService("CollectionService")
local Parent = script:FindFirstAncestor("SponsoredAdViewability").Parent

require(Parent.DiscoveryTypes)

local Constants = require(script.Parent.Constants)
local t1 = {}
local n1 = 0

return {
	bind = function(p1, t2: {[any]: any}) -- line: 23
		-- upvalues: n1 (ref), t1 (copy), Constants (copy), CollectionService (copy)
		n1 += 1

		local str = tostring(n1)

		t1[str] = t2
		p1:SetAttribute(Constants.ViewabilityTargetIdAttribute, str)
		CollectionService:AddTag(p1, Constants.CandidateTag)

		return function() -- line: 30
			-- upvalues: p1 (copy), Constants (copy), str (copy), CollectionService (copy), t1 (copy)
			if p1:GetAttribute(Constants.ViewabilityTargetIdAttribute) == str then
				CollectionService:RemoveTag(p1, Constants.CandidateTag)
				p1:SetAttribute(Constants.ViewabilityTargetIdAttribute, nil)
			end

			t1[str] = nil
		end
	end,
	get = function(s1: string) -- line: 40
		-- upvalues: t1 (copy)
		return t1[s1]
	end,
	_clear = function() -- line: 44
		-- upvalues: t1 (copy)
		for v10 in t1 do
			t1[v10] = nil
		end
	end,
	_size = function() -- line: 50
		-- upvalues: t1 (copy)
		local n2 = 0

		for _ in t1 do
			n2 += 1
		end

		return n2
	end
}
