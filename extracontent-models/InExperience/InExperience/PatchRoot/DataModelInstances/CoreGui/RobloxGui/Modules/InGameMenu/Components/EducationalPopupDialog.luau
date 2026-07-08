local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local EducationalModal = UIBlox.App.Dialog.Modal.EducationalModal
local withStyle = UIBlox.Core.Style.withStyle
local v11 = Roact.PureComponent:extend("EducationalPopupDialog")

v11.validateProps = t.strictInterface({
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
v11.defaultProps = {
	blurBackground = false
}

function v11.render(p1) -- line: 47
	-- upvalues: withStyle (copy), Roact (copy), CoreGui (copy), EducationalModal (copy)
	return withStyle(function(p2) -- line: 48
		-- upvalues: Roact (copy), CoreGui (copy), p1 (copy), EducationalModal (copy)
		return Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			InGameMenuEducationalPopupDialog = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = p1.props.blurBackground,
				Enabled = p1.props.visible,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Overlay = Roact.createElement("TextButton", {
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Text = "",
					BackgroundColor3 = p2.Theme.Overlay.Color,
					BackgroundTransparency = p2.Theme.Overlay.Transparency,
					Size = UDim2.fromScale(1, 1)
				}),
				Popup = Roact.createElement(EducationalModal, {
					bodyContents = p1.props.bodyContents,
					cancelText = p1.props.cancelText,
					confirmText = p1.props.confirmText,
					titleText = p1.props.titleText,
					titleBackgroundImageProps = p1.props.titleBackgroundImageProps,
					screenSize = p1.props.screenSize,
					onDismiss = p1.props.onDismiss,
					onCancel = p1.props.onCancel,
					onConfirm = p1.props.onConfirm
				})
			})
		})
	end)
end
function v11.bindActions(p3) -- line: 83
	-- upvalues: ContextActionService (copy)
	local function dismissFunc(_, p5, _) -- line: 84
		-- upvalues: p3 (copy)
		if p5 == Enum.UserInputState.Begin then
			p3.props.onDismiss()
		end
	end

	ContextActionService:BindCoreAction("EducationalPopupConfirm", dismissFunc, false, Enum.KeyCode.Escape)
end
function v11.unbindActions(_) -- line: 93
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("EducationalPopupConfirm")
end
function v11.updateBlur(p8) -- line: 97
	-- upvalues: RunService (copy)
	local v17 = p8.props.blurBackground and p8.props.visible and not game:GetService("VRService").VREnabled

	RunService:SetRobloxGuiFocused(v17)
end
function v11.didMount(p9) -- line: 104
	p9:updateBlur()

	if p9.props.visible then
		p9:bindActions()
	end
end
function v11.didUpdate(p10) -- line: 112
	p10:updateBlur()

	if p10.props.visible then
		p10:bindActions()

		return
	end

	p10:unbindActions()
end
function v11.willUnmount(p11) -- line: 122
	-- upvalues: RunService (copy)
	if p11.props.blurBackground then
		RunService:SetRobloxGuiFocused(false)
	end

	p11:unbindActions()
end

return v11
