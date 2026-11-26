local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation").Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local iconSize = UIBlox.App.Constant.IconSize
local SocialNetworksInEditProfileIXP = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Flags/SocialNetworksInEditProfileIXP")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useScreenSize

local callbackInputBox = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/LuaSocialLibrariesDeps").SocialLibraries.config({}).Components.CallbackInputBox

local function EditSocialNetworksItem(props)
	local ref = React.useRef(nil)

	local v5 = useStyle()
	local font = v5.Font
	local theme = v5.Theme
	local v6 = font.BaseSize * font.Body.RelativeSize
	local v7 = useScreenSize()

	local v8 = SocialNetworksInEditProfileIXP.useGetExperimentVariant({ isExposureEnabled = true })

	local v9 = if v8 then v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityFirst and props.isVisibilityNoOne else nil

	local v10 = React.useCallback(function()
		if UserInputService.OnScreenKeyboardVisible then
			if ref.current and ref.current:IsFocused() then
				local v11 = UserInputService.OnScreenKeyboardPosition.Y - (ref.current.AbsolutePosition.Y + ref.current.AbsoluteSize.Y)

				if v11 < 0 then
					props.setKeyboardOffset(v11)
				else
					props.setKeyboardOffset(0)
				end
			end
		else
			props.setKeyboardOffset(0)
		end
	end, { v7, props.setKeyboardOffset })

	React.useEffect(function()
		local v11 = {
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"):Connect(v10),
			UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"):Connect(v10)
		}

		if props.focusOn then
			task.spawn(function()
				if ref and ref.current then
					ref.current:captureFocus()
				end
			end)
		end

		return function()
			for k, connection in v11 do
				connection:Disconnect()
			end
		end
	end, { v10 })

	local createElement = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.layoutOrder,
		Interactable = not v9
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12)
		}),
		Padding = 0,
		NetworkLabel = 0,
		InputBackground = 0
	}

	local createElement2 = React.createElement
	local v15 = if v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityFirst then UDim.new(0, 12) else nil

	local v16 = if v8 == SocialNetworksInEditProfileIXP.Variants.VisibilityLast then UDim.new(0, 12) else nil
	children.Padding = createElement2("UIPadding", {
		PaddingTop = v15,
		PaddingBottom = v16
	})

	children.NetworkLabel = React.createElement("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		FontFace = normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font),
		Text = props.networkTitle,
		TextSize = v6,
		TextColor3 = theme.TextDefault.Color,
		AutomaticSize = Enum.AutomaticSize.XY,
		RichText = true
	})

	local createElement3 = React.createElement
	local v18 = {
		Size = UDim2.new(1, 0, 0, v6 + 20),
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Image = images["component_assets/circle_21"],
		ImageColor3 = theme.UIMuted.Color,
		ImageTransparency = theme.UIMuted.Transparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}

	local createElement4 = React.createElement
	local v21 = {
		Size = UDim2.new(1, 0, 0, v6 + 20),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Image = images["component_assets/circle_21_stroke_1"],
		ImageColor3 = theme.Divider.Color,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}
	local v22 = {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		}),
		TextBox = 0
	}

	local createElement5 = React.createElement
	local v24 = {
		captureFocusOnMount = props.focusOn,
		clearButtonDisabled = false,
		clearButtonSize = iconSize.Small,
		clearIcon = images["icons/actions/edit/clear_small"],
		clearIconColor3 = theme.IconEmphasis.Color,
		clearIconTransparency = 0,
		initialInputText = 0,
		inputBoxRef = 0,
		inputTextColor3 = 0,
		inputTextSize = 0,
		inputTextTransparency = 0,
		inputTextXAlignment = 0,
		placeholderText = 0,
		placeholderTextColor3 = 0,
		placeholderTextTransparency = 0,
		textChangedCallback = 0
	}
	local v25 = if v9 then theme.PlaceHolder.Transparency else nil
	v24.clearIconTransparency = v25
	v24.initialInputText = props.initialText
	v24.inputBoxRef = ref
	v24.inputTextColor3 = theme.TextDefault.Color
	v24.inputTextSize = v6

	local v26 = if v9 then theme.PlaceHolder.Transparency else theme.TextDefault.Transparency
	v24.inputTextTransparency = v26

	v24.inputTextXAlignment = Enum.TextXAlignment.Left
	v24.placeholderText = props.placeholderText
	v24.placeholderTextColor3 = theme.TextDefault.Color
	local v27 = if v9 then theme.PlaceHolder.Transparency else nil
	v24.placeholderTextTransparency = v27
	v24.textChangedCallback = props.textChanged
	v22.TextBox = createElement5(callbackInputBox, v24)
	children.InputBackground = createElement3(imageSetLabel, v18, {
		InputBorder = createElement4(imageSetLabel, v21, v22)
	})
	return createElement("Frame", v12, children)
end

return EditSocialNetworksItem
