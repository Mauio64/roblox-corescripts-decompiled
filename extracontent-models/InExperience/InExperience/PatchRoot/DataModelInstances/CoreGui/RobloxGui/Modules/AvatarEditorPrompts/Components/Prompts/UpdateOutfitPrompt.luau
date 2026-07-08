local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local ButtonType = require(CorePackages.Packages.UIBlox).App.Button.Enum.ButtonType

CoreGui:WaitForChild("RobloxGui")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local SignalUpdateOutfitPermissionDenied = require(ParentParentParent.Thunks.SignalUpdateOutfitPermissionDenied)
local PerformUpdateOutfit = require(ParentParentParent.Thunks.PerformUpdateOutfit)
local PromptWithAvatarViewport = require(ParentParent.Prompts.PromptWithAvatarViewport)
local AvatarEditorPromptsPolicy = require(ParentParentParent.AvatarEditorPromptsPolicy)
local v14 = Roact.PureComponent:extend("UpdateOutfitPrompt")

v14.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	humanoidDescription = t.instanceOf("HumanoidDescription"),
	rigType = t.enum(Enum.HumanoidRigType),
	outfitName = t.string,
	signalUpdateOutfitPermissionDenied = t.callback,
	performUpdateOutfit = t.callback,
	showCustomOutfitNames = t.boolean
})

function v14.render(p1) -- line: 45
	-- upvalues: RobloxTranslator (copy), Roact (copy), PromptWithAvatarViewport (copy), ButtonType (copy)
	local v19 = if not p1.props.showCustomOutfitNames then RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptTextNoOutfitName") else RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptText", {
		RBX_NAME = p1.props.outfitName
	})

	return Roact.createElement(PromptWithAvatarViewport, {
		humanoidDescription = p1.props.humanoidDescription,
		rigType = p1.props.rigType,
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptTitle"),
		bodyText = v19,
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p1.props.signalUpdateOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptNo")
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p1.props.performUpdateOutfit,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptYes")
					}
				}
			}
		}
	})
end

local function mapStateToProps(p2) -- line: 83
	return {
		screenSize = p2.screenSize,
		humanoidDescription = p2.promptInfo.humanoidDescription,
		rigType = p2.promptInfo.rigType,
		outfitName = p2.promptInfo.outfitName
	}
end
local function mapDispatchToProps(p3) -- line: 92
	-- upvalues: SignalUpdateOutfitPermissionDenied (copy), PerformUpdateOutfit (copy)
	return {
		signalUpdateOutfitPermissionDenied = function() -- line: 94
			-- upvalues: p3 (copy), SignalUpdateOutfitPermissionDenied (copy)
			return p3(SignalUpdateOutfitPermissionDenied)
		end,
		performUpdateOutfit = function() -- line: 98
			-- upvalues: p3 (copy), PerformUpdateOutfit (copy)
			return p3(PerformUpdateOutfit)
		end or nil
	}
end

local v17 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v14)

return (AvatarEditorPromptsPolicy.connect(function(p4, _) -- line: 106
	return {
		showCustomOutfitNames = p4.getCustomOutfitNames()
	}
end)(v17))
