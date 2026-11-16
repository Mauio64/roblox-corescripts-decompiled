local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local parent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local InitialView = require(parent.Components.InitialView)
local AssetDetails = require(parent.Components.AssetDetails)
local CloseButton = require(parent.Components.CloseButton)
local Overlay = require(parent.Components.Overlay)
local NoInventoryNotice = require(parent.Components.NoInventoryNotice)
local Colors = require(parent.Colors)
local Constants = require(parent.Constants)

local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)

local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)
local Constants2 = require(Modules.TopBar.Constants)

local InspectAndBuyContext = require(parent.Components.InspectAndBuyContext)

local extended = Roact.PureComponent:extend("Container")

function extended:init()
	self.frameRef = Roact.createRef()
	self.lastSavedSelectedCoreGui = nil
	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)
end

function extended:didMount()
	local gamepadEnabled = self.props.gamepadEnabled

	self.selectedCoreObjectChangedSignal = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function()
		if self.props.visible and GuiService.SelectedCoreObject then
			self.lastSavedSelectedCoreGui = GuiService.SelectedCoreObject
		end
	end)

	if gamepadEnabled then
		GuiService:AddSelectionParent("InspectMenu", self.frameRef.current)
	end
end

function extended.didUpdate(data, p)
	local visible = data.props.visible
	local gamepadEnabled = data.props.gamepadEnabled

	if visible and gamepadEnabled and data.frameRef.current then
		GuiService:RemoveSelectionGroup("InspectMenu")
		GuiService:AddSelectionParent("InspectMenu", data.frameRef.current)

		if data.lastSavedSelectedCoreGui then
			GuiService.SelectedCoreObject = data.lastSavedSelectedCoreGui
		end
	elseif not gamepadEnabled and p.gamepadEnabled or not visible then
		GuiService:RemoveSelectionGroup("InspectMenu")
	end

	if visible and not p.visible then
		GuiService.SelectedCoreObject = data.lastSavedSelectedCoreGui
	end
end

function extended.willUnmount(p)
	p.selectedCoreObjectChangedSignal:disconnect()
	GuiService:RemoveSelectionGroup("InspectMenu")
	GuiService.SelectedCoreObject = nil

	if p.disposeUiScaleEffect then
		p.disposeUiScaleEffect()
	end
end

function extended.render(props)
	local view = props.props.view
	local localPlayerModel = props.props.localPlayerModel
	local visible = props.props.visible
	local v = Theme.UseInspectAndBuyPanel()
	local v2 = Constants2.TopBarHeight * props.state.UiScale
	local v3 = Constants2.ScreenSideOffset * props.state.UiScale

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p)
			local v4 = p[view]
			local containerSize = v4.ContainerSize(props.state.UiScale)
			local containerPosition = v4.ContainerPosition(props.state.UiScale)

			local createElement = Roact.createElement

			local v5 = not v and 0 or v3 * -2
			local v7

			if v then
				v7 = Theme.DefaultCornerRadius.Offset
			else
				v7 = v2
			end

			local v6 = {
				Size = UDim2.new(1, v5, 1, v7),
				Position = UDim2.new(0, not v and 0 or v3, 0, v and 0 or -v2),
				BackgroundColor3 = v4.ContainerBackgroundColor,
				BackgroundTransparency = v4.ContainerBackgroundTransparency,
				Visible = visible,
				Selectable = false,
				AutoButtonColor = false,
				AutoLocalize = false,
				[Roact.Event.Activated] = function()
					if view == Constants.View.Wide then
						GuiService:CloseInspectMenu()
					end
				end
			}
			local uiCorner

			if v then
				uiCorner = Roact.createElement("UICorner", {
					CornerRadius = Theme.DefaultCornerRadius
				})
			end

			return createElement("ImageButton", v6, {
				UICorner = uiCorner,
				Overlay = Roact.createElement(Overlay),
				MainContainer = Roact.createElement("ImageButton", {
					AnchorPoint = v4.ContainerAnchorPoint,
					Size = containerSize,
					Position = containerPosition,
					BackgroundColor3 = Colors.Carbon,
					BorderSizePixel = 0,
					Active = true,
					AutoButtonColor = false,
					Selectable = false,
					[Roact.Ref] = props.frameRef
				}, {
					AspectRatioConstraint = v4.UseContainerAspectRatio and Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = v4.ContainerAspectRatio
					}),
					CloseButton = Roact.createElement(CloseButton),
					InitialView = Roact.createElement(InitialView),
					AssetDetails = Roact.createElement(AssetDetails, {
						localPlayerModel = localPlayerModel
					}),
					NoInventoryNotice = Roact.createElement(NoInventoryNotice)
				})
			})
		end
	})
end

return RoactRodux.UNSTABLE_connect2(function(data, _)
	return { view = data.view, visible = data.visible, gamepadEnabled = data.gamepadEnabled }
end)(extended)
