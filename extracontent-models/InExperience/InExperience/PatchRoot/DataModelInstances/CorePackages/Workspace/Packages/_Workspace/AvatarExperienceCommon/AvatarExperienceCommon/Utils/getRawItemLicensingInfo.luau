return function(p)
	if type(p) ~= "table" then
		return nil
	end

	if p.itemLicensingInfo == nil then
		return p.license
	end

	return p.itemLicensingInfo
end
