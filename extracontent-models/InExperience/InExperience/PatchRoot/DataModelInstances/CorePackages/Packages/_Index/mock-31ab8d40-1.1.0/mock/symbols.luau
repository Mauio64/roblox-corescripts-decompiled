local function newSymbol(p) -- 13 equivalent calls inferred from this helper
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
	None = newSymbol("None"), -- inferred equivalent call
	ReturnValue = newSymbol("ReturnValue"), -- inferred equivalent call
	Name = newSymbol("Name"), -- inferred equivalent call
	Address = newSymbol("Address"), -- inferred equivalent call
	Operations = newSymbol("Operations"), -- inferred equivalent call
	Spec = newSymbol("Spec"), -- inferred equivalent call
	SideEffect = newSymbol("SideEffect"), -- inferred equivalent call
	isSpy = newSymbol("isSpy"), -- inferred equivalent call
	isTuple = newSymbol("isTuple"), -- inferred equivalent call
	isMagicMock = newSymbol("isMagicMock"), -- inferred equivalent call
	isPredicate = newSymbol("isPredicate") -- inferred equivalent call
}
