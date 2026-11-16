local UserInputService = game:GetService("UserInputService")

local getPlatformTargetimpl = require(script.Parent["getPlatformTarget.impl"])

return getPlatformTargetimpl(UserInputService)
