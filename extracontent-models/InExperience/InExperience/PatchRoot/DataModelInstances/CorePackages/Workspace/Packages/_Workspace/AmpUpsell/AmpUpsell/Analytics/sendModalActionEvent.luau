return function(p, p2: string, origin: string, aType: string)
	p.sendEventDeferred(p2, "modalAction", { aType = aType, origin = origin })
end
