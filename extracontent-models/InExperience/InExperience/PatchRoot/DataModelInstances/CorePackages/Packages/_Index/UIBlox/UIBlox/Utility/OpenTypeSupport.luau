local OpenTypeSupport = {}
OpenTypeSupport.__index = OpenTypeSupport

function OpenTypeSupport.getSupportedFeatures(_): string
	return "zero, ss03"
end

function OpenTypeSupport.getPasswordStylisticAlternative(_): string
	return "zero, ss03"
end

function OpenTypeSupport.getUserNameStylisticAlternative(_): string
	return "zero, ss03"
end

return OpenTypeSupport
