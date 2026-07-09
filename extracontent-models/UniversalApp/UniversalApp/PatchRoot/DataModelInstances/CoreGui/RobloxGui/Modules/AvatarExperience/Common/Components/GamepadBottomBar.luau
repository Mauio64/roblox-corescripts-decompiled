local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Cryo = require(CorePackages.Packages.Cryo)
local Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text
local UIBlox = require(CorePackages.Packages.UIBlox)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local FitFrameHorizontal = AvatarExperienceDeps.RoactFitComponents.FitFrameHorizontal
local withStyle = UIBlox.Style.withStyle
local SpringAnimatedItem = UIBlox.Utility.SpringAnimatedItem
local GamepadBottomBarContent = require(Modules.AvatarExperience.Common.Components.GamepadBottomBarContent)
local GamepadBottomBarElement = require(Modules.AvatarExperience.Common.Components.GamepadBottomBarElement)
local Constants = require(Modules.LuaApp.Constants)
local ScreenGuiWithBlurControl = require(Modules.LuaApp.Components.ScreenGuiWithBlurControl)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local t1 = {
	dampingRatio = 1,
	frequency = 2.5
}
local v21 = Roact.PureComponent:extend("GamepadBottomBar")

v21.validateProps = t.strictInterface({
	displayOrder = t.number,
	hideGamepadBottomBar = t.optional(t.boolean),
	boundInputs = t.table,
	screenSize = t.Vector2
})
v21.defaultProps = {
	hideGamepadBottomBar = false
}

function v21.getDerivedStateFromProps(p1, _) -- line: 54
	-- upvalues: Utils (copy), Constants (copy)
	local v24 = Utils.getNumElementsWithKeyField(p1.boundInputs) > 0

	return {
		showBar = v24,
		height = v24 and Constants.GAMEPAD_BOTTOM_BAR_SIZE or Constants.GAMEPAD_BOTTOM_BAR_SIZE / 2
	}
end
function v21.renderWithLocalization(p3, p4) -- line: 63
	-- upvalues: withStyle (copy), Text (copy), UIBlox (copy), Roact (copy), CoreGui (copy), ScreenGuiWithBlurControl (copy), SpringAnimatedItem (copy), Constants (copy), t1 (copy), GamepadBottomBarElement (copy), FitFrameHorizontal (copy), GamepadBottomBarContent (copy)
	if not p3.state.showBar then
		return nil
	end

	return withStyle(function(p5) -- line: 67
		-- upvalues: p4 (copy), Text (copy), UIBlox (copy), Roact (copy), CoreGui (copy), ScreenGuiWithBlurControl (copy), p3 (copy), SpringAnimatedItem (copy), Constants (copy), t1 (copy), GamepadBottomBarElement (copy), FitFrameHorizontal (copy), GamepadBottomBarContent (copy)
		local Theme = p5.Theme
		local p5Font = p5.Font
		local Header2Font = p5Font.Header2.Font
		local v36 = p5Font.BaseSize * p5Font.Header2.RelativeSize
		local v37 = p4.bText or p4.backText
		local v38 = Text.GetTextWidth(v37, Header2Font, v36)
		local v39 = 24 + (UIBlox.App.Constant.IconSize.Regular + v38 + 8) + 36

		return Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			PortalUIForGamepadBottomBar = Roact.createElement(ScreenGuiWithBlurControl, {
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				DisplayOrder = p3.props.displayOrder,
				Enabled = not p3.props.hideGamepadBottomBar
			}, {
				AnimatedFrame = Roact.createElement(SpringAnimatedItem.AnimatedFrame, {
					regularProps = {
						ZIndex = 3,
						AnchorPoint = Vector2.new(0, 0),
						Position = UDim2.new(0, 0, 0, 0),
						BackgroundColor3 = Theme.BackgroundUIContrast.Color,
						BackgroundTransparency = Theme.BackgroundUIContrast.Transparency,
						Size = UDim2.new(1, 0, 0, Constants.GAMEPAD_BOTTOM_BAR_SIZE)
					},
					animatedValues = {
						positionY = p3.state.height
					},
					mapValuesToProps = function(p6) -- line: 99
						return {
							Position = UDim2.new(0, 0, 1, -p6.positionY)
						}
					end,
					springOptions = t1
				}, {
					BackElement = Roact.createElement(GamepadBottomBarElement, {
						elementIcon = "rbxasset://textures/ui/Controls/DesignSystem/ButtonB.png",
						elementText = v37,
						position = UDim2.new(0, 24, 0, 0)
					}),
					UIElementsFrame = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						ClipsDescendants = true,
						Position = UDim2.new(0, v39, 0, 0),
						Size = UDim2.new(1, -v39, 1, 0)
					}, {
						UIElements = Roact.createElement(FitFrameHorizontal, {
							BackgroundTransparency = 1,
							height = UDim.new(1, 0),
							FillDirection = Enum.FillDirection.Horizontal,
							AnchorPoint = Vector2.new(1, 0),
							Position = UDim2.new(1, -24, 0, 0),
							contentPadding = UDim.new(0, 36)
						}, {
							GamepadBottomBarElements = Roact.createElement(GamepadBottomBarContent, {
								width = p3.props.screenSize.X - v39,
								boundInputs = p3.props.boundInputs
							})
						})
					})
				})
			})
		})
	end)
end
function v21.render(p7) -- line: 140
	-- upvalues: Cryo (copy), withLocalization (copy)
	local t2 = {
		backText = "CommonUI.Controls.Action.Back"
	}
	local v29 = p7.props.boundInputs[Enum.KeyCode.ButtonB]

	if v29 and v29.key then
		t2 = Cryo.Dictionary.join(t2, {
			bText = v29.key
		})
	end

	return withLocalization(t2)(function(p8) -- line: 153
		-- upvalues: p7 (copy)
		return p7:renderWithLocalization(p8)
	end)
end

return (RoactRodux.connect(function(p9, _) -- line: 158
	return {
		boundInputs = p9.GamepadBottomBar.boundInputs,
		screenSize = p9.ScreenSize
	}
end)(v21))
