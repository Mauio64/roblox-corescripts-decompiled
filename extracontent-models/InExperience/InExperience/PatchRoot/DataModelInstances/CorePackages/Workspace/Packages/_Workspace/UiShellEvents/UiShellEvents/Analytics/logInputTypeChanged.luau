return function(p1, s1: string, p2) -- line: 1
	p1:sendEventDeferred(s1, "inputTypeChanged", p2)
end
