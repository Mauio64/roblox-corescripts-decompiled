local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local parent = script.Parent.Parent
local parent2 = parent.Parent

local PromptWithTextField = require(parent.Prompts.PromptWithTextField)

local SignalRenameOutfitPermissionDenied = require(parent2.Thunks.SignalRenameOutfitPermissionDenied)
local PerformRenameOutfit = require(parent2.Thunks.PerformRenameOutfit)

local AvatarEditorPromptsPolicy = require(parent2.AvatarEditorPromptsPolicy)

local extended = Roact.PureComponent:extend("RenameOutfitNamePrompt")

extended.validateProps = t.strictInterface({
	outfitId = t.integer,
	outfitName = t.string,
	screenSize = t.Vector2,
	signalRenameOutfitPermissionDenied = t.callback,
	performRenameOutfit = t.callback,
	showCustomOutfitNames = t.boolean
})

function extended:init()
	self:setState({ outfitName = "", alertPosition = UDim2.fromScale(0.5, 0.5) })

	function self.textUpdated(outfitName)
		self:setState({ outfitName = outfitName })
	end

	function self.confirmRenameOutfit()
		self.props.performRenameOutfit(self.state.outfitName)
	end
end

function extended.render(props)
	if props.props.showCustomOutfitNames then
		return Roact.createElement(PromptWithTextField, {
			fieldText = props.state.outfitName,
			onFieldTextUpdated = props.textUpdated,
			title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.RenameOutfitNamePromptTitle"),
			bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.RenameOutfitPromptText", {
				RBX_NAME = props.props.outfitName
			}),
			buttonStackInfo = {
				buttons = {
					{
						props = {
							onActivated = props.props.signalRenameOutfitPermissionDenied,
							text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptNo")
						},
						isDefaultChild = true
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isDisabled = props.state.outfitName == "",
							onActivated = props.confirmRenameOutfit,
							text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptYes")
						},
						isDefaultChild = false
					}
				}
			}
		})
	end

	return Roact.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DisabledRenameOutfitPromptTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DisabledRenameOutfitPromptText"),
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.props.signalRenameOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DisabledRenameOutfitPromptOkay")
					},
					isDefaultChild = true
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = props.props.screenSize,
		isMiddleContentFocusable = false
	})
end

local function mapStateToProps(p)
	return {
		outfitId = p.promptInfo.outfitId,
		outfitName = p.promptInfo.outfitName,
		screenSize = p.screenSize
	}
end

local function mapDispatchToProps(callback)
	return {
		signalRenameOutfitPermissionDenied = function()
			return callback(SignalRenameOutfitPermissionDenied)
		end,
		performRenameOutfit = function(p)
			return callback(PerformRenameOutfit(p))
		end
	}
end

local v = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)

return (AvatarEditorPromptsPolicy.connect(function(p, _)
	return { showCustomOutfitNames = p.getCustomOutfitNames() }
end)(v))
