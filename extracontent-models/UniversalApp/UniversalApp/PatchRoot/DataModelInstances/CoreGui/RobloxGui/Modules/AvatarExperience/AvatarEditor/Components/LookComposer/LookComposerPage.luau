local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local BuilderIcons = require(CorePackages.Packages.BuilderIcons)
local IconSize = Foundation.Enums.IconSize
local IconSize2 = UIBlox.App.ImageSet.Enum.IconSize
local Loading = Foundation.Loading
local Focusable = RoactGamepad.Focusable
local AppPage = require(Modules.LuaApp.AppPage)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local LookViewport = require(Modules.AvatarExperience.Common.Components.Looks.LookViewport)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local SetTryOnManagerPeekViewState = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetTryOnManagerPeekViewState
local CreateDraftLook = require(Modules.AvatarExperience.AvatarEditor.Thunks.CreateDraftLook)
local DraftLookFinalPreview = require(Modules.AvatarExperience.AvatarEditor.Thunks.DraftLookFinalPreview)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local LookEmotePicker = require(script.Parent.LookEmotePicker)
local LookBackgroundPicker = require(script.Parent.LookBackgroundPicker)
local LookInfoForm = require(script.Parent.LookInfoForm)
local ActionBar = UIBlox.App.Button.ActionBar
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local IconButton2 = Foundation.IconButton
local GetFFlagAXLookComposerBackgroundsEnabled = require(Modules.AvatarExperience.Flags.GetFFlagAXLookComposerBackgroundsEnabled)
local GetFFlagAXLooksTranslationAudit = require(Modules.AvatarExperience.Flags.GetFFlagAXLooksTranslationAudit)
local v41 = game:DefineFastFlag("AXFixLookComposerExitPrompt", false)
local v42 = game:DefineFastFlag("AXLookComposerEmotesPickerEnabled", false)
local v43 = game:DefineFastFlag("AXLookComposerStepsRefactor", false)
local v44 = game:DefineFastFlag("AXFixLookComposerCloseButton", false)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local _ = {
	ApplyEmote = "ApplyEmote",
	ApplyBackground = "ApplyBackground",
	EditInfo = "EditInfo"
}
local t1 = {
	ApplyEmote = true,
	ApplyBackground = false,
	EditInfo = false
}
local t2 = {}

if v43 then
	if v42 then
		table.insert(t2, "ApplyEmote")
	end

	if GetFFlagAXLookComposerBackgroundsEnabled() then
		table.insert(t2, "ApplyBackground")
	end

	table.insert(t2, "EditInfo")
end

local function v49(t3: {[any]: any}) -- line: 94
	-- upvalues: useNavigation (copy), AppPage (copy), NavigationUtils (copy), v44 (copy), React (copy), IconButton2 (copy), IconSize (copy), BuilderIcons (copy), IconButton (copy), IconSize2 (copy), Images (copy)
	local v53 = useNavigation()

	local function v54() -- line: 96
		-- upvalues: t3 (copy), v53 (copy), AppPage (copy), NavigationUtils (copy)
		if t3.onActivated then
			t3.onActivated()

			return
		end

		local v89 = v53.getParam("prevNavPage") or AppPage.Home

		NavigationUtils.closeLookComposer(v53)
		v53.navigate(v89)
	end

	if v44 then
		return React.createElement(IconButton2, {
			size = IconSize.Medium,
			icon = BuilderIcons.Icon.X,
			onActivated = v54
		})
	end

	return React.createElement(IconButton, {
		size = UDim2.fromOffset(0, 0),
		iconSize = IconSize2.Medium,
		icon = Images["icons/navigation/close"],
		onActivated = v54
	})
end
local function v50(p1) -- line: 121
	-- upvalues: Constants (copy)
	return p1.AvatarExperience.AvatarScene.Looks[Constants.DraftLookId] and (p1.AvatarExperience.AvatarScene.Looks[Constants.DraftLookId].displayProperties and p1.AvatarExperience.AvatarScene.Looks[Constants.DraftLookId].displayProperties.emoteAssetId ~= nil)
end

function trimWhitespaceFromString(p2) -- line: 128
	return p2:match("^%s*(.-)%s*$")
end

local function LookComposerPage() -- line: 132
	-- upvalues: useDispatch (copy), useNavigation (copy), useStyle (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), v43 (copy), t2 (copy), GetFFlagAXLooksTranslationAudit (copy), useLocalization (copy), useSelector (copy), Constants (copy), v50 (copy), PeekViewState (copy), useRoactService (copy), RoactNetworking (copy), SetTryOnManagerPeekViewState (copy), CreateDraftLook (copy), NavigationUtils (copy), LookViewport (copy), GetFFlagAXLookComposerBackgroundsEnabled (copy), DraftLookFinalPreview (copy), ButtonType (copy), AppPage (copy), v41 (copy), AvatarScreen (copy), v49 (copy), Focusable (copy), AvatarExperienceView (copy), TopBar (copy), t1 (copy), Loading (copy), IconSize (copy), LookEmotePicker (copy), LookBackgroundPicker (copy), LookInfoForm (copy), ActionBar (copy), ButtonStack (copy)
	local v57 = useDispatch()
	local v58 = useNavigation()
	local v59 = useStyle()
	local v60 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil
	local v61, v62 = React.useState(Vector2.new())
	local v63 = not v43 and "ApplyEmote" or t2[1]
	local v64, v65 = React.useState(v63)
	local v66, v67 = React.useState(true)
	local v68, v69 = React.useState(true)
	local v70 = if not GetFFlagAXLooksTranslationAudit() then nil else useLocalization({
		goBack = "Feature.Avatar.Action.GoBack",
		next = "Feature.Avatar.Action.Next",
		previewAndPost = "Feature.Avatar.Action.ComposerPreviewAndPost",
		postHeader = "Feature.Avatar.Header.Post"
	})
	local v71 = useSelector(function(p3) -- line: 154
		-- upvalues: Constants (copy)
		return p3.AvatarExperience.AvatarScene.Looks[Constants.DraftLookId]
	end)
	local v72 = useSelector(v50)
	local v73, v74 = React.useState(false)
	local v75, v76 = React.useState(false)
	local v77 = useSelector(function(p4) -- line: 161
		return p4.AvatarExperience.Common.ItemDetailsPeekView.tryOnManagerViewState
	end) ~= PeekViewState.Closed
	local v78 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 167
		-- upvalues: v57 (copy), SetTryOnManagerPeekViewState (copy), PeekViewState (copy), CreateDraftLook (copy), v78 (copy), v67 (copy), NavigationUtils (copy), v58 (copy)
		v57(SetTryOnManagerPeekViewState(PeekViewState.Closed))
		v57(CreateDraftLook(v78)):andThen(function(p5) -- line: 169
			-- upvalues: v67 (copy), NavigationUtils (copy), v58 (copy)
			if p5 then
				v67(false)

				return
			end

			NavigationUtils.closeLookComposer(v58)
		end)
	end, {})

	local v79 = if not v71 or (not v71.displayProperties or v71.displayProperties.backgroundType ~= "Hex") then v59.Theme.PlaceHolder.Color else Color3.fromHex(v71.displayProperties.backgroundValue)
	local v80 = React.useMemo(function() -- line: 184
		-- upvalues: React (copy), v59 (copy), v79 (copy), v71 (copy), LookViewport (copy)
		return React.createElement("Frame", {
			BorderSizePixel = 1,
			BackgroundTransparency = 0,
			Size = UDim2.fromScale(1, 1),
			BorderColor3 = v59.Theme.BackgroundDefault.Color,
			BackgroundColor3 = v59.Theme.BackgroundDefault.Color
		}, {
			ThumbnailBackground = React.createElement("Frame", {
				BorderSizePixel = 1,
				Size = UDim2.fromScale(1, 1),
				BorderColor3 = v79,
				BackgroundColor3 = v79,
				BackgroundTransparency = v59.Theme.PlaceHolder.Transparency
			}, {
				LookViewport = if not v71 then nil else React.createElement(LookViewport, {
					lookDetails = v71
				})
			})
		})
	end, {
		v79,
		v71
	})
	local v81 = React.useCallback(function() -- line: 216
		-- upvalues: v43 (copy), v65 (copy), t2 (copy), v64 (copy), GetFFlagAXLookComposerBackgroundsEnabled (copy)
		if v43 then
			v65(function(p6) -- line: 218
				-- upvalues: t2 (copy)
				local v101 = table.find(t2, p6)

				return t2[not v101 and 1 or v101 - 1]
			end)

			return
		end

		if v64 == "ApplyBackground" then
			v65("ApplyEmote")

			return
		end

		if v64 == "EditInfo" then
			if GetFFlagAXLookComposerBackgroundsEnabled() then
				v65("ApplyBackground")

				return
			end

			v65("ApplyEmote")
		end
	end, if not v43 then { v64 } else {})
	local v82 = React.useMemo(function() -- line: 235
		-- upvalues: v81 (copy), GetFFlagAXLooksTranslationAudit (copy), v70 (copy)
		return {
			props = {
				onActivated = v81,
				text = not GetFFlagAXLooksTranslationAudit() and "Go Back" or v70.goBack
			}
		}
	end, { v81 })
	local v83 = React.useCallback(function() -- line: 244
		-- upvalues: v43 (copy), v64 (copy), t2 (copy), v57 (copy), DraftLookFinalPreview (copy), v58 (copy), v65 (copy), GetFFlagAXLookComposerBackgroundsEnabled (copy)
		if v43 then
			if v64 == t2[#t2] then
				v57(DraftLookFinalPreview(v58))

				return
			end

			v65(function(p7) -- line: 249
				-- upvalues: t2 (copy)
				local v103 = table.find(t2, p7)

				return t2[not v103 and 1 or v103 + 1]
			end)

			return
		end

		if v64 == "ApplyEmote" then
			if GetFFlagAXLookComposerBackgroundsEnabled() then
				v65("ApplyBackground")

				return
			end

			v65("EditInfo")

			return
		end

		if v64 == "ApplyBackground" then
			v65("EditInfo")

			return
		end

		if v64 == "EditInfo" then
			v57(DraftLookFinalPreview(v58))
		end
	end, { v64 })
	local v84 = React.useMemo(function() -- line: 269
		-- upvalues: ButtonType (copy), v83 (copy), v43 (copy), v64 (copy), t2 (copy), v70 (copy), GetFFlagAXLooksTranslationAudit (copy), v68 (copy)
		return {
			isDefaultChild = true,
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = v83,
				text = if not v43 then if not GetFFlagAXLooksTranslationAudit() then v64 ~= "EditInfo" and "Next" or "Preview & Share" else if v64 ~= "EditInfo" then v70.next else v70.previewAndPost else if v64 ~= t2[#t2] then v70.next else v70.previewAndPost,
				isDisabled = if v64 ~= "EditInfo" then nil else v68
			}
		}
	end, {
		v83,
		v68
	})
	local v85 = React.useCallback(function() -- line: 286
		-- upvalues: v58 (copy), AppPage (copy), v41 (copy), NavigationUtils (copy)
		local v92 = v58.getParam("prevNavPage") or AppPage.Home

		if v41 then
			NavigationUtils.closeFocusedScreen(v58)
		end

		NavigationUtils.closeLookComposer(v58)
		v58.navigate(v92)
	end, { v58 })
	local v86 = v72 or (v73 or v75)
	local v87 = React.useCallback(function() -- line: 297
		-- upvalues: v86 (copy), v58 (copy), AvatarScreen (copy), v85 (copy)
		if v86 then
			v58.navigate(AvatarScreen.LooksConfirmationPrompt, {
				onOverlayClosed = v85
			})

			return
		end

		if v85 then
			v85()
		end
	end, {
		v58,
		v86,
		v85
	})
	local v88 = React.useCallback(function() -- line: 309
		-- upvalues: v49 (copy), v87 (copy)
		return v49({
			onActivated = v87
		})
	end, { v87 })

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v60 else nil
	}, {
		AvatarExperienceView = React.createElement(AvatarExperienceView, {
			bottomBarEnabled = false,
			allowAdaptiveScrolling = false,
			isSceneFullView = false,
			isUIFullView = false,
			topBar = React.createElement(TopBar.Container, {
				transparentBackground = false,
				titleText = not GetFFlagAXLooksTranslationAudit() and "Post" or v70.postHeader,
				leftItem = v88
			}),
			sceneUi = v80,
			showRobuxBalance = t1[v64]
		}, {
			Overlay = v77 and React.createElement("Frame", {
				ZIndex = 2,
				BackgroundTransparency = v59.Theme.Overlay.Transparency,
				BackgroundColor3 = v59.Theme.Overlay.Color,
				Size = UDim2.fromScale(1, 1)
			}),
			Content = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, -v61.Y)
			}, {
				LoadingFrame = v66 and React.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					BackgroundColor3 = v59.Theme.BackgroundDefault.Color
				}, {
					LoadingSpinner = React.createElement(Loading, {
						Position = UDim2.fromScale(0.5, 0.5),
						size = IconSize.Large,
						AnchorPoint = Vector2.new(0.5, 0.5)
					})
				}),
				Content = not v66 and React.createElement(React.Fragment, {}, {
					EmotePicker = v64 == "ApplyEmote" and React.createElement(LookEmotePicker),
					BackgroundPicker = v64 == "ApplyBackground" and React.createElement(LookBackgroundPicker),
					InfoForm = v64 == "EditInfo" and React.createElement(LookInfoForm, {
						interactable = not v77,
						disableNextButton = function(b1: boolean) -- line: 361
							-- upvalues: v69 (copy)
							v69(b1)
						end,
						onTitleChange = function(s1: string) -- line: 364
							-- upvalues: v74 (copy)
							local v95 = string.len((trimWhitespaceFromString(s1))) ~= 0

							v74(v95)
						end,
						onSubtitleChange = function(s2: string) -- line: 368
							-- upvalues: v76 (copy)
							local v97 = string.len((trimWhitespaceFromString(s2))) ~= 0

							v76(v97)
						end
					})
				})
			}),
			ActionBarBackground = React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 0,
				AnchorPoint = Vector2.new(0, 1),
				Position = UDim2.fromScale(0, 1),
				Size = UDim2.new(1, 0, 0, v61.Y),
				BackgroundColor3 = v59.Theme.BackgroundDefault.Color
			}),
			ActionBar = not v66 and (not v77 and React.createElement(ActionBar, {
				onAbsoluteSizeChanged = function(vector2: Vector2) -- line: 386
					-- upvalues: v62 (copy)
					v62(vector2 + Vector2.new(0, 12))
				end
			}, {
				ButtonStack = React.createElement(ButtonStack, {
					buttons = if v64 ~= v63 then {
						v82,
						v84
					} else { v84 }
				})
			}))
		})
	})
end

return LookComposerPage
