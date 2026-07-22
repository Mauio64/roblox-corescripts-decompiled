local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local InputType = require(CorePackages.Workspace.Packages.InputType)
local getInputGroup = require(CorePackages.Workspace.Packages.InputType).getInputGroup
local scriptParent = script.Parent
local PromptType = require(scriptParent.Parent.PromptType)
local PublishAssetPromptSingleStep = require(scriptParent.PublishAssetPromptSingleStep)
local PublishAvatarPrompt = require(scriptParent.PublishAvatarPrompt.PublishAvatarPrompt)
local PublishAvatarAssetPrompt = require(scriptParent.PublishAvatarAssetPrompt.PublishAvatarAssetPrompt)
local PublishMakeupLookPrompt = require(scriptParent.PublishMakeupLookPrompt.PublishMakeupLookPrompt)
local ResultModal = require(scriptParent.ResultModal)
local SelectionCursorProvider = require(CorePackages.Packages.UIBlox).App.SelectionImage.SelectionCursorProvider
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local v19 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local GetFFlagUploadMakeupSupport = require(scriptParent.Parent.Flags.GetFFlagUploadMakeupSupport)
local v25 = Roact.PureComponent:extend("PublishAssetPromptApp")

v25.validateProps = t.strictInterface({
	assetType = t.optional(t.enum(Enum.AssetType)),
	assetInstance = t.optional(t.Instance)
})

local function isGamepadInput(p1) -- line: 50
	-- upvalues: getInputGroup (copy), InputType (copy)
	return getInputGroup(p1) == InputType.InputTypeConstants.Gamepad
end

function v25.init(p2) -- line: 55
	p2:setState({
		screenSize = Vector2.new(0, 0)
	})

	function p2.absoluteSizeChanged(p3) -- line: 60
		-- upvalues: p2 (copy)
		if p2.state.screenSize ~= p3.AbsoluteSize then
			p2:setState({
				screenSize = p3.AbsoluteSize
			})
		end
	end

	p2.selectedCoreGuiObject = nil
	p2.selectedGuiObject = nil
end
function v25.render(p4) -- line: 72
	-- upvalues: Roact (copy), ResultModal (copy), PromptType (copy), PublishAssetPromptSingleStep (copy), PublishAvatarPrompt (copy), PublishAvatarAssetPrompt (copy), GetFFlagUploadMakeupSupport (copy), PublishMakeupLookPrompt (copy), ExternalEventConnection (copy), UserInputService (copy), getInputGroup (copy), InputType (copy), RoactGamepad (copy), SelectionCursorProvider (copy), ReactFocusNavigation (copy), v19 (copy), Provider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v31 = nil

	if p4.props.resultModalType then
		v31 = Roact.createElement(ResultModal, {
			screenSize = p4.state.screenSize
		})
	elseif p4.props.assetInstance then
		if p4.props.promptType == PromptType.PublishAssetSingleStep then
			v31 = Roact.createElement(PublishAssetPromptSingleStep, {
				screenSize = p4.state.screenSize
			})
		end
	elseif p4.props.promptType == PromptType.PublishAvatar then
		v31 = Roact.createElement(PublishAvatarPrompt, {
			screenSize = p4.state.screenSize
		})
	elseif p4.props.promptType == PromptType.PublishAvatarAsset then
		v31 = Roact.createElement(PublishAvatarAssetPrompt, {
			screenSize = p4.state.screenSize
		})
	elseif GetFFlagUploadMakeupSupport() and p4.props.promptType == PromptType.PublishMakeupLook then
		v31 = Roact.createElement(PublishMakeupLookPrompt, {
			screenSize = p4.state.screenSize
		})
	end

	if v31 == nil then
		return nil
	end

	return (Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		DisplayOrder = -1,
		[Roact.Change.AbsoluteSize] = p4.absoluteSizeChanged
	}, {
		LastInputTypeConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService.LastInputTypeChanged,
			callback = function(p5) -- line: 112
				-- upvalues: p4 (copy), getInputGroup (copy), InputType (copy)
				p4:setState({
					isGamepad = getInputGroup(p5) == InputType.InputTypeConstants.Gamepad
				})
			end
		}),
		PromptFrame = Roact.createElement(RoactGamepad.Focusable.Frame, {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			CursorProvider = Roact.createElement(SelectionCursorProvider, {}, {
				FocusNavigationProvider = Roact.createElement(ReactFocusNavigation.FocusNavigationContext.Provider, {
					value = v19
				}, {
					FocusNavigationRegistryProvider = Roact.createElement(Provider, nil, {
						FocusNavigationCoreScriptsWrapper = Roact.createElement(FocusRoot, {
							isIsolated = true,
							isAutoFocusRoot = true,
							surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView
						}, {
							Prompt = v31
						})
					})
				})
			})
		})
	}))
end

local function mapStateToProps(p6) -- line: 150
	return {
		resultModalType = p6.promptRequest.resultModalType,
		promptType = p6.promptRequest.promptInfo.promptType,
		assetInstance = p6.promptRequest.promptInfo.assetInstance,
		assetType = p6.promptRequest.promptInfo.assetType
	}
end

return RoactRodux.connect(mapStateToProps)(v25)
