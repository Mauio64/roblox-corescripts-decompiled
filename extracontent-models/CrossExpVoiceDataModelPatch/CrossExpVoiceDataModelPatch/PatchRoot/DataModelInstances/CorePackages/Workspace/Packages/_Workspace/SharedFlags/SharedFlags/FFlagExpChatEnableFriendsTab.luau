local FFlagExpChatWindowMessageSourceRefactor = require(script.Parent.FFlagExpChatWindowMessageSourceRefactor)
local FFlagExpChatChannelTabRefactor = require(script.Parent.FFlagExpChatChannelTabRefactor)
local GetFFlagEnableAppChatInExperience = require(script.Parent.GetFFlagEnableAppChatInExperience)

return game:DefineFastFlag("ExpChatEnableFriendsTab", false) and (FFlagExpChatWindowMessageSourceRefactor and (FFlagExpChatChannelTabRefactor and GetFFlagEnableAppChatInExperience()))
