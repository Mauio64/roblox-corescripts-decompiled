local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local withOverlayFocusHandling = require(Modules.AvatarExperience.Common.Components.withOverlayFocusHandling)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants2 = require(Modules.LuaApp.Constants)
local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v22 = game:DefineFastFlag("FixNilButtonCrashApp", false)
local Focusable = RoactGamepad.Focusable

local function ContextFrame(t1: {[any]: any}) -- line: 60
	-- upvalues: useNavigation (copy), useDesignTokens (copy), NavigationUtils (copy), useSelector (copy), getUseSelectorDeepEquals (copy), selectIsPortrait (copy), Constants (copy), Utils (copy), Constants2 (copy), React (copy), v22 (copy), Cryo (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Focusable (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ContextualMenu (copy), MenuDirection (copy)
	local v27 = useNavigation()
	local v28 = useDesignTokens()
	local v29 = useSelector(function(p1) -- line: 71
		return p1.ScreenSize
	end, getUseSelectorDeepEquals())
	local v30 = useSelector(function(p2) -- line: 75
		return p2.GamepadBottomBar.boundInputs
	end, getUseSelectorDeepEquals())
	local v31 = useSelector(selectIsPortrait, getUseSelectorDeepEquals())
	local v32 = if not v31 then Constants.LandscapeNavWidth else 0
	local v33 = if not v31 then Constants.LandscapeSceneWidth else 1
	local n1 = -76

	if Utils.getNumElementsWithKeyField(v30) > 0 then
		n1 = -76 - Constants2.GAMEPAD_BOTTOM_BAR_SIZE
	end

	local uDim2, uDim2_2

	if t1.centered and not v31 then
		local v35 = math.min(v29.X, 640)

		uDim2 = UDim2.fromOffset((v29.X - v35) / 2, 0)
		uDim2_2 = UDim2.new(0, v35, 1, 0)
	else
		uDim2 = UDim2.fromScale(v32, 0)
		uDim2_2 = UDim2.fromScale(v33, 1)
	end

	local v38 = React.useMemo(function() -- line: 99
		-- upvalues: t1 (copy), v22 (copy), Cryo (copy), v27 (copy)
		local contextButtons = t1.contextButtons

		if v22 then
			contextButtons = Cryo.List.filter(t1.contextButtons, function(p3) -- line: 102
				return p3 ~= nil
			end)
		end

		return Cryo.List.map(contextButtons, function(p4) -- line: 106
			-- upvalues: Cryo (copy), v27 (copy)
			if not p4.onActivated then
				return p4
			end

			return Cryo.Dictionary.join(p4, {
				onActivated = function() -- line: 112
					-- upvalues: p4 (copy), v27 (copy)
					p4.onActivated(v27)
				end
			})
		end)
	end, {
		t1.contextButtons,
		v27
	})

	return React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		Position = uDim2,
		Size = uDim2_2
	}, {
		SizeFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.fromScale(1, 1)
		}, {
			ContextMenuPadding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v28.Global.Size_300 else v28.Size.Size_600),
				PaddingLeft = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v28.Global.Size_300 else v28.Size.Size_600)
			}),
			ContextMenu = React.createElement(ContextualMenu, {
				closeBackgroundVisible = true,
				open = true,
				buttonProps = v38,
				menuDirection = MenuDirection.Up,
				onDismiss = function() -- line: 64
					-- upvalues: NavigationUtils (copy), v27 (copy), t1 (copy)
					NavigationUtils.closeOverlay(v27)

					if t1.onOverlayClosed ~= nil then
						t1.onOverlayClosed()
					end
				end,
				openPositionY = UDim.new(1, n1),
				screenSize = v29,
				contextMenuWidthOverride = UDim.new(1, 0)
			})
		})
	})
end

local v25 = withMappedNavigationParams(ContextFrame)

if FFlagAXMigrateAXToGlobalAutofocus then
	v25 = withOverlayFocusHandling(v25)
end

return v25
