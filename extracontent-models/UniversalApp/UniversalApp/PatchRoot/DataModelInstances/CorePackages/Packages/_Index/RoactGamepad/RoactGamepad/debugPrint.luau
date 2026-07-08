local function debugPrint(_, ...) -- line: 3
end

return (setmetatable({
	isEnabled = false
}, {
	__call = debugPrint
}))
