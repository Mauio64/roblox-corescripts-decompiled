local function isValidIdentifier(p2): boolean
	return p2 ~= nil and p2 ~= "" and p2 ~= "0"
end

return isValidIdentifier
