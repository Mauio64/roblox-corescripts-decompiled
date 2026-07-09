local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local RoactUtils = require(ParentParentParent.RoactUtils)
local Constants = require(ParentParent.Constants)
local PromptConnections = require(ParentParent.Components.CaptureService.PromptConnections)
local PromptType = require(ParentParent.Enums.PromptType)
local SaveCapturesPrompt = require(ParentParent.Components.CaptureService.SaveCapturesPrompt)
local ShareCapturePrompt = require(ParentParent.Components.CaptureService.ShareCapturePrompt)
local CapturePermissionsPromptV2 = require(ParentParent.Components.CaptureService.CapturePermissionsPromptV2)

require(ParentParent.Types)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local t1 = {
	[PromptType.SaveCaptures] = SaveCapturesPrompt,
	[PromptType.ShareCapture] = ShareCapturePrompt
}

if game:GetEngineFeature("CaptureServiceGalleryPermissionPrompt") then
	t1[PromptType.CapturePermissions] = CapturePermissionsPromptV2
end

return function(_: {[any]: any}) -- line: 30
	-- upvalues: useSelector (copy), Constants (copy), t1 (copy), React (copy), PromptConnections (copy)
	local v14 = useSelector(function(p1) -- line: 31
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].Prompts[1]
	end)
	local v15 = v14 and v14.PromptData
	local v16 = v14 and v14.PromptId
	local v17 = v14 and v14.PromptType
	local v18 = nil

	if v17 then
		local v19 = t1[v17]

		if v19 then
			v18 = React.createElement(v19, {
				promptData = v15,
				promptId = v16
			})
		else
			error(`Unexpected prompt type: { v17 }!`)
		end
	end

	return React.createElement(React.Fragment, {}, {
		PromptConnections = React.createElement(PromptConnections),
		Prompt = v18
	})
end
