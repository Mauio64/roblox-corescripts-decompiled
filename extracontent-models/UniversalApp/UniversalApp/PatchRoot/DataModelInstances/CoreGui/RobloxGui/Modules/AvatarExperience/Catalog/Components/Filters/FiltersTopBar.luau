local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation

require(CorePackages.Workspace.Packages.AppCommonLib)

local Utils = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local Platform = UserInputService:GetPlatform()
local v17 = Platform == Enum.Platform.Windows or Platform == Enum.Platform.OSX
local v18 = Images["icons/navigation/close"]
local v19 = not v17 and 0 or 0.5

local function FiltersTopBar(p1) -- line: 43
	-- upvalues: useSelector (copy), getUseSelectorDeepEquals (copy), Utils (copy), useNavigation (copy), React (copy), useSelectionCursor (copy), CursorKind (copy), Focusable (copy), v19 (copy), ImageSetLabel (copy), v18 (copy)
	local v22 = useSelector(function(p2) -- line: 44
		return p2.TopBar.statusBarHeight
	end, getUseSelectorDeepEquals())
	local v23 = useSelector(Utils.getTopBarHeightAvatarScene, getUseSelectorDeepEquals())
	local v24 = useNavigation()
	local v25 = React.useCallback(function() -- line: 52
		-- upvalues: p1 (copy)
		p1.closePeekViewSignal:fire()
	end, {
		v24,
		p1.closePeekViewSignal
	})
	local v26 = useSelectionCursor(CursorKind.RoundedRectNoInset)

	return React.createElement("Frame", {
		Active = true,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v23)
	}, {
		TouchFriendlyNavigationButton = React.createElement(Focusable.TextButton, {
			AnchorPoint = Vector2.new(0, v19),
			Position = UDim2.new(0, 15, v19, v22),
			Size = UDim2.new(0, 36, 0, 36),
			BackgroundTransparency = 1,
			Text = "",
			[React.Event.Activated] = v25,
			ref = p1.buttonRef,
			NextSelectionLeft = p1.NextSelectionLeft,
			NextSelectionRight = p1.NextSelectionRight,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown,
			SelectionImageObject = v26
		}, {
			CloseButton = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(0, 36, 0, 36),
				Image = v18,
				ImageColor3 = Color3.new(1, 1, 1)
			})
		})
	})
end

return FiltersTopBar
