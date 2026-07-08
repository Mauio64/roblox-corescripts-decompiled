local function forEachArgs(p1: ((...any) -> ...any), ...) -- line: 9
	for i = 1, select("#", ...) do
		p1(select(i, ...), i)
	end
end

return forEachArgs
