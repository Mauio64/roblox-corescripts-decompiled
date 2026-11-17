local EditProfile = script:FindFirstAncestor("EditProfile")
local parent = EditProfile.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Display = require(parent.Display)
require(EditProfile.Common.Enums)
local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local GetDisplayStore = Display.GetDisplayStore
local useEditProfileScreenConfig = require(EditProfile.Hooks.useEditProfileScreenConfig)
local EditProfileModal = require(EditProfile.BaseComponents.EditProfileModal)
local EditProfileScreen = require(EditProfile.BaseComponents.EditProfileScreen)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSplitPaneFullBleedEditProfile = SharedFlags2.FFlagSplitPaneFullBleedEditProfile

local function EditorSlot(p)
	local ref = React.useRef(nil)

	React.useLayoutEffect(function()
		local host = p.host
		host.Parent = ref.current
		return function()
			host.Parent = nil
		end
	end, { p.host })

	return React.createElement(View, { tag = "size-full-0 auto-y", ref = ref })
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
	local v3, editor

	if FFlagSplitPaneFullBleedEditProfile then
		local useContext = React.useContext
		local SplitPane = require(parent.SplitPane)
		local v4 = useContext(SplitPane.PaneHostContext)

		if v4 ~= nil then
			fullBleed = not v4.isFullScreen
		end

		local host = React.useMemo(createEditorHost, {})
		React.useEffect(function()
			return function()
				host:Destroy()
			end
		end, { host })
		v3 = React.createElement(EditorSlot, { host = host })
		editor = ReactRoblox.createPortal(component, host)
	else
		v3 = component
	end

	local join = Cryo.Dictionary.join

	if FFlagSplitPaneFullBleedEditProfile then
		component = v3
	end

	local v4 = join(v, {
		component = component,
		isDisabled = v.hasError == true,
		fullBleed = fullBleed
	})

	local v5 = displayStore.getDisplaySize(false) == Enum.DisplaySize.Small
	local content

	if v5 or fullBleed then
		content = React.createElement(EditProfileScreen, v4)
	else
		content = React.createElement(EditProfileModal, v4)
	end

	if fullBleed then
		local v6 = { onClose = v.onClose }

		if not FFlagSplitPaneFullBleedEditProfile then
			editor = nil
		end

		return FocusNavigatorWrapper(v6, { Content = content, Editor = editor })
	else
		local v6 = { onClose = v.onClose }

		local createElement = React.createElement
		local v7 = {
			["Size"] = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = v2.Color.Common.Scrim.Transparency,
			BackgroundColor3 = v2.Color.Common.Scrim.Color3,
			Active = true,
			AutoButtonColor = false
		}

		local activated = React.Event.Activated
		local v8

		if not v5 then
			v8 = v.onClose
		end

		v7[activated] = v8
		local v9 = { [1] = nil, (createElement("ImageButton", v7, { Content = content })) }

		if not FFlagSplitPaneFullBleedEditProfile then
			editor = nil
		end

		v9.Editor = editor
		return FocusNavigatorWrapper(v6, v9)
	end
end
