local Actions = require(script.Actions)
local Commands = require(script.Commands)
local GlobalCommands = require(script.GlobalCommands)
local TabTypes = require(script.TabTypes)
require(script.Reducers.TextChannels)

return {
	ActionBindableEvent = require(script.ActionBindableEvent),
	Actions = Actions,
	Analytics = require(script.Analytics),
	ChannelTabDisplayLabel = require(script.ChannelTabDisplayLabel),
	Commands = Commands,
	Config = require(script.Config),
	GlobalCommands = GlobalCommands,
	Flags = require(script.Flags),
	FriendsSurfaceVisibility = require(script.FriendsSurfaceVisibility),
	Logger = require(script.Logger),
	RaiseActionAsEventMiddleware = require(script.RaiseActionAsEventMiddleware),
	Reducers = require(script.Reducers),
	TabTypes = TabTypes,
	Version = require(script.Version),
	context = require(script.context),
	countParticipantsInTextChannel = require(script.countParticipantsInTextChannel),
	getOtherDisplayNameInWhisperChannel = require(script.getOtherDisplayNameInWhisperChannel),
	getPresetIconRichText = require(script.getPresetIconRichText),
	getPresetIconSize = require(script.getPresetIconSize),
	getTextChannelDisplayMode = require(script.getTextChannelDisplayMode),
	isPresetMessage = require(script.isPresetMessage),
	markTextChannelAsDefault = require(script.markTextChannelAsDefault),
	shouldRenderTextChannelInDefaultWindow = require(script.shouldRenderTextChannelInDefaultWindow),
	watchForErrors = require(script.watchForErrors),
	["jest.config"] = script["jest.config"]
}
