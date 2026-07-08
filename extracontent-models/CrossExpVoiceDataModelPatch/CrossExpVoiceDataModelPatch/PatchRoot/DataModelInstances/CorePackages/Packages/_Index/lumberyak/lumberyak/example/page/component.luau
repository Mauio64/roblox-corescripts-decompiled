local v1 = require(script.Parent.pageLogger):new()

v1:setContext({
	bar = "bar"
})

return function() -- line: 4
	-- upvalues: v1 (copy)
	v1:info("calling {root} {foo} {bar}")

	return "done"
end
