local Platform = require(script.Parent.Platform)
local getInputPlatform = require(script.Parent.getInputPlatform)
local PlatformIconMap = require(script.Parent.PlatformIconMap)
local Services = require(script.Parent.Parent.Services)
local UserInputService = Services.UserInputService
local Services2 = require(script.Parent.Parent.Services)
local GuiService = Services2.GuiService

local v = {
	[Platform.PS4] = Enum.Platform.PS4,
	[Platform.PS5] = Enum.Platform.PS5,
	[Platform.Xbox] = Enum.Platform.XBoxOne
}

local function getPlatform() -- 1 equivalent call inferred from this helper
	local success, platform = pcall(UserInputService.GetPlatform, UserInputService)

	if success then
		return platform
	end

	local isTenFootInterface = GuiService:IsTenFootInterface()
	local inputPlatform = getInputPlatform()

	if isTenFootInterface then
		return v[inputPlatform]
	end

	return nil
end

local function getBuilderIconForCurrentPlatform()
	return PlatformIconMap[getPlatform()] -- inferred equivalent call
end

return getBuilderIconForCurrentPlatform
