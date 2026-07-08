return {
	Connect = function(p1, p2: ((...any) -> ...any)) -- line: 2
		return p1:Connect(p2)
	end
}
