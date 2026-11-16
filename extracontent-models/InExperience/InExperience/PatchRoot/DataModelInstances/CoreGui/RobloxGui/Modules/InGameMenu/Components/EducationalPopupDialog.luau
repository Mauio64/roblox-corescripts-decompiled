local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local EducationalModal = InGameMenuDependencies.UIBlox.App.Dialog.Modal.EducationalModal
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local extended = Roact.PureComponent:extend("EducationalPopupDialog")

extended.validateProps = t.strictInterface({
	bodyContents = t.array(t.strictInterface({
		icon = t.optional(t.union(t.string, t.table)),
		text = t.string,
		layoutOrder = t.optional(t.integer),
		isSystemMenuIcon = t.optional(t.boolean)
	})),
	cancelText = t.string,
	confirmText = t.string,
	titleText = t.optional(t.string),
	titleBackgroundImageProps = t.strictInterface({
		image = t.string,
		imageHeight = t.number,
		text = t.optional(t.string)
	}),
	screenSize = t.Vector2,
	onDismiss = t.callback,
	onCancel = t.callback,
	onConfirm = t.callback,
	blurBackground = t.boolean,
	visible = t.boolean
})

extended.defaultProps = { blurBackground = false }

function extended.render(p)
	return withFoundationOrUIBloxStyle(function(p2)
		return {
			Theme = {
				Overlay = {
					Color = p2.Color.Common.Scrim.Color3,
					Transparency = p2.Color.Common.Scrim.Transparency
				}
			}
		}
	end, function(p2)
		return Roact.createElement(Roact.Portal, { target = CoreGui }, {
			InGameMenuEducationalPopupDialog = Roact.createElement(
				"ScreenGui",
				{
					IgnoreGuiInset = true,
					OnTopOfCoreBlur = p.props.blurBackground,
					Enabled = p.props.visible,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				},
				{
					Overlay = Roact.createElement("TextButton", {
						AutoButtonColor = false,
						BackgroundColor3 = p2.Theme.Overlay.Color,
						BackgroundTransparency = p2.Theme.Overlay.Transparency,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),
						Text = ""
					}),
					Popup = Roact.createElement(EducationalModal, {
						bodyContents = p.props.bodyContents,
						cancelText = p.props.cancelText,
						confirmText = p.props.confirmText,
						titleText = p.props.titleText,
						titleBackgroundImageProps = p.props.titleBackgroundImageProps,
						screenSize = p.props.screenSize,
						onDismiss = p.props.onDismiss,
						onCancel = p.props.onCancel,
						onConfirm = p.props.onConfirm
					})
				}
			)
		})
	end)
end

function extended:bindActions()
	local function dismissFunc(_, p, _)
		if p == Enum.UserInputState.Begin then
			self.props.onDismiss()
		end
	end

	ContextActionService:BindCoreAction("EducationalPopupConfirm", dismissFunc, false, Enum.KeyCode.Escape)
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("EducationalPopupConfirm")
end

function extended:updateBlur()
	local v = self.props.blurBackground and self.props.visible

	if v then
		local VRService = game:GetService("VRService")
		v = not VRService.VREnabled
	end

	RunService:SetRobloxGuiFocused(v)
end

function extended:didMount()
	self:updateBlur()

	if self.props.visible then
		self:bindActions()
	end
end

function extended:didUpdate()
	self:updateBlur()

	if self.props.visible then
		self:bindActions()
	else
		self:unbindActions()
	end
end

function extended:willUnmount()
	if self.props.blurBackground then
		RunService:SetRobloxGuiFocused(false)
	end

	self:unbindActions()
end

return extended
