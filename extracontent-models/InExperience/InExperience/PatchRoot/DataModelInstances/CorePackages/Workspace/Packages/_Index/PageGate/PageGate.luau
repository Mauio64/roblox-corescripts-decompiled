local PageGate = require(script.PageGate)

return {
	FFlagEnablePLTPrefetchCallbacks = PageGate.FFlagEnablePLTPrefetchCallbacks,
	Page = PageGate.Page,
	Milestone = PageGate.Milestone,
	signal = PageGate.signal,
	["jest.config"] = script["jest.config"]
}
