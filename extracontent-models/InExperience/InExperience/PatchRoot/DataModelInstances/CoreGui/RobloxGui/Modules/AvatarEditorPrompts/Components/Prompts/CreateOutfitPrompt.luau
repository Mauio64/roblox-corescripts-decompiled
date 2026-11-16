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

local PromptWithAvatarViewport = require(parent.Prompts.PromptWithAvatarViewport)

local SignalCreateOutfitPermissionDenied = require(parent2.Thunks.SignalCreateOutfitPermissionDenied)
local CreateOutfitConfirmed = require(parent2.Actions.CreateOutfitConfirmed)
local PerformCreateOutfit = require(parent2.Thunks.PerformCreateOutfit)

local AvatarEditorPromptsPolicy = require(parent2.AvatarEditorPromptsPolicy)

local extended = Roact.PureComponent:extend("CreateOutfitPrompt")

extended.validateProps = t.strictInterface({
	humanoidDescription = t.instanceOf("HumanoidDescription"),
	rigType = t.enum(Enum.HumanoidRigType),
	createOutfitConfirmed = t.callback,
	signalCreateOutfitPermissionDenied = t.callback,
	performCreateOutfit = t.callback,
	showCustomOutfitNames = t.boolean
})

function extended.render(p)
	local onActivated

	if p.props.showCustomOutfitNames then
		onActivated = p.props.createOutfitConfirmed
	else
		onActivated = p.props.performCreateOutfit
	end

	return Roact.createElement(PromptWithAvatarViewport, {
		humanoidDescription = p.props.humanoidDescription,
		rigType = p.props.rigType,
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.CreateOutfitPromptTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.CreateOutfitPromptText"),
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = p.props.signalCreateOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.CreateOutfitPromptNo")
					},
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = onActivated,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.CreateOutfitPromptYes")
					},
					isDefaultChild = false
				}
			}
		}
	})
end

local function mapStateToProps(p)
	return {
		humanoidDescription = p.promptInfo.humanoidDescription,
		rigType = p.promptInfo.rigType
	}
end

local function mapDispatchToProps(callback)
	return {
		signalCreateOutfitPermissionDenied = function()
			return callback(SignalCreateOutfitPermissionDenied)
		end,
		createOutfitConfirmed = function()
			return callback(CreateOutfitConfirmed())
		end,
		performCreateOutfit = function()
			return callback(PerformCreateOutfit(""))
		end
	}
end

local v = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

return (AvatarEditorPromptsPolicy.connect(function(p, _)
	return { showCustomOutfitNames = p.getCustomOutfitNames() }
end)(v))
