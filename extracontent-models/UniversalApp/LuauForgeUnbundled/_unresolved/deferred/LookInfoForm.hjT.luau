local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local module = require("@luauforge/bundled/dFm")
local module2 = require("@luauforge/bundled/dzE")
local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/dPv")
local module5 = require("@luauforge/bundled/gxM")
local useStyle = UIBlox.Core.Style.useStyle
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection

local module6 = require("@luauforge/deferred/gSH")

local defineFastString = game:DefineFastString("AXFormPositionWhenKeyboardVisible", "-0.4")
local module7 = require("@luauforge/bundled/gJS")

local v5 = {
	toastMessage = "Feature.Avatar.Toast.AvatarTitleExceedMaximum",
	isLocalized = false,
	toastType = module2.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.Toast.AvatarCaptionExceedMaximum",
	isLocalized = false,
	toastType = module2.InformationMessage
}

local function getSafePositionFromString(p2, p3)
	return tonumber(p2) or p3
end

local function LookInfoForm(props)
	local v7 = useDispatch()
	local v8 = useStyle()
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v9 = useDesignTokens()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(UDim2.new(0, 0, 0, 0))
	local ref3 = React.useRef(nil)
	local v10

	if module6() then
		v10 = module5({
			avatarTitle = "Feature.Avatar.Placeholder.NameYourAvatar",
			describeAvatar = "Feature.Avatar.Placeholder.WriteAvatarCaption"
		})
	end

	local v11 = useSelector(function(p2)
		return p2.AvatarExperience.AvatarScene.Looks[module3.DraftLookId]
	end)

	local v12 = useSelector(module7)
	React.useEffect(function()
		if v11 and ref.current and ref2.current then
			ref.current.Text = v11.name or ""
			ref2.current.Text = v11.description or ""
		end
	end, { v11, ref, ref2 })

	React.useEffect(function()
		if ref.current then
			ref.current:CaptureFocus()
		end
	end, {})

	local v13 = React.useCallback(function()
		if ref.current and ref2.current then
			v7(module4(module3.DraftLookId, {
				name = ref.current.Text,
				description = ref2.current.Text
			}))
		end
	end, { ref, ref2, v7 })

	local v14 = React.useCallback(function()
		local v15 = not (ref and ref.current) and 0 or string.len(ref.current.Text)
		local v16 = not (ref2 and ref2.current) and 0 or string.len(ref2.current.Text)

		local v17 = v15 >= 1 and v15 <= 50
		local v18 = v16 < 1001

		if props.disableNextButton then
			props.disableNextButton(not (v17 and v18))
		end

		if v15 > 50 then
			v7(module(v5))
		end

		if v16 >= 1001 then
			v7(module(v6))
		end
	end, { v11, ref, ref2, v7 })

	local v15 = React.useCallback(function()
		if props.onTitleChange and ref and ref.current then
			props.onTitleChange(ref.current.Text)
		end

		if v14 then
			v14()
		end
	end, { ref, props.onTitleChange, v14 })

	local v16 = React.useCallback(function()
		if props.onSubtitleChange and ref2 and ref2.current then
			props.onSubtitleChange(ref2.current.Text)
		end

		if v14 then
			v14()
		end
	end, { ref2, props.onSubtitleChange, v14 })

	local v17 = React.useCallback(function()
		setState(function(p2)
			if p2 == UserInputService.OnScreenKeyboardVisible then
				return p2
			end

			return UserInputService.OnScreenKeyboardVisible
		end)
	end, { v12 })

	React.useEffect(function()
		if not v12 then
			return
		end

		local v18 = tonumber(defineFastString) or -0.4

		local v19 = if state then UDim2.new(0, 0, v18, 0) else UDim2.new(0, 0, 0, 0)
		setState2(v19)
	end, { state, v12 })

	local createElement = React.createElement
	local v19 = {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v8.Theme.BackgroundDefault.Color,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = 0,
		ref = 0
	}

	if not v12 then
		state2 = nil
	end

	v19.Position = state2

	if not v12 then
		ref3 = nil
	end

	v19.ref = ref3

	local v20 = if v12 then React.createElement(externalEventConnection, {
		event = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"),
		callback = v17
	}) else nil
	return createElement("Frame", v19, {
		KeyboardConnection = v20,
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v9.Size.Size_300),
			PaddingBottom = UDim.new(0, v9.Size.Size_300),
			PaddingLeft = UDim.new(0, v9.Size.Size_300),
			PaddingRight = UDim.new(0, v9.Size.Size_300)
		}),
		ListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v9.Size.Size_300),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		NameBox = React.createElement("TextBox", {
			ref = ref,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			FontFace = normalizeFontFace(v9.Typography.TitleLarge.Font),
			ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = v8.Font.BaseSize * v8.Font.Header2.RelativeSize,
			TextColor3 = v8.Theme.TextEmphasis.Color,
			PlaceholderColor3 = v8.Theme.TextDefault.Color,
			PlaceholderText = not module6() and "Name your Avatar" or v10.avatarTitle,
			Interactable = props.interactable,
			LayoutOrder = 1,
			[React.Event.FocusLost] = v13,
			[React.Change.Text] = v15
		}),
		Spacer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = v8.Theme.Divider.Color,
			BackgroundTransparency = v8.Theme.Divider.Transparency,
			BorderSizePixel = 0,
			LayoutOrder = 2
		}),
		DescriptionBox = React.createElement("TextBox", {
			ref = ref2,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			MultiLine = true,
			ClearTextOnFocus = false,
			FontFace = normalizeFontFace(v9.Typography.BodyLarge.Font),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = v8.Font.BaseSize * v8.Font.Body.RelativeSize,
			TextColor3 = v8.Theme.TextDefault.Color,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			PlaceholderColor3 = v8.Theme.TextDefault.Color,
			PlaceholderText = not module6() and "Describe your Avatar (Optional)" or v10.describeAvatar,
			Interactable = props.interactable,
			LayoutOrder = 3,
			[React.Event.FocusLost] = v13,
			[React.Change.Text] = v16
		})
	})
end

return LookInfoForm
