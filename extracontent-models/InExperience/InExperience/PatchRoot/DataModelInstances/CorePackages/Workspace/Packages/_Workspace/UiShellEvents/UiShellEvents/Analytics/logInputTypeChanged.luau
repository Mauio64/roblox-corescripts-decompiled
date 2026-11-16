return function(object, p: string, p2)
	object:sendEventDeferred(p, "inputTypeChanged", p2)
end
