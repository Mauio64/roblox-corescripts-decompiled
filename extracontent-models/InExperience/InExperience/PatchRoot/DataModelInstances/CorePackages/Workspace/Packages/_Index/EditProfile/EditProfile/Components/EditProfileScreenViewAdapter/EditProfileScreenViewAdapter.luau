local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local Display = require(EditProfileParent.Display)

require(EditProfile.Common.Enums)

local Cryo = require(EditProfileParent.Cryo)
local useTokens = require(EditProfileParent.Foundation).Hooks.useTokens
local GetDisplayStore = Display.GetDisplayStore
local useEditProfileScreenConfig = require(EditProfile.Hooks.useEditProfileScreenConfig)
local EditProfileModal = require(EditProfile.BaseComponents.EditProfileModal)
local EditProfileScreen = require(EditProfile.BaseComponents.EditProfileScreen)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local FFlagAXEnableProfileTab = require(EditProfileParent.SharedFlags).FFlagAXEnableProfileTab

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: useEditProfileScreenConfig (copy), GetDisplayStore (copy), useTokens (copy), React (copy), FFlagAXEnableProfileTab (copy), Cryo (copy), EditProfileScreen (copy), EditProfileModal (copy), FocusNavigatorWrapper (copy)
	local params = t1.navigation.state.params
	local v15 = useEditProfileScreenConfig(params.screen)
	local v16 = GetDisplayStore(false)
	local v17 = useTokens()
	local v18 = React.useRef(nil)
	local v19 = React.useRef(false)

	React.useEffect(function() -- line: 38
		-- upvalues: v18 (copy), v19 (copy)
		if v18.current and (v18.current.focus and not v19.current) then
			v19.current = true
			v18.current.focus()
		end
	end, { v18.current })

	local v20 = React.useMemo(function() -- line: 45
		-- upvalues: v15 (copy), v18 (copy), React (copy)
		local t2 = {
			registerSaveHandler = v15.registerSaveHandler,
			textBoxRef = v18
		}

		if v15.updateErrorState then
			t2.updateErrorState = v15.updateErrorState
		end

		return (React.createElement(v15.component, t2))
	end, {
		v15.component,
		v15.registerSaveHandler,
		v18
	})
	local v21 = FFlagAXEnableProfileTab and t1.navigation.state.params.fullBleed == true
	local v22 = Cryo.Dictionary.join(v15, {
		component = v20,
		isDisabled = v15.hasError == true,
		fullBleed = v21
	})
	local v23 = v16.getDisplaySize(false) == Enum.DisplaySize.Small
	local v24 = if not v23 and not v21 then React.createElement(EditProfileModal, v22) else React.createElement(EditProfileScreen, v22)

	if v21 then
		return FocusNavigatorWrapper({
			onClose = v15.onClose
		}, {
			Content = v24
		})
	end

	return FocusNavigatorWrapper({
		onClose = v15.onClose
	}, { React.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v17.Color.Common.Scrim.Transparency,
		BackgroundColor3 = v17.Color.Common.Scrim.Color3,
		Active = true,
		AutoButtonColor = false,
		[React.Event.Activated] = if v23 then nil else v15.onClose
	}, {
		Content = v24
	}) })
end
