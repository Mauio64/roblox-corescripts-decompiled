local function forEachArgs(callback, ...)
	for i = 1, select("#", ...) do
		callback(select(i, ...), i)
	end
end

return forEachArgs
