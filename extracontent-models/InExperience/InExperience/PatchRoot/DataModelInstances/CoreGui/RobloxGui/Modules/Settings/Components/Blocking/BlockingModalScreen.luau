local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local Roact = require(CorePackages.Packages.Roact)
local Foundation = require(CorePackages.Packages.Foundation)
local BlockingModalContainer = require(script.Parent.BlockingModalContainer)
local renderWithCoreScriptsStyleProvider = require(RobloxGui.Modules.Common.renderWithCoreScriptsStyleProvider)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local useOverlay = Foundation.Hooks.useOverlay
local v13 = Roact.PureComponent:extend("BlockingModalScreen")

v13.validateProps = t.interface({
	closeModal = t.callback,
	player = t.interface({
		DisplayName = t.string,
		Name = t.string,
		UserId = t.number
	}),
	translator = t.optional(t.table),
	source = t.optional(t.string),
	onBlockingSuccess = t.optional(t.callback),
	overlay = t.optional(t.instanceIsA("GuiBase2d"))
})

function v13.render(p1) -- line: 33
	-- upvalues: Roact (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), BlockingModalContainer (copy), CoreGui (copy), renderWithCoreScriptsStyleProvider (copy)
	local overlay = p1.props.overlay
	local v17 = Roact.createElement(FocusRoot, {
		isIsolated = true,
		isAutoFocusRoot = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
	}, {
		BlockingModalContainerWrapper = Roact.createElement(BlockingModalContainer, p1.props)
	})
	local v18 = if overlay == nil then { Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		BlockingModalScreen = Roact.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			AutoLocalize = false,
			DisplayOrder = 6
		}, {
			BlockingModalContainer = v17
		})
	}) } else { Roact.createElement(Roact.Portal, {
		target = overlay
	}, {
		BlockingModalScreen = v17
	}) }

	return renderWithCoreScriptsStyleProvider(v18)
end

local function BlockingModalScreenWithFoundationOverlay(p2) -- line: 72
	-- upvalues: useOverlay (copy), Roact (copy), v13 (copy)
	local v20 = useOverlay()
	local v21 = table.clone(p2)

	v21.overlay = v20

	return Roact.createElement(v13, v21)
end

return BlockingModalScreenWithFoundationOverlay
