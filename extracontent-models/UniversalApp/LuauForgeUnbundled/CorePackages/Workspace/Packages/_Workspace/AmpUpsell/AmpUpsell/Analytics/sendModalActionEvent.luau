return function(p2, p3, p4, p5)
	p2.sendEventDeferred(p3, "modalAction", { aType = p5, origin = p4 })
end
