local function isFocusRequestFresh(p: number?, p2: number, p3: number): boolean
	return p ~= nil and p2 - p <= p3
end

return isFocusRequestFresh
