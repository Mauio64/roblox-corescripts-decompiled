local function isValidIdentifier(p: string?): boolean
	return p ~= nil and p ~= "" and p ~= "0"
end

return isValidIdentifier
