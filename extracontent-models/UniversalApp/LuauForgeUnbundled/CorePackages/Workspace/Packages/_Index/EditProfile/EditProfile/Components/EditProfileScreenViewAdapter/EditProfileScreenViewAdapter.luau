local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/ReactRoblox")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Display")
require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Common/Enums")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local getDisplayStore = Display.GetDisplayStore
local useEditProfileScreenConfig = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Hooks/useEditProfileScreenConfig")
local EditProfileModal = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/BaseComponents/EditProfileModal")
local EditProfileScreen = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/BaseComponents/EditProfileScreen")
local FocusNavigatorWrapper = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Utils/FocusNavigatorWrapper")
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagAXEnableProfileTab
local fFlagSplitPaneFullBleedEditProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagSplitPaneFullBleedEditProfile

local function EditorSlot(p2)
	local ref = React.useRef(nil)

	React.useLayoutEffect(function()
		local host = p2.host
		host.Parent = ref.current
		return function()
			host.Parent = nil
		end
	end, { p2.host })

	return React.createElement(view, { tag = "size-full-0 auto-y", ref = ref })
end

local function createEditorHost()
	local editorHost = Instance.new("Frame")
	editorHost.Name = "EditorHost"
	editorHost.BackgroundTransparency = 1
	editorHost.BorderSizePixel = 0
	editorHost.Size = UDim2.fromScale(1, 0)
	editorHost.AutomaticSize = Enum.AutomaticSize.Y
	return editorHost
end

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
	local v9, v10

	if fFlagSplitPaneFullBleedEditProfile then
		local v11 = React.useContext(require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SplitPane").PaneHostContext)

		if v11 ~= nil then
			v8 = not v11.isFullScreen
		end

		local v12 = React.useMemo(createEditorHost, {})
		React.useEffect(function()
			return function()
				v12:Destroy()
			end
		end, { v12 })
		v9 = React.createElement(EditorSlot, { host = v12 })
		v10 = ReactRoblox.createPortal(v7, v12)
	else
		v9 = v7
	end

	local join = Cryo.Dictionary.join

	if fFlagSplitPaneFullBleedEditProfile then
		v7 = v9
	end

	local v12 = join(v5, {
		component = v7,
		isDisabled = v5.hasError == true,
		fullBleed = v8
	})

	local v13 = displayStore.getDisplaySize(false) == Enum.DisplaySize.Small
	local v14

	if v13 or v8 then
		v14 = React.createElement(EditProfileScreen, v12)
	else
		v14 = React.createElement(EditProfileModal, v12)
	end

	if v8 then
		local v16 = { onClose = v5.onClose }

		if not fFlagSplitPaneFullBleedEditProfile then
			v10 = nil
		end

		return FocusNavigatorWrapper(v16, { Content = v14, Editor = v10 })
	else
		local v16 = { onClose = v5.onClose }

		local createElement = React.createElement
		local v19 = {
			["Size"] = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = v6.Color.Common.Scrim.Transparency,
			BackgroundColor3 = v6.Color.Common.Scrim.Color3,
			Active = true,
			AutoButtonColor = false
		}

		local activated = React.Event.Activated
		local v20 = if not v13 then v5.onClose else nil
		v19[activated] = v20
		local v17 = { [1] = nil, (createElement("ImageButton", v19, { Content = v14 })) }

		if not fFlagSplitPaneFullBleedEditProfile then
			v10 = nil
		end

		v17.Editor = v10
		return FocusNavigatorWrapper(v16, v17)
	end
end
