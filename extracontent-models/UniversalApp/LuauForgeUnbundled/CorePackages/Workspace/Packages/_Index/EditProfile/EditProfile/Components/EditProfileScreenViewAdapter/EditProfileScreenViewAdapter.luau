local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Display")
require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Cryo")
local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation").Hooks.useTokens

local getDisplayStore = Display.GetDisplayStore
local useEditProfileScreenConfig = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useEditProfileScreenConfig")
local EditProfileModal = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/BaseComponents/EditProfileModal")
local EditProfileScreen = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/BaseComponents/EditProfileScreen")
local FocusNavigatorWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Utils/FocusNavigatorWrapper")
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagAXEnableProfileTab

return function(p2)
	local v5 = useEditProfileScreenConfig(p2.navigation.state.params.screen)
	local displayStore = getDisplayStore(false)
	local v6 = useTokens()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	React.useEffect(function()
		if ref.current and ref.current.focus and not ref2.current then
			ref2.current = true
			ref.current.focus()
		end
	end, { ref.current })

	local v7 = React.useMemo(function()
		local v8 = { registerSaveHandler = v5.registerSaveHandler, textBoxRef = ref }

		if v5.updateErrorState then
			v8.updateErrorState = v5.updateErrorState
		end

		return React.createElement(v5.component, v8)
	end, { v5.component, v5.registerSaveHandler, ref })

	local v8 = fFlagAXEnableProfileTab and p2.navigation.state.params.fullBleed == true

	local joined = Cryo.Dictionary.join(v5, {
		component = v7,
		isDisabled = v5.hasError == true,
		fullBleed = v8
	})

	local v9 = displayStore.getDisplaySize(false) == Enum.DisplaySize.Small
	local v10

	if v9 or v8 then
		v10 = React.createElement(EditProfileScreen, joined)
	else
		v10 = React.createElement(EditProfileModal, joined)
	end

	if v8 then
		return FocusNavigatorWrapper({ onClose = v5.onClose }, { Content = v10 })
	end

	local v12 = { onClose = v5.onClose }

	local createElement = React.createElement
	local v15 = {
		["Size"] = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = v6.Color.Common.Scrim.Transparency,
		BackgroundColor3 = v6.Color.Common.Scrim.Color3,
		Active = true,
		AutoButtonColor = false
	}

	local activated = React.Event.Activated
	local v16 = if not v9 then v5.onClose else nil
	v15[activated] = v16
	return FocusNavigatorWrapper(v12, { createElement("ImageButton", v15, { Content = v10 }) })
end
