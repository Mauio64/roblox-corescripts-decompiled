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
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local PromptWithTextField = require(ParentParent.Prompts.PromptWithTextField)
local SignalRenameOutfitPermissionDenied = require(ParentParentParent.Thunks.SignalRenameOutfitPermissionDenied)
local PerformRenameOutfit = require(ParentParentParent.Thunks.PerformRenameOutfit)
local AvatarEditorPromptsPolicy = require(ParentParentParent.AvatarEditorPromptsPolicy)
local v16 = Roact.PureComponent:extend("RenameOutfitNamePrompt")

v16.validateProps = t.strictInterface({
	outfitId = t.integer,
	outfitName = t.string,
	screenSize = t.Vector2,
	signalRenameOutfitPermissionDenied = t.callback,
	performRenameOutfit = t.callback,
	showCustomOutfitNames = t.boolean
})

function v16.init(p1) -- line: 43
	p1:setState({
		outfitName = "",
		alertPosition = UDim2.fromScale(0.5, 0.5)
	})

	function p1.textUpdated(p2) -- line: 49
		-- upvalues: p1 (copy)
		p1:setState({
			outfitName = p2
		})
	end
	function p1.confirmRenameOutfit() -- line: 55
		-- upvalues: p1 (copy)
		p1.props.performRenameOutfit(p1.state.outfitName)
	end
end
function v16.render(p3) -- line: 60
	-- upvalues: Roact (copy), InteractiveAlert (copy), RobloxTranslator (copy), ButtonType (copy), PromptWithTextField (copy)
	if not p3.props.showCustomOutfitNames then
		return Roact.createElement(InteractiveAlert, {
			isMiddleContentFocusable = false,
			title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DisabledRenameOutfitPromptTitle"),
			bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DisabledRenameOutfitPromptText"),
			buttonStackInfo = {
				buttons = {{
					isDefaultChild = true,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = p3.props.signalRenameOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.DisabledRenameOutfitPromptOkay")
					}
				}}
			},
			position = UDim2.fromScale(0.5, 0.5),
			screenSize = p3.props.screenSize
		})
	end

	return Roact.createElement(PromptWithTextField, {
		fieldText = p3.state.outfitName,
		onFieldTextUpdated = p3.textUpdated,
		title = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.RenameOutfitNamePromptTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.RenameOutfitPromptText", {
			RBX_NAME = p3.props.outfitName
		}),
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = true,
					props = {
						onActivated = p3.props.signalRenameOutfitPermissionDenied,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptNo")
					}
				},
				{
					isDefaultChild = false,
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = p3.state.outfitName == "",
						onActivated = p3.confirmRenameOutfit,
						text = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.EnterOutfitNamePromptYes")
					}
				}
			}
		}
	})
end

local function mapStateToProps(p4) -- line: 119
	return {
		outfitId = p4.promptInfo.outfitId,
		outfitName = p4.promptInfo.outfitName,
		screenSize = p4.screenSize
	}
end
local function mapDispatchToProps(p5) -- line: 127
	-- upvalues: SignalRenameOutfitPermissionDenied (copy), PerformRenameOutfit (copy)
	return {
		signalRenameOutfitPermissionDenied = function() -- line: 129
			-- upvalues: p5 (copy), SignalRenameOutfitPermissionDenied (copy)
			return p5(SignalRenameOutfitPermissionDenied)
		end,
		performRenameOutfit = function(p6) -- line: 133
			-- upvalues: p5 (copy), PerformRenameOutfit (copy)
			return p5(PerformRenameOutfit(p6))
		end
	}
end

local v19 = RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v16)

return (AvatarEditorPromptsPolicy.connect(function(p7, _) -- line: 141
	return {
		showCustomOutfitNames = p7.getCustomOutfitNames()
	}
end)(v19))
