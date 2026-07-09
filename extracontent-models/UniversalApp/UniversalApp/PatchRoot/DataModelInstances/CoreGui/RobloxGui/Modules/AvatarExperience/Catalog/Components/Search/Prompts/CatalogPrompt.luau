local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local withNavigation = require(CorePackages.Packages.RoactNavigation).withNavigation
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local v16 = Roact.PureComponent:extend("CatalogPrompt")

function v16.init(p1) -- line: 25
	-- upvalues: Roact (copy)
	p1.state = {
		apply = false
	}
	p1.buttonStackRef = Roact.createRef()
end

v16.validateProps = t.strictInterface({
	title = t.string,
	onApply = t.callback,
	contentPadding = t.optional(t.UDim),
	[Roact.Children] = t.table,
	secondaryButtonProps = t.optional(t.table),
	forwardRef = t.optional(t.table),
	NextSelectionUp = t.optional(t.table),
	NextSelectionDown = t.optional(t.table),
	NextSelectionLeft = t.optional(t.table),
	NextSelectionRight = t.optional(t.table),
	disablePrimaryButton = t.optional(t.boolean),
	overlayFocusController = t.optional(t.table),
	isPortrait = t.boolean,
	screenSize = t.Vector2,
	navigation = t.table
})
v16.defaultProps = {
	disablePrimaryButton = false,
	contentPadding = UDim.new(0, 0)
}

function v16.onClose(p2, p3) -- line: 60
	-- upvalues: NavigationUtils (copy)
	if p3 then
		p2.props.onApply()
	end

	NavigationUtils.closeOverlay(p2.props.navigation)
end
function v16.render(p4) -- line: 67
	-- upvalues: withStyle (copy), withLocalization (copy), ButtonType (copy), Roact (copy), Focusable (copy), PartialPageModal (copy)
	return withStyle(function(_) -- line: 68
		-- upvalues: withLocalization (copy), p4 (copy), ButtonType (copy), Roact (copy), Focusable (copy), PartialPageModal (copy)
		return withLocalization({
			apply = "CommonUI.Messages.Action.Apply"
		})(function(p6) -- line: 71
			-- upvalues: p4 (copy), ButtonType (copy), Roact (copy), Focusable (copy), PartialPageModal (copy)
			local uDim2, vector2

			if p4.props.isPortrait then
				uDim2 = UDim2.new(0.5, 0, 1, 0)
				vector2 = Vector2.new(0.5, 1)
			else
				uDim2 = UDim2.new(0.5, 0, 0.5, 0)
				vector2 = Vector2.new(0.5, 0.5)
			end

			local t1 = {}

			if p4.props.secondaryButtonProps then
				table.insert(t1, p4.props.secondaryButtonProps)
			end

			table.insert(t1, {
				buttonType = ButtonType.PrimarySystem,
				props = {
					isDisabled = p4.props.disablePrimaryButton,
					onActivated = function() -- line: 89
						-- upvalues: p4 (copy)
						p4:onClose(true)
					end,
					text = p6.apply
				}
			})

			local forwardRef = p4.props.forwardRef

			return Roact.createElement(Focusable.Frame, {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				[Roact.Ref] = forwardRef,
				defaultChild = p4.buttonStackRef
			}, {
				PartialPageModal = Roact.createElement(PartialPageModal, {
					title = p4.props.title,
					screenSize = p4.props.screenSize,
					position = uDim2,
					anchorPoint = vector2,
					contentPadding = p4.props.contentPadding,
					buttonStackProps = {
						buttons = t1,
						frameRef = p4.buttonStackRef,
						NextSelectionUp = p4.props.NextSelectionUp
					},
					onCloseClicked = function() -- line: 115
						-- upvalues: p4 (copy)
						p4:onClose()
					end
				}, p4.props[Roact.Children])
			})
		end)
	end)
end

local u17 = withNavigation((RoactRodux.connect(function(p7) -- line: 124
	-- upvalues: DeviceOrientationMode (copy)
	return {
		isPortrait = p7.DeviceOrientation == DeviceOrientationMode.Portrait,
		screenSize = p7.ScreenSize
	}
end, nil)(v16)))

return Roact.forwardRef(function(p8, p9) -- line: 136
	-- upvalues: Roact (copy), u17 (ref), Cryo (copy)
	return Roact.createElement(u17, Cryo.Dictionary.join(p8, {
		forwardRef = p9
	}))
end)
