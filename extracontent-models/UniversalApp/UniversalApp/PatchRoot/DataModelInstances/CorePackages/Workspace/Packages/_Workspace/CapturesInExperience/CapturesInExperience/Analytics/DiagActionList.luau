local EventNames = require(script.Parent.EventNames)

return {
	[EventNames.CapturesActivatedInGameMenu] = {
		name = game:DefineFastString("CapturesActivatedInGameMenu", "CapturesActivatedInGameMenu")
	},
	[EventNames.CapturesCarouselOpened] = {
		name = game:DefineFastString("CapturesCarouselOpened", "CapturesCarouselOpened")
	},
	[EventNames.CapturesDeactivatedInGameMenu] = {
		name = game:DefineFastString("CapturesDeactivatedInGameMenu", "CapturesDeactivatedInGameMenu")
	},
	[EventNames.CapturesEntrypointActivated] = {
		name = game:DefineFastString("CapturesEntrypointActivated", "CapturesEntrypointActivated")
	},
	[EventNames.CapturesPageOpenedInGameMenu] = {
		name = game:DefineFastString("CapturesPageOpenedInGameMenu", "CapturesPageOpenedInGameMenu")
	},
	[EventNames.CapturesShareFromNonStandardServer] = {
		name = game:DefineFastString("CapturesShareToastButtonActivated", "CapturesShareToastButtonActivated")
	},
	[EventNames.CapturesShareToastButtonActivated] = {
		name = game:DefineFastString("CapturesShareToastButtonActivated", "CapturesShareToastButtonActivated")
	},
	[EventNames.ShareCaptureGenerateLinkFailed] = {
		name = game:DefineFastString("ShareCaptureGenerateLinkFailed", "ShareCaptureGenerateLinkFailed")
	},
	[EventNames.ShareCapturePromptAccepted] = {
		name = game:DefineFastString("ShareCapturePromptAccepted", "ShareCapturePromptAccepted")
	},
	[EventNames.ShareCapturePromptRejected] = {
		name = game:DefineFastString("ShareCapturePromptRejected", "ShareCapturePromptRejected")
	}
}
