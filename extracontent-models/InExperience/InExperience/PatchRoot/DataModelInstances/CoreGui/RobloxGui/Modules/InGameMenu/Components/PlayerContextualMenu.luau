local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local BaseMenu = UIBlox.App.Menu.BaseMenu
local ParentParent = script.Parent.Parent
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local RootedConnection = require(script.Parent.Connection.RootedConnection)
local Flags = ParentParent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(Flags.GetFFlagIGMGamepadSelectionHistory)
local v15 = Roact.PureComponent:extend("PlayerContextualMenu")

v15.validateProps = t.strictInterface({
	moreActions = t.table,
	actionWidth = t.number,
	xOffset = t.number,
	yOffset = t.number,
	onClose = t.callback,
	canCaptureFocus = t.boolean
})

function v15.init(p1) -- line: 36
	-- upvalues: Roact (copy)
	p1.firstOptionRef = Roact.createRef()
	p1.containerRef = Roact.createRef()
end
function v15.renderContextualMenuFocusHandler(p2, p3, p4) -- line: 41
	-- upvalues: Roact (copy), FocusHandler (copy), ContextActionService (copy), GuiService (copy), GetFFlagIGMGamepadSelectionHistory (copy)
	local v20 = p2.props.canCaptureFocus and p3

	return Roact.createElement(FocusHandler, {
		isFocused = v20,
		didFocus = function(p5) -- line: 47
			-- upvalues: ContextActionService (copy), p2 (copy), GuiService (copy), GetFFlagIGMGamepadSelectionHistory (copy)
			ContextActionService:BindCoreAction("player_contextual_menu_close_action", function(_, p7) -- line: 48
				-- upvalues: p2 (copy)
				if p7 == Enum.UserInputState.End and p2.props.onClose then
					p2.props.onClose()

					return Enum.ContextActionResult.Sink
				end

				return Enum.ContextActionResult.Pass
			end, false, Enum.KeyCode.ButtonB)
			GuiService:RemoveSelectionGroup("player_contextual_menu_selection_parent")
			GuiService:AddSelectionParent("player_contextual_menu_selection_parent", p2.containerRef:getValue())

			if GetFFlagIGMGamepadSelectionHistory() then
				GuiService.SelectedCoreObject = p5 or p2.firstOptionRef:getValue()

				return
			end

			GuiService.SelectedCoreObject = p2.firstOptionRef:getValue()
		end,
		didBlur = function() -- line: 68
			-- upvalues: ContextActionService (copy)
			ContextActionService:UnbindCoreAction("player_contextual_menu_close_action")
		end
	}, p4)
end
function v15.render(p8) -- line: 74
	-- upvalues: Roact (copy), CoreGui (copy), RootedConnection (copy), BaseMenu (copy)
	return Roact.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		InGameMenuContextGui = Roact.createElement("ScreenGui", {
			DisplayOrder = 2,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			RootedConnection = Roact.createElement(RootedConnection, {
				render = function(p9) -- line: 84
					-- upvalues: p8 (copy), Roact (copy), BaseMenu (copy)
					return p8:renderContextualMenuFocusHandler(p9, {
						MoreActionsMenu = Roact.createElement("Frame", {
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							[Roact.Ref] = p8.containerRef
						}, {
							BaseMenu = Roact.createElement(BaseMenu, {
								buttonProps = p8.props.moreActions,
								setFirstItemRef = p8.firstOptionRef,
								width = UDim.new(0, p8.props.actionWidth),
								position = UDim2.fromOffset(p8.props.xOffset, p8.props.yOffset)
							})
						})
					})
				end
			})
		})
	})
end

return v15
