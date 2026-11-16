local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection
local InputType = require(CorePackages.Workspace.Packages.InputType)
local InputType2 = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = InputType2.getInputGroup

local parent = script.Parent
local PromptType = require(parent.Parent.PromptType)
local PublishAssetPromptSingleStep = require(parent.PublishAssetPromptSingleStep)
local PublishAvatarPrompt = require(parent.PublishAvatarPrompt.PublishAvatarPrompt)
local PublishAvatarAssetPrompt = require(parent.PublishAvatarAssetPrompt.PublishAvatarAssetPrompt)
local PublishMakeupLookPrompt = require(parent.PublishMakeupLookPrompt.PublishMakeupLookPrompt)
local ResultModal = require(parent.ResultModal)

local UIBlox = require(CorePackages.Packages.UIBlox)
local SelectionCursorProvider = UIBlox.App.SelectionImage.SelectionCursorProvider
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

local focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local GetFFlagUploadMakeupSupport = require(parent.Parent.Flags.GetFFlagUploadMakeupSupport)

local extended = Roact.PureComponent:extend("PublishAssetPromptApp")

extended.validateProps = t.strictInterface({
	assetType = t.optional(t.enum(Enum.AssetType)),
	assetInstance = t.optional(t.Instance)
})

local function isGamepadInput(p): boolean -- 1 equivalent call inferred from this helper
	return getInputGroup(p) == InputType.InputTypeConstants.Gamepad
end

function extended:init()
	self:setState({ screenSize = Vector2.new(0, 0) })

	function self.absoluteSizeChanged(p)
		if self.state.screenSize ~= p.AbsoluteSize then
			self:setState({ screenSize = p.AbsoluteSize })
		end
	end

	self.selectedCoreGuiObject = nil
	self.selectedGuiObject = nil
end

function extended.render(props)
	local prompt = nil

	if props.props.resultModalType then
		prompt = Roact.createElement(ResultModal, { screenSize = props.state.screenSize })
	elseif props.props.assetInstance then
		if props.props.promptType == PromptType.PublishAssetSingleStep then
			prompt = Roact.createElement(PublishAssetPromptSingleStep, {
				screenSize = props.state.screenSize
			})
		end
	elseif props.props.promptType == PromptType.PublishAvatar then
		prompt = Roact.createElement(PublishAvatarPrompt, { screenSize = props.state.screenSize })
	elseif props.props.promptType == PromptType.PublishAvatarAsset then
		prompt = Roact.createElement(PublishAvatarAssetPrompt, {
			screenSize = props.state.screenSize
		})
	elseif GetFFlagUploadMakeupSupport() and props.props.promptType == PromptType.PublishMakeupLook then
		prompt = Roact.createElement(PublishMakeupLookPrompt, {
			screenSize = props.state.screenSize
		})
	end

	if prompt == nil then
		return nil
	end

	return (Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		DisplayOrder = -1,
		[Roact.Change.AbsoluteSize] = props.absoluteSizeChanged
	}, {
		LastInputTypeConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p)
				props:setState({ isGamepad = isGamepadInput(p) }) -- inferred equivalent call
			end
		}),
		PromptFrame = Roact.createElement(
			RoactGamepad.Focusable.Frame,
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) },
			{
				CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
					FocusNavigationProvider = Roact.createElement(
						ReactFocusNavigation.FocusNavigationContext.Provider,
						{ value = focusNavigationService },
						{
							FocusNavigationRegistryProvider = Roact.createElement(Provider, nil, {
								FocusNavigationCoreScriptsWrapper = Roact.createElement(
									FocusRoot,
									{
										surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView,
										isIsolated = true,
										isAutoFocusRoot = true
									},
									{ Prompt = prompt }
								)
							})
						}
					)
				})
			}
		)
	}))
end

local function mapStateToProps(p)
	return {
		resultModalType = p.promptRequest.resultModalType,
		promptType = p.promptRequest.promptInfo.promptType,
		assetInstance = p.promptRequest.promptInfo.assetInstance,
		assetType = p.promptRequest.promptInfo.assetType
	}
end

return RoactRodux.connect(mapStateToProps)(extended)
