local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local Display = require(parent.Display)
require(EditProfile.Common.Enums)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local GetDisplayStore = Display.GetDisplayStore
local useEditProfileScreenConfig = require(EditProfile.Hooks.useEditProfileScreenConfig)
local EditProfileModal = require(EditProfile.BaseComponents.EditProfileModal)
local EditProfileScreen = require(EditProfile.BaseComponents.EditProfileScreen)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab

return function(p)
	local v = useEditProfileScreenConfig(p.navigation.state.params.screen)
	local displayStore = GetDisplayStore(false)
	local v2 = useTokens()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		if ref.current and ref.current.focus and not ref2.current then
			ref2.current = true
			ref.current.focus()
		end
	end, { ref.current })

	local component = React.useMemo(function()
		local v3 = { registerSaveHandler = v.registerSaveHandler, textBoxRef = ref }

		if v.updateErrorState then
			v3.updateErrorState = v.updateErrorState
		end

		return (React.createElement(v.component, v3))
	end, { v.component, v.registerSaveHandler, ref })

	local fullBleed = FFlagAXEnableProfileTab and p.navigation.state.params.fullBleed == true

	local joined = Cryo.Dictionary.join(v, {
		component = component,
		isDisabled = v.hasError == true,
		fullBleed = fullBleed
	})

	local v3 = displayStore.getDisplaySize(false) == Enum.DisplaySize.Small
	local content

	if v3 or fullBleed then
		content = React.createElement(EditProfileScreen, joined)
	else
		content = React.createElement(EditProfileModal, joined)
	end

	if fullBleed then
		return FocusNavigatorWrapper({ onClose = v.onClose }, { Content = content })
	end

	local v4 = { onClose = v.onClose }

	local createElement = React.createElement
	local v5 = {
		["Size"] = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v2.Color.Common.Scrim.Transparency,
		BackgroundColor3 = v2.Color.Common.Scrim.Color3,
		Active = true,
		AutoButtonColor = false
	}

	local activated = React.Event.Activated
	local v6

	if not v3 then
		v6 = v.onClose
	end

	v5[activated] = v6
	return FocusNavigatorWrapper(v4, { createElement("ImageButton", v5, { Content = content }) })
end
