local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local InitialView = require(ParentParent.Components.InitialView)
local AssetDetails = require(ParentParent.Components.AssetDetails)
local CloseButton = require(ParentParent.Components.CloseButton)
local Overlay = require(ParentParent.Components.Overlay)
local NoInventoryNotice = require(ParentParent.Components.NoInventoryNotice)
local Colors = require(ParentParent.Colors)
local Constants = require(ParentParent.Constants)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Theme = require(Modules.Settings.Theme)
local Constants2 = require(Modules.TopBar.Constants)
local InspectAndBuyContext = require(ParentParent.Components.InspectAndBuyContext)
local v19 = Roact.PureComponent:extend("Container")

function v19.init(p1) -- line: 26
	-- upvalues: Roact (copy), Signals (copy), Display (copy)
	p1.frameRef = Roact.createRef()
	p1.lastSavedSelectedCoreGui = nil
	p1.disposeUiScaleEffect = Signals.createEffect(function(p2) -- line: 29
		-- upvalues: Display (copy), p1 (copy)
		local v38 = Display.GetDisplayStore(p2)

		p1:setState({
			UiScale = v38.getUIScale(p2)
		})
	end)
end
function v19.didMount(p3) -- line: 37
	-- upvalues: GuiService (copy)
	local gamepadEnabled = p3.props.gamepadEnabled

	p3.selectedCoreObjectChangedSignal = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(function() -- line: 40
		-- upvalues: p3 (copy), GuiService (copy)
		if p3.props.visible and GuiService.SelectedCoreObject then
			p3.lastSavedSelectedCoreGui = GuiService.SelectedCoreObject
		end
	end)

	if gamepadEnabled then
		GuiService:AddSelectionParent("InspectMenu", p3.frameRef.current)
	end
end
function v19.didUpdate(p4, p5) -- line: 52
	-- upvalues: GuiService (copy)
	local visible = p4.props.visible
	local gamepadEnabled = p4.props.gamepadEnabled

	if visible and (gamepadEnabled and p4.frameRef.current) then
		GuiService:RemoveSelectionGroup("InspectMenu")
		GuiService:AddSelectionParent("InspectMenu", p4.frameRef.current)

		if p4.lastSavedSelectedCoreGui then
			GuiService.SelectedCoreObject = p4.lastSavedSelectedCoreGui
		end
	elseif not gamepadEnabled and p5.gamepadEnabled or not visible then
		GuiService:RemoveSelectionGroup("InspectMenu")
	end

	if visible and not p5.visible then
		GuiService.SelectedCoreObject = p4.lastSavedSelectedCoreGui
	end
end
function v19.willUnmount(p6) -- line: 72
	-- upvalues: GuiService (copy)
	p6.selectedCoreObjectChangedSignal:disconnect()
	GuiService:RemoveSelectionGroup("InspectMenu")
	GuiService.SelectedCoreObject = nil

	if p6.disposeUiScaleEffect then
		p6.disposeUiScaleEffect()
	end
end
function v19.render(p7) -- line: 81
	-- upvalues: Theme (copy), Constants2 (copy), Roact (copy), InspectAndBuyContext (copy), Constants (copy), GuiService (copy), Overlay (copy), Colors (copy), CloseButton (copy), InitialView (copy), AssetDetails (copy), NoInventoryNotice (copy)
	local view = p7.props.view
	local localPlayerModel = p7.props.localPlayerModel
	local visible = p7.props.visible
	local v32 = Theme.UseInspectAndBuyPanel()
	local v33 = Constants2.TopBarHeight * p7.state.UiScale
	local v34 = Constants2.ScreenSideOffset * p7.state.UiScale

	return Roact.createElement(InspectAndBuyContext.Consumer, {
		render = function(p8) -- line: 90
			-- upvalues: view (copy), p7 (copy), Roact (copy), v32 (copy), v34 (copy), Theme (copy), v33 (copy), visible (copy), Constants (copy), GuiService (copy), Overlay (copy), Colors (copy), CloseButton (copy), InitialView (copy), AssetDetails (copy), localPlayerModel (copy), NoInventoryNotice (copy)
			local v40 = p8[view]
			local v41 = v40.ContainerSize(p7.state.UiScale)
			local v42 = v40.ContainerPosition(p7.state.UiScale)

			return Roact.createElement("ImageButton", {
				Size = UDim2.new(1, not v32 and 0 or v34 * -2, 1, if not v32 then v33 else Theme.DefaultCornerRadius.Offset),
				Position = UDim2.new(0, not v32 and 0 or v34, 0, if not v32 then -v33 else 0),
				BackgroundColor3 = v40.ContainerBackgroundColor,
				BackgroundTransparency = v40.ContainerBackgroundTransparency,
				Visible = visible,
				Selectable = false,
				AutoButtonColor = false,
				AutoLocalize = false,
				[Roact.Event.Activated] = function() -- line: 114
					-- upvalues: view (copy), Constants (copy), GuiService (copy)
					if view == Constants.View.Wide then
						GuiService:CloseInspectMenu()
					end
				end
			}, {
				UICorner = if not v32 then nil else Roact.createElement("UICorner", {
					CornerRadius = Theme.DefaultCornerRadius
				}),
				Overlay = Roact.createElement(Overlay),
				MainContainer = Roact.createElement("ImageButton", {
					AnchorPoint = v40.ContainerAnchorPoint,
					Size = v41,
					Position = v42,
					BackgroundColor3 = Colors.Carbon,
					BorderSizePixel = 0,
					Active = true,
					AutoButtonColor = false,
					Selectable = false,
					[Roact.Ref] = p7.frameRef
				}, {
					AspectRatioConstraint = v40.UseContainerAspectRatio and Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = v40.ContainerAspectRatio
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

return RoactRodux.UNSTABLE_connect2(function(p9, _) -- line: 153
	return {
		view = p9.view,
		visible = p9.visible,
		gamepadEnabled = p9.gamepadEnabled
	}
end)(v19)
