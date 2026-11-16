return function(p, p2): boolean
	return p ~= nil and p2 ~= nil and p.UserInputType == Enum.UserInputType.Touch and p2 ~= p
end
