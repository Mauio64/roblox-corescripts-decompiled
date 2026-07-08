local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local v7 = UIBlox.App.ImageSet.Images["icons/controls/keys/xboxA"]
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local InputType = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = require(CorePackages.Workspace.Packages.InputType).getInputGroup
local ParentParent = script.Parent.Parent
local CloseResultModal = require(ParentParent.Thunks.CloseResultModal)
local ParentParent2 = script.Parent.Parent
local GetFFlagValidateDescription = require(ParentParent2.GetFFlagValidateDescription)
local v17 = Roact.PureComponent:extend("ResultModal")

v17.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	resultModalType = t.enum(Enum.PromptPublishAssetResult),
	closeResultModal = t.callback
})

local function isGamepadInput(p1) -- line: 38
	-- upvalues: getInputGroup (copy), InputType (copy)
	return getInputGroup(p1) == InputType.InputTypeConstants.Gamepad
end

function v17.init(p2) -- line: 43
	-- upvalues: UserInputService (copy), getInputGroup (copy), InputType (copy)
	local t1 = {}
	local LastInputType = UserInputService:GetLastInputType()

	t1.isGamepad = getInputGroup(LastInputType) == InputType.InputTypeConstants.Gamepad
	p2:setState(t1)
end
function v17.getLocalizedStringForResultPrompt(_, p4) -- line: 49
	-- upvalues: RobloxTranslator (copy)
	if p4 == Enum.PromptPublishAssetResult.Success then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PublishSuccessMessage")
	end

	if p4 == Enum.PromptPublishAssetResult.UploadFailed then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PublishFailed")
	end

	if p4 == Enum.PromptPublishAssetResult.NoUserInput then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.NoUserInput")
	end

	return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.UndefinedError", {
		RESULT_TYPE = tostring(p4)
	})
end
function v17.getLocalizedTitleForResultPrompt(_, p6) -- line: 64
	-- upvalues: RobloxTranslator (copy)
	if p6 == Enum.PromptPublishAssetResult.Success then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PublishSuccessTitle")
	end

	return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PublishFailedTitle")
end
function v17.render(p7) -- line: 72
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy), GetFFlagValidateDescription (copy), RobloxTranslator (copy), v7 (copy)
	return Roact.createElement(InteractiveAlert, {
		title = p7:getLocalizedTitleForResultPrompt(p7.props.resultModalType),
		bodyText = p7:getLocalizedStringForResultPrompt(p7.props.resultModalType),
		screenSize = p7.props.screenSize,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = p7.props.closeResultModal,
					text = if not GetFFlagValidateDescription() then RobloxTranslator:FormatByKey("InGame.CommonUI.Button.Ok") else RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.ResultModalOk"),
					inputIcon = p7.state.isGamepad and v7 or nil
				}
			}}
		}
	})
end

local function mapStateToProps(p8) -- line: 94
	return {
		resultModalType = p8.promptRequest.resultModalType
	}
end
local function mapDispatchToProps(p9) -- line: 100
	-- upvalues: CloseResultModal (copy)
	return {
		closeResultModal = function() -- line: 102
			-- upvalues: p9 (copy), CloseResultModal (copy)
			return p9(CloseResultModal)
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v17)
