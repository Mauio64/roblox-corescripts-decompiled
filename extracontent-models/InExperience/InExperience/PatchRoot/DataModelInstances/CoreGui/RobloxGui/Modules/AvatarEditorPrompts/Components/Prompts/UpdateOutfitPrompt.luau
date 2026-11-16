local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local ButtonType = UIBlox.App.Button.Enum.ButtonType

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local parent = script.Parent.Parent
local parent2 = parent.Parent

local SignalUpdateOutfitPermissionDenied = require(parent2.Thunks.SignalUpdateOutfitPermissionDenied)
local PerformUpdateOutfit = require(parent2.Thunks.PerformUpdateOutfit)

local PromptWithAvatarViewport = require(parent.Prompts.PromptWithAvatarViewport)

local AvatarEditorPromptsPolicy = require(parent2.AvatarEditorPromptsPolicy)

local extended = Roact.PureComponent:extend("UpdateOutfitPrompt")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	humanoidDescription = t.instanceOf("HumanoidDescription"),
	rigType = t.enum(Enum.HumanoidRigType),
	outfitName = t.string,
	signalUpdateOutfitPermissionDenied = t.callback,
	performUpdateOutfit = t.callback,
	showCustomOutfitNames = t.boolean
})

function extended.render(p)
	local bodyText

	if p.props.showCustomOutfitNames then
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptText", {
			RBX_NAME = p.props.outfitName
		})
	else
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptTextNoOutfitName")
	end

	return Roact.createElement(PromptWithAvatarViewport, {
		humanoidDescription = p.props.humanoidDescription,
		rigType = p.props.rigType,
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptTitle"),
		bodyText = bodyText,
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = p.props.signalUpdateOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptNo")
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p.props.performUpdateOutfit,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.UpdateOutfitPromptYes")
					},
					isDefaultChild = false
				}
			}
		}
	})
end

local function mapStateToProps(p)
	return {
		screenSize = p.screenSize,
		humanoidDescription = p.promptInfo.humanoidDescription,
		rigType = p.promptInfo.rigType,
		outfitName = p.promptInfo.outfitName
	}
end

local function mapDispatchToProps(callback)
	return {
		signalUpdateOutfitPermissionDenied = function()
			return callback(SignalUpdateOutfitPermissionDenied)
		end,
		performUpdateOutfit = function()
			return callback(PerformUpdateOutfit)
		end or nil
	}
end

local v = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

return (AvatarEditorPromptsPolicy.connect(function(p, _)
	return { showCustomOutfitNames = p.getCustomOutfitNames() }
end)(v))
