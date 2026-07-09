local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local UpdateLookDetails = require(Modules.AvatarExperience.Common.Actions.UpdateLookDetails)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useStyle = UIBlox.Core.Style.useStyle
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local GetFFlagAXLooksTranslationAudit = require(Modules.AvatarExperience.Flags.GetFFlagAXLooksTranslationAudit)
local v18 = game:DefineFastString("AXFormPositionWhenKeyboardVisible", "-0.4")
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local t1 = {
	toastMessage = "Feature.Avatar.Toast.AvatarTitleExceedMaximum",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}
local t2 = {
	toastMessage = "Feature.Avatar.Toast.AvatarCaptionExceedMaximum",
	isLocalized = false,
	toastType = ToastType.InformationMessage
}

local function getSafePositionFromString(s1: string, n1: number) -- line: 49
	return tonumber(s1) or n1
end
local function LookInfoForm(t3: {[any]: any}) -- line: 54
	-- upvalues: useDispatch (copy), useStyle (copy), React (copy), useDesignTokens (copy), GetFFlagAXLooksTranslationAudit (copy), useLocalization (copy), useSelector (copy), Constants (copy), selectIsPortrait (copy), UpdateLookDetails (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy), UserInputService (copy), v18 (copy), ExternalEventConnection (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local v27 = useDispatch()
	local v28 = useStyle()
	local v29 = React.useRef(nil)
	local v30 = React.useRef(nil)
	local v31 = useDesignTokens()
	local v32, v33 = React.useState(false)
	local v34, v35 = React.useState(UDim2.new(0, 0, 0, 0))
	local v36 = React.useRef(nil)
	local v37 = if not GetFFlagAXLooksTranslationAudit() then nil else useLocalization({
		avatarTitle = "Feature.Avatar.Placeholder.NameYourAvatar",
		describeAvatar = "Feature.Avatar.Placeholder.WriteAvatarCaption"
	})
	local v38 = useSelector(function(p1) -- line: 70
		-- upvalues: Constants (copy)
		return p1.AvatarExperience.AvatarScene.Looks[Constants.DraftLookId]
	end)
	local v39 = useSelector(selectIsPortrait)

	React.useEffect(function() -- line: 74
		-- upvalues: v38 (copy), v29 (copy), v30 (copy)
		if v38 and (v29.current and v30.current) then
			v29.current.Text = v38.name or ""
			v30.current.Text = v38.description or ""
		end
	end, {
		v38,
		v29,
		v30
	})
	React.useEffect(function() -- line: 81
		-- upvalues: v29 (copy)
		if v29.current then
			v29.current:CaptureFocus()
		end
	end, {})

	local v40 = React.useCallback(function() -- line: 87
		-- upvalues: v29 (copy), v30 (copy), v27 (copy), UpdateLookDetails (copy), Constants (copy)
		if v29.current and v30.current then
			v27(UpdateLookDetails(Constants.DraftLookId, {
				name = v29.current.Text,
				description = v30.current.Text
			}))
		end
	end, {
		v29,
		v30,
		v27
	})
	local v41 = React.useCallback(function() -- line: 96
		-- upvalues: v29 (copy), v30 (copy), t3 (copy), v27 (copy), SetCurrentToastMessage (copy), t1 (copy), t2 (copy)
		local v46 = (not v29 or not v29.current) and 0 or string.len(v29.current.Text)
		local v47 = (not v30 or not v30.current) and 0 or string.len(v30.current.Text)
		local v48 = v46 >= 1 and v46 <= 50
		local v49 = v47 < 1001

		if t3.disableNextButton then
			t3.disableNextButton(not (v48 and v49))
		end

		if v46 > 50 then
			v27(SetCurrentToastMessage(t1))
		end

		if v47 >= 1001 then
			v27(SetCurrentToastMessage(t2))
		end
	end, {
		v38,
		v29,
		v30,
		v27
	})
	local v42 = React.useCallback(function() -- line: 118
		-- upvalues: t3 (copy), v29 (copy), v41 (copy)
		if t3.onTitleChange and (v29 and v29.current) then
			t3.onTitleChange(v29.current.Text)
		end

		if v41 then
			v41()
		end
	end, {
		v29,
		t3.onTitleChange,
		v41
	})
	local v43 = React.useCallback(function() -- line: 127
		-- upvalues: t3 (copy), v30 (copy), v41 (copy)
		if t3.onSubtitleChange and (v30 and v30.current) then
			t3.onSubtitleChange(v30.current.Text)
		end

		if v41 then
			v41()
		end
	end, {
		v30,
		t3.onSubtitleChange,
		v41
	})
	local v44 = React.useCallback(function() -- line: 137
		-- upvalues: v33 (copy), UserInputService (copy)
		v33(function(p2) -- line: 138
			-- upvalues: UserInputService (copy)
			if p2 ~= UserInputService.OnScreenKeyboardVisible then
				return UserInputService.OnScreenKeyboardVisible
			end

			return p2
		end)
	end, { v39 })

	React.useEffect(function() -- line: 146
		-- upvalues: v39 (copy), v18 (copy), v32 (copy), v35 (copy)
		if not v39 then
			return
		end

		local v50 = tonumber(v18) or -0.4
		local v51 = if not v32 then UDim2.new(0, 0, 0, 0) else UDim2.new(0, 0, v50, 0)

		v35(v51)
	end, {
		v32,
		v39
	})

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v28.Theme.BackgroundDefault.Color,
		Position = if not v39 then nil else v34,
		ref = if not v39 then nil else v36
	}, {
		KeyboardConnection = if not v39 then nil else React.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"),
			callback = v44
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v31.Global.Space_150 else v31.Size.Size_300),
			PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v31.Global.Space_150 else v31.Size.Size_300),
			PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v31.Global.Space_150 else v31.Size.Size_300),
			PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v31.Global.Space_150 else v31.Size.Size_300)
		}),
		ListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v31.Global.Space_150 else v31.Size.Size_300),
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		NameBox = React.createElement("TextBox", {
			ref = v29,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = v28.Font.Header2.Font,
			ClearTextOnFocus = false,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = v28.Font.BaseSize * v28.Font.Header2.RelativeSize,
			TextColor3 = v28.Theme.TextEmphasis.Color,
			PlaceholderColor3 = v28.Theme.TextDefault.Color,
			PlaceholderText = not GetFFlagAXLooksTranslationAudit() and "Name your Avatar" or v37.avatarTitle,
			Interactable = t3.interactable,
			LayoutOrder = 1,
			[React.Event.FocusLost] = v40,
			[React.Change.Text] = v42
		}),
		Spacer = React.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundColor3 = v28.Theme.Divider.Color,
			BackgroundTransparency = v28.Theme.Divider.Transparency
		}),
		DescriptionBox = React.createElement("TextBox", {
			ref = v30,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			MultiLine = true,
			ClearTextOnFocus = false,
			Font = v28.Font.Body.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextSize = v28.Font.BaseSize * v28.Font.Body.RelativeSize,
			TextColor3 = v28.Theme.TextDefault.Color,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			PlaceholderColor3 = v28.Theme.TextDefault.Color,
			PlaceholderText = not GetFFlagAXLooksTranslationAudit() and "Describe your Avatar (Optional)" or v37.describeAvatar,
			Interactable = t3.interactable,
			LayoutOrder = 3,
			[React.Event.FocusLost] = v40,
			[React.Change.Text] = v43
		})
	})
end

return LookInfoForm
