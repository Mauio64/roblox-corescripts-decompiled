local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local RoactUtils = require(parent2.RoactUtils)

local Constants = require(parent.Constants)
local PromptConnections = require(parent.Components.CaptureService.PromptConnections)
local PromptType = require(parent.Enums.PromptType)
local SaveCapturesPrompt = require(parent.Components.CaptureService.SaveCapturesPrompt)
local ShareCapturePrompt = require(parent.Components.CaptureService.ShareCapturePrompt)

local CapturePermissionsPromptV2 = require(parent.Components.CaptureService.CapturePermissionsPromptV2)

require(parent.Types)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local v = {
	[PromptType.SaveCaptures] = SaveCapturesPrompt,
	[PromptType.ShareCapture] = ShareCapturePrompt
}

if game:GetEngineFeature("CaptureServiceGalleryPermissionPrompt") then
	v[PromptType.CapturePermissions] = CapturePermissionsPromptV2
end

return function(_)
	local v2 = useSelector(function(p)
		return p[Constants.RoduxKey].Prompts[1]
	end)

	local promptData = v2 and v2.PromptData
	local promptId = v2 and v2.PromptId
	local promptType = v2 and v2.PromptType

	local prompt = nil

	if promptType then
		local v3 = v[promptType]

		if v3 then
			prompt = React.createElement(v3, { promptData = promptData, promptId = promptId })
		else
			error(`Unexpected prompt type: {promptType}!`)
		end
	end

	return React.createElement(React.Fragment, {}, {
		PromptConnections = React.createElement(PromptConnections),
		Prompt = prompt
	})
end
