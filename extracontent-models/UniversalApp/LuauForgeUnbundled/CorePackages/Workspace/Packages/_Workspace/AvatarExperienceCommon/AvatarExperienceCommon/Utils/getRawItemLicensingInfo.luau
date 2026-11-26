return function(p2)
	if type(p2) ~= "table" then
		return nil
	end

	if p2.itemLicensingInfo == nil then
		return p2.license
	end

	return p2.itemLicensingInfo
end
