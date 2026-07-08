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
local ResultModal = require(scriptParent.ResultModal)
local SelectionCursorProvider = require(CorePackages.Packages.UIBlox).App.SelectionImage.SelectionCursorProvider
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local v18 = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local v23 = Roact.PureComponent:extend("PublishAssetPromptApp")

v23.validateProps = t.strictInterface({
	assetType = t.optional(t.enum(Enum.AssetType)),
	assetInstance = t.optional(t.Instance)
})

local function isGamepadInput(p1) -- line: 47
	-- upvalues: getInputGroup (copy), InputType (copy)
	return getInputGroup(p1) == InputType.InputTypeConstants.Gamepad
end

function v23.init(p2) -- line: 52
	p2:setState({
		screenSize = Vector2.new(0, 0)
	})

	function p2.absoluteSizeChanged(p3) -- line: 57
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
function v23.render(p4) -- line: 69
	-- upvalues: Roact (copy), ResultModal (copy), PromptType (copy), PublishAssetPromptSingleStep (copy), PublishAvatarPrompt (copy), PublishAvatarAssetPrompt (copy), ExternalEventConnection (copy), UserInputService (copy), getInputGroup (copy), InputType (copy), RoactGamepad (copy), SelectionCursorProvider (copy), ReactFocusNavigation (copy), v18 (copy), Provider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v29 = nil

	if p4.props.resultModalType then
		v29 = Roact.createElement(ResultModal, {
			screenSize = p4.state.screenSize
		})
	elseif p4.props.assetInstance then
		if p4.props.promptType == PromptType.PublishAssetSingleStep then
			v29 = Roact.createElement(PublishAssetPromptSingleStep, {
				screenSize = p4.state.screenSize
			})
		end
	elseif p4.props.promptType == PromptType.PublishAvatar then
		v29 = Roact.createElement(PublishAvatarPrompt, {
			screenSize = p4.state.screenSize
		})
	elseif p4.props.promptType == PromptType.PublishAvatarAsset then
		v29 = Roact.createElement(PublishAvatarAssetPrompt, {
			screenSize = p4.state.screenSize
		})
	end

	if v29 == nil then
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
			callback = function(p5) -- line: 105
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
					value = v18
				}, {
					FocusNavigationRegistryProvider = Roact.createElement(Provider, nil, {
						FocusNavigationCoreScriptsWrapper = Roact.createElement(FocusRoot, {
							isIsolated = true,
							isAutoFocusRoot = true,
							surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.RouterView
						}, {
							Prompt = v29
						})
					})
				})
			})
		})
	}))
end

local function mapStateToProps(p6) -- line: 143
	return {
		resultModalType = p6.promptRequest.resultModalType,
		promptType = p6.promptRequest.promptInfo.promptType,
		assetInstance = p6.promptRequest.promptInfo.assetInstance,
		assetType = p6.promptRequest.promptInfo.assetType
	}
end

return RoactRodux.connect(mapStateToProps)(v23)
