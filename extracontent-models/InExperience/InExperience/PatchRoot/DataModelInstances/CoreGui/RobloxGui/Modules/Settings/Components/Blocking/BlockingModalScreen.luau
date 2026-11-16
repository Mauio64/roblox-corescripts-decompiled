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

local extended = Roact.PureComponent:extend("BlockingModalScreen")

extended.validateProps = t.interface({
	closeModal = t.callback,
	player = t.interface({ DisplayName = t.string, Name = t.string, UserId = t.number }),
	translator = t.optional(t.table),
	source = t.optional(t.string),
	onBlockingSuccess = t.optional(t.callback),
	overlay = t.optional(t.instanceIsA("GuiBase2d"))
})

function extended.render(p)
	local overlay = p.props.overlay

	local element = Roact.createElement(
		FocusRoot,
		{
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
			isIsolated = true,
			isAutoFocusRoot = true
		},
		{
			BlockingModalContainerWrapper = Roact.createElement(BlockingModalContainer, p.props)
		}
	)
	local v

	if overlay == nil then
		v = { Roact.createElement(Roact.Portal, { target = CoreGui }, {
				BlockingModalScreen = Roact.createElement(
					"ScreenGui",
					{ IgnoreGuiInset = true, AutoLocalize = false, DisplayOrder = 6 },
					{ BlockingModalContainer = element }
				)
			}) }
	else
		v = { Roact.createElement(Roact.Portal, { target = overlay }, {
				BlockingModalScreen = element
			}) }
	end

	return renderWithCoreScriptsStyleProvider(v)
end

local function BlockingModalScreenWithFoundationOverlay(p)
	local overlay = useOverlay()
	local clone = table.clone(p)
	clone.overlay = overlay

	return Roact.createElement(extended, clone)
end

return BlockingModalScreenWithFoundationOverlay
