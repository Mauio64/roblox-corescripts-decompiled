return function(p2, p3, p4, p5)
	p2.sendEventDeferred(p3, "buttonClick", { origin = p4, btn = p5 })
end
