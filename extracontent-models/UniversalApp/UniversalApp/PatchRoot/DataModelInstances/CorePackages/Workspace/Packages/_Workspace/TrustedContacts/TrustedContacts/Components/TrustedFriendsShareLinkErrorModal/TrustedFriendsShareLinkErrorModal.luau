local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FFlagTCShareLinkErrorModalTextRename = require(Parent.SharedFlags).FFlagTCShareLinkErrorModalTextRename

local function TrustedFriendsShareLinkErrorModal(t1: {[any]: any}) -- line: 24
	-- upvalues: useLocalization (copy), FFlagTCShareLinkErrorModalTextRename (copy), React (copy), Dialog (copy), DialogSize (copy), ButtonVariant (copy)
	local navigation = t1.navigation
	local v12 = navigation.getParam("extraProps")
	local v13 = useLocalization({
		expiredTitle = "Feature.Friends.Title.TrustedFriendsExpiredLink",
		invalidTitle = "Feature.Friends.Title.TrustedFriendsInvalidLink",
		invalidDescription = "Feature.Friends.Description.TrustedFriendsInvalidLink",
		ok = "CommonUI.Controls.Action.OK",
		expiredDescription = not FFlagTCShareLinkErrorModalTextRename and "Feature.Friends.Description.TrustedConnectionExpiredLink" or "Feature.Friends.Description.TrustedFriendsExpiredLink"
	})
	local v14 = React.useCallback(function() -- line: 38
		-- upvalues: navigation (copy), v12 (copy)
		navigation.pop()
		v12.closeModal()
	end, {
		navigation,
		v12.closeModal
	})

	return React.createElement(Dialog.Root, {
		size = DialogSize.Medium
	}, {
		Title = React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = if v12.errorType ~= "Expired" then v13.invalidTitle else v13.expiredTitle
		}),
		BodyText = React.createElement(Dialog.Text, {
			LayoutOrder = 2,
			Text = if v12.errorType ~= "Expired" then v13.invalidDescription else v13.expiredDescription
		}),
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			actions = {{
				text = v13.ok,
				variant = ButtonVariant.Emphasis,
				onActivated = v14
			}}
		})
	})
end

return TrustedFriendsShareLinkErrorModal
