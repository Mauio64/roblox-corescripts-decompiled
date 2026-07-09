local NotApprovedPage = script:FindFirstAncestor("NotApprovedPage")

require(NotApprovedPage.Common.Types)

local function hasAnyCommutation(p1) -- line: 10
	if not p1 then
		return false
	end

	for _, v5 in p1 do
		if v5 == true then
			return true
		end
	end

	return false
end

return hasAnyCommutation
