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
local PromptWithAvatarViewport = require(ParentParent.Prompts.PromptWithAvatarViewport)
local SignalCreateOutfitPermissionDenied = require(ParentParentParent.Thunks.SignalCreateOutfitPermissionDenied)
local CreateOutfitConfirmed = require(ParentParentParent.Actions.CreateOutfitConfirmed)
local PerformCreateOutfit = require(ParentParentParent.Thunks.PerformCreateOutfit)
local AvatarEditorPromptsPolicy = require(ParentParentParent.AvatarEditorPromptsPolicy)
local v15 = Roact.PureComponent:extend("CreateOutfitPrompt")

v15.validateProps = t.strictInterface({
	humanoidDescription = t.instanceOf("HumanoidDescription"),
	rigType = t.enum(Enum.HumanoidRigType),
	createOutfitConfirmed = t.callback,
	signalCreateOutfitPermissionDenied = t.callback,
	performCreateOutfit = t.callback,
	showCustomOutfitNames = t.boolean
})

function v15.render(p1) -- line: 41
	-- upvalues: Roact (copy), PromptWithAvatarViewport (copy), RobloxTranslator (copy), ButtonType (copy)
	local v20 = if not p1.props.showCustomOutfitNames then p1.props.performCreateOutfit else p1.props.createOutfitConfirmed

	return Roact.createElement(PromptWithAvatarViewport, {
		humanoidDescription = p1.props.humanoidDescription,
		rigType = p1.props.rigType,
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.CreateOutfitPromptTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.CreateOutfitPromptText"),
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p1.props.signalCreateOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.CreateOutfitPromptNo")
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = v20,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.CreateOutfitPromptYes")
					}
				}
			}
		}
	})
end

local function mapStateToProps(p2) -- line: 77
	return {
		humanoidDescription = p2.promptInfo.humanoidDescription,
		rigType = p2.promptInfo.rigType
	}
end
local function mapDispatchToProps(p3) -- line: 84
	-- upvalues: SignalCreateOutfitPermissionDenied (copy), CreateOutfitConfirmed (copy), PerformCreateOutfit (copy)
	return {
		signalCreateOutfitPermissionDenied = function() -- line: 86
			-- upvalues: p3 (copy), SignalCreateOutfitPermissionDenied (copy)
			return p3(SignalCreateOutfitPermissionDenied)
		end,
		createOutfitConfirmed = function() -- line: 90
			-- upvalues: p3 (copy), CreateOutfitConfirmed (copy)
			return p3(CreateOutfitConfirmed())
		end,
		performCreateOutfit = function() -- line: 94
			-- upvalues: p3 (copy), PerformCreateOutfit (copy)
			return p3(PerformCreateOutfit(""))
		end
	}
end

local v18 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v15)

return (AvatarEditorPromptsPolicy.connect(function(p4, _) -- line: 102
	return {
		showCustomOutfitNames = p4.getCustomOutfitNames()
	}
end)(v18))
