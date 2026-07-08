local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FFlagAvatarSwitcherUiFixes = require(Parent.AvatarExperienceFlags).FFlagAvatarSwitcherUiFixes

local function MessageCard(t1: {[any]: any}) -- line: 20
	-- upvalues: useTokens (copy), React (copy), Foundation (copy), FFlagAvatarSwitcherUiFixes (copy)
	local Size_800 = useTokens().Size.Size_800

	return React.createElement(Foundation.View, {
		tag = "col gap-medium stroke-default bg-shift-100 radius-medium padding-large",
		Size = t1.Size,
		AutomaticSize = t1.AutomaticSize
	}, {
		Header = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y row align-y-center gap-small"
		}, {
			Image = React.createElement(Foundation.Image, {
				LayoutOrder = 1,
				tag = t1.icon ~= "Info" and "content-system-warning" or "",
				Image = t1.icon ~= "Info" and "icons/status/alert" or "icons/actions/info",
				Size = UDim2.fromOffset(Size_800, Size_800)
			}),
			HeaderText = React.createElement(Foundation.Text, {
				tag = "auto-y text-align-x-left anchor-center-right text-title-medium text-wrap grow",
				LayoutOrder = 2,
				Text = t1.headerText
			}),
			CloseButton = t1.onClose and React.createElement(Foundation.Image, {
				tag = "size-600 radius-small",
				Image = "icons/navigation/close",
				LayoutOrder = 3,
				onActivated = t1.onClose
			})
		}),
		ContentText = (not FFlagAvatarSwitcherUiFixes or t1.contentText) and React.createElement(Foundation.Text, {
			tag = " size-full-0 auto-y text-align-x-left text-body-medium text-wrap",
			Text = t1.contentText
		})
	})
end

return MessageCard
