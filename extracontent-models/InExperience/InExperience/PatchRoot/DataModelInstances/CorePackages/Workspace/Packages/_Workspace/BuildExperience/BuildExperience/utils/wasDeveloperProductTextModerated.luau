local function wasDeveloperProductTextModerated(p: string?, value: string?): boolean
	return p ~= nil and (value or "") ~= p
end

return wasDeveloperProductTextModerated
