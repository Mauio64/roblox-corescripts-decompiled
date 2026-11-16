local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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

	local createElement3 = React.createElement

	local v19 = if not foundationFontFaceMigration then font.Body.Font else nil

	local v20 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
	children.NetworkLabel = createElement3("TextLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Font = v19,
		FontFace = v20,
		Text = props.networkTitle,
		TextSize = v6,
		TextColor3 = theme.TextDefault.Color,
		AutomaticSize = Enum.AutomaticSize.XY,
		RichText = true
	})

	local createElement4 = React.createElement
	local v22 = {
		Size = UDim2.new(1, 0, 0, v6 + 20),
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		Image = images["component_assets/circle_21"],
		ImageColor3 = theme.UIMuted.Color,
		ImageTransparency = theme.UIMuted.Transparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}

	local createElement5 = React.createElement
	local v25 = {
		Size = UDim2.new(1, 0, 0, v6 + 20),
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		Image = images["component_assets/circle_21_stroke_1"],
		ImageColor3 = theme.Divider.Color,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}
	local v26 = {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12)
		}),
		TextBox = 0
	}

	local createElement6 = React.createElement
	local v28 = {
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
	local v29 = if v9 then theme.PlaceHolder.Transparency else nil
	v28.clearIconTransparency = v29
	v28.initialInputText = props.initialText
	v28.inputBoxRef = ref
	v28.inputTextColor3 = theme.TextDefault.Color
	v28.inputTextSize = v6

	local v30 = if v9 then theme.PlaceHolder.Transparency else theme.TextDefault.Transparency
	v28.inputTextTransparency = v30

	v28.inputTextXAlignment = Enum.TextXAlignment.Left
	v28.placeholderText = props.placeholderText
	v28.placeholderTextColor3 = theme.TextDefault.Color
	local v31 = if v9 then theme.PlaceHolder.Transparency else nil
	v28.placeholderTextTransparency = v31
	v28.textChangedCallback = props.textChanged
	v26.TextBox = createElement6(callbackInputBox, v28)
	children.InputBackground = createElement4(imageSetLabel, v22, {
		InputBorder = createElement5(imageSetLabel, v25, v26)
	})
	return createElement("Frame", v12, children)
end

return EditSocialNetworksItem
