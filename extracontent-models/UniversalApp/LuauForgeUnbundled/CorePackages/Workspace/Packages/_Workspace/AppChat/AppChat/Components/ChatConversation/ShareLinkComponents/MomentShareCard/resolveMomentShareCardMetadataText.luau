local function nonEmpty(p2)
	if p2 == nil or p2 == "" then
		return nil
	end

	return p2
end

local function resolveMomentShareCardMetadataText(p2, p3, p4)
	if p2 == nil or p2 == "" then
		p2 = nil
	end

	if p2 then
		return p2
	end

	p2 = if not (p3 == nil or p3 == "") then p3 else nil

	if p2 then
		return p2
	end

	if p4 ~= nil and p4 ~= "" then
		return p4
	end

	p2 = nil
	return p2
end

return resolveMomentShareCardMetadataText
