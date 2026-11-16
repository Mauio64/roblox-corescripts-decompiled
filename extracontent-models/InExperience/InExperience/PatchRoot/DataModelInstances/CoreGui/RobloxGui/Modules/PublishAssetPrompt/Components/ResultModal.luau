local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local iconscontrolskeysxboxA = UIBlox.App.ImageSet.Images["icons/controls/keys/xboxA"]

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local InputType = require(CorePackages.Workspace.Packages.InputType)
local InputType2 = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = InputType2.getInputGroup

local parent = script.Parent.Parent
local CloseResultModal = require(parent.Thunks.CloseResultModal)
local v

if game:GetEngineFeature("EnableImagePublish") then
	v = Enum.PromptCreatePlatformContentResult
else
	v = Enum.PromptPublishAssetResult
end

local extended = Roact.PureComponent:extend("ResultModal")

extended.validateProps = t.strictInterface({
	screenSize = t.Vector2,
	resultModalType = t.enum(v),
	closeResultModal = t.callback
})

local function isGamepadInput(lastInputType): boolean -- 1 equivalent call inferred from this helper
	return getInputGroup(lastInputType) == InputType.InputTypeConstants.Gamepad
end

function extended.init(object)
	object:setState({
		isGamepad = isGamepadInput(UserInputService:GetLastInputType()) -- inferred equivalent call
	})
end

function extended:getLocalizedStringForResultPrompt(p)
	if p == v.Success then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PublishSuccessMessage")
	end

	if p == v.UploadFailed then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PublishFailed")
	end

	if p == v.NoUserInput then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.NoUserInput")
	end

	return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.UndefinedError", {
		RESULT_TYPE = tostring(p)
	})
end

function extended:getLocalizedTitleForResultPrompt(p)
	if p == v.Success then
		return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PublishSuccessTitle")
	end

	return RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.PublishFailedTitle")
end

function extended:render()
	return Roact.createElement(InteractiveAlert, {
		title = self:getLocalizedTitleForResultPrompt(self.props.resultModalType),
		bodyText = self:getLocalizedStringForResultPrompt(self.props.resultModalType),
		screenSize = self.props.screenSize,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = self.props.closeResultModal,
						text = RobloxTranslator:FormatByKey("CoreScripts.PublishAssetPrompt.ResultModalOk"),
						inputIcon = self.state.isGamepad and iconscontrolskeysxboxA or nil
					}
				}
			}
		}
	})
end

local function mapStateToProps(p)
	return { resultModalType = p.promptRequest.resultModalType }
end

local function mapDispatchToProps(callback)
	return {
		closeResultModal = function()
			return callback(CloseResultModal)
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
