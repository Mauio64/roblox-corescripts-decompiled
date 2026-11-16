return function(p: string): boolean
	return p ~= nil and p ~= "" and tonumber(p) > 0
end
