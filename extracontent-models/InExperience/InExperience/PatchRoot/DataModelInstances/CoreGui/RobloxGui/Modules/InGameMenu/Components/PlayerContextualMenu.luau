local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local BaseMenu = UIBlox.App.Menu.BaseMenu

local parent = script.Parent.Parent

local FocusHandler = require(script.Parent.Connection.FocusHandler)
local RootedConnection = require(script.Parent.Connection.RootedConnection)

local flags = parent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(flags.GetFFlagIGMGamepadSelectionHistory)

local extended = Roact.PureComponent:extend("PlayerContextualMenu")

extended.validateProps = t.strictInterface({
	moreActions = t.table,
	actionWidth = t.number,
	xOffset = t.number,
	yOffset = t.number,
	onClose = t.callback,
	canCaptureFocus = t.boolean
})

function extended:init()
	self.firstOptionRef = Roact.createRef()
	self.containerRef = Roact.createRef()
end

function extended:renderContextualMenuFocusHandler(p, p2)
	local isFocused = self.props.canCaptureFocus and p

	return Roact.createElement(FocusHandler, {
		isFocused = isFocused,
		didFocus = function(p3)
			ContextActionService:BindCoreAction("player_contextual_menu_close_action", function(_, p4)
				if p4 ~= Enum.UserInputState.End or not self.props.onClose then
					return Enum.ContextActionResult.Pass
				end

				self.props.onClose()
				return Enum.ContextActionResult.Sink
			end, false, Enum.KeyCode.ButtonB)

			GuiService:RemoveSelectionGroup("player_contextual_menu_selection_parent")

			GuiService:AddSelectionParent("player_contextual_menu_selection_parent", self.containerRef:getValue())

			if GetFFlagIGMGamepadSelectionHistory() then
				GuiService.SelectedCoreObject = p3 or self.firstOptionRef:getValue()
			else
				GuiService.SelectedCoreObject = self.firstOptionRef:getValue()
			end
		end,
		didBlur = function()
			ContextActionService:UnbindCoreAction("player_contextual_menu_close_action")
		end
	}, p2)
end

function extended.render(props)
	return Roact.createElement(Roact.Portal, { target = CoreGui }, {
		InGameMenuContextGui = Roact.createElement(
			"ScreenGui",
			{ DisplayOrder = 2, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
			{
				RootedConnection = Roact.createElement(RootedConnection, {
					render = function(p)
						return props:renderContextualMenuFocusHandler(p, {
							MoreActionsMenu = Roact.createElement(
								"Frame",
								{
									Size = UDim2.fromScale(1, 1),
									BackgroundTransparency = 1,
									[Roact.Ref] = props.containerRef
								},
								{
									BaseMenu = Roact.createElement(BaseMenu, {
										buttonProps = props.props.moreActions,
										setFirstItemRef = props.firstOptionRef,
										width = UDim.new(0, props.props.actionWidth),
										position = UDim2.fromOffset(props.props.xOffset, props.props.yOffset)
									})
								}
							)
						})
					end
				})
			}
		)
	})
end

return extended
