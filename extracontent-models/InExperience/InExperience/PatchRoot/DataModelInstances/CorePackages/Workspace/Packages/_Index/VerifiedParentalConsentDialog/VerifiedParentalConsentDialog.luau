local VPCModalType = require(script.VPCModalType)

return {
	VerifiedParentalConsentDialog = require(script.Features.VPCModalPrompt.VPCModalPrompt),
	VPCModalType = VPCModalType,
	["jest.config"] = script["jest.config"]
}
