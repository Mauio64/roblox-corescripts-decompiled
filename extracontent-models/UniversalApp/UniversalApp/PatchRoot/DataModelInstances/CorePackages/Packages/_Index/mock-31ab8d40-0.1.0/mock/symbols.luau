local function newSymbol(p) -- 5 equivalent calls inferred from this helper
	local symbol = newproxy(true)
	local formatted = ("Mocks.%s"):format(p)
	getmetatable(symbol).__tostring = function()
		return formatted
	end

	return symbol
end

return {
	Calls = newSymbol("Calls"), -- inferred equivalent call
	Children = newSymbol("Children"), -- inferred equivalent call
	Lock = newSymbol("Lock"), -- inferred equivalent call
	None = newSymbol("None"), -- inferred equivalent call
	ReturnValue = newSymbol("ReturnValue") -- inferred equivalent call
}
