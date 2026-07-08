local Platform = require(script.Parent.Platform)
local getInputPlatform = require(script.Parent.getInputPlatform)
local PlatformIconMap = require(script.Parent.PlatformIconMap)
local UserInputService = require(script.Parent.Parent.Services).UserInputService
local GuiService = require(script.Parent.Parent.Services).GuiService
local t1 = {
	[Platform.PS4] = Enum.Platform.PS4,
	[Platform.PS5] = Enum.Platform.PS5,
	[Platform.Xbox] = Enum.Platform.XBoxOne
}

local function getPlatform() -- line: 13
	-- upvalues: UserInputService (copy), GuiService (copy), getInputPlatform (copy), t1 (copy)
	local ok, result = pcall(UserInputService.GetPlatform, UserInputService)

	if ok then
		return result
	end

	local v11 = GuiService:IsTenFootInterface()
	local v12 = getInputPlatform()

	if v11 then
		return t1[v12]
	end

	return nil
end
local function getBuilderIconForCurrentPlatform() -- line: 27
	-- upvalues: UserInputService (copy), GuiService (copy), getInputPlatform (copy), t1 (copy), PlatformIconMap (copy)
	local ok, result = pcall(UserInputService.GetPlatform, UserInputService)

	if ok then
	else
		local v15 = GuiService:IsTenFootInterface()
		local v16 = getInputPlatform()

		result = if not v15 then nil else t1[v16]
	end

	return PlatformIconMap[result]
end

return getBuilderIconForCurrentPlatform
