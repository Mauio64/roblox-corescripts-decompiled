local parent = script:FindFirstAncestor("ExpChat").Parent
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local defineFastFlag = game:DefineFastFlag("ExpChatFocusNavigation", false)
local defineFastFlag2 = game:DefineFastFlag("ExpChatFocusNavigationIxpEnabled", false)
local defineFastFlag3 = game:DefineFastFlag("ExpChatFocusNavigationBackupIxpEnabled", false)

local defineFastString = game:DefineFastString("ExpChatFocusNavigationIxpLayer", "ExperienceChat.FocusNavigation")

return {
	isTabNavEnabled = defineFastFlag,
	isExposureLoggingEnabled = defineFastFlag2,
	isBackupExposureLoggingEnabled = defineFastFlag3,
	logExposure = function()
		IXPServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
	end
}
