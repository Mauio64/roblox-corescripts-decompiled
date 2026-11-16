local function wasDeveloperProductTextModerated(p2, value): boolean
	return p2 ~= nil and (value or "") ~= p2
end

return wasDeveloperProductTextModerated
