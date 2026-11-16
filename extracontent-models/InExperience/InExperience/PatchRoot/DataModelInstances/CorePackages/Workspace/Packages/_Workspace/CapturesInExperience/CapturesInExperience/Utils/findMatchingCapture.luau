local parent = script.Parent.Parent

require(parent.Types)

local function getLocalId(p) -- 2 equivalent calls inferred from this helper
	return if p and p.LocalId then p.LocalId else nil
end

local function findMatchingCapture(items, p)
	local localId = getLocalId(p) -- inferred equivalent call

	if localId == nil then
		return nil
	end

	for _, item in items do
		if item.LocalId == localId then
			return item
		end

		if item.videoCapture and getLocalId(item.videoCapture) == localId then -- inferred equivalent call
			return item.videoCapture
		end
	end

	return nil
end

return findMatchingCapture
