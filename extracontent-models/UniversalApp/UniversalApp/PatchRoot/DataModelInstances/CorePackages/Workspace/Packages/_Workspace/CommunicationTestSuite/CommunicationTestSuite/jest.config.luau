_G.__TESTEZ_RUNNING_TEST__ = true

local ParentParent = script.Parent.Parent

return {
	projects = {
		require(ParentParent.VoiceChat)["jest.config"],
		require(ParentParent.VoiceChatCore)["jest.config"]
	}
}
