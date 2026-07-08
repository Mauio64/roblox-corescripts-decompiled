local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Localization = require(Parent.Localization)
local UIBlox = require(Parent.UIBlox)
local useLocalization = Localization.Hooks.useLocalization
local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local Button = Foundation.Button
local InputSize = Foundation.Enums.InputSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), useLocalization (copy), useSelector (copy), React (copy), ModalWindow (copy), View (copy), Icon (copy), IconName (copy), FoundationText (copy), Button (copy), InputSize (copy)
	local v17 = useTokens()
	local v18 = useLocalization({
		modalTitle = "Feature.Durables.InfoModal.Title",
		modalDescription = "Feature.Durables.InfoModal.Description",
		actionOK = "CommonUI.Messages.Action.OK"
	})
	local v19 = useSelector(function(p1) -- line: 35
		return p1.ScreenSize
	end)

	return React.createElement(ModalWindow, {
		isFullHeight = false,
		screenSize = v19
	}, {
		Body = React.createElement(View, {
			tag = "size-full-0 auto-y padding-large col gap-large",
			BackgroundTransparency = 1
		}, {
			IconContainer = React.createElement(View, {
				tag = "size-full-0 auto-y align-x-center margin-top-medium margin-bottom-medium",
				LayoutOrder = 0
			}, {
				InnerContainer = React.createElement(View, {
					tag = "size-2000-2000 auto-xy",
					BackgroundTransparency = 1
				}, {
					RotatedSquare = React.createElement(View, {
						tag = "size-full radius-small stroke-default stroke-thicker",
						BackgroundTransparency = 1,
						Rotation = 25,
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5)
					}, {
						IconWrapper = React.createElement(View, {
							tag = "size-full",
							BackgroundTransparency = 1
						}, {
							ClockIcon = React.createElement(Icon, {
								Rotation = -25,
								name = IconName.Clock,
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5, 0.5),
								size = v17.Size.Size_600
							})
						})
					})
				})
			}),
			Title = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-align-x-left text-heading-medium",
				LayoutOrder = 1,
				Text = v18.modalTitle
			}),
			Description = React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-wrap text-truncate-none text-align-x-left text-body-medium",
				RichText = true,
				LayoutOrder = 2,
				Text = v18.modalDescription
			}),
			CloseButton = React.createElement(Button, {
				LayoutOrder = 5,
				tag = "size-full-0 auto-y",
				testId = "theCloseButton",
				text = v18.actionOK,
				size = InputSize.Medium,
				width = UDim.new(1, 0),
				onActivated = t1.onClose
			})
		})
	})
end
