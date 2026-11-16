local function isFoundationImage(value: string?): boolean
	return value ~= nil and value ~= "" and value:match("^%w+://.*$") == nil
end

return isFoundationImage
