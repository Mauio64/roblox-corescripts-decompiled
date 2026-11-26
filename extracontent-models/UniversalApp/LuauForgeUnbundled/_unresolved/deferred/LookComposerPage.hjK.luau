local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local focusable = RoactGamepad.Focusable

local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/fvR")
local module3 = require("@luauforge/bundled/egx")
local module4 = require("@luauforge/bundled/eie")
local module5 = require("@luauforge/bundled/gxM")
local module6 = require("@luauforge/deferred/gTt")
local module7 = require("@luauforge/deferred/gSS")
local module8 = require("@luauforge/bundled/dPN")
local module9 = require("@luauforge/bundled/dXh")
local setTryOnManagerPeekViewState = require("@luauforge/bundled/dKU").Actions.SetTryOnManagerPeekViewState
local module10 = require("@luauforge/deferred/hjL")
local module11 = require("@luauforge/deferred/hjM")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local compositionTags = require("@luauforge/bundled/gRW").CompositionTags

local module12 = require("@luauforge/deferred/hjN")
local module13 = require("@luauforge/deferred/hjS")
local module14 = require("@luauforge/deferred/hjT")

local actionBar = UIBlox.App.Button.ActionBar
local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType

local useStyle = UIBlox.Core.Style.useStyle
local iconButton = Foundation.IconButton

local module15 = require("@luauforge/deferred/hjU")
local module16 = require("@luauforge/deferred/gSH")
local defineFastFlag = game:DefineFastFlag("AXFixLookComposerExitPrompt", false)
local defineFastFlag2 = game:DefineFastFlag("AXLookComposerEmotesPickerEnabled", false)
local defineFastFlag3 = game:DefineFastFlag("AXLookComposerStepsRefactor", false)

local v5 = {
	ApplyEmote = "ApplyEmote",
	ApplyBackground = "ApplyBackground",
	EditInfo = "EditInfo"
}

local v6 = { ApplyEmote = true, ApplyBackground = false, EditInfo = false }

local v7 = {}

if defineFastFlag3 then
	if defineFastFlag2 then
		table.insert(v7, "ApplyEmote")
	end

	if module15() then
		table.insert(v7, "ApplyBackground")
	end

	table.insert(v7, "EditInfo")
end

local function fn(p2)
	local v8 = useNavigation()
	local function onActivated()
		if p2.onActivated then
			p2.onActivated()
			return
		end

		local v9 = v8.getParam("prevNavPage") or module.Home
		module9.closeLookComposer(v8)
		v8.navigate(v9)
	end
	return React.createElement(iconButton, {
		size = iconSize.Medium,
		icon = BuilderIcons.Icon.X,
		onActivated = onActivated
	})
end

local function fn2(p2)
	return p2.AvatarExperience.AvatarScene.Looks[module8.DraftLookId]
		and p2.AvatarExperience.AvatarScene.Looks[module8.DraftLookId].displayProperties
		and p2.AvatarExperience.AvatarScene.Looks[module8.DraftLookId].displayProperties.emoteAssetId ~= nil
end

function LUAUFORGE_MODULE_GLOBALS_hjK_trimWhitespaceFromString(value)
	return value:match("^%s*(.-)%s*$")
end

local function LookComposerPage()
	local v8 = useDispatch()
	local v9 = useNavigation()
	local v10 = useStyle()
	local state, setState = React.useState(Vector2.new())
	local v11 = not defineFastFlag3 and "ApplyEmote" or v7[1]
	local state2, setState2 = React.useState(v11)
	local state3, setState3 = React.useState(true)
	local state4, setState4 = React.useState(true)
	local v12

	if module16() then
		v12 = module5({
			goBack = "Feature.Avatar.Action.GoBack",
			next = "Feature.Avatar.Action.Next",
			previewAndPost = "Feature.Avatar.Action.ComposerPreviewAndPost",
			postHeader = "Feature.Avatar.Header.Post"
		})
	else
		v12 = nil
	end

	local v13 = useSelector(function(p2)
		return p2.AvatarExperience.AvatarScene.Looks[module8.DraftLookId]
	end)

	local v14 = useSelector(fn2)
	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(false)

	local v15 = useSelector(function(p2)
		return p2.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
	end) ~= peekViewState.Closed

	local v16 = module4(module3)
	React.useEffect(function()
		v8(setTryOnManagerPeekViewState(peekViewState.Closed))
		v8(module10(v16)):andThen(function(p2)
			if p2 then
				setState3(false)
			else
				module9.closeLookComposer(v9)
			end
		end)
	end, {})
	local color

	if v13 and v13.displayProperties and v13.displayProperties.backgroundType == "Hex" then
		color = Color3.fromHex(v13.displayProperties.backgroundValue)
	else
		color = v10.Theme.PlaceHolder.Color
	end

	local v17 = React.useMemo(function()
		local createElement = React.createElement

		local v19 = {
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 1,
			BorderColor3 = v10.Theme.BackgroundDefault.Color,
			BackgroundColor3 = v10.Theme.BackgroundDefault.Color,
			BackgroundTransparency = 0
		}

		local createElement2 = React.createElement

		local v22 = {
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 1,
			BorderColor3 = color,
			BackgroundColor3 = color,
			BackgroundTransparency = v10.Theme.PlaceHolder.Transparency
		}

		local v24 = if v13 then React.createElement(module7, { lookDetails = v13 }) else nil
		return createElement("Frame", v19, {
			ThumbnailBackground = createElement2("Frame", v22, { LookViewport = v24 })
		})
	end, { color, v13 })

	local v18 = React.useCallback(function()
		if defineFastFlag3 then
			setState2(function(p2)
				local index = table.find(v7, p2)
				return v7[not index and 1 or index - 1]
			end)
		elseif state2 == "ApplyBackground" then
			setState2("ApplyEmote")
		elseif state2 == "EditInfo" then
			if module15() then
				setState2("ApplyBackground")
			else
				setState2("ApplyEmote")
			end
		end
	end, defineFastFlag3 and {} or { state2 })

	local v19 = React.useMemo(function()
		return {
			props = {
				onActivated = v18,
				text = not module16() and "Go Back" or v12.goBack
			}
		}
	end, { v18 })

	local v20 = React.useCallback(function()
		if defineFastFlag3 then
			if state2 == v7[#v7] then
				v8(module11(v9))
			else
				setState2(function(p2)
					local index = table.find(v7, p2)
					return v7[not index and 1 or index + 1]
				end)
			end
		elseif state2 == "ApplyEmote" then
			if module15() then
				setState2("ApplyBackground")
			else
				setState2("EditInfo")
			end
		elseif state2 == "ApplyBackground" then
			setState2("EditInfo")
		elseif state2 == "EditInfo" then
			v8(module11(v9))
		end
	end, { state2 })

	local v21 = React.useMemo(function()
		local v22 = {
			buttonType = buttonType.PrimarySystem,
			isDefaultChild = true,
			props = 0
		}

		local v23 = { onActivated = v20, text = 0, isDisabled = 0 }
		local v24

		if defineFastFlag3 then
			v24 = if state2 == v7[#v7] then v12.previewAndPost else v12.next
		elseif module16() then
			v24 = if state2 == "EditInfo" then v12.previewAndPost else v12.next
		else
			v24 = state2 == "EditInfo" and "Preview & Share" or "Next"
		end

		v23.text = v24

		local v25 = if state2 == "EditInfo" then state4 else nil
		v23.isDisabled = v25
		v22.props = v23
		return v22
	end, { v20, state4 })

	local v22 = React.useCallback(function()
		local v23 = v9.getParam("prevNavPage") or module.Home

		if defineFastFlag then
			module9.closeFocusedScreen(v9)
		end

		module9.closeLookComposer(v9)
		v9.navigate(v23)
	end, { v9 })
	local v23 = v14 or state5 or state6
	local v24 = React.useCallback(function()
		if v23 then
			v9.navigate(avatarScreen.LooksConfirmationPrompt, { onOverlayClosed = v22 })
		elseif v22 then
			v22()
		end
	end, { v9, v23, v22 })

	local v25 = React.useCallback(function()
		return fn({ onActivated = v24 })
	end, { v24 })

	local createElement = React.createElement
	local frame = focusable.Frame
	local v26 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

	local createElement2 = React.createElement
	local v29 = {
		bottomBarEnabled = false,
		allowAdaptiveScrolling = false,
		topBar = React.createElement(module2.Container, {
			tag = compositionTags.ContentRegion.Header,
			sideMarginOverride = 0,
			titleText = not module16() and "Post" or v12.postHeader,
			transparentBackground = false,
			leftItem = v25
		}),
		sceneUi = v17,
		isSceneFullView = false,
		isUIFullView = false,
		showRobuxBalance = v6[state2]
	}
	local children = {
		Overlay = v15 and React.createElement("Frame", {
			BackgroundTransparency = v10.Theme.Overlay.Transparency,
			BackgroundColor3 = v10.Theme.Overlay.Color,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2
		}),
		Content = 0,
		ActionBarBackground = 0,
		ActionBar = 0
	}

	local createElement3 = React.createElement
	local v31 = {
		Size = UDim2.new(1, 0, 1, -state.Y),
		BackgroundTransparency = 1
	}

	local v32 = {
		LoadingFrame = state3 and React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = v10.Theme.BackgroundDefault.Color,
				BorderSizePixel = 0
			},
			{
				LoadingSpinner = React.createElement(loading, {
					Position = UDim2.fromScale(0.5, 0.5),
					size = iconSize.Large,
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			}
		),
		Content = 0
	}

	local v33 = not state3

	if v33 then
		local createElement4 = React.createElement
		local fragment = React.Fragment
		local v35 = {
			EmotePicker = state2 == "ApplyEmote" and React.createElement(module12),
			BackgroundPicker = state2 == "ApplyBackground" and React.createElement(module13),
			InfoForm = 0
		}
		local v38

		if state2 == "EditInfo" then
			v38 = React.createElement(module14, {
				interactable = not v15,
				disableNextButton = function(p2)
					setState4(p2)
				end,
				onTitleChange = function(p2)
					setState5(string.len((LUAUFORGE_MODULE_GLOBALS_hjK_trimWhitespaceFromString(p2))) ~= 0)
				end,
				onSubtitleChange = function(p2)
					setState6(string.len((LUAUFORGE_MODULE_GLOBALS_hjK_trimWhitespaceFromString(p2))) ~= 0)
				end
			})
		else
			v38 = false
		end

		v35.InfoForm = v38
		v33 = createElement4(fragment, {}, v35)
	end

	v32.Content = v33
	children.Content = createElement3("Frame", v31, v32)

	children.ActionBarBackground = React.createElement("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, state.Y),
		BorderSizePixel = 0,
		BackgroundColor3 = v10.Theme.BackgroundDefault.Color,
		ZIndex = 0
	})

	children.ActionBar = not state3 and not v15 and React.createElement(actionBar, {
		onAbsoluteSizeChanged = function(p2)
			setState(p2 + Vector2.new(0, 12))
		end
	}, {
		ButtonStack = React.createElement(buttonStack, {
			buttons = state2 == v11 and { v21 } or { v19, v21 }
		})
	})
	return createElement(frame, v26, {
		AvatarExperienceView = createElement2(module6, v29, children)
	})
end

return LookComposerPage
