local ParentParent = script.Parent.Parent

require(ParentParent.Types)

local function getLocalId(p1) -- line: 5
	if p1 and p1.LocalId then
		return p1.LocalId
	end

	return nil
end
local function findMatchingCapture(t1: {[any]: any}, p2) -- line: 12
	local v7 = if not p2 or not p2.LocalId then nil else p2.LocalId

	if v7 == nil then
		return nil
	end

	for _, v9 in t1 do
		if v7 == v9.LocalId then
			return v9
		end

		if v9.videoCapture then
			local videoCapture = v9.videoCapture

			if v7 ~= if not videoCapture or not videoCapture.LocalId then nil else videoCapture.LocalId then
				continue
			end

			return v9.videoCapture
		end
	end

	return nil
end

return findMatchingCapture
