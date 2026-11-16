local function debugPrint(_, ...) end

return (setmetatable({ isEnabled = false }, { __call = debugPrint }))
