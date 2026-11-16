return function(p, p2: string, origin: string, btn: string)
	p.sendEventDeferred(p2, "buttonClick", { origin = origin, btn = btn })
end
