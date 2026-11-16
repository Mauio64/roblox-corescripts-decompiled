local function nonEmpty(p: string?)
	return if not (p == nil or p == "") then p else nil
end

local function resolveMomentShareCardMetadataText(p: string?, p2: string?, p3: string?)
	if p == nil or p == "" then
		p = nil
	end

	if p then
		return p
	end

	p = if not (p2 == nil or p2 == "") then p2 else nil

	if p then
		return p
	end

	if p3 ~= nil and p3 ~= "" then
		return p3
	end

	p = nil
	return p
end

return resolveMomentShareCardMetadataText
