local parent = script.Parent.Parent
local AppCommonLib = require(parent.AppCommonLib)
local Symbol = AppCommonLib.Symbol

return {
	Hidden = Symbol.named("Hidden"),
	Closed = Symbol.named("Closed"),
	Brief = Symbol.named("Brief"),
	SuperBrief = Symbol.named("SuperBrief"),
	Full = Symbol.named("Full"),
	Extended = Symbol.named("Extended")
}
